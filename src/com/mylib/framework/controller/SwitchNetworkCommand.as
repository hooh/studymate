package com.mylib.framework.controller
{
	import com.mylib.framework.model.tcp.SocketProxy;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.tcp.PackData;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class SwitchNetworkCommand extends SimpleCommand implements ICommand
	{
		public function SwitchNetworkCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var so:SocketProxy = facade.retrieveProxy(SocketProxy.NAME) as SocketProxy;
			
			if(!so.socket.connected&&PackData.app.head.dwReqCnt){
				so.reLogin();
			}
			
				
		}
		
	}
}