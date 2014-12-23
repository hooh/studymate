package com.mylib.framework.controller
{
	import com.mylib.framework.model.tcp.SocketProxy;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class StopRecCommand extends SimpleCommand
	{
		public function StopRecCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var socket:SocketProxy = facade.retrieveProxy(SocketProxy.NAME) as SocketProxy;
			socket.stopPackRec();
		}
		
	}
}