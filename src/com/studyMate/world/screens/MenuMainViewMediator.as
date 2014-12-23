package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.mylib.api.IMainView;
	import com.mylib.api.ISwitchScreenProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.utils.MyUtils;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	
	public class MenuMainViewMediator extends Mediator implements IMediator, IMainView
	{
		public static const NAME:String = "MenuMainViewMediator";
		private var _view:starling.display.Sprite;
		private var stack:Vector.<SwitchScreenVO>;
		private var menuVO:SwitchScreenVO;
		private var isOpened:Boolean;
		private var menuCpuLayer:flash.display.Sprite;
		private var menuUILayer:starling.display.Sprite;
		private var popView:starling.display.Sprite;
		private var isMenu:Boolean;
		
		private var isOpening:Boolean;
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case WorldConst.OPEN_MENU:
				{
					if(Global.isSwitching){
						return;
					}
					trace("open menu!!!!!!!!!!!!!!!!!!!!!!");
					AppLayoutUtils.gpuLayer.visible = false;
					AppLayoutUtils.cpuLayer.visible = false;
					AppLayoutUtils.uiLayer.visible = false;
					AppLayoutUtils.root = this;
					Global.stage.addChild(menuCpuLayer);
					menuCpuLayer.scaleX = Global.widthScale;
					menuCpuLayer.scaleY = Global.heightScale;
					Starling.current.stage.addChild(AppLayoutUtils.gpuLayer);
					Starling.current.stage.addChild(AppLayoutUtils.gpuPopUpLayer);
					sendNotification(WorldConst.HIDE_MAIN_MENU);
					isOpened = true;
					sendNotification(WorldConst.DISABLE_WORLD_BACK);
					
					if(notification.getBody()){
						isMenu = false;
						showMain(notification.getBody() as SwitchScreenVO);
					}else{
						isMenu = true;
						showMain(new SwitchScreenVO(FullScreenMenuMediator,null,SwitchScreenType.SHOW,view));
					}
					
					NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN,keybackHandle);
					break;
				}
				case WorldConst.CLOSE_MENU:{
					trace("close menu!!!!!!!!!!!!!!!!!!!!!!");
					gpuLayer.touchable = true;
					AppLayoutUtils.gpuLayer.removeFromParent(false);
					AppLayoutUtils.root = facade.retrieveMediator(ModuleConst.MAIN_VIEW) as IMainView;
					view.removeFromParent();
					Global.stage.removeChild(menuCpuLayer);
					AppLayoutUtils.gpuLayer.visible = true;
					AppLayoutUtils.cpuLayer.visible = true;
					AppLayoutUtils.uiLayer.visible = true;
					isOpened = false;
					sendNotification(WorldConst.ENABLE_WORLD_BACK);
					hideMain();
					NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN,keybackHandle);
					sendNotification(WorldConst.SHOW_MAIN_MENU);
					
					break;
				}
				case WorldConst.REGIST_MENU_SCREEN:{
					
					if(!stack.length){
						
					}
					Global.isSwitching = true;
					isOpening = true;
					
					var pushVO:SwitchScreenVO = notification.getBody() as SwitchScreenVO;
					stack.push(pushVO);
					pushVO.type = SwitchScreenType.SHOW;
					pushVO.holder = view;
					sendNotification(WorldConst.SWITCH_SCREEN,pushVO);
					
					break;
				}
				case WorldConst.REMOVE_MENU_SCREEN:{
					var popVO:SwitchScreenVO = notification.getBody() as SwitchScreenVO;
					popVO.type = SwitchScreenType.HIDE;
					sendNotification(WorldConst.SWITCH_SCREEN,popVO);
					Global.isSwitching = false;
					
					break;
				}
				case CoreConst.SAFETY_QUIT:{
					
					if(!isOpened){
						return;
					}
					
					
					if(isMenu){
						sendNotification(WorldConst.REMOVE_MENU_SCREEN,stack.pop());
					}else{
						sendNotification(WorldConst.CLOSE_MENU);
						
					}
					
					
					
					break;
				}
				case WorldConst.SHOW_SCREEN_COMPLETE:{
					
					if(!isOpened){
						return;
					}
					
					if(menuVO==notification.getBody()[0]){
						sendNotification(CoreConst.HIDE_STARTUP_LOADING);
						if(isMenu){
							isOpening = false;
						}else{
							TweenLite.delayedCall(1,function():void{
								isOpening = false;
							});
						}
					}else{
						isOpening = false;
					}
					
					
					
					
					break;
				}
				default:
				{
					break;
				}
			}
			
			
			
		}
		
		private function hideMain():void{
			if(!menuVO){
				return;
			}
			trace("hide main menu");
			menuVO.type = SwitchScreenType.HIDE;
			sendNotification(WorldConst.SWITCH_SCREEN,menuVO);
			menuVO = null;
			var switchProxy:ISwitchScreenProxy = facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy;
			switchProxy.currentGpuScreen.activate();
			switchProxy.currentCpuScreen.activate();
		}
		
		private function showMain(switchVO:SwitchScreenVO):void{
			
			var switchProxy:ISwitchScreenProxy = facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy;
			if(switchProxy){
				if(switchProxy.currentGpuScreen)
				switchProxy.currentGpuScreen.deactivate();
				if(switchProxy.currentCpuScreen)
				switchProxy.currentCpuScreen.deactivate();
			}
			
			
			if(!menuVO){
				sendNotification(CoreConst.SHOW_STARTUP_LOADING);
				isOpening = true;
				menuVO = switchVO;
				menuVO.holder = view;
				sendNotification(WorldConst.SWITCH_SCREEN,menuVO);
			}else{
				
				
				
				
			}
			
		}
		
		
		protected function keybackHandle(event:KeyboardEvent):void
		{
			if(event.keyCode ==Keyboard.BACK || event.keyCode == Keyboard.ESCAPE){
				event.preventDefault();
				if(isOpening){
					return;
				}
				
				trace("menu back");
				
				if(!stack.length&&isMenu){
					sendNotification(WorldConst.CLOSE_MENU);
				}else{
					
					trace("@VIEW:FullScreenMenuMediator:");
					sendNotification(CoreConst.REQUEST_QUIT);
				}
			}
		}
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
			hideMain();
			view.removeFromParent(true);
		}
		
		
		override public function onRegister():void
		{
			_view = new starling.display.Sprite;
			stack = new Vector.<SwitchScreenVO>;
			menuCpuLayer = new flash.display.Sprite;
			menuUILayer = new starling.display.Sprite;
			popView = new starling.display.Sprite;
		}
		
		
		public function get view():starling.display.Sprite{
			return _view;
		}
		
		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.OPEN_MENU,WorldConst.CLOSE_MENU,WorldConst.REGIST_MENU_SCREEN,WorldConst.REMOVE_MENU_SCREEN,CoreConst.SAFETY_QUIT,WorldConst.SHOW_SCREEN_COMPLETE];
		}
		
		
		public function MenuMainViewMediator()
		{
			super(NAME);
		}
		
		public function get cpuLayer():flash.display.Sprite
		{
			return menuCpuLayer;
		}
		
		public function get gpuLayer():starling.display.Sprite
		{
			return view;
		}
		
		public function get gpuPopUpLayer():starling.display.Sprite
		{
			// TODO Auto Generated method stub
			return popView;
		}
		
		public function get uiLayer():starling.display.Sprite
		{
			return menuUILayer;
		}
		
	}
}