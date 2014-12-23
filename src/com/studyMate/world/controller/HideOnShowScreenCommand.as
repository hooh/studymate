package com.studyMate.world.controller
{
	import com.mylib.api.ISwitchScreenProxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class HideOnShowScreenCommand extends SimpleCommand
	{
		public function HideOnShowScreenCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
			var switchScreenProxy:ISwitchScreenProxy = facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy;
			
			var showViewsData:Vector.<SwitchScreenVO> = switchScreenProxy.cpuFloatScreens.concat(switchScreenProxy.gpuFloatScreens);
			
			
			if(showViewsData.length){
				sendNotification(WorldConst.HIDE_SCREEN,showViewsData);
			}
			
		}
		
	}
}