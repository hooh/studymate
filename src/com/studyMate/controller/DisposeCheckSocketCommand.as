package com.studyMate.controller
{
	import com.mylib.framework.model.NetStateProxy;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class DisposeCheckSocketCommand extends SimpleCommand implements ICommand
	{
		
		public function DisposeCheckSocketCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
			var checkSocket:NetStateProxy = facade.retrieveProxy(NetStateProxy.NAME) as NetStateProxy;
			
			if(checkSocket){
				
				checkSocket.applyDispose();
				
			}
			
			
			
		}
		
		
	}
}