package com.mylib.framework.controller
{
	import com.mylib.api.ISwitchScreenProxy;
	import com.mylib.framework.model.SwitchScreenProxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.module.ModuleConst;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class AddGpuScreenDataCommand extends SimpleCommand
	{
		public function AddGpuScreenDataCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var proxy:ISwitchScreenProxy = facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy;
			proxy.gpuStack.push(notification.getBody() as SwitchScreenVO);
			
		}
		
	}
}