package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.ShareConst;
	import com.studyMate.controller.IPReaderProxy;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class FixMaterialMediator extends Mediator
	{
		public static const NAME:String = "FixMaterialMediator";
		public static const Send_FAQ_Info:String = NAME + "SendErrorInfo";
		private var alertWindow:Sprite;
		private var btn:Sprite;
		private var txt:TextField;
		
		public function FixMaterialMediator(){
			super(NAME, new Sprite);
		}
		
		override public function onRegister():void{
			var textFormat:TextFormat = new TextFormat("HeiTi",22,0xffffff,true);
			textFormat.align = TextFormatAlign.CENTER;
			
			var mainFormat:TextFormat = new TextFormat();
			mainFormat.size = 20;
			mainFormat.align = TextFormatAlign.CENTER;
			
			alertWindow = new Sprite();
			alertWindow.graphics.lineStyle(1);
			alertWindow.graphics.beginFill(0xA3E6F7);
			alertWindow.graphics.drawRect(0,0,700,300);
			alertWindow.graphics.endFill();
			view.addChild(alertWindow);
			alertWindow.x = ( Global.stageWidth - alertWindow.width ) / 2; alertWindow.y = ( Global.stageHeight - alertWindow.height ) / 2;
			
			var titleBar:Sprite = new Sprite();
			titleBar.graphics.lineStyle(1);
			titleBar.graphics.beginFill(0xff8a00);
			titleBar.graphics.drawRect(0,0,700,35);
			titleBar.graphics.endFill();
			alertWindow.addChild(titleBar);
			
			var title:TextField = new TextField();
			title.text = "系统修复";
			title.setTextFormat(textFormat);
			title.textColor = 0xffffff;
			title.width = 700; title.height = 35;
			titleBar.addChild(title);
			
			btn = new Sprite();
			btn.graphics.lineStyle(1);
			btn.graphics.beginFill(0xfcaf42);
			btn.graphics.drawRect(0,0,100,40);
			btn.graphics.endFill();
			var tf:TextField = new TextField();
			tf.text = "重新修复";
			tf.x = 24; tf.y = 10;
			
			tf.mouseEnabled = false;
			tf.height = 40;
			btn.addChild(tf);
			btn.addEventListener(MouseEvent.CLICK,fixHandle);
			btn.x = 300; btn.y = 230;
			alertWindow.addChild(btn);
			
			txt = new TextField();
			txt.width = 700; txt.height = 150;
			txt.defaultTextFormat = mainFormat;
			txt.y = 50;
			alertWindow.addChild(txt);
			
			loginByDefault();
		}
		
		private function fixHandle(event:MouseEvent):void{
			txt.text = "";
			sendNotification(WorldConst.CLEAN_SCREEN,WorldConst.GPU|WorldConst.CPU);
			if(!Global.isLoading){
				loginByDefault();
			}
		}
		
		private function viewHandle(event:MouseEvent):void{
			Global.isUserExit = true;
			NativeApplication.nativeApplication.exit();
		}
		
		private function loginByDefault():void{  // 默认用户登录
			txt.text = "\n检查并连接网络...";
			
			if(!Global.getSharedProperty(ShareConst.IP)){
				var ipReader:IPReaderProxy = facade.retrieveProxy(IPReaderProxy.NAME) as IPReaderProxy;
				var array:Array = ipReader.getIpInf("telecom");
				if(array == null){
					array = ["121.33.246.212", 8820, 5];
				}
				sendNotification(CoreConst.CONFIG_IP_PORT,array);
			}
			
			Global.user = Global.fixUserName;
			Global.password = Global.fixUserPSW;
			Global.hasLogin = false;
			sendNotification(CoreConst.SOCKET_INIT,[false,"B0","a"]);
		}
		
		override public function handleNotification(notification:INotification):void{
			var name:String = notification.getName() ;
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(name){
				case CoreConst.REMIND_UPDATE_COMPLETE:
					btn.visible = false;
					txt.appendText("\n\n修复完毕，点击屏幕任意位置关闭程序...");
					view.addEventListener(MouseEvent.CLICK,viewHandle);
					break;
				case CoreConst.LICENSE_PASSED:
					
					if(Global.use3G){
						sendNotification(CoreConst.REMIND_UPDATE_COMPLETE);
					}else{
						txt.appendText( "\n\n更新系统文件...");
						sendNotification(CoreConst.RUN_UPDATE,"a");
					}
					
					
					break;
				default :
					break;
			}
		}
		
		override public function listNotificationInterests():Array{
			return [CoreConst.REMIND_UPDATE_COMPLETE,CoreConst.LICENSE_PASSED];
		}
		
		override public function onRemove():void{
			super.onRemove();
		}
		
		private function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
	}
}