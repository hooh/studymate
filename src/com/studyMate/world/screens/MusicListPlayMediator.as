package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.MP3PlayerProxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.framework.utils.CacheTool;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.utils.BitmapFontUtils;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.model.vo.BackgroundMusicVO;
	import com.studyMate.world.model.vo.LoadSoundEffectVO;
	import com.studyMate.world.model.vo.PlaySoundEffectVO;
	import com.studyMate.world.screens.component.BaseResTableMediator;
	import com.studyMate.world.screens.component.MusicPlayerMediator;
	import com.studyMate.world.screens.ui.music.MusicBaseClass;
	import com.studyMate.world.screens.ui.music.MusicBitmapFontItemRender;
	import com.studyMate.world.screens.ui.music.MusicClassify;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import feathers.controls.List;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.filters.BlurFilter;
	import starling.text.TextField;

	public class MusicListPlayMediator extends BaseResTableMediator
	{
		public static const NAME:String = "MusicListPlayMediator";
		public static var isEditBoo:Boolean;//是否正在编辑
		private var editBtn:Button;
		private var editCompleteBtn:Button;
				
		private const CLASSIFY:String = NAME+ "CLASSIFY";
		private const MUSIC_LIST:String = NAME + "MUSIC_LIST";
		private const YES_DEL_FILE:String = NAME + "YES_DEL_FILE";
		
		private var playList:List;//列表组件
		public var dic:Dictionary = new Dictionary();
		public var currentGrid:String;		
		
		private var classifyArr:Vector.<MusicClassify> = new Vector.<MusicClassify>;
		private var Index:int = 0;
		private const defaultStr:String = "默认列表";
		
		private var preClassBtn:Button;//前一个分类
		private var nextClassBtn:Button;//后一个分类
		private var classifyTxt:TextField;//分类名

		private var currentDown:MusicBaseClass;
		private var currenDel:MusicBaseClass;
		private var currentBg:MusicBaseClass;
		
		private var url:String = '';
				
		private var bgmManager:UserBGMusicManagerMediator;
								
		public function MusicListPlayMediator(viewComponent:Object=null)
		{
			super(NAME,viewComponent);
		}
		override public function onRemove():void
		{
			super.onRemove();
			TweenLite.killTweensOf(updateList);
			BitmapFontUtils.dispose();
			dic = null;
			isEditBoo = false;
			MusicBitmapFontItemRender.isEdit = false
			sendNotification(CoreConst.REMOVE_EFFECT_SOUND,'wordRight');
			currentBg = null;
			currentDown = null;
			currenDel = null;
			classifyArr.length = 0;
			classifyArr = null;
			sendNotification(WorldConst.SHOW_MAIN_MENU);
			facade.removeMediator(UserBGMusicManagerMediator.NAME);
			view.removeChildren(0,-1,true);	
			
		}
		override public function onRegister():void{
			super.onRegister();
			sendNotification(CoreConst.LOAD_EFFECT_SOUND,new LoadSoundEffectVO(MyUtils.getSoundPath("wordRight.mp3"),"wordRight"));						
			
			var bg:Image = new Image(Assets.getTexture("musicListPlayBg"));
			bg.blendMode = BlendMode.NONE;
			bg.touchable = false;
			view.addChild(bg);
			
			preClassBtn = new Button(Assets.getMusicSeriesTexture("bigClassBtn"));
			preClassBtn.x = 303;
			preClassBtn.y = 681;
			view.addChild(preClassBtn);
			
			nextClassBtn = new Button(Assets.getMusicSeriesTexture("bigClassBtn"));
			nextClassBtn.scaleX = -1;
			nextClassBtn.x = 970;
			nextClassBtn.y = 681;
			view.addChild(nextClassBtn);
			
			preClassBtn.addEventListener(Event.TRIGGERED,preClassHandler);
			nextClassBtn.addEventListener(Event.TRIGGERED,nextClassHandler);
			
			classifyTxt = new TextField(388,50,"","HeiTi",28,0xFFFFFF,true);
			
			classifyTxt.filter = BlurFilter.createGlow(0x0A4475,1,2,1);
			classifyTxt.x = 452;
			classifyTxt.y = 701;
			view.addChild(classifyTxt);
			
					
				
			bgmManager = new UserBGMusicManagerMediator();
			facade.registerMediator(bgmManager);
						
						
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(MusicPlayerMediator,null,SwitchScreenType.SHOW,view,0,0)]);//播放器	
			sendDelayMediator.sendinServerInfo(CmdStr.GET_ALL_CLASSIFY,CLASSIFY,[ PackData.app.head.dwOperID.toString(),"MUSIC","*"]);//第一步取得所有分类.
			
			
			editBtn = new Button(Assets.getMusicSeriesTexture("editBtn"));
			editBtn.x = 1176;
			editBtn.y = 202;
			view.addChild(editBtn);
			editBtn.addEventListener(TouchEvent.TOUCH,editTOUCHHandler);
			
			editCompleteBtn = new Button(Assets.getMusicSeriesTexture("editCompleteBtn"));
			editCompleteBtn.x = 1176;
			editCompleteBtn.y = 202;
			editCompleteBtn.visible = false;
			view.addChild(editCompleteBtn);
			editCompleteBtn.addEventListener(TouchEvent.TOUCH,editCompleteTOUCHHandler);
			
//			trace("@VIEW:MusicListPlayMediator:");
		}
		
		private function initList():void{
			
			var layout:VerticalLayout = new VerticalLayout();
			layout.paddingBottom = 100;
			layout.gap = 50;
			
			playList = new List();
			playList.allowMultipleSelection = false;
			playList.x = 0;
			playList.y = 220;
			playList.width = 1280;
			playList.height = 438;
			playList.paddingLeft=280;
			playList.layout = layout;
			//			playList.itemRendererType = MusicPlayItemRenderer;
			playList.itemRendererType = MusicBitmapFontItemRender;
			view.addChildAt(playList,3);
		}
		
		private function editTOUCHHandler(e:TouchEvent):void
		{
			if(e.touches[0].phase=="ended"){
				editBtn.visible = false;
				editCompleteBtn.visible = true;
				isEditBoo = !isEditBoo;
				if(dic[currentGrid]){
					for(var i:int=0;i<dic[currentGrid].length;i++){
						dic[currentGrid].updateItemAt(i);
					}
				}
			}
			
		}
		private function editCompleteTOUCHHandler(e:TouchEvent):void{
			if(e.touches[0].phase=="ended"){
				editBtn.visible = true;
				editCompleteBtn.visible = false;
				isEditBoo = !isEditBoo;
				if(dic[currentGrid]){
					for(var i:int=0;i<dic[currentGrid].length;i++){
						dic[currentGrid].updateItemAt(i);
					}
				}
			}
		}
					
		//上一个分类
		private function nextClassHandler(event:Event):void
		{
			if(classifyArr.length>1){// 若是没有分类则无需理会
				if(Index<classifyArr.length-1) Index++;
				else Index = 0;
				changeList();
			}						
		}
		//下一个分类
		private function preClassHandler(event:Event):void
		{
			if(classifyArr.length>1){
				if(Index>0) Index--;
				else Index = classifyArr.length-1;
				changeList();
			}					
		}
		//切换列表需通知播放器
		private function changeList():void{			
			currentGrid = classifyArr[Index].grid;
			if(playList){
				playList.stopScrolling();
			}
			if(dic[currentGrid]){
				if(playList){
					playList.dataProvider = dic[currentGrid];
					selectPlayItem();
				}
			}else{				
				if(dic[currentGrid]==null){
					dic[currentGrid] = new ListCollection();
					if(playList){
						playList.removeFromParent(true);						
					}							
					BitmapFontUtils.dispose();
					initList();							
					playList.dataProvider = dic[currentGrid];
				}
				sendDelayMediator.sendinServerInfo(CmdStr.GET_RESOURCE_LIST2,MUSIC_LIST,[PackData.app.head.dwOperID.toString(),"MUSIC","*",currentGrid],SendCommandVO.QUEUE);
				updateList();//刷新列表
				preClassBtn.enabled = false;
				nextClassBtn.enabled = false;
			}
			classifyTxt.text = classifyArr[Index].className;
			
		}
		
		private var bmpStr:String = '\%.0123456789kb:';
		//初始化位图字体
		public function initBitmapFont(listCollection:ListCollection):void{
			var len:int = listCollection.length;
			var musicBase:MusicBaseClass;
			var str:String = '';
			for(var i:int=0;i< len;i++){
				musicBase = (listCollection.data[i] as MusicBaseClass);
				str += (musicBase.Name + musicBase.author);
			}
			if(str!=''){
				bmpStr += str;
				BitmapFontUtils.dispose();
				var assets:Vector.<DisplayObject> = new Vector.<DisplayObject>;
				var bmp:Bitmap = Assets.getTextureAtlasBMP(Assets.store["MusicSeriesTexture"],Assets.store["MusicSeriesXML"],"flagBgBaseIcon");
				bmp.name = "flagBgBaseIcon";
				assets.push(bmp);
				bmp = Assets.getTextureAtlasBMP(Assets.store["MusicSeriesTexture"],Assets.store["MusicSeriesXML"],"downBtn");
				bmp.name = "downBtn";
				assets.push(bmp);
				bmp = Assets.getTextureAtlasBMP(Assets.store["MusicSeriesTexture"],Assets.store["MusicSeriesXML"],"flagBgIcon");
				bmp.name = "flagBgIcon";
				assets.push(bmp);
				bmp = Assets.getTextureAtlasBMP(Assets.store["MusicSeriesTexture"],Assets.store["MusicSeriesXML"],"delCircleIcon");
				bmp.name = "delCircleIcon";
				assets.push(bmp);
				bmp = Assets.getTextureAtlasBMP(Assets.store["MusicSeriesTexture"],Assets.store["MusicSeriesXML"],"delMusicBtn");
				bmp.name = "delMusicBtn";
				assets.push(bmp);
				
				var ui:Shape = new Shape();
				ui.graphics.clear();
				ui.graphics.beginFill(0x0a4475,0.25);
				ui.graphics.drawRect(0,0,748,48);
				var bmd:BitmapData = new BitmapData(748,48,true,0);
				bmd.draw(ui);
				bmp = new Bitmap(bmd);
				bmp.name = 'bgQuad';
				assets.push(bmp);
				
				ui.graphics.clear();
				ui.graphics.beginFill(0x0a4475,0.65);
				ui.graphics.drawRect(0,0,748,48);
				bmd = new BitmapData(748,48,true,0);
				bmd.draw(ui);
				bmp = new Bitmap(bmd);
				bmp.name = 'bgQuad2';
				assets.push(bmp);
				
				var tf:TextFormat = new TextFormat('HeiTi',16,0xFFFFFF);
				tf.letterSpacing = -2;
				BitmapFontUtils.init(bmpStr,assets,tf);
			}
		}
		
		override public function handleNotification(notification:INotification):void
		{
			super.handleNotification(notification);
			switch(notification.getName()){
				case CLASSIFY://分类只进来一次
					if((PackData.app.CmdOStr[0] as String).charAt(1)=="0"){//接收
						var musicClassify:MusicClassify = new MusicClassify();
						musicClassify.grid = PackData.app.CmdOStr[1];
						musicClassify.className = PackData.app.CmdOStr[3];						
						classifyArr.push(musicClassify);						
					}else if((PackData.app.CmdOStr[0] as String).charAt(0)=="!"){//接收完成
						musicClassify = new MusicClassify();
						musicClassify.grid = "0";
						musicClassify.className = defaultStr;						
						classifyArr.push(musicClassify);
						classifyTxt.text = defaultStr;
						
						
						if(classifyArr.length<2){
							preClassBtn.visible = false;
							nextClassBtn.visible = false;
						}
						//第二部获取未分类的歌曲			
						Index = classifyArr.length-1;
						currentGrid = "0";
						changeList();
					}
					break;				
				case MUSIC_LIST:
					if((PackData.app.CmdOStr[0] as String).charAt(1)=="0"){//接收
						var baseClass:MusicBaseClass = new MusicBaseClass(PackData.app.CmdOStr);						
						
						if(baseClass.hasSource){
							tempPre.push(baseClass);
						}else{
							tempEnd.push(baseClass);							
						}
					}else if((PackData.app.CmdOStr[0] as String).charAt(0)=="!"){//接收完成
						stopUpdateList();//停止刷新列表
						if(dic[currentGrid]==null){
							dic[currentGrid] = new ListCollection();
						}
						initBitmapFont(dic[currentGrid]);
						
						preClassBtn.enabled = true;
						nextClassBtn.enabled = true;
						selectPlayItem();
						queueDownMediator.downloadNextItem();
						trace("@VIEW:MusicListPlayMediator:");
					}										
					break;
				case WorldConst.CURRENT_DOWN_RESINFOSP:
					currentDown = notification.getBody() as MusicBaseClass;					
					break;
				case WorldConst.CURRENT_DOWN_COMPLETE:///下载完成
					currentDown = notification.getBody() as MusicBaseClass;	
					currentDown.hasSource = true;					
					try{
						dic[currentGrid].updateItemAt(dic[currentGrid].getItemIndex(currentDown));						
					}catch(e:Error){
						
					}
					break;
				case WorldConst.Del_Music:
					currenDel = notification.getBody() as MusicBaseClass;
					if(currenDel){						
						var userId:String = PackData.app.head.dwOperID.toString();
						sendDelayMediator.sendinServerInfo(CmdStr.DEL_RESOURCE,YES_DEL_FILE,["UMDI",userId,Global.user,"0","",currenDel.instid]);
					}
					break;
				case YES_DEL_FILE:
					if(currenDel && dic[currentGrid].contains(currenDel)){
						dic[currentGrid].removeItem(currenDel);
						queueDownMediator.removeOf(currenDel);
//						currenDel = null;
					}
					queueDownMediator.downloadNextItem();
					break;
				case WorldConst.Move_BgMusic:
					currentBg = notification.getBody() as MusicBaseClass; 
					var bgVO:BackgroundMusicVO = new BackgroundMusicVO(currentBg.goodsId,currentBg.Name,currentBg.encrypt);
					if(currentBg.isBgMusic=="0"){
						sendDelayMediator.execute(sendNotification,[WorldConst.ADD_BGMUSIC,bgVO]);
					}else{
						sendDelayMediator.execute(sendNotification,[WorldConst.DEL_BGMUSIC,bgVO]);
					}										
					break;
				case WorldConst.DEL_BGMUSIC_OVER://删除背景音乐
					sendNotification(CoreConst.TOAST,new ToastVO(currentBg.Name+" 已在背景音乐列表删除."));
					CacheTool.put('MusicSoundMediator','ChangeBackGround',true);//背景音乐已修改
					sendNotification(CoreConst.PLAY_EFFECT_SOUND,new PlaySoundEffectVO("wordRight",0.7));
					currentBg.isBgMusic = "0";
					if(dic[currentGrid]){
						dic[currentGrid].updateItemAt(dic[currentGrid].getItemIndex(currentBg));
					}
					queueDownMediator.downloadNextItem();
					break;
				case WorldConst.ADD_BGMUSIC_OVER://添加背景音乐成功
					CacheTool.put('MusicSoundMediator','ChangeBackGround',true);
					sendNotification(CoreConst.TOAST,new ToastVO(currentBg.Name+" 设为背景音乐成功."));
//					SoundAS.play("wordRight",0.7);	
					sendNotification(CoreConst.PLAY_EFFECT_SOUND,new PlaySoundEffectVO("wordRight",0.7));

					currentBg.isBgMusic = "1";
					if(dic[currentGrid]){
						dic[currentGrid].updateItemAt(dic[currentGrid].getItemIndex(currentBg));
					}
					queueDownMediator.downloadNextItem();
					break;
				case MP3PlayerProxy.LOADED_COMPLETE:
					url = notification.getBody() as String;
					selectPlayItem();		
					break;				
			}
		}
		
		private var tempPre:ListCollection = new ListCollection();
		private var tempEnd:ListCollection = new ListCollection();
		private function updateList():void{
			if(tempPre.length>0){
				dic[currentGrid].addAllAt(tempPre,0);
				tempPre.removeAll();
			}
			if(tempEnd.length>0){
				dic[currentGrid].addAll(tempEnd);
				tempEnd.removeAll();
			}			
			TweenLite.delayedCall(2,updateList);
				
		}
		private function stopUpdateList():void{
			updateList();
			TweenLite.killTweensOf(updateList);
		}
		
		//选择当前正在播放的歌曲
		private function selectPlayItem():void{
			if(url=='') return;
			if(dic[currentGrid]){
				for(var i:int=0;i<dic[currentGrid].length;i++){
					if(dic[currentGrid].getItemAt(i).Encrypt_path == url){
						playList.selectedItem = dic[currentGrid].getItemAt(i);
						break;
					}
				}
			}
		}
		
		// 该函数为降低刷新List频率
		override protected function updateLoadingHandler():void
		{
			if(currentDown){					
				currentDown.downPercent = (process/total * 100).toString().substr(0,5) + "%";	
				if(dic[currentGrid]){
					dic[currentGrid].updateItemAt(dic[currentGrid].getItemIndex(currentDown));
				}
			}			
		}
		
		override public function listNotificationInterests():Array
		{ 			
			var arr:Array = super.listNotificationInterests();
			return arr.concat([WorldConst.CURRENT_DOWN_COMPLETE,WorldConst.ADD_BGMUSIC_OVER,WorldConst.DEL_BGMUSIC_OVER,MP3PlayerProxy.LOADED_COMPLETE,YES_DEL_FILE,CLASSIFY,MUSIC_LIST,WorldConst.CURRENT_DOWN_RESINFOSP, WorldConst.Del_Music,WorldConst.Move_BgMusic]);
		}

	}
}