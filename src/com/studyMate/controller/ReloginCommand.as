package com.studyMate.controller
{
	import com.mylib.framework.ShareConst;
	import com.mylib.framework.model.tcp.SocketProxy;
	import com.studyMate.global.Global;
	
	import flash.concurrent.Mutex;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class ReloginCommand extends SimpleCommand implements ICommand
	{
		public function ReloginCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var socket:SocketProxy = facade.retrieveProxy(SocketProxy.NAME) as SocketProxy;
			
			socket.reLogin();
			
		}
		
	}
}