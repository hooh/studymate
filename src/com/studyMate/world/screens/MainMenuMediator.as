package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.PopUpCommandVO;
	import com.studyMate.world.model.vo.MessageVO;
	import com.studyMate.world.screens.ui.ChatPanelMediator;
	import com.studyMate.world.screens.ui.IMenuPanel;
	import com.studyMate.world.screens.ui.MenuButtonVO;
	import com.studyMate.world.screens.ui.MusicSoundMediator;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
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
	import starling.textures.Texture;
	
	public class MainMenuMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MainMenuMediator";
		
		private var btnHolder:starling.display.Sprite;
		
		private var buttonMap:Dictionary;
		
		private var openPanel:IMenuPanel;
		
		private var panelHolder:starling.display.Sprite;
		
		private var openBtn:Button;
		private var showBtn:Button;
		
		private var bg:Image;
		private var isShow:Boolean; //记录主菜单显示状态，默认为false，没有显示
		
		private var openMenu_Btn:Button;	//打开菜单时，指定提醒的button
		
		public function MainMenuMediator()
		{
			super(NAME, new starling.display.Sprite);
		}
		
		public function get view():starling.display.Sprite{
			return getViewComponent() as starling.display.Sprite
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case WorldConst.ADD_MAINMENU_BUTTON:									
					if(notification.getBody() == "menuSoundBtn"){
						if(!btnHolder.getChildByName( "menuSoundBtn")){
							var chat:MenuButtonVO = new MenuButtonVO("menuSoundBtn",Assets.getAtlasTexture("mainMenu/menuSound"),null,onEnterMusicHandler);
							addButton(chat)
						}
					}
					layout();
					break;
				case WorldConst.REMOVE_MAINMENU_BUTTON:
					removeButton(notification.getBody() as String);
					if(notification.getBody() == "menuSoundBtn"){
						if(facade.hasMediator(MusicSoundMediator.NAME)){
							facade.removeMediator(MusicSoundMediator.NAME);
						}
					}
					layout();
					break;
				case WorldConst.OPEN_MAIN_MENU:
					trace("打开！！！");
					if(!isShow){
						TweenLite.to(showBtn,0.3,{rotation:Math.PI});
						TweenLite.to(view,0.3,{y:0});
						isShow = true;
						
						var btnName:String = notification.getBody() as String;
//						if(btnHolder.getChildByName(btnName)){
//							openMenu_Btn = btnHolder.getChildByName(btnName) as Button;
//							TweenMax.to(openMenu_Btn,0.2,{scaleX:0.9,scaleY:0.9,yoyo:true,repeat:99});
//						}
					}
					break;
				case WorldConst.CLOSE_MAIN_MENU:
					
					if(isShow){
						TweenLite.to(showBtn,0.3,{rotation:0});
						TweenLite.to(view,0.3,{y:-656});
						isShow = false;
					}
					break;
				case WorldConst.BROADCAST_FAQ:
					
					trace("BROADCAST_FAQ",notification.getBody());
					
					break;
				/*case WorldConst.HAS_KEYBOARD:
					removeListener();
					break;
				case WorldConst.NO_KEYBOARD:
					addListener(null);					
					break;*/
			}
		}
		override public function listNotificationInterests():Array
		{
			return [WorldConst.ADD_MAINMENU_BUTTON,WorldConst.REMOVE_MAINMENU_BUTTON,WorldConst.OPEN_MAIN_MENU,WorldConst.CLOSE_MAIN_MENU,WorldConst.BROADCAST_FAQ];
		}
		
		override public function onRegister():void
		{
			view.name = "MainMenu";
			view.x = 1145;
			view.y = -656;  //-726+70 ,726为菜单背景长度
			
			panelHolder = new starling.display.Sprite;
			view.addChild(panelHolder);
			
			bg = new Image(Assets.getAtlasTexture("mainMenu/menuBg"));
			view.addChild(bg);
			
			btnHolder = new starling.display.Sprite;
			view.addChild(btnHolder);
//			btnHolder.x = 10;
//			panelHolder.y = btnHolder.y = 130;
			
			buttonMap = new Dictionary(true);
			
			showBtn = new Button(Assets.getAtlasTexture("mainMenu/menuShowBtn"));
			showBtn.pivotX = showBtn.width>>1;
			showBtn.pivotY = showBtn.height>>1;
			showBtn.x = 35+(showBtn.width>>1);
			showBtn.y = 661+(showBtn.height>>1);
			view.addChild(showBtn);
			showBtn.addEventListener(TouchEvent.TOUCH,showBtnHandle);
			
			
			var texture:Texture;
			var chat:MenuButtonVO;
			
			
			
			/*texture = Assets.getAtlasTexture("mainMenu/menuYouxiBtn1");
			chat = new MenuButtonVO("SoundBtn",texture,null,gameBtnHandle);//游戏市场
			addButton(chat);*/
			
			/*texture = Assets.getAtlasTexture("mainMenu/menuHelpBtn1");
			chat = new MenuButtonVO("MakePromiseBtn",texture,null,onMakePromiseBtnHandler);
			addButton(chat);*/
			
			texture = Assets.getAtlasTexture("mainMenu/menuHelpBtn1");
			chat = new MenuButtonVO("GuideBtn",texture,null,onGuideBtnHandler);
//			addButton(chat);
			
			//texture = Assets.getAtlasTexture("mainMenu/menuYueBtn1");
			//chat = new MenuButtonVO("MakePromiseBtn",texture,null,onMakePromiseBtnHandler);
//			addButton(chat);
			
			texture = Assets.getAtlasTexture("mainMenu/menuDuihuaBtn1");//faq界面
			chat = new MenuButtonVO("FAQBtn",texture,null,onEnterFaqHandler);
			addButton(chat);
			
			texture = Assets.getAtlasTexture("mainMenu/menuPersonBtn1");
			chat = new MenuButtonVO("InstallBtn",texture,null,showPersonalInfoHandle);
			addButton(chat);
			
			texture = Assets.getAtlasTexture("mainMenu/honourBtn");
			chat = new MenuButtonVO("HonourBtn",texture,null,showHonourHandler);
			addButton(chat);
			
			texture = Assets.getAtlasTexture("mainMenu/growUpBtn");
			chat = new MenuButtonVO("GrowUpBtn",texture,null,showGrowUpHandler);
			addButton(chat);
			
			texture = Assets.getAtlasTexture("mainMenu/SettingBtn");
			chat = new MenuButtonVO("SettingBtn",texture,null,onEnterSettingHandler);
			addButton(chat);
			
			texture = Assets.getAtlasTexture("mainMenu/ProBtn");
			chat = new MenuButtonVO("PromiseBtn",texture,null,onEnterPromises);
			addButton(chat);
			
			texture = Assets.getAtlasTexture("mainMenu/MessageBtn");
			chat = new MenuButtonVO("MessageBtn",texture,null,showMessage);
//			addButton(chat);
			
	//		texture = Assets.getAtlasTexture("mainMenu/growUpBtn");//成长日历
		//	chat = new MenuButtonVO("GuideBtn",texture,null,onGrowUpHandler);
//			addButton(chat);
			
//			texture = Assets.getAtlasTexture("mainMenu/menuSound");//背景音乐
//			chat = new MenuButtonVO("menuSoundBtn",texture,null,onEnterMusicHandler);
//			addButton(chat);
//			
//			
//			texture = Assets.getAtlasTexture("mainMenu/menuInstallBtn");//setting界面
//			chat = new MenuButtonVO("menuSoundBtn",texture,null,onEnterSettingHandler);
//			addButton(chat);
			
			layout();

			view.addEventListener(Event.ADDED_TO_STAGE,addListener);
		}
		
		//打开成长日历界面
		private function showGrowUpHandler(event:Event):void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(MonthTaskInfoMediator,Global.player.operId.toString(),SwitchScreenType.SHOW,view.stage)]);
		}
		
		private function onEnterFaqHandler(event:Event):void{
			//sendNotification(WorldConst.SHOW_FAQ_ALERT);
			var faqMeidator:FAQChatMediator = new FAQChatMediator(new flash.display.Sprite);
			faqMeidator.view.x = 302;
			faqMeidator.view.y = 14;
			sendNotification(WorldConst.POPUP_SCREEN,(new PopUpCommandVO(faqMeidator)));
		}
		
		private function onEnterMusicHandler(event:Event):void{
			sendNotification(WorldConst.SHOW_MUSICPLAYER);
		}
		
		private function showMessage(e:Event):void{
			
		}
		
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
		}
		
		//进入设置界面
		private function onEnterSettingHandler(event:Event):void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SystemSetMediator),new SwitchScreenVO(CleanCpuMediator)]);
		}
		
		//进入成就界面
		private function showHonourHandler(event:Event):void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(HonourViewMediator),new SwitchScreenVO(CleanCpuMediator)]);
		}
		
		//显示个人信息界面
		private function showPersonalInfoHandle(event:Event):void{
			sendNotification(WorldConst.SHOW_PERSONALINFO);
		}
		//显示游戏界面
		private function gameBtnHandle(event:Event):void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(AndroidGameMediator),new SwitchScreenVO(CleanCpuMediator)]);
			
			sendNotification(WorldConst.HIDE_MAIN_MENU);
			sendNotification(WorldConst.HIDE_LEFT_MENU);
			
		}
		//制定约定按钮
		private function onMakePromiseBtnHandler(event:Event):void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ShowProMediator),new SwitchScreenVO(CleanCpuMediator)]);
			
		}
		//显示帮助手册
		private function onGuideBtnHandler(event:Event):void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(GuideMediator,null,SwitchScreenType.SHOW,view.stage)]);
			
		}
		
		private function addListener(event:Event):void{		
			if(view.stage){
				view.stage.addEventListener(TouchEvent.TOUCH,stageTouchHandle);
			}
		}
		/*private function removeListener():void{
			if(view.stage)
				if(view.stage.hasEventListener(TouchEvent.TOUCH))
					view.stage.removeEventListener(TouchEvent.TOUCH,stageTouchHandle);
		}*/
		//监听点击屏幕其他地方，关闭主菜单
		private function stageTouchHandle(event:TouchEvent):void{
			var touchPoint:Touch = event.getTouch(event.target as DisplayObject);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN)
					if(!bg.getBounds(view.stage).contains(touchPoint.globalX,touchPoint.globalY) 
						&& !panelHolder.getBounds(view.stage).contains(touchPoint.globalX,touchPoint.globalY)){ //主菜单区域
						if(isShow){
							trace("关闭！！！");
							if(openPanel){
								facade.removeMediator(openPanel.getMediatorName());
								var tmpPanel:IMenuPanel = openPanel;
								TweenLite.to(tmpPanel.view,0.2,{x:0,onComplete:function():void{
									panelHolder.removeChild(tmpPanel.view);
								}});
								openPanel=null;
								openBtn = null;
								TweenLite.to(showBtn,0.3,{delay:0.2,rotation:0});
								TweenLite.to(view,0.3,{delay:0.2,y:-656});
							}else{
								TweenLite.to(showBtn,0.3,{rotation:0});
								TweenLite.to(view,0.3,{y:-656})
							}
							isShow = false;
							
						}
					}
			}
		}
		
		//显示主菜单
		private function showBtnHandle(event:TouchEvent):void{
			var btn:Button = event.currentTarget as Button;
			var touchPoint:Touch = event.getTouch(btn);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					beginX = touchPoint.globalX;
				}else if(touchPoint.phase==TouchPhase.ENDED){
					endX = touchPoint.globalX;
					if(Math.abs(endX-beginX) < 50){
						TweenLite.killTweensOf(view);
						if(!isShow){
							TweenLite.to(showBtn,0.3,{rotation:Math.PI});
							TweenLite.to(view,0.3,{y:0});
							isShow = true;
						}else{
							if(openPanel){
								facade.removeMediator(openPanel.getMediatorName());
								var tmpPanel:IMenuPanel = openPanel;
								TweenLite.to(tmpPanel.view,0.2,{x:0,onComplete:function():void{
									panelHolder.removeChild(tmpPanel.view);
								}});
								openPanel=null;
								openBtn = null;
								TweenLite.to(showBtn,0.3,{delay:0.2,rotation:0});
								TweenLite.to(view,0.3,{delay:0.2,y:-656});
							}else{
								TweenLite.to(showBtn,0.3,{rotation:0});
								TweenLite.to(view,0.3,{y:-656})
							}
							isShow = false;
						}
					}
				}
			}
		}
		
		public function refresh(data:Vector.<MenuButtonVO>):void{
			
		}
		
		public function addButton(vo:MenuButtonVO):void{
			var btn:Button = new Button(vo.texture);
			btn.name = vo.id;
			btnHolder.addChild(btn);
			buttonMap[btn] = vo;
			btn.addEventListener(Event.TRIGGERED,btnClickHandle);
			
			if(vo.clickFunction!=null){
				btn.addEventListener(Event.TRIGGERED,vo.clickFunction);
			}
		}
		public function removeButton(btnName:String):void{
			if(btnHolder.getChildByName(btnName)){
				var btn:Button = btnHolder.getChildByName(btnName) as Button;
//				btn.removeEventListener(TouchEvent.TOUCH,btnClickHandle);
//				if((buttonMap[btn] as MenuButtonVO).clickFunction != null)
//					btn.removeEventListener(TouchEvent.TOUCH,(buttonMap[btn] as MenuButtonVO).clickFunction);
				btn.removeEventListeners();
				buttonMap[btn] = null;
				
				btnHolder.removeChild(btn);
				btn = null;
			}
		}
		
		
		private var beginX:Number;
		private var endX:Number;
		private function btnClickHandle(event:Event):void{
			var vo:MenuButtonVO = buttonMap[event.currentTarget];
			
			if(openPanel){
				facade.removeMediator(openPanel.getMediatorName());
				var tmpPanel:IMenuPanel = openPanel;
				TweenLite.to(tmpPanel.view,0.5,{x:0,onComplete:function():void{
					panelHolder.removeChild(tmpPanel.view);
				}});
				openPanel=null;
			}
			var doShow:Boolean = true;
			if(openBtn==event.currentTarget){
				doShow = false;
				openBtn = null;
			}else{
				openBtn = event.currentTarget as Button;
			}
			
			if(vo.panel!=null){
				if(vo.panel&&doShow){
					openPanel = new vo.panel;
					facade.registerMediator(openPanel);
					panelHolder.addChild(openPanel.view);
					TweenLite.to(openPanel.view,0.5,{x:-openPanel.view.width+60});
					openPanel.view.y = openBtn.y;
					var point:Point = openBtn.localToGlobal(new Point(0,0));
					(openPanel as ChatPanelMediator).input.x = point.x -242;
					(openPanel as ChatPanelMediator).input.y = point.y +50;
				}
				
			}
			
		}
			


		public function layout():void{
			
			for (var i:int = 0; i < btnHolder.numChildren; i++) 
			{
				var item:DisplayObject = btnHolder.getChildAt(i);
//				item.y = i*88;
				item.y = 20+i*88;
				item.x = (view.width - item.width)>>1;
				
			}
			
		}
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			showBtn.removeEventListener(TouchEvent.TOUCH,showBtnHandle);
			view.removeEventListener(Event.ADDED_TO_STAGE,addListener);			
			if(view.stage.hasEventListener(TouchEvent.TOUCH))
				view.stage.removeEventListener(TouchEvent.TOUCH,stageTouchHandle);
			view.removeChildren(0,-1,true);
			super.onRemove();
		}
		
	}
}