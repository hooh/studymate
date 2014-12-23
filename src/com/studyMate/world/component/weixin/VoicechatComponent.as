package com.studyMate.world.component.weixin
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.MP3PlayerProxy;
	import com.studyMate.global.Global;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.component.weixin.configure.ConfigChatView;
	import com.studyMate.world.component.weixin.configure.ConfigTextInput;
	import com.studyMate.world.component.weixin.configure.ConfigVoiceInput;
	import com.studyMate.world.component.weixin.renderers.ChatItemRenderer;
	import com.studyMate.world.component.weixin.vo.WeixinVO;
	
	import flash.filesystem.File;
	
	import feathers.controls.List;
	import feathers.core.FeathersControl;
	import feathers.data.ListCollection;
	import feathers.events.CollectionEventType;
	import feathers.events.FeathersEventType;
	import feathers.layout.VerticalLayout;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	
	/**
	 * 语音聊天，包含文字聊天
	 * 
	 * 基本用法
	 * voicechat = new VoicechatComponent();
	 * voicechat.configView.viewWidth = 778;
	 * voicechat.configView.viewHeight = 570;
	 * voicechat.configView.verticalGap = 10;
	 * voicechat.configText.writeView =  CRTextInputView;//输入框聊天皮肤，需要实现ITextInputView接口
	 * voicechat.configText.insertTextFun = insertTextHandler;//输入文字插入函数
	 * voicechat.configText.insertImgFun = insertImgHandler;//插入图片的函数
	 * voicechat.configVoice.recordView = RecordView; //语音聊天皮肤，需要实现IRecordView接口
	 * voicechat.configVoice.inserVoiceFun = insertVoiceHandler;//插入语音函数
	 * voicechat.configVoice.tryListenView = TryListenView;//试听皮肤，需要实现ITryListenView接口
	 * view.holder.addChild(chatAndVoice);
	 * 
	 * 
	 * 方法
	 * addMsgItem(item:VoiceVO):void;
	 * 
	 * 其余的config参数可以进入内部去详看
	 * 
	 * @author wt
	 * 
	 */	
	public class VoicechatComponent extends Sprite implements IMediator
	{
		public static const NAME:String = 'VoicechatComponent';		

		private var initialization:Boolean;
		
		private static var index:int=0;
		public var core:String = NAME+(index++);//多核核心
		
		public var activeVoice:Boolean=true;//是否激活语音,默认激活
		public var configView:ConfigChatView;//视图配置表
		public var configVoice:ConfigVoiceInput;//语音配置表
		public var configText:ConfigTextInput;//文字聊天配置表
		
		private var msglistCollection:ListCollection;//添加小心请用addMsgItem
		
		private var chatList:List;		
		
		private var voiceInputMediator:VoiceInputMediator;//语音录制
		private var textInputMediator:TextInputMediator;//文字输入
		private var voiceListenMediator:VoiceBroadcastMediator;//播放语音
		private var imgMsgMediator:ImgBroadcastMediator;
		
		private var verticalPoistion:Number=0;
		
		public function onRemove():void{
			Facade.getInstance(CoreConst.CORE).removeMediator(NAME);
			if(activeVoice)
				MyUtils.clearFileNum(configVoice.folder);// 录音文件超出范围。
			if(voiceListenMediator){
				Facade.getInstance(core).removeMediator(voiceListenMediator.getMediatorName());
				voiceListenMediator = null;
			}
			if(voiceInputMediator){
				Facade.getInstance(core).removeMediator(voiceInputMediator.getMediatorName());			
			}
			if(textInputMediator){
				Facade.getInstance(core).removeMediator(textInputMediator.getMediatorName());			
			}
			
			Facade.getInstance(core).removeMediator(imgMsgMediator.getMediatorName());
		}
		override public function dispose():void
		{
			Facade.getInstance(core).removeMediator(NAME);
			Facade.removeCore(core);
			super.dispose();
		}
		public function VoicechatComponent()
		{
			super();
			msglistCollection = new ListCollection();
			configView = new ConfigChatView();
			configText = new ConfigTextInput();
			configVoice = new ConfigVoiceInput();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE,addToStageHandler);
		}
		
		protected function addToStageHandler(e:starling.events.Event):void
		{
			if(chatList == null){				
				chatList = new List();
				chatList.width = configView.viewWidth;
				chatList.height =configView.viewHeight;
				var layout:VerticalLayout = new VerticalLayout();
				layout.gap = configView.verticalGap;
				layout.hasVariableItemDimensions = true;
				layout.paddingBottom = 20;
				chatList.layout = layout;
				chatList.itemRendererType = ChatItemRenderer;
				this.addChild(chatList);
				
				
				chatList.dataProvider = msglistCollection;
				msglistCollection.addEventListener(CollectionEventType.ADD_ITEM,addItemHandler);
				Facade.getInstance(core).registerMediator(this);
				
				if(_activeAutoScroll){					
					chatList.scrollToPageIndex(0,msglistCollection.length-1,0)
				}

			}
		}	
		

		public function onRegister():void
		{
			Facade.getInstance(CoreConst.CORE).registerMediator(this);
			
			if(!initialization){
				initialization = true;
				
				imgMsgMediator = new ImgBroadcastMediator();
				imgMsgMediator.core = core;
				Facade.getInstance(core).registerMediator(imgMsgMediator);
				voiceListenMediator = new VoiceBroadcastMediator("VoiceBroadcastMediator"+core);
				voiceListenMediator.core = core;
				Facade.getInstance(core).registerMediator(voiceListenMediator);
				if(activeVoice){
					if(configVoice.voiceInputView==null) return;
					voiceInputMediator = new VoiceInputMediator("VoiceInputMediator"+core,new configVoice.voiceInputView);
					voiceInputMediator.core = core;
					Facade.getInstance(core).registerMediator(voiceInputMediator);
				}else{
					if(configText.textInputView==null) return;
					textInputMediator = new TextInputMediator("TextInputMediator"+core,new configText.textInputView);
					textInputMediator.core = core;;
					Facade.getInstance(core).registerMediator(textInputMediator);
				}
			}			
		}
		
		override public function set visible(value:Boolean):void
		{
			if(this.visible==value) return;
			if(value){
				if(imgMsgMediator==null || !Facade.getInstance(core).hasMediator(imgMsgMediator.getMediatorName())){
					imgMsgMediator = new ImgBroadcastMediator();
					imgMsgMediator.core = core;
					Facade.getInstance(core).registerMediator(imgMsgMediator);
				}
				if(voiceInputMediator) Facade.getInstance(core).removeMediator(voiceInputMediator.getMediatorName());	
				if(textInputMediator==null || !Facade.getInstance(core).hasMediator(textInputMediator.getMediatorName())){
					textInputMediator = new TextInputMediator("TextInputMediator"+core,new configText.textInputView);
					textInputMediator.core = core;
					Facade.getInstance(core).registerMediator(textInputMediator);
				}
			}else{
				if(imgMsgMediator) Facade.getInstance(core).removeMediator(imgMsgMediator.getMediatorName());
				if(voiceInputMediator) Facade.getInstance(core).removeMediator(voiceInputMediator.getMediatorName());
				if(textInputMediator){
					textInputMediator.view.defaultState();
					Facade.getInstance(core).removeMediator(textInputMediator.getMediatorName());
					textInputMediator = null;
				}
			}
			super.visible = value;
		}
		private var isAddAt:Boolean;
		
		
		//添加新的消息
		public function addMsgItem(item:WeixinVO):void{
			isAddAt = false;
			item.core = core;
			msglistCollection.push(item);
		}
		public function addMsgAll(collection:ListCollection):void{
			isAddAt = false;
			if(collection){
				for(var i:int=0;i<collection.length;i++){
					collection.getItemAt(i).core = core;
				}
			}
			msglistCollection.addAll(collection);
		}
		public function addMsgItemAt(item:WeixinVO,index:int):void{
			verticalPoistion = chatList.maxVerticalScrollPosition;
			isAddAt = true;
			item.core = core;
			msglistCollection.addItemAt(item,index);						
		}
		public function  addMsgAllAt(collection:ListCollection, index:int):void{
			isAddAt = true;
			if(collection){
				for(var i:int=0;i<collection.length;i++){
					collection.getItemAt(i).core = core;
				}
			}
			msglistCollection.addAllAt(collection,index);
		}
		
		
		//删除添加的信息,(默认是删除所有，否则删除下标提示的项目)
		public function clearMsgItem(index:int=-1):void{
			if(index==-1){
				msglistCollection.removeAll();
			}else{
				msglistCollection.removeItemAt(index);
			}
			
		}
		//检索信息
		public function searchMsg(property:String,value:Object):void{
			var len:int = msglistCollection.length;
			var obj:Object;
			if(len>5){
				for(var i:int=0;i<len;i++){
					obj = msglistCollection.getItemAt(i);
					if(obj[property]==value){						
//						trace('检索到信息',i,chatList.maxVerticalScrollPosition);
						if(i+3<=len)
							chatList.scrollToDisplayIndex(i+3,0.5);	
						else
							chatList.scrollToDisplayIndex(i,0.5);	
//						chatList.scrollToPosition(0,(i+1)*chatList.maxVerticalScrollPosition/len);
						
//						trace('坐标',(chatList.getChildAt(0) as DisplayObjectContainer).getChildAt(i).y);
						break;
					}
				}
			}
		}
		
		
		public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SpeechConst.UPDATE_UI_STATE:
					if(msglistCollection.contains(notification.getBody()))
						msglistCollection.updateItemAt(msglistCollection.getItemIndex(notification.getBody()));
					break;					
				case SpeechConst.USE_WRITE_OPERATE:
					if(voiceInputMediator)Facade.getInstance(core).removeMediator(voiceInputMediator.getMediatorName());	
					if(textInputMediator==null || !Facade.getInstance(core).hasMediator(textInputMediator.getMediatorName())){
						textInputMediator = new TextInputMediator("TextInputMediator"+core,new configText.textInputView);
						textInputMediator.core = core;
						Facade.getInstance(core).registerMediator(textInputMediator);
					}
					break;
				case SpeechConst.USE_RECORD_OPERATE:
					if(activeVoice){						
						if(textInputMediator)Facade.getInstance(core).removeMediator(textInputMediator.getMediatorName());
						if(voiceInputMediator==null || !Facade.getInstance(core).hasMediator(voiceInputMediator.getMediatorName())){
							voiceInputMediator = new VoiceInputMediator("VoiceInputMediator"+core,new configVoice.voiceInputView);
							voiceInputMediator.core = core;
							Facade.getInstance(core).registerMediator(voiceInputMediator);
						}
					}
					break;
				case SpeechConst.FILE_DOWNCOMPLETE_STATE:
					var wPath:String = notification.getBody() as String;
					for(var i:int=msglistCollection.length-1;i>=0;i--){
						if(wPath.indexOf(msglistCollection.getItemAt(i).mtxt)!=-1){
							msglistCollection.getItemAt(i).mtxt = wPath;
							(msglistCollection.getItemAt(i) as WeixinVO).updateUIState = VoiceState.defaultState;
							break;
						}
					}
					break;
			}
		}
		public function listNotificationInterests():Array
		{
			return [
					SpeechConst.UPDATE_UI_STATE,
					SpeechConst.USE_RECORD_OPERATE,
					SpeechConst.USE_WRITE_OPERATE,
					SpeechConst.FILE_DOWNCOMPLETE_STATE
				];
		}
		
		private var _activeAutoScroll:Boolean;
		public function activeAutoScroll(value:Boolean):void{
			if(value){	
				_activeAutoScroll = true;
//				chatList.scrollToPageIndex(0,msglistCollection.length-1,0);
			}else{
				_activeAutoScroll = false;
			}
		}
		private function addItemHandler(e:Event):void
		{
			if(!isAddAt){				
				var voiceVO:WeixinVO = (msglistCollection.getItemAt(e.data as int) as WeixinVO);
				if(voiceVO.mtype == 'voice' && !voiceVO.hasRead){				
					sendNotification(SpeechConst.ADD_NEW_SPEECH,voiceVO);
				}
				if(_activeAutoScroll){
					if(chatList.maxVerticalScrollPosition-chatList.verticalScrollPosition<90){						
						chatList.scrollToPageIndex(0,msglistCollection.length-1,1);				
					}
				}
			}else{
				chatList.addEventListener(Event.SCROLL,positionHandler);

			}
		}

		
		private function positionHandler():void
		{			
//			trace("flaten chatList.maxVerticalScrollPosition",chatList.maxVerticalScrollPosition);
			chatList.removeEventListener(Event.SCROLL,positionHandler);
			var len:Number = chatList.maxVerticalScrollPosition-verticalPoistion;
			if(len>0){					
				chatList.verticalScrollPosition += len;
			}

		}
		
		public function updateHeight(value:Number):void{
			if(chatList.height != value){								
				if(chatList.height>value){
					var difference:Number = chatList.height-value;
					
					if(chatList.verticalScrollPosition+difference<=chatList.maxVerticalScrollPosition){
						chatList.verticalScrollPosition += difference;
					}else{
						if(chatList.maxVerticalScrollPosition-chatList.verticalScrollPosition<90){
							
							chatList.scrollToPageIndex(0,msglistCollection.length-1,0);	
						}
					}
				}else{
					difference = value - chatList.height;
					if(chatList.verticalScrollPosition-difference>=0){
						chatList.verticalScrollPosition -= difference;
					}
				}
				chatList.height = value;
			}
		}
				
		/**
		 * @param path 后台下载目录的相对路径
		 * @return 真实存储文件 File
		 */		
		public function localFile(path:String):File{
			return Global.document.resolvePath(localPath(path))
		}
		/**
		 * @param path 服务器的相对路径
		 * @return 本地文件路径
		 */		
		public function localPath(path:String):String{
			return Global.localPath + configVoice.folder+'/' + path.substring(path.lastIndexOf("/")+1);
		}
		
	
		public static function owner(core:String):VoicechatComponent{
			return Facade.getInstance(core).retrieveMediator(VoicechatComponent.NAME) as VoicechatComponent;
		}
		public function getMediatorName():String
		{
			return NAME;
		}
		
		public function getViewComponent():Object
		{
			return this;
		}
		
		public function setViewComponent(viewComponent:Object):void
		{
		}
		public function initializeNotifier(key:String):void		{
			
		}
		
		public function sendNotification(notificationName:String, body:Object=null, type:String=null):void
		{
			Facade.getInstance(core).sendNotification( notificationName, body, type );
		}
	}
}