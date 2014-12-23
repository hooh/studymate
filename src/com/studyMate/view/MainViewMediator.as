package com.studyMate.view
{
	
	import com.mylib.api.IConfigProxy;
	import com.mylib.api.IMainView;
	import com.mylib.api.ISwitchScreenProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.PopUpCommandVO;
	import com.studyMate.model.vo.PushViewVO;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.controller.ConfigWorldModelCommand;
	import com.studyMate.world.screens.CPUUIMediator;
	import com.studyMate.world.screens.CleanCpuMediator;
	import com.studyMate.world.screens.CleanGpuMediator;
	import com.studyMate.world.screens.GPULayerMediator;
	import com.studyMate.world.screens.IslandWelcomeMediator;
	import com.studyMate.world.screens.LsjTestMediator;
	import com.studyMate.world.screens.TestDrawingBoardMediator;
	import com.studyMate.world.screens.TestP2P;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	
	public class MainViewMediator extends Mediator implements IMediator, IPreloadMediator,IMainView
	{
		private var _starling:Starling;
		
		private var _gpuLayer:starling.display.Sprite;
		private var _cpuLayer:flash.display.Sprite;
		
		private var _uiLayer:starling.display.Sprite;
		private var _gpuPopUpLayer:starling.display.Sprite;
		private var backButton:starling.display.Button;
		
		public var popUpLayer:flash.display.Sprite;
		
		private var _modalOn:Boolean;
		
		private var _useBack:Boolean;
		
		private static var gpuIdx:uint=0;
		private static var cpuIdx:uint=0;
		
		private var initialied:Boolean;
		private var popUpModal:Boolean;
		
		public var popupMediatorsName:Vector.<String> = new Vector.<String>;
		
		private var assetLock:Boolean;
		private var dataLock:Boolean;
		private var backEnabled:Boolean;
		
		public function MainViewMediator(viewComponent:Object=null)
		{
			super(ModuleConst.MAIN_VIEW, viewComponent);
		}
		
		override public function onRegister():void
		{
			sendNotification(CoreConst.STARTUP_STEP_BEGIN,"初始化cpu渲染层");
			
			AppLayoutUtils.root = this;
			
			cpuLayer = new flash.display.Sprite;
			view.addChild(cpuLayer);
			
			uiLayer = new starling.display.Sprite;
			
			popUpLayer = new flash.display.Sprite;
			Global.stage.addChild(popUpLayer);
			
			gpuPopUpLayer = new starling.display.Sprite; 
			
			startGame();
			
			
			sendNotification(WorldConst.ENABLE_WORLD_BACK);
			
		}
		
		protected function keybackHandle(event:KeyboardEvent):void
		{
			if(event.keyCode ==Keyboard.BACK || event.keyCode == Keyboard.ESCAPE){
				event.preventDefault();
				var proxy:ISwitchScreenProxy = facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy;
				if(proxy&&(proxy.gpuStack.lastTwoScreen()||proxy.cpuStack.lastTwoScreen())){
					sendNotification(CoreConst.OPER_RECORD,new RecordVO("back","",0));
					sendNotification(CoreConst.REQUEST_QUIT,"back");
				}
			}
		}
		
		override public function onRemove():void
		{
		}
		
		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.POPUP_SCREEN,WorldConst.REMOVE_POPUP_SCREEN,WorldConst.HIDE_BACK,WorldConst.SHOW_BACK,
				WorldConst.SHOW_INDEX,WorldConst.SET_MODAL,WorldConst.CLEANUP_POPUP,CoreConst.SAFETY_QUIT,WorldConst.DISABLE_WORLD_BACK,WorldConst.ENABLE_WORLD_BACK];
		}
		
		
		override public function handleNotification(notification:INotification):void
		{
			var name:String = notification.getName();
			switch(name)
			{
				case WorldConst.POPUP_SCREEN:
				{
					
					
					if(popupMediatorsName.indexOf((notification.getBody() as PopUpCommandVO).screenMediator.getMediatorName())<0){
						
						popUpModal = (notification.getBody() as PopUpCommandVO).useModal;
						modalOn = popUpModal;
						
						popupMediatorsName.push((notification.getBody() as PopUpCommandVO).screenMediator.getMediatorName());
						facade.registerMediator((notification.getBody() as PopUpCommandVO).screenMediator);
						
						
						if((notification.getBody() as PopUpCommandVO).screenMediator.getViewComponent() is flash.display.DisplayObject){
							popUpLayer.addChild((notification.getBody() as PopUpCommandVO).screenMediator.getViewComponent() as flash.display.DisplayObject);
							popUpLayer.parent.setChildIndex(popUpLayer,popUpLayer.parent.numChildren-1);
						}else{
							AppLayoutUtils.gpuPopUpLayer.addChild((notification.getBody() as PopUpCommandVO).screenMediator.getViewComponent() as starling.display.DisplayObject);
						}
						
						
					}
					break;
				}
				case WorldConst.REMOVE_POPUP_SCREEN:{
					
					if(popupMediatorsName.indexOf((notification.getBody() as IMediator).getMediatorName())>=0){
						
						
						if((notification.getBody() as IMediator).getViewComponent() is flash.display.DisplayObject){
							popUpLayer.removeChild((notification.getBody() as IMediator).getViewComponent() as flash.display.DisplayObject);
						}else{
							((notification.getBody() as IMediator).getViewComponent() as starling.display.DisplayObject).removeFromParent(true);
						}
						
						popupMediatorsName.splice(popupMediatorsName.indexOf((notification.getBody() as IMediator).getMediatorName()),1);
						facade.removeMediator((notification.getBody() as IMediator).getMediatorName());
						
						if(popUpLayer.numChildren==0){
							popUpModal = false;
							if(!Global.isLoading||(Global.isLoading&&Global.isBeating)){
								modalOn = false;
							}
						}
					}
					
						
					break;
				}
				case WorldConst.CLEANUP_POPUP:{
					popUpLayer.removeChildren();
					AppLayoutUtils.gpuPopUpLayer.removeChildren();
					while(popupMediatorsName.length>0){
						facade.removeMediator(popupMediatorsName.pop());
					}
					popUpModal = false;
					if(!Global.isLoading){
						modalOn = false;
					}
					break;
				}
				case WorldConst.SHOW_BACK:{
					useBack = true;
					break;	
				}
				case WorldConst.HIDE_BACK:{
					useBack = false;
					break;	
				}
				case WorldConst.SHOW_INDEX:{
//					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(WhaleInsideMediator)]);
					sendNotification(CoreConst.STARTUP_STEP_BEGIN,"切换首页");
					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(IslandWelcomeMediator),new SwitchScreenVO(CleanCpuMediator)]);
//					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(TestP2P)]);
//					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(TestFishMediator),new SwitchScreenVO(CleanCpuMediator)]);
//					sendNotification(WorldConst.LOAD_INIT_LIB);
//					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(TestP2P)]);
//					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(LsjTestMediator)]);
					
					WorldConst.stageWidth = Global.stageWidth;
					WorldConst.stageHeight = Global.stageHeight;
//					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(TestCardFlow),new SwitchScreenVO(CleanCpuMediator)]);
//					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(OceanMapMediator)]);
//					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(EnglishIslandMediator)]);
					
//					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(CharacterEditorMediator)]);
					
					//切换进入自动安装
//					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(InstallerViewMediator),new SwitchScreenVO(CleanCpuMediator)]);
					
					break;
				}
				case WorldConst.SET_MODAL:{
					
					if(notification.getType()=="a"){
						assetLock = notification.getBody();
					}else{
						dataLock = notification.getBody();
					}
					
					
					if(popUpModal&&!notification.getBody()){
						
					}else if(!popUpModal&&!dataLock&&!assetLock){
						modalOn = false;
					}else if(assetLock||dataLock){
						modalOn = true;
					}
					break;
				}
				case CoreConst.SAFETY_QUIT:{
					if(notification.getBody()=="back"&&!modalOn&&backEnabled){
						doPopScreen();
					}
					break;
				}
				case WorldConst.DISABLE_WORLD_BACK:{
					backEnabled = false;
					NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN,keybackHandle);
					break;
				}
				case WorldConst.ENABLE_WORLD_BACK:{
					backEnabled = true;
					NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN,keybackHandle);
					break;
				}
				default:
				{
					break;
				}
			}
			
			
			
		}
		
		
		protected function pushGpuAndCpuHandle(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(CPUUIMediator,"cpu page "+cpuIdx),new SwitchScreenVO(CleanGpuMediator,"gpu page "+gpuIdx)]);
			cpuIdx++;
			gpuIdx++;
		}
		
		protected function pushCpuHandle(event:MouseEvent):void
		{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(CPUUIMediator,"cpu page "+cpuIdx)]);
			cpuIdx++;
		}
		
		protected function pushGpuHandle(event:MouseEvent):void
		{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(GPULayerMediator,"gpu page "+gpuIdx)]);
			gpuIdx++;
		}		
		
		
		
		/*protected function backHandle(event:starling.events.TouchEvent):void
		{
			var touch:Touch = event.touches[0];
			if(touch.phase==TouchPhase.ENDED){
				doPopScreen();
			}
			
		}*/
		
		private function doPopScreen():void{
			
			if(Global.isSwitching){
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.CANCEL_SWITCH);
				return;
			}
			if(assetLock||dataLock){
				return;
			}
			
			
			var switchProxy:ISwitchScreenProxy = facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy;
			if(switchProxy.currentGpuScreen&&switchProxy.currentGpuScreen.backHandle!=null){
				switchProxy.currentGpuScreen.backHandle.call();
			}else if(switchProxy.currentCpuScreen&&switchProxy.currentCpuScreen.backHandle!=null){
				switchProxy.currentCpuScreen.backHandle.call();
			}else{
				sendNotification(WorldConst.POP_SCREEN);
			}
			
		}
		
		
		
		public function set useBack(_b:Boolean):void{
			
			if(_useBack==_b){
				return;
			}
			
			_useBack=_b;
			
			if(_useBack){
				uiLayer.addChild(backButton);
			}else if(backButton.parent){
				backButton.parent.removeChild(backButton);
			}
			
		}
		
		
		public function startGame(e:flash.events.Event=null):void
		{
			Starling.multitouchEnabled = false; // useful on mobile devices
			Starling.handleLostContext = true; // deactivate on mobile devices (to save memory)
//			DeviceCapabilities.dpi = 160; //feather DPI设置
			_starling=new Starling(StarlingScene, view.stage,null,null,"auto", "auto");
//			_starling.simulateMultitouch = true;
//			_starling.enableErrorChecking=true;
			_starling.addEventListener(starling.events.Event.ROOT_CREATED, onContextReady);
			
			sendNotification(CoreConst.STARTUP_STEP_BEGIN,"初始化gpu渲染层");
			_starling.start();
			_starling.showStats = !CONFIG::ARM;
		}
		
		private function resize():void{
			const rect:Rectangle = new Rectangle(0, 0, view.stage.stageWidth, view.stage.stageHeight);
			_starling.viewPort = rect;
			_starling.stage.stageWidth = Global.stageWidth;
			if(view.stage.stageHeight<770){
				_starling.stage.stageHeight = view.stage.stageHeight;
			}else{
				_starling.stage.stageHeight = Global.stageHeight;
			}
			Global.widthScale = view.stage.stageWidth/_starling.stage.stageWidth;
			Global.heightScale = view.stage.stageHeight/_starling.stage.stageHeight;
			cpuLayer.scaleX = Global.widthScale;
			cpuLayer.scaleY = Global.heightScale;
		}
		
		protected function onContextReady(event:starling.events.Event):void {
			
			if(!initialied){
				initialied = true;
				gpuLayer = StarlingScene.instance;
				gpuLayer.stage.addChild(uiLayer);
				gpuLayer.stage.addChild(gpuPopUpLayer);
				resize();
				
				facade.registerCommand(WorldConst.CONFIG_WORLD_MODEL,ConfigWorldModelCommand);
				sendNotification(WorldConst.CONFIG_WORLD_MODEL);
				facade.removeCommand(WorldConst.CONFIG_WORLD_MODEL);
				sendNotification(WorldConst.SHOW_INDEX);
				_starling.stage3D.addEventListener(Event.CONTEXT3D_CREATE,context3dCreateHandle,false,11,true);
				sendNotification(CoreConst.DETECT_DATA);
				
				
			}
		}
		
		private function context3dCreateHandle(e:Event):void{
			sendNotification(CoreConst.FLOW_RECORD,new RecordVO("context3dCreateHandle","MainViewMediator",0));
			var proxy:ISwitchScreenProxy = facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy;
			if(initialied&&proxy.gpuStack.length>0){
//				Starling.current.stop();
				
				if(proxy){
//					sendNotification(WorldConst.CLEANUP_POPUP);
//					sendNotification(WorldConst.SWITCH_SCREEN,[proxy.gpuStack.stack.shift(),new SwitchScreenVO(CleanCpuMediator)]);
//					Assets.clean();
					/*if(UITheme.theme){
						UITheme.theme.dispose();
					}
					
					TweenLite.delayedCall(10,sendNotification,[WorldConst.BUILD_THEME]);*/
					
					
//					proxy.gpuStack.length=0;
//					proxy.cpuStack.length=0;
//					sendNotification(WorldConst.SHOW_INDEX);
				}else{
					Global.isUserExit = true;
					NativeApplication.nativeApplication.exit();
				}
				
				
				
			}
			
			
		}
		
		protected function onStageVideoState(event:StageVideoAvailabilityEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected function addToStageHandle(event:flash.events.Event):void
		{
			// TODO Auto-generated method stub
			
		}		
		
		public function get view():flash.display.Sprite{
			return viewComponent as flash.display.Sprite;
		}
		
		
		
		public function prepare(vo:PushViewVO):void
		{
			// TODO Auto Generated method stub
			sendNotification("ApplicationFacadePrepareReady",vo);
		}

		private function get modalOn():Boolean
		{
			return _modalOn;
		}

		private function set modalOn(value:Boolean):void
		{
			if(_modalOn==value){
				return;
			}
			
			_modalOn = value;
			
			trace("modalOn ",value);
			sendNotification(CoreConst.OPER_RECORD,new RecordVO("modalOn",value.toString(),0));
			if(_modalOn){
				if(AppLayoutUtils.root.gpuLayer)
					AppLayoutUtils.root.gpuLayer.touchable = false;
				AppLayoutUtils.root.uiLayer.touchable = false;
				AppLayoutUtils.root.cpuLayer.mouseEnabled = AppLayoutUtils.root.cpuLayer.mouseChildren = false;
				Global.stage.removeEventListener(flash.events.Event.RENDER,stageRenderHandler);
				Starling.current.stage.addEventListener(TouchEvent.TOUCH,busyTouchHandle);
			}else{
				Global.stage.addEventListener(flash.events.Event.RENDER,stageRenderHandler);
				Global.stage.invalidate();
				Starling.current.stage.removeEventListener(TouchEvent.TOUCH,busyTouchHandle);
				
			}
		}
		
		protected function busyTouchHandle(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.currentTarget as starling.display.DisplayObject,TouchPhase.BEGAN);
			if(touch){
				
				if(!Global.isStartupShowing&&!AppLayoutUtils.gpuPopUpLayer.numChildren&&!popUpLayer.numChildren)
					sendNotification(CoreConst.SHOW_BUSY);
			}
		}		
		
		protected function stageRenderHandler(event:flash.events.Event):void
		{
			Global.stage.removeEventListener(flash.events.Event.RENDER,stageRenderHandler);
			AppLayoutUtils.root.cpuLayer.mouseEnabled = AppLayoutUtils.root.cpuLayer.mouseChildren = true;
			if(AppLayoutUtils.root.gpuLayer)
				AppLayoutUtils.root.gpuLayer.touchable = true;
			AppLayoutUtils.root.uiLayer.touchable = true;
		}

		public function get gpuLayer():starling.display.Sprite
		{
			return _gpuLayer;
		}

		public function set gpuLayer(value:starling.display.Sprite):void
		{
			_gpuLayer = value;
		}

		public function get cpuLayer():flash.display.Sprite
		{
			return _cpuLayer;
		}

		public function set cpuLayer(value:flash.display.Sprite):void
		{
			_cpuLayer = value;
		}

		public function get uiLayer():starling.display.Sprite
		{
			return _uiLayer;
		}

		public function set uiLayer(value:starling.display.Sprite):void
		{
			_uiLayer = value;
		}

		public function get gpuPopUpLayer():starling.display.Sprite
		{
			return _gpuPopUpLayer;
		}

		public function set gpuPopUpLayer(value:starling.display.Sprite):void
		{
			_gpuPopUpLayer = value;
		}

		
	}
}
import starling.display.Sprite;

class StarlingScene extends Sprite {
	public static var instance:Sprite;
	public function StarlingScene() {
		instance = this;
	}
}