package com.studyMate.controller
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.ServerRegisterVO;
	import com.studyMate.model.vo.ToastVO;
	
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class RegisterPadCommand extends SimpleCommand
	{
		public function RegisterPadCommand()
		{
			super();
		}
		
		private var region:String;
		
		override public function execute(notification:INotification):void
		{
			if(!Global.hasLogin){
				sendNotification(CoreConst.TOAST,new ToastVO("请先用管理员注册"));
				return;
			}
			
			region = notification.getBody() as String;
			
			doReg();
			
			
			
		}
		
		
		
		private function doReg():void{
			var mac:Vector.<NetworkInterface> = NetworkInfo.networkInfo.findInterfaces();
			var macItem:NetworkInterface;
			var address:String;
			for (var i:int = 0; i < mac.length; i++) 
			{
				macItem = mac[i];
				
				address=macItem.hardwareAddress;
				
				if(address!=""){
					break;
				}
				
				
			}
			
			address = address.replace(/:/g,"-");
			address = address.replace(/\./g,"-");
			address = address.toLocaleUpperCase();
			
			sendNotification(CoreConst.SERVER_REGISTER,new ServerRegisterVO(address,region));
			
		}
		
		
		
	}
}