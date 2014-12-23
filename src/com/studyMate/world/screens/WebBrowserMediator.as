package com.studyMate.world.screens
{
	import com.edu.EduAllExtension;
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.CheckSocketProxy;
	import com.mylib.framework.model.NetStateProxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.utils.MyUtils;
	
	import flash.desktop.NativeApplication;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.LocationChangeEvent;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import feathers.controls.Button;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;

	public class WebBrowserMediator extends ScreenBaseMediator implements IMediator
	{
		public static const NAME:String = "WebBrowserMediator";
		
		//浏览器用
		private var stageWebView:StageWebView;
		private var webStartTime:int;
		private var webEndTime:int;
		//private var launcher:LaunchAppExtension;
		
		private var input:flash.text.TextField;
		
		public function WebBrowserMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}

		override public function onRegister():void
		{
			
			NativeApplication.nativeApplication.removeEventListener(Event.DEACTIVATE,deactivateHandle);
			
			init();
			
		}
		private function init():void{
			
			//launcher = new LaunchAppExtension();
			
			
			var tipText:starling.text.TextField = new starling.text.TextField(230,45,"网页认证,请在5分钟内验证身份");
			view.addChild(tipText);
			
			input = new flash.text.TextField();
			input.type = TextFieldType.INPUT;
			input.name = "input";
			input.defaultTextFormat = new TextFormat("HeiTi",18);
			input.width = 880;
			input.height = 45;
			input.x = 230;
			input.needsSoftKeyboard = false;
			input.addEventListener(KeyboardEvent.KEY_DOWN,inputHandle);
			Starling.current.nativeOverlay.addChild(input);
			input.text = "http://www.baidu.com/www.baidu.com/";
			
			
			var enterBtn:Button = new Button();
//			enterBtn.x = 1130;
			enterBtn.x = 1000;
			enterBtn.label = "确认";
			enterBtn.addEventListener(TouchEvent.TOUCH, enterBtnHandle);
			view.addChild(enterBtn);
			
			var closeBtn:Button = new Button();
			closeBtn.x = 1070;
			closeBtn.label = "X";
			closeBtn.addEventListener(TouchEvent.TOUCH, webCloseHandle);
			view.addChild(closeBtn);
			
			
			webStartTime = (Global.nowDate.time)/1000;
			TweenLite.delayedCall(MyUtils.webUsingTime,webClose);	
			
			
			stageWebView = new StageWebView();
			
			stageWebView.stage = Starling.current.nativeOverlay.stage;
			
			stageWebView.viewPort = new Rectangle( 0, 45, 1280, 717);
			stageWebView.addEventListener(LocationChangeEvent.LOCATION_CHANGE,urlChangeHandle);
			stageWebView.addEventListener(ErrorEvent.ERROR,urlError);

			webEnterBtnHandle();
			
			//进入网页认证，5秒后连接一次服务器（电信、联通），判断是否成功连接网络
			TweenLite.delayedCall(5,checkSocket);
		}
		private var checkSocketProxy:NetStateProxy;
		//检查电信、联通连接情况
		private function checkSocket():void{
//			sendNotification(WorldConst.CHECK_SOCKET_CONNECT);
			
			if(!checkSocketProxy){
				checkSocketProxy = new NetStateProxy();
				facade.registerProxy(checkSocketProxy);
			}
			checkSocketProxy.startCheck(true);
		}
		
		private function inputHandle(e:KeyboardEvent):void{
			if(e.keyCode==13){
				webEnterBtnHandle();
			}
		}
		//转入地址栏url地址
		private function webEnterBtnHandle():void{
			if(input.text.split("//")[0] != "http:")
				stageWebView.loadURL("http://"+input.text);
			else
				stageWebView.loadURL(input.text);
		}
		private function urlChangeHandle(event:LocationChangeEvent):void{
			input.text = stageWebView.location;
		}
		private function urlError(e:ErrorEvent):void{
			
			trace("网页加载失败！");
		}
		private function enterBtnHandle(event:TouchEvent):void{
			var touch:Touch = event.getTouch(event.target as DisplayObject,TouchPhase.ENDED);
			if(touch){
				webEnterBtnHandle();
			}
			
		}
		private function webCloseHandle(event:TouchEvent):void{
			var touch:Touch = event.getTouch(event.target as DisplayObject,TouchPhase.ENDED);
			if(touch){
				webClose();
			}
		}
		private function webClose():void{
			sendNotification(WorldConst.POP_SCREEN);
		}
		
		private function deactivateHandle(event:flash.events.Event):void{
			//launcher.execute("com.eduonline.service","exeCommands",["iptables -P OUTPUT DROP"]);
			EduAllExtension.getInstance().launchAppExtension("com.eduonline.service","exeCommands",["iptables -P OUTPUT DROP"]);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var name:String = notification.getName();
			switch(name)
			{
				case WorldConst.CHECK_SOCKET_RESULT:
					var res:Boolean = notification.getBody() as Boolean;
					TweenLite.killTweensOf(checkSocket);
					//可以连接我们系统，退出网页认证
					if(res){
						MyUtils.webUsingTime = 0;
						webClose();
						
					}else{
						//连不上，30秒后检查
						TweenLite.delayedCall(30,checkSocket);
					}
					
					break;
			}
		}
		override public function listNotificationInterests():Array
		{
			return [WorldConst.CHECK_SOCKET_RESULT];
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		override public function onRemove():void
		{
			sendNotification(WorldConst.DISPOSE_CHECK_SOCKET);
			
			NativeApplication.nativeApplication.removeEventListener(Event.DEACTIVATE,deactivateHandle);
			input.removeEventListener(KeyboardEvent.KEY_DOWN,inputHandle);
			Starling.current.nativeOverlay.removeChild(input);
			stageWebView.stage = null;
			
			webEndTime = (Global.nowDate.time)/1000;
			MyUtils.webUsingTime -= (webEndTime - webStartTime);
			TweenLite.killTweensOf(webClose);
			TweenLite.killTweensOf(checkSocket);
			
			EduAllExtension.getInstance().launchAppExtension("com.eduonline.service","exeCommands",["iptables -P OUTPUT DROP"]);
		}

		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
	}
}