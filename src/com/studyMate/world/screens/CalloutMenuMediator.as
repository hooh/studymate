package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.controller.vo.DisplayChatViewCommandVO;
	import com.studyMate.world.vo.ButtonTipsVO;
	
	import feathers.controls.ScrollContainer;
	import feathers.layout.VerticalLayout;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class CalloutMenuMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "CalloutMenuMediator";
		
		private var bg:Image;
		private var btnContainer:ScrollContainer;
		private var showBtn:Button;
		private var blinkIcon:LoopBlinkIcon;
		//		private var buttonMap:Dictionary;
		private var buttonMap:Array;
		
		public function CalloutMenuMediator()
		{
			super(NAME, new starling.display.Sprite);
		}
		
		override public function onRegister():void
		{
			addBaseFrame();
			addBtnContainer();
			addButtons();
		}
		
		override public function onRemove():void
		{
			view.removeEventListener(Event.ADDED_TO_STAGE,addListener);	
			if(view.stage != null){
				view.stage.removeEventListener(TouchEvent.TOUCH,stageTouchHandle);
			}
			
			for each (var i:CalloutMenuButton in buttonMap) {
				i.dispose();
			}
			
			view.removeChildren(0,-1,true);
			
			bg.dispose();
			
			super.onRemove();
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var btnName:String;
			switch(notification.getName()){
				case WorldConst.ADD_MAINMENU_BUTTON : 
					var btn:CalloutMenuButton = notification.getBody() as CalloutMenuButton;
					addButton(btn);
					showButton(btn.name);
					break;
				case WorldConst.REMOVE_MAINMENU_BUTTON : 
					btnName = notification.getBody() as String;
					removeButton(btnName);
					break;
				case WorldConst.SHOW_MAINMENU_BUTTON :
					btnName = notification.getBody() as String;
					showButton(btnName);
					break;
				case WorldConst.HIDE_MAINMENU_BUTTON :
					btnName = notification.getBody() as String;
					hideButton(btnName);
					break;
				case WorldConst.ADD_BLINK_ICON :
					btnName = notification.getBody() as String;
					addBlinkIcon(btnName);
					break;
				case WorldConst.CHANGE_BUTTON_TIPS :
					var data:ButtonTipsVO = notification.getBody() as ButtonTipsVO;
					changeBtnTips(data);
					break;
				case WorldConst.SHOW_BUTTON_BY_LEVEL :
					var level:int = notification.getBody() as int;
					showButtonByLevel(level);
					break;
				case WorldConst.BROADCAST_FAQ:
					var _tips:int = int(notification.getBody());
					//大于0 有提示
					trace("FAQ提示："+_tips);
					sendNotification(WorldConst.CHANGE_BUTTON_TIPS, new ButtonTipsVO("FAQBtn", _tips));
					
					break;
				case WorldConst.BROADCAST_MAIL:
					_tips = int(notification.getBody());
					//大于0 有提示
					trace("MAIL提示："+_tips);
					_tips>0?Global.unreadMessage = true:Global.unreadMessage = false;
					sendNotification(WorldConst.CHANGE_BUTTON_TIPS, new ButtonTipsVO("MessageBtn", _tips));
					break;
				default :
					break;
			}
		}
		
		
		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.ADD_MAINMENU_BUTTON, WorldConst.REMOVE_MAINMENU_BUTTON, 
				WorldConst.ADD_BLINK_ICON, WorldConst.CHANGE_BUTTON_TIPS, 
				WorldConst.SHOW_MAINMENU_BUTTON, WorldConst.HIDE_MAINMENU_BUTTON, 
				WorldConst.SHOW_BUTTON_BY_LEVEL,WorldConst.BROADCAST_FAQ,WorldConst.BROADCAST_MAIL];
		}
		
		public function get view():starling.display.Sprite{
			return getViewComponent() as starling.display.Sprite;
		}
		
		private function addBaseFrame():void{
			view.name = "MainMenu";
			view.x = 1145; view.y = -656;  //-726+70 ,726为菜单背景长度
			
			bg = new Image(Assets.getAtlasTexture("mainMenu/menuBg"));
			view.addChild(bg);
			
			buttonMap = new Array();
			
			showBtn = new Button(Assets.getAtlasTexture("mainMenu/menuShowBtn"));
			showBtn.pivotX = showBtn.width>>1; showBtn.pivotY = showBtn.height>>1;
			showBtn.x = 35+(showBtn.width>>1); showBtn.y = 661+(showBtn.height>>1);
			view.addChild(showBtn);
			showBtn.addEventListener(TouchEvent.TOUCH, showBtnHandle);
			
			blinkIcon = new LoopBlinkIcon();
			blinkIcon.x = -8; blinkIcon.y = 668;
			view.addChild(blinkIcon);
			
			view.addEventListener(Event.ADDED_TO_STAGE, addListener);
		}
		
		private function addBtnContainer():void{
			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = 10; layout.paddingTop = 20;
			layout.verticalAlign = VAlign.TOP;
			layout.horizontalAlign = HAlign.CENTER;
			
			btnContainer = new ScrollContainer();
			btnContainer.layout = layout;
			btnContainer.snapScrollPositionsToPixels = true;
			btnContainer.width = 125; btnContainer.height = 656;
			view.addChild(btnContainer);
		}
		
		private function addButtons():void{
			var btn:CalloutMenuButton = new CalloutMenuButton(Assets.getAtlasTexture("mainMenu/FAQBtn"));
			btn.secUpState = Assets.getAtlasTexture("mainMenu/MsgSecBtn");
			btn.name = "FAQBtn"; btn.level = 1;
			btn.addEventListener(Event.TRIGGERED, onEnterFaqHandler);
			addButton(btn);
			showButton("FAQBtn");
			
			btn = new CalloutMenuButton(Assets.getAtlasTexture("mainMenu/growUpBtn"));
			btn.name = "GrowUpBtn"; btn.level = 2;
			btn.addEventListener(Event.TRIGGERED, showGrowUpHandler);
			addButton(btn);
			showButton("GrowUpBtn");
			
			btn = new CalloutMenuButton(Assets.getAtlasTexture("mainMenu/MessageBtn"));
			btn.secUpState = Assets.getAtlasTexture("mainMenu/MsgSecBtn");
			btn.name = "MessageBtn"; btn.level = 2;
			btn.addEventListener(Event.TRIGGERED, showMessageHandler);
			addButton(btn);
			showButton("MessageBtn");
			
			btn = new CalloutMenuButton(Assets.getAtlasTexture("mainMenu/honourBtn"));
			btn.name = "HonourBtn"; btn.level = 2;
			btn.addEventListener(Event.TRIGGERED, showHonourHandler);
			addButton(btn);
			showButton("HonourBtn");
			
			btn = new CalloutMenuButton(Assets.getAtlasTexture("mainMenu/ProBtn"));
			btn.secUpState = Assets.getAtlasTexture("mainMenu/proSecBtn");
			btn.name = "PromiseBtn"; btn.level = 2;
			btn.addEventListener(Event.TRIGGERED, onEnterPromises);
			addButton(btn);
			showButton("PromiseBtn");
			
			btn = new CalloutMenuButton(Assets.getAtlasTexture("mainMenu/SettingBtn"));
			btn.name = "SettingBtn"; btn.level = 2;
			btn.addEventListener(Event.TRIGGERED, onEnterSettingHandler);
			addButton(btn);
			showButton("SettingBtn");
			
			btn = new CalloutMenuButton(Assets.getAtlasTexture("mainMenu/croomBtn"));
			btn.name = "croomBtn"; btn.level = 2;
//			btn.addEventListener(Event.TRIGGERED, onEnterCRoomHandler);
			addButton(btn);
			showButton("croomBtn");

			btn = new CalloutMenuButton(Assets.getAtlasTexture("mainMenu/SettingBtn"),"我的房间");
			btn.name = "MyDressBtn"; btn.level = 2;
			btn.addEventListener(Event.TRIGGERED, myDressBtnHandler);
			addButton(btn);
			showButton("MyDressBtn");
			
			btn = new CalloutMenuButton(Assets.getAtlasTexture("mainMenu/SettingBtn"),"装备商城");
			btn.name = "DressMarketBtn"; btn.level = 2;
			btn.addEventListener(Event.TRIGGERED, dressMarketBtnHandler);
			addButton(btn);
			showButton("DressMarketBtn");
			
			
			btn = new CalloutMenuButton(Assets.getAtlasTexture("mainMenu/menuSound"));
			btn.name = "menuSoundBtn";
			btn.addEventListener(Event.TRIGGERED, onEnterMusicHandler);
			addButton(btn);
		}
		
		private function addBlinkIcon(btnName:String):void{
			var btn:CalloutMenuButton = btnContainer.getChildByName(btnName) as CalloutMenuButton;
			if(btn == null) return;
			blinkIcon.addIcon(btn.name, btn.secUpState);
		}
		
		private function changeBtnTips(data:ButtonTipsVO):void{
			var btn:CalloutMenuButton = btnContainer.getChildByName(data.buttonName) as CalloutMenuButton;
			if(btn == null) return;
			btn.number = data.tipsNumber;
			if(btn.number > 0){
				sendNotification(WorldConst.ADD_BLINK_ICON, btn.name);
			}
		}
		
		private var _isShow:Boolean;
		public function get isShow():Boolean
		{
			return _isShow;
		}
		
		public function set isShow(value:Boolean):void{
			if(isShow == value){
				return;
			}
			if(value == false){  //隐藏
				TweenLite.to(showBtn,0.3,{rotation:0});
				TweenLite.to(view,0.3,{y:-656});
			}else{  //显示
				TweenLite.to(showBtn,0.3,{rotation:Math.PI});
				TweenLite.to(view,0.3,{y:0});
				blinkIcon.clearBlink();
			}
			_isShow = value;
		}
		
		private var beginX:Number;
		private var endX:Number;
		private function showBtnHandle(event:TouchEvent):void{
			var btn:Button = event.currentTarget as Button;
			var touchPoint:Touch = event.getTouch(btn);
			if(touchPoint == null){
				return;
			}
			if(touchPoint.phase == TouchPhase.BEGAN){
				beginX = touchPoint.globalX;
			}else if(touchPoint.phase == TouchPhase.ENDED){
				endX = touchPoint.globalX;
			if(Math.abs(endX-beginX) < 50){
				TweenLite.killTweensOf(view);
				isShow = !isShow;
			}
			}
		}
		
		private function addListener(event:Event):void{		
			if(view.stage){
				view.stage.addEventListener(TouchEvent.TOUCH, stageTouchHandle);
			}
		}
		
		private function addButton(btn:CalloutMenuButton):void{
			var name:String = btn.name;
			for each (var i:CalloutMenuButton in buttonMap) {
				if(i.name == name){
					if(i == btn){
						return;
					}
					buttonMap.splice(buttonMap.indexOf(i),1);
					view.removeChild(i);
					i.dispose();
				}
			}
			buttonMap.push(btn);
		}
		
		private function removeButton(name:String):void{
			for each (var i:CalloutMenuButton in buttonMap) {
				if(i.name == name){
					buttonMap.splice(buttonMap.indexOf(i),1);
					i.dispose();
					return;
				}
			}
		}
		
		private function getButton(name:String):CalloutMenuButton{
			for each (var i:CalloutMenuButton in buttonMap) {
				if(i.name == name){
					return i;
				}
			}
			return null;
		}
		
		private function showButton(name:String):void{
			if(btnContainer.getChildByName(name)){
				return;
			}
			var btn:CalloutMenuButton = getButton(name);
			if(btn){
				btnContainer.addChild(btn);
			}
		}
		
		private function hideButton(name:String):void{
			var btn:CalloutMenuButton = getButton(name);
			if(btn){
				btnContainer.removeChild(btn);
			}
		}
		
		private function showButtonByLevel(level:int = -1):void{
			btnContainer.removeChildren(0, -1);
			var button:CalloutMenuButton;
			var key:String;
			if(level == -1){
				for each (var i:CalloutMenuButton in buttonMap) {
					btnContainer.addChild(i);
				}
			}else{
				for each (var j:CalloutMenuButton in buttonMap) {
					if(j.level != -1 && j.level <= level){
						btnContainer.addChild(j);
					}
				}
				
			}
		}
		
		//监听点击屏幕其他地方，关闭主菜单
		private function stageTouchHandle(event:TouchEvent):void{
			var touchPoint:Touch = event.getTouch(event.target as DisplayObject);
			if(touchPoint == null){
				return;
			}
			if(touchPoint.phase == TouchPhase.BEGAN){
				if(bg.getBounds(view.stage).contains(touchPoint.globalX,touchPoint.globalY) == false){ //主菜单区域
					isShow = false;
				}
			}
		}
		
		private function onEnterFaqHandler(event:Event):void{
			sendNotification(WorldConst.SHOW_CHAT_VIEW,new DisplayChatViewCommandVO(false));
			
			//sendNotification(WorldConst.SHOW_FAQ_ALERT);
			//			var faqMeidator:FAQChatMediator = new FAQChatMediator(new flash.display.Sprite);
			//			faqMeidator.view.x = 302;
			//			faqMeidator.view.y = 0;
			//			sendNotification(WorldConst.POPUP_SCREEN,(new PopUpCommandVO(faqMeidator)));
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(FAQChatMediator,null,SwitchScreenType.SHOW,null)]);
		}
		
		//进入成就界面
		private function showHonourHandler(event:Event):void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(HonourViewMediator),new SwitchScreenVO(CleanCpuMediator)]);
			//			sendNotification(CoreConst.SWITCH_MODULE,[new SwitchScreenVO(ModuleConst.DRESS_MARKET_MANAGER)]);
			//			sendNotification(CoreConst.SWITCH_MODULE,[new SwitchScreenVO(ModuleConst.DRESS_ROOM)]);
		}
		
		//打开成长日历界面
		private function showGrowUpHandler(event:Event):void{
			sendNotification(WorldConst.SHOW_CHAT_VIEW,new DisplayChatViewCommandVO(false));
			
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(MonthTaskInfoMediator,Global.player.operId.toString(),SwitchScreenType.SHOW,AppLayoutUtils.gpuLayer)]);
		}
		
		//进入设置界面
		private function onEnterSettingHandler(event:Event):void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SystemSetMediator),new SwitchScreenVO(CleanCpuMediator)]);
			
			//			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(AndroidGameShowMediator)]);
			//			sendNotification(CoreConst.SWITCH_MODULE,[new SwitchScreenVO(ModuleConst.DRESS_ROOM)]);
			//			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(FightGameMediator),new SwitchScreenVO(CleanCpuMediator)]);
		}
//		private function onEnterCRoomHandler(event:Event):void{
//			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ListClassRoomMediator)]);
//		}
		
		//进入约定界面
		private function onEnterPromises(event:Event):void{
			var data:String = ShowProMediator.SHOW_ALL;
			if(Global.myPromiseInf == null){
				data = ShowProMediator.SHOW_ALL;
			}else if(Global.myPromiseInf.newFinishCount != 0){
				data = ShowProMediator.SHOW_FINISH;
			}else if(Global.myPromiseInf.unFinishCount != 0){
				data = ShowProMediator.SHOW_UNFINISH;
			}
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(CleanCpuMediator),new SwitchScreenVO(ShowProMediator,data)]);
			
			//			sendNotification(CoreConst.SWITCH_MODULE,[new SwitchScreenVO(ModuleConst.DRESS_MARKET)]);
			//			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(TestFightGameMediator)]);
		}
		
		//显示消息
		private function showMessageHandler(e:Event):void{
			sendNotification(WorldConst.SHOW_CHAT_VIEW,new DisplayChatViewCommandVO(false));
			
			//			sendNotification(WorldConst.GET_ALL_MESSAGE, AppLayoutUtils.uiLayer);
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ShowMessageMediator,["A"],SwitchScreenType.SHOW, AppLayoutUtils.uiLayer)]);
			//			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ShowMessageMediator,["A"])]);
		}
		
		//打开音乐
		private function onEnterMusicHandler(event:Event):void{
			sendNotification(WorldConst.SHOW_MUSICPLAYER);
		}
		
		
		
		
		//服装房间
		private function myDressBtnHandler(e:Event):void{
			sendNotification(CoreConst.SWITCH_MODULE,[new SwitchScreenVO(ModuleConst.DRESS_ROOM)]);
		}
		//装备商城
		private function dressMarketBtnHandler(e:Event):void{
			sendNotification(CoreConst.SWITCH_MODULE,[new SwitchScreenVO(ModuleConst.DRESS_MARKET)]);
		}
		
	}
}


