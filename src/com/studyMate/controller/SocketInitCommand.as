package com.studyMate.controller
{
	import com.mylib.framework.model.tcp.SocketProxy;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 *socket 初始化 
	 * @author hoohuayip
	 * 
	 */	
	public final class SocketInitCommand extends SimpleCommand implements ICommand
	{
		public function SocketInitCommand()
		{
			
		}
		
		override public function execute(notification:INotification):void
		{
			
			var proxy:SocketProxy = facade.retrieveProxy(SocketProxy.NAME) as SocketProxy;
			
			if(proxy.isConnecting){
				return;
			}
			
			
			proxy.connectFuntion = proxy.sendLoginCommand;
			proxy.connectFuntionParameters = notification.getBody() as Array;
			proxy.connect();
			
			
		}
		
	}
}