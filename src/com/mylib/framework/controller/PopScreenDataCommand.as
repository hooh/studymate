package com.mylib.framework.controller
{
	import com.mylib.api.ISwitchScreenProxy;
	import com.studyMate.module.ModuleConst;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class PopScreenDataCommand extends SimpleCommand
	{
		public function PopScreenDataCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var proxy:ISwitchScreenProxy = facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy;
			
			proxy.gpuStack.pop();
			proxy.cpuStack.pop();
			
			
		}
		
	}
}