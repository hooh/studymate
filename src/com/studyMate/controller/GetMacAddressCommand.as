package com.studyMate.controller
{
	import com.mylib.framework.ShareConst;
	import com.studyMate.global.Global;
	
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class GetMacAddressCommand extends SimpleCommand
	{
		public function GetMacAddressCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
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
			
//			Global.address = address.replace(/\./g,"-");
			
			Global.setSharedProperty(ShareConst.ADDRESS,address.replace(/\./g,"-"));
		}
		
	}
}