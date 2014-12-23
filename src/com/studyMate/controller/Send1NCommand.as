package com.studyMate.controller
{
	import com.mylib.framework.model.tcp.SocketProxy;
	import com.studyMate.model.vo.SendCommandVO;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class Send1NCommand extends SimpleCommand implements ICommand
	{
		public static const NAME:String = "Send1NCommand";
		
		
		public function Send1NCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var proxy:SocketProxy = facade.retrieveProxy(SocketProxy.NAME) as SocketProxy;
			proxy.setReceiveNotification((notification.getBody() as SendCommandVO).receiveNotification);
			proxy.receiveNotificationPara = (notification.getBody() as SendCommandVO).para;
			proxy.receiveEncode = (notification.getBody() as SendCommandVO).encode;
			proxy.byteIdx = (notification.getBody() as SendCommandVO).byteIdx;
			
			proxy.sendHostCmd1N();
		}
		
	}
}