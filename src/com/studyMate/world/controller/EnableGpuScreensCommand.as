package com.studyMate.world.controller
{
	import com.mylib.api.ISwitchScreenProxy;
	import com.mylib.framework.model.SwitchScreenProxy;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.controller.vo.EnableScreenCommandVO;
	import com.studyMate.world.screens.ScreenBaseMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import starling.display.DisplayObject;
	
	public class EnableGpuScreensCommand extends SimpleCommand
	{
		public function EnableGpuScreensCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var vo:EnableScreenCommandVO = notification.getBody() as EnableScreenCommandVO;
			var proxy:ISwitchScreenProxy = facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy;
			
			for (var i:int = 0; i < proxy.gpuMediators.length; i++) 
			{
				
				if(vo&&vo.exceptions&&vo.exceptions.indexOf(proxy.gpuMediators[i])<0){
					
					var screenbase:ScreenBaseMediator = facade.retrieveMediator(proxy.gpuMediators[i]) as ScreenBaseMediator;
					
					if(screenbase){
						if(screenbase.getViewComponent() is DisplayObject){
							(screenbase.getViewComponent() as DisplayObject).touchable = vo.enable;
						}
					}
					
					
				}
				
			}
			
			
		}
		
	}
}