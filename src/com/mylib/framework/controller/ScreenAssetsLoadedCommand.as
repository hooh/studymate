package com.mylib.framework.controller
{
	import com.mylib.framework.model.PrepareViewProxy;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ScreenAssetsLoadedCommand extends SimpleCommand implements ICommand
	{
		public function ScreenAssetsLoadedCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var proxy:PrepareViewProxy = facade.retrieveProxy(PrepareViewProxy.NAME) as PrepareViewProxy;
			proxy.doAssetsLoad();
		}
		
	}
}