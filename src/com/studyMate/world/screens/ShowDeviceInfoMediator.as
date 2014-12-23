package com.studyMate.world.screens
{
	import com.studyMate.controller.LicenseProxy;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.LicenseVO;
	import com.studyMate.world.model.IPSpeedMediator;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class ShowDeviceInfoMediator extends Mediator
	{
		public static var NAME:String = "ShowDeviceInfoMediator";
		private var btn:Sprite;
		
		private var holder:Sprite;
		
		public function ShowDeviceInfoMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				default:
				{
					break;
				}
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [];
		}
		
		override public function onRegister():void
		{
			var titleFormat:TextFormat = new TextFormat("HeiTi",22,0xffffff,true);
			titleFormat.align = TextFormatAlign.CENTER;
			
			view.graphics.lineStyle(1);
			view.graphics.beginFill(0x00AA8F);
			view.graphics.drawRect(0,0,350,435);
			view.graphics.endFill();
			
			view.graphics.lineStyle(1);
			view.graphics.beginFill(0xD62F2A);
			view.graphics.drawRect(0,0,350,35);
			view.graphics.endFill();
			
			var title:TextField = new TextField();
			title.text = "设备信息";
			title.setTextFormat(titleFormat);
			title.width = 350; title.height = 35;
			title.mouseEnabled = false;
			view.addChild(title);
			
			btn = new Sprite();
			btn.graphics.lineStyle(1);
			btn.graphics.beginFill(0xfcaf42);
			btn.graphics.drawRect(0,0,35,35);
			btn.graphics.endFill();
			var tf:TextField = new TextField();
			tf.text = "关闭";
			tf.x = 5; tf.y = 10;
			
			tf.mouseEnabled = false;
			tf.height = 40;
			btn.addChild(tf);
			btn.addEventListener(MouseEvent.CLICK, closeHandler);
			btn.x = 315; btn.y = 0;
			view.addChild(btn);
			
			holder = new Sprite();
			holder.y = 45;
			view.addChild(holder);
			
			addDeviceInfo();
		}
		private function addDeviceInfo():void{
			var licenseProxy:LicenseProxy = facade.retrieveProxy(LicenseProxy.NAME) as LicenseProxy;
			if(licenseProxy){
				var licenseVo:LicenseVO = licenseProxy.getLicense();
				
				var info:TextField = new TextField();
				info.width = 350; 
				info.height = 380;
				info.mouseEnabled = false;
				info.defaultTextFormat = new TextFormat("HeiTi",15,0,true);
				holder.addChild(info);
				
				//磁盘剩余空间
				var value:Number = File.documentsDirectory.spaceAvailable/1024/1024/1024;
				
				info.text = "系统版本:\tV "+Global.appVersion
					+"\n\n磁盘剩余:\t"+value.toFixed(2)+"G"
					+"\n\nMacId:\t\t"+licenseVo.macid
					+"\n\nMacAdd:\t\t"+licenseVo.regmac;
				
			}
			
			
		}

		
		private function closeHandler(event:MouseEvent):void{
			sendNotification(WorldConst.REMOVE_POPUP_SCREEN,this);
		}
		

		override public function onRemove():void
		{
			view.removeChildren();
			super.onRemove();
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
	}
}