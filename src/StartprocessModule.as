package
{
	
	import com.mylib.api.ISwitchScreenProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.StudyMateCoreFacade;
	import com.studyMate.db.schema.Player;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.IFileVO;
	import com.studyMate.model.vo.LicenseVO;
	import com.studyMate.model.vo.LoginVO;
	import com.studyMate.model.vo.RemoteFileLoadVO;
	import com.studyMate.model.vo.SaveTempFileVO;
	import com.studyMate.model.vo.SoundVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.UpLoadCommandVO;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.model.vo.UpdateListVO;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.GraphicsEndFill;
	import flash.display.GraphicsPath;
	import flash.display.GraphicsSolidFill;
	import flash.display.GraphicsStroke;
	import flash.display.IGraphicsData;
	import flash.display.IGraphicsFill;
	import flash.display.IGraphicsStroke;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.registerClassAlias;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.setup.target.TraceTarget;
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import starling.core.Starling;
	
	/**
	 * 启动流程
	 * @author wangtu
	 * 创建时间: 2014-8-15 下午1:39:11
	 */	
	public class StartprocessModule extends Sprite implements IMediator
	{
		public static const NAME:String = "StudyMate";
		private var facade:IFacade;
		
//		[Embed(source="../assets/loading.jpg")]
//		public static var StartupBG:Class;
		private var _alertWindow:Sprite;
		private var alertText:TextField;
		
		private var starupInfo:TextField;
		public var startupBMP:Bitmap;//请勿删除。Main模块会传递图片过来
		
		private var errorInfo:String;
		private var multitonKey:String;
		
		public function StartprocessModule()
		{
			
			registerClassAlias("com.studyMate.model.vo.LoginVO",LoginVO);
			registerClassAlias("com.studyMate.db.schema.Player",Player);
			registerClassAlias("com.studyMate.model.vo.DataResultVO",DataResultVO);
			registerClassAlias("com.studyMate.model.vo.RemoteFileLoadVO",RemoteFileLoadVO);
			registerClassAlias("com.studyMate.model.vo.IFileVO",IFileVO);
			registerClassAlias("com.studyMate.model.vo.UpdateListItemVO",UpdateListItemVO);
			registerClassAlias("com.studyMate.model.vo.LicenseVO",LicenseVO);
			registerClassAlias("com.studyMate.model.vo.ToastVO",ToastVO);
			registerClassAlias("com.studyMate.model.vo.UpLoadCommandVO",UpLoadCommandVO);
			registerClassAlias("com.studyMate.model.vo.UpdateListVO",UpdateListVO);
			registerClassAlias("com.studyMate.model.vo.SaveTempFileVO",SaveTempFileVO);
			registerClassAlias("flash.display.IGraphicsStroke",IGraphicsStroke);
			registerClassAlias("flash.display.GraphicsStroke",GraphicsStroke);
			registerClassAlias("flash.display.IGraphicsData",IGraphicsData);
			registerClassAlias("flash.display.GraphicsPath",GraphicsPath);
			registerClassAlias("flash.display.IGraphicsFill",IGraphicsFill);
			registerClassAlias("flash.display.GraphicsSolidFill",GraphicsSolidFill);
			registerClassAlias("flash.display.GraphicsEndFill",GraphicsEndFill);
			registerClassAlias("com.studyMate.model.vo.SoundVO",SoundVO);
			
			super();
			
		}
		
		public function init(_stage:Stage):void{
			Global.stage = _stage;
			_stage.addChild(this);
			if(!CONFIG::ARM){
				LOGGER_FACTORY.setup = new SimpleTargetSetup( new TraceTarget );
			}
			
			initHandle(null);
			
		}
		
		// 一直不报错就一直不初始化
		public function get alertWindow():Sprite
		{
			if(_alertWindow==null){				
				_alertWindow = new Sprite();
				_alertWindow.graphics.lineStyle(1);
				_alertWindow.graphics.beginFill(0xefefef);
				_alertWindow.graphics.drawRect(0,0,400,200);
				_alertWindow.graphics.endFill();
				
				alertText = new TextField();
				alertText.multiline = true;
				alertText.width = 360;
				alertText.height = 160;
				alertText.x = 10;
				alertText.y = 30;
				_alertWindow.addChild(alertText);
				
				var title:TextField = new TextField();
				title.text = "程序出错提示";
				title.height = 20;
				title.mouseEnabled = false;
				title.x = title.y = 4;
				_alertWindow.addChild(title);
				
				
				var btn:Sprite = new Sprite();
				btn.graphics.lineStyle(1);
				btn.graphics.beginFill(0xfcaf42);
				btn.graphics.drawRect(0,0,100,40);
				btn.graphics.endFill();
				var tf:TextField = new TextField();
				tf.text = "自动修复";
				tf.x = 24;
				tf.y = 10;
				
				tf.mouseEnabled = false;
				tf.height = 40;
				btn.addChild(tf);
				btn.addEventListener(MouseEvent.CLICK,fixHandle);
				btn.x = _alertWindow.width-120;
				btn.y = 130;
				_alertWindow.addChild(btn);
				
				btn = new Sprite();
				btn.graphics.lineStyle(1);
				btn.graphics.beginFill(0xa2ee29);
				btn.graphics.drawRect(0,0,100,40);
				btn.graphics.endFill();
				tf = new TextField();
				tf.x = 28;
				tf.y = 10;
				tf.text = "忽    略";
				tf.mouseEnabled = false;
				tf.height = 40;
				btn.addChild(tf);
				btn.addEventListener(MouseEvent.CLICK,ignoreHandle);
				
				btn.x = _alertWindow.width-340;
				btn.y = 130;
				_alertWindow.addChild(btn);
			}
			
			return _alertWindow;
		}
		
		protected function initHandle(event:flash.events.Event):void{
			trace("init");
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.align=StageAlign.TOP_LEFT;
			stage.frameRate = 60;
			stage.quality = StageQuality.LOW;
			Global.root = this;
			
			
			facade = StudyMateCoreFacade.getInstance();
			
			facade.registerMediator(this);
			
		}
		
		private var errorType:String;
		public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case CoreConst.ERROR_REPORT:
				{
					var currentInfo:String = notification.getBody() as String;
					
					if(currentInfo.charAt(0)=="2"){
						errorType = "2";
					}else{
						errorType = "1";
					}
					
					var screenName:String;
					
					
					if(facade.hasProxy(ModuleConst.SWITCH_SCREEN_PROXY)&&(facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy).currentGpuScreen){
						screenName = (facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy).currentGpuScreen.getMediatorName();
					}else{
						screenName = "before login";
					}
					
					if(errorInfo==currentInfo){
						return;
					}
					
					errorInfo = currentInfo;
					
					if(CONFIG::ARM){
						facade.sendNotification(CoreConst.SEND_ERR,screenName+"\r\n"+errorInfo+"; studyVersion="+Global.appVersion);
					}
					showAlert(errorInfo);
					break;
				}
				case CoreConst.STARTUP_STEP_BEGIN:
				{
					starupInfo.appendText(notification.getBody() as String);
					starupInfo.appendText("\n");
					break;
				}
				case CoreConst.HIDE_STARTUP_LOADING:
				{
					Global.isStartupShowing = false;
					if(startupBMP.parent){
						startupBMP.parent.removeChild(startupBMP);
						
					}
					break;
				}
				case CoreConst.SHOW_STARTUP_LOADING:{
					//					facade.sendNotification(WorldConst.SET_MODAL,true);
					Global.isStartupShowing = true;
					if(startupBMP.parent!=stage){
						startupBMP.width = stage.stageWidth;
						startupBMP.height = stage.stageHeight;
						stage.addChild(startupBMP);
					}
					break;
				}
				case CoreConst.SHOW_STARUP_INFOR:{
					stage.addChild(starupInfo);
					break;
				}
				case CoreConst.HIDE_STARUP_INFOR:{
					if(starupInfo.parent){
						starupInfo.parent.removeChild(starupInfo);
						
					}
					break;
				}
				case CoreConst.CLEAN_STARUP_INFOR:{
					starupInfo.text = "";
					break;
				}
				case CoreConst.HIDE_ALERT_WINDOW:{
					if(alertWindow.parent){
						facade.sendNotification(WorldConst.SET_MODAL,false);
						alertWindow.parent.removeChild(alertWindow);
						stage.removeEventListener(MouseEvent.CLICK,stageHandle,false);
						stage.removeEventListener(MouseEvent.MOUSE_UP,stageHandle,false);
						stage.removeEventListener(MouseEvent.MOUSE_DOWN,stageHandle,false);
					}
					break;
				}
				default:
				{
					break;
				}
			}
		}
		
		public function listNotificationInterests():Array
		{
			return [CoreConst.ERROR_REPORT,CoreConst.STARTUP_STEP_BEGIN,CoreConst.HIDE_STARTUP_LOADING,
				CoreConst.SHOW_STARTUP_LOADING,CoreConst.HIDE_ALERT_WINDOW,CoreConst.SHOW_STARUP_INFOR,CoreConst.HIDE_STARUP_INFOR,CoreConst.CLEAN_STARUP_INFOR];
		}
		
		public function onRegister():void
		{			
			
			//			createAlertUI();
//			startupBMP = new StartupBG();
//			StartupBG = null;
			startupBMP.width = Capabilities.screenResolutionX;
			startupBMP.height = Capabilities.screenResolutionY;
			stage.addChild(startupBMP);
			
			starupInfo = new TextField();
			starupInfo.multiline = true;
			starupInfo.textColor = 0;
			starupInfo.autoSize = TextFieldAutoSize.LEFT;
			starupInfo.selectable = false;
			starupInfo.mouseEnabled = false;
			stage.addChild(starupInfo);
			
			
			var appXml:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appXml.namespace();
			Global.appName=appXml.ns::filename[0]+".swf";
			Global.appVersion = appXml.ns::versionNumber[0];
			sendNotification(CoreConst.STARTUP);
		}
		
		
		public function onRemove():void
		{
			// TODO Auto Generated method stub
			
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
		
		
		
		private function fixHandle(event:MouseEvent):void{
			facade.sendNotification(CoreConst.FIX);
		}
		
		private function ignoreHandle(event:MouseEvent):void{
			facade.sendNotification(CoreConst.HIDE_ALERT_WINDOW);						
			sendNotification(CoreConst.LOADING,false);
			sendNotification(WorldConst.UPLOAD_SYSTEM_LOG);//上传系统日志
			
		}
		
		private function showAlert(txt:String):void{
			alertWindow.x = (Global.stage.stageWidth - alertWindow.width)*0.5;
			alertWindow.y = (Global.stage.stageHeight - alertWindow.height)*0.5;
			alertText.text = txt;
			stage.addChild(alertWindow);
			
			
			if(Starling.current&&Starling.current.stage){
				Starling.current.stage.removeEventListeners();
			}
			
			stage.addEventListener(MouseEvent.CLICK,stageHandle,false,999);
			stage.addEventListener(MouseEvent.MOUSE_UP,stageHandle,false,999);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,stageHandle,false,999);
		}
		
		private function stageHandle(event:MouseEvent):void{
			event.preventDefault();
			event.stopImmediatePropagation();
			
		}
		
		
		public function initializeNotifier(key:String):void
		{
			// TODO Auto Generated method stub
			multitonKey = key;
		}
		
		public function sendNotification(notificationName:String, body:Object=null, type:String=null):void
		{
			if (facade != null) 
				facade.sendNotification( notificationName, body, type );
		}
		
	}
}

