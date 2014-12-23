package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import myLib.myTextBase.TextFieldHasKeyboard;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.controller.vo.EnableScreenCommandVO;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.model.vo.MessageVO;
	import com.studyMate.world.model.vo.RelListItemSpVO;
	
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.ui.Keyboard;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PickerList;
	import feathers.controls.popups.VerticalCenteredPopUpContentManager;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class MakeMessageMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "MakeMessageMediator";
		private const GET_RELATE_LIST:String = NAME + "getRelateList";
		private const SEND_MESSAGE:String = NAME + "SendMessage";
		public static const HIDE_VIEW:String = NAME + "HideView";
		private var vo:SwitchScreenVO;
		
		public function MakeMessageMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}
		
		private var messages:Vector.<MessageVO>;
		private var index:int;
		
		override public function prepare(vo:SwitchScreenVO):void{
			this.vo = vo;
			selectPerson = new RelListItemSpVO();
			messages = vo.data[0];
			index = vo.data[1];
			if(vo.data[2] == null){
				getRelateList();
			}else{
				selectPerson.rstdId = vo.data[2];
				selectPerson.rstdCode = vo.data[3];
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
			}
		}
		
		private var relListItemSpVoList:Vector.<RelListItemSpVO>;
		private var selectPerson:RelListItemSpVO;
		private var messageInput:TextFieldHasKeyboard;
		
		private function getRelateList():void{
			relListItemSpVoList = new Vector.<RelListItemSpVO>;
			PackData.app.CmdIStr[0] = CmdStr.QRY_STD_RELATLIST;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 2;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(GET_RELATE_LIST));
		}
		
		private var list:PickerList;
		
		override public function onRegister():void{
			var img:Image = new Image(Assets.getTexture("makeNew"));
			view.addChild(img);
			img.x = 28; img.y = 20;
			
			messageInput = new TextFieldHasKeyboard();
			var format:TextFormat = new TextFormat("HeiTi", 28, 0x925200);
			format.leading = 22;
			messageInput.defaultTextFormat = format;
			messageInput.restrict  = "^`&#\\";
//			messageInput.embedFonts = true;
			messageInput.prompt = "请输入邮件正文，正文最长不超过280个字符...";
			messageInput.borderColor = 0x925200;
			messageInput.border = true;
			messageInput.x = 165; messageInput.y = 170;
			messageInput.width = 975; messageInput.height = 430;
			messageInput.maxChars = 280;
			messageInput.wordWrap = true;
			Starling.current.nativeOverlay.addChild(messageInput);
			messageInput.addEventListener(FocusEvent.FOCUS_IN,focusInHandler);
			messageInput.addEventListener(FocusEvent.FOCUS_OUT,focusOutHandler)
			messageInput.addEventListener(KeyboardEvent.KEY_DOWN,inputHandle);
			
			if(relListItemSpVoList == null){
				var receName:TextField = new TextField(920, 59, selectPerson.rstdCode, "comic", 30, 0x925200);
				receName.autoScale = true; receName.hAlign = HAlign.CENTER; receName.vAlign = VAlign.CENTER;
				receName.x = 143; receName.y = 74;
				view.addChild(receName);
			}else if(relListItemSpVoList.length > 0){
				var items:Array = [];
				for(var i:int = 0; i < relListItemSpVoList.length; i++){
					items.push({text:relListItemSpVoList[i].realName});
				}
				
				list = new PickerList();
				list.dataProvider = new ListCollection(items);
				view.addChild(list);
				list.labelField = "text";
				list.listProperties.@itemRendererProperties.labelField = "text";
				list.width = 920; list.height = 57;
				list.x = 132; list.y = 79;
				
				var popUpContentmanager:VerticalCenteredPopUpContentManager = new VerticalCenteredPopUpContentManager();
				//				var popUpContentmanager:CalloutPopUpContentManager = new CalloutPopUpContentManager();
				popUpContentmanager.addEventListener(starling.events.Event.CLOSE, closePopUpListHandler);
				list.popUpContentManager = popUpContentmanager;
				
				list.buttonFactory = pickerListButton;
				var boldFontDescription:FontDescription = new FontDescription("HeiTi",FontWeight.NORMAL,FontPosture.NORMAL,FontLookup.EMBEDDED_CFF);
//				list.buttonProperties.@defaultLabelProperties.textFormat = new TextFormat("HeiTi", 30, 0x925200);
//				list.buttonProperties.@defaultLabelProperties.embedFonts = true;
				list.buttonProperties.@defaultLabelProperties.elementFormat = new ElementFormat(boldFontDescription, 30, 0x925200);
				list.buttonProperties.stateToSkinFunction = null;
				
				list.listFactory = pickerListList;
//				list.listProperties.@itemRendererProperties.@defaultLabelProperties.embedFonts = true;
//				list.listProperties.@itemRendererProperties.@defaultLabelProperties.textFormat = new TextFormat("HeiTi", 30, 0x925200);
				list.listProperties.@itemRendererProperties.@defaultLabelProperties.elementFormat = new ElementFormat(boldFontDescription, 30, 0x925200);
				list.listProperties.@itemRendererProperties.@defaultLabelProperties.stateToSkinFunction = null;
				list.listProperties.stateToSkinFunction = null;
				
				list.listProperties.itemRendererFactory = listItemRender;
				list.listProperties.@itemRendererProperties.defaultSelectedIcon = new Image(Assets.getAtlasTexture("message/selectIcon"));
				list.listProperties.itemRendererProperties.stateToSkinFunction = null;
				
				list.addEventListener(starling.events.Event.CHANGE, listChangeHandler);
				selectPerson = relListItemSpVoList[0];
			}else{
				messageInput.visible = false;
				sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.stage,
					640,381,closeView,"好友列表为空，不能发送邮件O(∩_∩)O~",closeView));
			}
			
			var sendBtn:starling.display.Button = new starling.display.Button(Assets.getAtlasTexture("message/send"));
			sendBtn.x = 1060; sendBtn.y = 74;
			view.addChild(sendBtn);
			sendBtn.addEventListener(Event.TRIGGERED, onSendBtnhandler);
			
			var texture:Texture = Assets.getAtlasTexture("huInfo_closeBtn");
			var closeBtn:starling.display.Button = new starling.display.Button(texture);
			closeBtn.x = 1180; closeBtn.y = 10;
			closeBtn.addEventListener(Event.TRIGGERED, onCloseBtnHandler);
			view.addChild(closeBtn);
			
			sendNotification(ShowMessageMediator.HIDE_VIEW);
			sendNotification(WorldConst.HIDE_MAIN_MENU);
			sendNotification(WorldConst.SET_ROLL_SCREEN,false);
//			sendNotification(WorldConst.POPUP_SCREEN,new PopUpCommandVO(this,true));
			sendNotification(WorldConst.ENABLE_GPU_SCREENS, new EnableScreenCommandVO(false, NAME));
			
			Global.stage.addEventListener(KeyboardEvent.KEY_DOWN,stageKeydownHandler,false,1);
			
			var changeBtn:feathers.controls.Button = new feathers.controls.Button();
			changeBtn.label = '切\n换\n输\n入\n键\n盘';
			changeBtn.x = 90;
			changeBtn.y = 170;
			view.addChild(changeBtn);
			changeBtn.addEventListener(Event.TRIGGERED,changInputHandler);
		}
		
		private function changInputHandler(e:Event):void{
			if(messageInput.useKeyboard){
				messageInput.useKeyboard = false;
				messageInput.needsSoftKeyboard = true;
				messageInput.requestSoftKeyboard();
				//view.changeInput.label = "切换两侧键盘";
				messageInput.setFocus();;
			}else{
				messageInput.useKeyboard = true;
				messageInput.needsSoftKeyboard = false;
				//view.changeInput.label = "切换系统键盘";
				TweenLite.killTweensOf(messageInput);
//				TweenLite.delayedCall(0.5,changeFocus);	
				messageInput.setFocus();
			}			
		}
		/*private function changeFocus():void
		{
			messageInput.setFocus();
		}*/
		
		//切换输入框大小范围
		protected function focusOutHandler(event:FocusEvent):void
		{
			TweenLite.killTweensOf(changeSize);
			TweenLite.delayedCall(0.3,changeSize,[430]);
		}
		
		protected function focusInHandler(event:FocusEvent):void
		{
			TweenLite.killTweensOf(changeSize);
			TweenLite.delayedCall(0.3,changeSize,[200]);
		}
		private function changeSize(value:Number):void{
			if(messageInput.height!=value)
				messageInput.height = value;
		}
		
		protected function stageKeydownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode ==Keyboard.BACK || event.keyCode == Keyboard.ESCAPE){
				event.stopImmediatePropagation();
				event.preventDefault();
			}
		}
		
		private function pickerListButton():feathers.controls.Button{
			var button:feathers.controls.Button = new feathers.controls.Button();
			button.addEventListener(starling.events.Event.TRIGGERED, listTiggeredHandler);
			button.defaultSkin = new Scale9Image(new Scale9Textures(Assets.getAtlasTexture("message/pickListButton"),new Rectangle(0,0,925,61)));
			return button;
		}
		
		private function pickerListList():List{
			var list:List = new List();
			list.backgroundSkin = new Quad(20, 20, 0xc5822a);
			return list;
		}
		
		private function listItemRender():IListItemRenderer{
			var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
			renderer.defaultSkin = new Scale9Image(new Scale9Textures(Assets.getAtlasTexture("message/defaultItem"),new Rectangle(16,16,149,36)));
			renderer.defaultSelectedSkin = new Scale9Image(new Scale9Textures(Assets.getAtlasTexture("message/defaultItem"),new Rectangle(16,16,149,36)));
			return renderer;
		}
		
		private function inputHandle(e:KeyboardEvent):void{
			if(e.keyCode==13){
				messageInput.text = messageInput.text + "\n";
				messageInput.selectTextRange(messageInput.text.length,messageInput.text.length);
			}						
		}
		
		private function listChangeHandler(event:Event):void{
			selectPerson = relListItemSpVoList[list.selectedIndex];
		}
		
		private function closePopUpListHandler(event:starling.events.Event):void{
			messageInput.visible = true;
		}
		
		private function listTiggeredHandler(event:starling.events.Event):void{
			messageInput.visible = false;
		}
		
		/*protected function stageKeydownHandler(event:KeyboardEvent):void{
		if(event.keyCode ==Keyboard.BACK || event.keyCode == Keyboard.ESCAPE){
		event.stopImmediatePropagation();
		event.preventDefault();
		}
		}*/
		
		private function onCloseBtnHandler(e:Event):void{
			closeView();
		}
		
		private function onSendBtnhandler(e:Event):void{
			checkInput();
		}
		
		private function checkInput():void{
			if(selectPerson.rstdId == null){
				sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.stage,
					640,381,null,"收件人不能为空哟，请选择收件人O(∩_∩)O~"));
				return;
			}
			if(messageInput.text.length <= 0){
				messageInput.visible = false;
				sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.stage,
					640,381,showMessageInput,"邮件内容不能为空哟，请输入邮件正文O(∩_∩)O~",showMessageInput));
				return;
			}
			sendMessage();
		}
		
		private function showMessageInput():void{
			messageInput.visible = true;
		}
		
		private function sendMessage():void{
			var message:String = messageInput.text;
			PackData.app.CmdIStr[0] = CmdStr.SEND_MESSAGE;
			PackData.app.CmdIStr[1] = selectPerson.rstdId;
			PackData.app.CmdIStr[2] = Global.player.operId;
			PackData.app.CmdIStr[3] = Global.player.userName;
			PackData.app.CmdIStr[4] = "L";
			PackData.app.CmdIStr[5] = "M";
			PackData.app.CmdIStr[6] = "";
			PackData.app.CmdIStr[7] = "";
			PackData.app.CmdIStr[8] = messageInput.text;
			PackData.app.CmdInCnt = 9;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(SEND_MESSAGE));
		}
		
		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case GET_RELATE_LIST:
					if(!result.isEnd){
						var relListItemSpVo:RelListItemSpVO = new RelListItemSpVO();
						relListItemSpVo.userId = PackData.app.CmdOStr[1];
						relListItemSpVo.rstdId = PackData.app.CmdOStr[2];
						relListItemSpVo.rstdCode = PackData.app.CmdOStr[3];
						relListItemSpVo.realName = PackData.app.CmdOStr[4];
						relListItemSpVo.relaType = PackData.app.CmdOStr[5];
						relListItemSpVoList.push(relListItemSpVo);
					}else{
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
					}
					break;
				case SEND_MESSAGE : 
					if(!result.isErr){
						var str:String = "邮件发送成功，点击任意位置退出O(∩_∩)O~~~";
						messageInput.visible = false;
						sendNotification(WorldConst.ALERT_SHOW,new AlertVo(str,false,"closeView"));
					}
					break;
				case "closeView" :
					closeView();
					break;
				case HIDE_VIEW : 
					vo.type = SwitchScreenType.HIDE;
					sendNotification(WorldConst.SWITCH_SCREEN,[vo]);
					break;
				default : 
					break;
			}
		}
		
		private function closeView():void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ShowMessageMediator,["B",messages,index],SwitchScreenType.SHOW,AppLayoutUtils.uiLayer)]);
		}
		
		override public function listNotificationInterests():Array{
			return [GET_RELATE_LIST,SEND_MESSAGE,"closeView",HIDE_VIEW];
		}
		
		override public function onRemove():void{
			TweenLite.killTweensOf(changeSize);
			sendNotification(WorldConst.SHOW_MAIN_MENU);
			//			Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN,stageKeydownHandler);
			sendNotification(WorldConst.SET_ROLL_SCREEN,true);
			messageInput.removeEventListener(KeyboardEvent.KEY_DOWN,inputHandle);
			messageInput.removeEventListener(FocusEvent.FOCUS_IN,focusInHandler);
			messageInput.removeEventListener(FocusEvent.FOCUS_OUT,focusOutHandler)
			Starling.current.nativeOverlay.removeChild(messageInput);
//			sendNotification(WorldConst.REMOVE_POPUP_SCREEN,this);
			sendNotification(WorldConst.ENABLE_GPU_SCREENS, new EnableScreenCommandVO(true));
			Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN,stageKeydownHandler);
			super.onRemove();
		}
		
		override public function get viewClass():Class{
			return Sprite;
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
	}
}


