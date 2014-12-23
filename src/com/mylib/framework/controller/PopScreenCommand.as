package com.mylib.framework.controller
{
	import com.mylib.api.ISwitchScreenProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class PopScreenCommand extends SimpleCommand implements ICommand
	{
		public function PopScreenCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var proxy:ISwitchScreenProxy = facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy;
			var preGpuVO:SwitchScreenVO;
			var preCpuVO:SwitchScreenVO;
			proxy.currentGpuScreen = null;
			
			sendNotification(CoreConst.DISABLE_CANCEL_DOWNLOAD);
			
			preGpuVO = proxy.gpuStack.lastScreen();
			preCpuVO = proxy.cpuStack.lastScreen();
			
			var nextGpuVO:SwitchScreenVO = proxy.gpuStack.lastTwoScreen();
			var nextCpuVO:SwitchScreenVO = proxy.cpuStack.lastTwoScreen();
			
			if(!nextGpuVO&&!nextCpuVO){
				return;
			}
			facade.registerCommand(WorldConst.SWITCH_SCREEN_COMPLETE,SwitchScreenCompleteCommand);
			sendNotification(WorldConst.SET_MODAL,true);
			
			if(proxy.gpuStack.length==0){
				sendNotification(WorldConst.CLEAN_SCREEN,WorldConst.GPU|WorldConst.CLEAN_ASSETS);
			}
			
			if(proxy.cpuStack.length==0){
				sendNotification(WorldConst.CLEAN_SCREEN,WorldConst.CPU|WorldConst.CLEAN_ASSETS);
			}
			
			
			
			
			if(!nextGpuVO){
				sendNotification(WorldConst.CLEAN_SCREEN,WorldConst.GPU|WorldConst.CLEAN_ASSETS);
			}
			
			if(!nextCpuVO){
				sendNotification(WorldConst.CLEAN_SCREEN,WorldConst.CPU|WorldConst.CLEAN_ASSETS);
			}
			
			
			
			if(preGpuVO==nextGpuVO){
				nextGpuVO =null;
			}
			
			if(preCpuVO==nextCpuVO){
				nextCpuVO =null;
			}
			
			
			
			var switchArray:Array = [];
			
			if(nextGpuVO){
				switchArray.push(nextGpuVO);
			}
			
			if(nextCpuVO){
				switchArray.push(nextCpuVO);
			}
			
			if(switchArray.length){
				sendNotification(WorldConst.SWITCH_SCREEN,switchArray,WorldConst.POP);
			}
			
			
		}
		
	}
}