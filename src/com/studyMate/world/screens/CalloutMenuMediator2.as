package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.mylib.api.ISwitchScreenProxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.screens.chatroom.ChatRoomMediator;
	import com.studyMate.world.screens.email.EmailViewMediator;
	
	import flash.events.KeyboardEvent;
	
	import feathers.controls.ScrollContainer;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	public class CalloutMenuMediator2 extends Mediator implements IMediator
	{
		public static const NAME:String = "CalloutMenuMediator2";
		
		private var btnContainer:ScrollContainer;
		private var showBtn:Button;
		private var buttonMap:Array;
		private var selectBackground:Image

		
		public static var shortcut:String = "";
		
		public static var emailNum:int;
		public static var chatNum:int;
		public static var faqNum:int;
		
		
		public function CalloutMenuMediator2()
		{
			super(NAME, new starling.display.Sprite);
		}
		
		override public function onRegister():void
		{
			addBaseFrame();
			addBtnContainer();
		}
		
		override public function onRemove():void
		{

			TweenLite.killTweensOf(emailBtn);
			TweenLite.killTweensOf(FAQBtn);
			TweenLite.killTweensOf(chatBtn);
			TweenLite.killTweensOf(selectBackground);
			showBtn.removeEventListener(TouchEvent.TOUCH, showBtnHandle);
			for each (var i:Button in buttonMap) {
				i.dispose();
			}
			view.removeFromParent(true);
			super.onRemove();
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var currentScreen:ScreenBaseMediator = (facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy).currentGpuScreen;
			switch (notification.getName())
			{
				case WorldConst.BROADCAST_FAQ:
				{
					faqNum = int(notification.getBody());
					if(faqNum != 0){
						if(!judeBtn("FAQBtn")){
							activeBackground();
							addButton(FAQBtn);
							showButton();
							FAQBtn.alpha =0;
							TweenLite.killTweensOf(FAQBtn);
							TweenLite.to(FAQBtn, 5, {alpha:1});
						}
					}else{
						if(view.contains(FAQBtn)){
							view.removeChild(FAQBtn,false);
							removeButtonMap("FAQBtn")
							showButton();
						}
					}
					break;
				}
				case WorldConst.BROADCAST_MAIL:
				{
					emailNum = int(notification.getBody());
					if(emailNum != 0){
//						if(Global.is||currentScreen.getMediatorName()=="IslandWelcomeMediator"){
//								sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(EmailViewMediator)]);
//						}else{
							if(!judeBtn("emailBtn")){
								activeBackground();
								addButton(emailBtn);
								showButton();
								emailBtn.alpha =0;
								TweenLite.killTweensOf(emailBtn);
								TweenLite.to(emailBtn, 5, {alpha:1});
							}
//						}
					}else{
						if(view.contains(emailBtn)){
							view.removeChild(emailBtn,false);
							removeButtonMap("emailBtn");
							showButton();
							
						}
					}
					break;
				}
				case WorldConst.BROADCAST_CHAT:
				{
					chatNum = int(notification.getBody());
//					trace(chatNum)
					if(chatNum != 0){
						if(!judeBtn("chatBtn")){
							addButton(chatBtn);
							showButton();
							activeBackground();
							chatBtn.alpha =0;
							TweenLite.killTweensOf(chatBtn);
							TweenLite.to(chatBtn, 5, {alpha:1});
						}
					}else{
						if(view.contains(chatBtn)&&!showChat){
							view.removeChild(chatBtn,false);
							removeButtonMap("chatBtn");
							showButton();
						}
					}
					break;
				}
				case WorldConst.REFRESH_NUM:
				{
					if(shortcut=="FAQBtn"){
						if(view.contains(FAQBtn)){
							view.removeChild(FAQBtn,false);
							removeButtonMap("FAQBtn");
							showButton();
						}
					}else if(shortcut=="emailBtn"){
						if(view.contains(emailBtn)){
							view.removeChild(emailBtn,false);
							removeButtonMap("emailBtn");
							showButton();
						}
					}else if(shortcut == "chatBtn"){
						if(view.contains(chatBtn)){
							view.removeChild(chatBtn,false);
							removeButtonMap("chatBtn");
							showButton();
						}
					}
					break;
				}
				case WorldConst.HAPPY_SHOWCHAT:
				{
					activeBackground();
					addButton(chatBtn);
					showButton();
					chatBtn.alpha =0;
					showChat = true;
					TweenLite.killTweensOf(chatBtn);
					TweenLite.to(chatBtn, 5, {alpha:1});
					break;
				}
				case WorldConst.HAPPY_HIDECHAT:
				{
					if(chatNum==0){
						if(view.contains(chatBtn)){
							view.removeChild(chatBtn,false);
							removeButtonMap("chatBtn");
							showButton();
							showChat = false;
						}
					}
					break;
				}
			}
		}
		
		private var showChat:Boolean;
		private function activeBackground():void{
			TweenLite.killTweensOf(selectBackground);
			selectBackground.alpha = 0;
			selectBackground.scaleX = selectBackground.scaleY = 1;
			TweenMax.to(selectBackground, 1, {transformAroundCenter:{scaleX:0.2, scaleY:0.2},alpha:0.6,yoyo:true,repeat:int.MAX_VALUE});
		}
		
		private function removeButtonMap(name:String):void
		{
			for(var i:int =0;i<buttonMap.length;i++){
				if(buttonMap[i].name == name ){
					buttonMap.splice(i,1);
				}
			}	
			if(buttonMap.length== 0){
				selectBackground.alpha = 0;
				TweenLite.killTweensOf(selectBackground);
				selectBackground.scaleX = selectBackground.scaleY = 1;
			}
		}
		
		private var tempBtn:Button;
		private function addShortCutButton(btn:Button):void
		{
			view.removeChild(tempBtn,false);
			btn.x = 15;
			btn.y = 80;
			view.addChild(btn);
		}
		
		
		private function showNum(num:int,btn:Button):void
		{
			numBtn = new Button(Assets.getMenuAtlasTexture("num"));
			numBtn.x = 22;
			numBtn.y =  -6;
			btn.addChild(numBtn);
			numText = new starling.text.TextField(25, 25,String(num),"HeiTi",13,0xffffff,false);
			numText.x = -3;
			numText.y = -3;
			numBtn.addChild(numText);
		}
		
		private function judeBtn(name:String):Boolean
		{
			var tap:Boolean=false;
			for(var i:int =0;i<buttonMap.length;i++){
				if(buttonMap[i].name == name ){
					tap = true
				}
			}
			return tap
		}
		
		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.BROADCAST_FAQ,WorldConst.BROADCAST_MAIL, WorldConst.BROADCAST_CHAT,WorldConst.SHOW_SHORTCUT,
					WorldConst.REFRESH_NUM,WorldConst.HAPPY_HIDECHAT,WorldConst.HAPPY_SHOWCHAT];
		}
		
		public function get view():starling.display.Sprite{
			return getViewComponent() as starling.display.Sprite;
		}
		
		private function addBaseFrame():void{
			view.name = "MainMenu";
			view.x = 1230; view.y = 20;
			selectBackground = new Image(Assets.getMenuAtlasTexture("selectBackground"));
			selectBackground.x = 10; selectBackground.y = 20;
			selectBackground.pivotX = selectBackground.width*0.5;
			selectBackground.pivotY = selectBackground.height*0.5;
			selectBackground.alpha = 0;
			
			
			buttonMap = new Array();
			
			showBtn = new Button(Assets.getMenuAtlasTexture("menuBtn"));
			showBtn.pivotX = showBtn.width>>1; showBtn.pivotY = showBtn.height>>1;
			showBtn.x = 10; showBtn.y = 20;
			
			showBtn.addEventListener(TouchEvent.TOUCH, showBtnHandle);
			showBaseFrame();
		}
		
		private function showBaseFrame():void
		{
			view.addChild(selectBackground);
			view.addChild(showBtn);
		}
		
		protected function keybackHandle(event:KeyboardEvent):void
		{
			buttonMap.length = 0;		
			if(view.contains(FAQBtn)){
				view.removeChild(FAQBtn,false);
			}
			if(view.contains(chatBtn)){
				view.removeChild(chatBtn,false)
			}
			if(view.contains(emailBtn)){
				view.removeChild(emailBtn);
			}
		}
		
		private var FAQBtn:Button;
		private var emailBtn:Button;
		private var chatBtn:Button;
		private var coachBtn:Button;
		private var appointBtn:Button;
		private var numBtn:Button;
		private var numText:TextField;
		private function addBtnContainer():void{
			
			chatBtn = new Button(Assets.getMenuAtlasTexture("chatBtn"));
			chatBtn.pivotX = chatBtn.width/2;
			chatBtn.pivotY = chatBtn.height/2
			chatBtn.name = "chatBtn";
			chatBtn.addEventListener(Event.TRIGGERED,chatBtnHandle);
			
			FAQBtn = new Button(Assets.getMenuAtlasTexture("FAQBtn"));
			FAQBtn.pivotX = FAQBtn.width/2;
			FAQBtn.pivotY = FAQBtn.height/2;
			FAQBtn.name = "FAQBtn";
			FAQBtn.addEventListener(Event.TRIGGERED,selectFAQHandler);
			
			emailBtn = new Button(Assets.getMenuAtlasTexture("emailBtn"));
			emailBtn.pivotX = emailBtn.width/2;
			emailBtn.pivotY = emailBtn.height/2;
			emailBtn.name = "emailBtn";
			emailBtn.addEventListener(Event.TRIGGERED,selectEmailHandler);
			
			appointBtn = new Button(Assets.getMenuAtlasTexture("appointBtn"));
			appointBtn.pivotX = appointBtn.width/2;
			appointBtn.pivotY = appointBtn.height/2
			appointBtn.name = "appointBtn";
			
		}
		
		
		private function selectFAQHandler():void
		{
			view.removeChild(FAQBtn,false);
			removeButtonMap("FAQBtn");
			showButton();
//			faqNum = 0;
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(FAQChatMediator,null,SwitchScreenType.SHOW,null)]);
		}
		
		
		private function chatBtnHandle():void
		{
			if(!showChat){
				view.removeChild(chatBtn,false);
				removeButtonMap("chatBtn");
				showButton();
				chatNum = 0;
			}
			var currentScreen:ScreenBaseMediator = (facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy).currentGpuScreen;
			if(currentScreen){
				switch(currentScreen.getMediatorName())
				{
					case ModuleConst.TASKLIST:
					case "WordLearningBGMediator":	
					case "ReadBGMediator":
					case "ExercisesLearnMediator":
					case "SpokenNewMediator":
					case "TalkingBookMediator":
					case ModuleConst.TASKLIST_SPOKEN:
						sendNotification(WorldConst.OPEN_MENU);
						break;
					default:
						sendNotification(WorldConst.OPEN_MENU, new SwitchScreenVO(ChatRoomMediator,null,SwitchScreenType.SHOW));
						break;		
				}
			}
		}
		
		private function selectEmailHandler():void
		{
			sendNotification(WorldConst.HIDE_MAIN_MENU);
			view.removeChild(emailBtn,false);
			removeButtonMap("emailBtn");
			showButton();
			emailNum =0;
			var currentScreen:ScreenBaseMediator = (facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy).currentGpuScreen;
			if(currentScreen){
				switch(currentScreen.getMediatorName())
				{
					case ModuleConst.TASKLIST:
					case "WordLearningBGMediator":	
					case "ReadBGMediator":
					case "ExercisesLearnMediator":
					case "TalkingBookMediator":
					case "SpokenNewMediator":
					case ModuleConst.WRONGWORD:
					case ModuleConst.TASKLIST_SPOKEN:
						sendNotification(WorldConst.OPEN_MENU);
						break;
					default:
						sendNotification(WorldConst.OPEN_MENU, new SwitchScreenVO(EmailViewMediator,null,SwitchScreenType.SHOW));
						break;		
				}
			}
		}
		
		private function setAlpha():void
		{
			emailBtn.alpha = 1;
			FAQBtn.alpha = 1;
			chatBtn.alpha = 1;
		}
		
		private function addButton(btn:Button):void{
			var tap:Boolean=false;
			for(var i:int =0;i<buttonMap.length;i++){
				if(buttonMap[i].name == btn.name ){
					tap = true
				}
			}
			if(!tap){
				buttonMap.push(btn);
			}
		}
		
		private function showButton():void{
				for(var i:int = 0;i<buttonMap.length;i++){
					if(i==0){
						buttonMap[i].x = -55;
						buttonMap[i].y = 3	;
						view.addChild(buttonMap[i]);
					}else if(i==1){
						buttonMap[i].x = -42;
						buttonMap[i].y = 45;
						view.addChild(buttonMap[i]);
					}else if(i==2){
						buttonMap[i].x = -10;
						buttonMap[i].y = 75;
						view.addChild(buttonMap[i]);
					}
				}
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
					TweenLite.killTweensOf(emailBtn);
					TweenLite.killTweensOf(chatBtn);
					TweenLite.killTweensOf(FAQBtn);
					setAlpha();
					sendNotification(WorldConst.OPEN_MENU);
				}
			}
		}
		
	}
}