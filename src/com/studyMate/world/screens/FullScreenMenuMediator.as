package com.studyMate.world.screens
{
	import com.mylib.api.ISwitchScreenProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.component.DotNavigationSp;
	import com.studyMate.world.screens.chatroom.ChatRoomMediator;
	import com.studyMate.world.screens.email.EmailViewMediator;
	
	import feathers.controls.ScrollContainer;
	import feathers.events.FeathersEventType;
	import feathers.layout.TiledRowsLayout;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.ColorMatrixFilter;
	import starling.text.TextField;

	public class FullScreenMenuMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "FullScreenMenuMediator";		
		private const GETMONEY:String = "GetMoney";
		
		private var btnContainer:ScrollContainer;
		private var searchWordBtn:CalloutMenuButton
		private var FAQBtn:CalloutMenuButton;
		private var musicBtn:CalloutMenuButton;
		private var appointBtn:CalloutMenuButton;
		private var achievementBtn:CalloutMenuButton;
		private var chatBtn:CalloutMenuButton;
		private var emailBtn:CalloutMenuButton;
		private var settingBtn:CalloutMenuButton;
		private var studyRepBtn:CalloutMenuButton;
		
		private var buttonMap:Vector.<CalloutMenuButton>;
		private var filter:ColorMatrixFilter;
		private var dotSp:DotNavigationSp;
		
		public function FullScreenMenuMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRemove():void
		{
			view.removeChildren(0,-1,true);
			buttonMap.length = 0;
			buttonMap = null;
			sendNotification(WorldConst.SHOW_MAIN_MENU);
			super.onRemove();
		}	
		
		override public function onRegister():void
		{
			var bg:Image = new Image(Assets.getTexture("menuBackground"));
			bg.blendMode = BlendMode.NONE;
			view.addChild(bg);
			
			buttonMap = new Vector.<CalloutMenuButton>();
			
			var matrix:Vector.<Number>= Vector.<Number>([0.3086, 0.6094, 0.0820, 0, 0,  
				0.3086, 0.6094, 0.0820, 0, 0,  
				0.3086, 0.6094, 0.0820, 0, 0,  
				0,      0,      0,      1, 0]);  			
			filter = new ColorMatrixFilter(matrix);
		
			var layout:TiledRowsLayout = new TiledRowsLayout();
			layout.paddingTop = 108;
			layout.paddingLeft = 50;
			layout.horizontalGap = 85;
			layout.verticalGap = 50;
			layout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			
			btnContainer = new ScrollContainer();		
			btnContainer.snapToPages = true;			
			btnContainer.width = Global.stageWidth; btnContainer.height = Global.stageHeight;
			btnContainer.layout = layout;
			btnContainer.addEventListener(FeathersEventType.SCROLL_COMPLETE,scrollCompleteHandler);
			btnContainer.addEventListener(FeathersEventType.CREATION_COMPLETE,creatCompleteHandler);
			view.addChild(btnContainer);
			
			addBtnGroupHandler();//添加全部按钮
			disableSomeHandler();//禁用部分按钮
			showNum(); //显示数目标记
								
			super.onRegister();
			trace("@VIEW:FullScreenMenuMediator:");
		}
		
		private function creatCompleteHandler():void
		{
			btnContainer.horizontalScrollBarFactory = null;
			dotSp = new DotNavigationSp();
			dotSp.pageTotal = btnContainer.horizontalPageCount;
			dotSp.x = Global.stageWidth>>1;
			dotSp.y = Global.stageHeight - 100;
			view.addChild(dotSp);
		}
		private function addBtnGroupHandler():void
		{
			FAQBtn = new CalloutMenuButton(Assets.getMenuAtlasTexture("FAQIcon"));
			FAQBtn.name = "FAQBtn"; FAQBtn.level = 3;
			FAQBtn.pivotX = FAQBtn.width/2;
			FAQBtn.pivotY = FAQBtn.height/2;					
			
			musicBtn = new CalloutMenuButton(Assets.getMenuAtlasTexture("musicIcon"));
			musicBtn.name = "musicBtn"; musicBtn.level = 2;
			musicBtn.pivotX = musicBtn.width/2;
			musicBtn.pivotY = musicBtn.height/2;			
			
			emailBtn = new CalloutMenuButton(Assets.getMenuAtlasTexture("emailIcon"));
			emailBtn.name = "emailBtn"; emailBtn.level = 1;
			emailBtn.pivotX = emailBtn.width/2;
			emailBtn.pivotY = emailBtn.height/2;
			
			chatBtn = new CalloutMenuButton(Assets.getMenuAtlasTexture("chatIcon"));
			chatBtn.name = "chatBtn"; chatBtn.level = 1;
			chatBtn.pivotX = chatBtn.width/2;
			chatBtn.pivotY = chatBtn.height/2;			
			
			achievementBtn = new CalloutMenuButton(Assets.getMenuAtlasTexture("achievementIcon"));
			achievementBtn.name = "achievementBtn"; achievementBtn.level = 1;
			achievementBtn.pivotX = achievementBtn.width/2;
			achievementBtn.pivotY = achievementBtn.height/2;			
			
			studyRepBtn = new CalloutMenuButton(Assets.getMenuAtlasTexture("studyReportIcon"));
			studyRepBtn.name = "studyRepBtn"; studyRepBtn.level = 1;
			studyRepBtn.pivotX = studyRepBtn.width/2;
			studyRepBtn.pivotY = studyRepBtn.height/2;			
			
			appointBtn = new CalloutMenuButton(Assets.getMenuAtlasTexture("appointIcon"));
			appointBtn.name = "appointBtn"; appointBtn.level = 1;
			appointBtn.pivotX = appointBtn.width/2;
			appointBtn.pivotY = appointBtn.height/2;			
			
			searchWordBtn =  new CalloutMenuButton(Assets.getAtlasTexture("searchWordBtn"));
			searchWordBtn.name = "searchWordBtn"; searchWordBtn.level = 1;
			searchWordBtn.pivotX = searchWordBtn.width/2;
			searchWordBtn.pivotY = searchWordBtn.height/2;
			
			settingBtn = new CalloutMenuButton(Assets.getMenuAtlasTexture("settingIcon"));
			settingBtn.name = "settingBtn"; settingBtn.level = 1;
			settingBtn.pivotX = settingBtn.width/2;
			settingBtn.pivotY = settingBtn.height/2;
			
			buttonMap.push(FAQBtn);
			buttonMap.push(musicBtn);
			buttonMap.push(emailBtn);
			buttonMap.push(chatBtn);
			buttonMap.push(achievementBtn);
			buttonMap.push(studyRepBtn);
			buttonMap.push(appointBtn);
			buttonMap.push(searchWordBtn);
			buttonMap.push(settingBtn);
			
			for(var i:int=0;i<buttonMap.length;i++){
				btnContainer.addChild(buttonMap[i]);
				buttonMap[i].addEventListener(TouchEvent.TOUCH,btnClickHandler);
			}
		}	
		
		private function showNum():void
		{
			addMarkeHandler(chatBtn,CalloutMenuMediator2.chatNum);
			addMarkeHandler(emailBtn,CalloutMenuMediator2.emailNum);
			addMarkeHandler(FAQBtn,CalloutMenuMediator2.faqNum);			
		}
				
		private function addMarkeHandler(container:DisplayObjectContainer,num:int):void{
			if(num>0){
				var markBtn:Button = new Button(Assets.getMenuAtlasTexture("num"));
				markBtn.x = container.width*0.7;
				markBtn.scaleX = 2;
				markBtn.scaleY = 2;
				container.addChild(markBtn);
				
				var txt:TextField = new starling.text.TextField(40, 40,String(num),"HeiTi",20,0xffffff,false);
				txt.scaleX = 0.5;
				txt.scaleY = 0.5;
				markBtn.addChild(txt);				
			}
		}
						
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case WorldConst.HIDE_MENU_BUTTON:
					view.touchable = false
					break;
				case WorldConst.SHOW_MENU_BUTTON:
					view.touchable = true
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [GETMONEY,WorldConst.HIDE_MENU_BUTTON,WorldConst.SHOW_MENU_BUTTON];
		}
		
		private function scrollCompleteHandler():void
		{
			trace('scrollCompleteHandler',btnContainer.horizontalPageIndex);
//			btnContainer.
			
			dotSp.pageIndex = btnContainer.horizontalPageIndex
		}
			

	
		private var beginX:Number;
		private var endX:Number;
		private function btnClickHandler(event:TouchEvent):void{
			var obj:DisplayObject = event.target as DisplayObject;
			var touchPoint:Touch = event.getTouch(obj);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					beginX = touchPoint.globalX;
				}else if(touchPoint.phase==TouchPhase.ENDED){
					endX = touchPoint.globalX;
					if(Math.abs(endX-beginX) < 10){	
						activeBtnHandler(obj.name);
					}
				}
				
			}
		}
		private function activeBtnHandler(name:String):void{
			CalloutMenuMediator2.shortcut = name;
			switch(name){
				case 'FAQBtn':
					sendNotification(WorldConst.CLOSE_MENU);
					sendNotification(WorldConst.SWITCH_SCREEN,new SwitchScreenVO(FAQChatMediator,null,SwitchScreenType.SHOW,null));
					if(CalloutMenuMediator2.faqNum>0){
						FAQBtn.removeChildren(1,FAQBtn.numChildren-1,true);
//						CalloutMenuMediator2.faqNum = 0;
						sendNotification(WorldConst.REFRESH_NUM);						
					}
					break;
				case 'musicBtn':
					sendNotification(WorldConst.CLOSE_MENU);
					sendNotification(WorldConst.SHOW_MUSICPLAYER);
					break;
				case "emailBtn":
					sendNotification(WorldConst.REGIST_MENU_SCREEN,new SwitchScreenVO(EmailViewMediator,null,SwitchScreenType.SHOW,null));
					if(CalloutMenuMediator2.emailNum>0){
						emailBtn.removeChildren(1,emailBtn.numChildren-1,true);
						CalloutMenuMediator2.emailNum = 0;
						sendNotification(WorldConst.REFRESH_NUM);
					}
					break;
				case "chatBtn":
					sendNotification(WorldConst.REGIST_MENU_SCREEN,new SwitchScreenVO(ChatRoomMediator));
					if(CalloutMenuMediator2.chatNum>0){
						chatBtn.removeChildren(1,chatBtn.numChildren-1,true);
						CalloutMenuMediator2.chatNum =0;
						sendNotification(WorldConst.REFRESH_NUM);
					}
					break;
				case "achievementBtn":
					sendNotification(WorldConst.REGIST_MENU_SCREEN,new SwitchScreenVO(HonourViewMediator,null,SwitchScreenType.SHOW,null));
					break;
				case "studyRepBtn":
					sendNotification(WorldConst.SWITCH_SCREEN,new SwitchScreenVO(MonthTaskInfoMediator,null,SwitchScreenType.SHOW,null));			
					break;
				case "appointBtn":
					sendNotification(WorldConst.REGIST_MENU_SCREEN,new SwitchScreenVO(ShowProMediator,null,SwitchScreenType.SHOW,null));
					break;
				case "searchWordBtn":		
//					sendNotification(WorldConst.CLOSE_MENU);
					sendNotification(WorldConst.SWITCH_SCREEN,new SwitchScreenVO(DictionaryMediator,'',SwitchScreenType.SHOW,null));
					break;
				case "settingBtn":
					sendNotification(WorldConst.REGIST_MENU_SCREEN,new SwitchScreenVO(SystemSetMediator,null,SwitchScreenType.SHOW,null));
					break;
			}
		}
		
		
		
		
		private function disableSomeHandler():void{
			var currentScreen:ScreenBaseMediator = (facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy).currentGpuScreen;
			if(currentScreen){				
				switch(currentScreen.getMediatorName())
				{
					case ModuleConst.TASKLIST:
					case "WordLearningBGMediator":	
					case "ReadBGMediator":
					case "ExercisesLearnMediator":
						disableLevel(1);
						break;
					case "TalkingBookMediator":
					case ModuleConst.TASKLIST_SPOKEN:
					case "SpokenNewMediator":
					case ModuleConst.WRONGWORD:
					case ResTableMediator.NAME:
					case "ReadAloudBGMediator":
						disableLevel(1);
						disableLevel(2);
						break;
					default:
						disableLevel(2);
						break;								
				}
			}else{
				disableLevel();
			}
		}
		/**
		 * @param level 禁用的层级 -1代表全部禁用
		 */		
		public function disableLevel(level:int=-1):void{						
			if(level==-1){
				for(var i:int=0;i<buttonMap.length;i++){
					buttonMap[i].touchable = false;
					buttonMap[i].filter = filter;
				}
			}else{
				for(i=0;i<buttonMap.length;i++){
					if(buttonMap[i].level==level){
						buttonMap[i].touchable = false;
						buttonMap[i].filter = filter;
					}
				}
			}
		}
				
		override public function prepare(vo:SwitchScreenVO):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class{
			return Sprite;
		}		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}				
	}
}