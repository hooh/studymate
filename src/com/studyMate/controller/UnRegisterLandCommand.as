package com.studyMate.controller
{
	import com.studyMate.model.GrowProxy;
	import com.studyMate.view.item.IGrowObj;
	import com.studyMate.view.map.ILand;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class UnRegisterLandCommand extends SimpleCommand implements ICommand
	{
		public function UnRegisterLandCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var proxy:GrowProxy = facade.retrieveProxy(GrowProxy.NAME) as GrowProxy;
			proxy.unregisterLand(notification.getBody() as ILand);
		}
		
	}
}