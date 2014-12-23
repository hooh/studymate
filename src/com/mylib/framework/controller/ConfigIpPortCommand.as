package com.mylib.framework.controller
{
	import com.mylib.framework.ShareConst;
	import com.mylib.framework.model.tcp.SocketProxy;
	import com.studyMate.global.Global;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ConfigIpPortCommand extends SimpleCommand
	{
		public function ConfigIpPortCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			Global.setSharedProperty(ShareConst.IP,notification.getBody()[0]);
			Global.setSharedProperty(ShareConst.PORT,notification.getBody()[1]);
			Global.setSharedProperty(ShareConst.NETWORK_ID,notification.getBody()[2]);
			
			var socket:SocketProxy = facade.retrieveProxy(SocketProxy.NAME) as SocketProxy;
			socket.host = notification.getBody()[0];
			socket.port = notification.getBody()[1];
		}
		
	}
}