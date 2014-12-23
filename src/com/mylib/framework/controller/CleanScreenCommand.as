package com.mylib.framework.controller
{
	import com.mylib.api.IFileLoadProxy;
	import com.mylib.api.ISwitchScreenProxy;
	import com.mylib.framework.model.SwitchScreenProxy;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	
	public class CleanScreenCommand extends SimpleCommand implements ICommand
	{
		private var fileProxy:IFileLoadProxy;
		
		
		public function CleanScreenCommand()
		{
			super();
		}
		
		
		/**
		 * clean GPU or CPU
		 * @param notification
		 * 
		 */		
		override public function execute(notification:INotification):void
		{
			
			var switchProxy:ISwitchScreenProxy = facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy;
			
			var sMediator:ScreenBaseMediator;
			
			
			var op:uint = notification.getBody() as uint;
			
			fileProxy = facade.retrieveProxy(ModuleConst.FILE_LOAD_PROXY) as IFileLoadProxy;
			
			var mname:String;
			
			if(WorldConst.GPU&op){
			
				while(switchProxy.gpuMediators.length){
					
					sMediator = facade.retrieveMediator(switchProxy.gpuMediators.pop()) as ScreenBaseMediator;
					if(sMediator){
						mname = sMediator.getMediatorName();
						facade.removeMediator(mname);
						
						if(Starling.juggler.contains(sMediator)){
							Starling.juggler.remove(sMediator);
						}
						
						if(sMediator.getViewComponent() is starling.display.DisplayObjectContainer){
							(sMediator.getViewComponent() as starling.display.DisplayObjectContainer).removeChildren(0,-1,true);
							
						}
						(sMediator.getViewComponent() as starling.display.DisplayObject).removeFromParent(true);
						
						if(WorldConst.CLEAN_ASSETS&op){
							sendNotification(WorldConst.REMOVE_GPU_LIBS,mname);
						}
					}
				}
				
				switchProxy.gpuFloatScreens.length=0;
			
			}
			
			if(WorldConst.CPU&op){
				
				if(WorldConst.CLEAN_ASSETS&op){
					fileProxy.disposeLibsDomain();
				}
				
				while(switchProxy.cpuMediators.length){
					sMediator = facade.retrieveMediator(switchProxy.cpuMediators.pop()) as ScreenBaseMediator;
					if(sMediator){
						mname = sMediator.getMediatorName();
						facade.removeMediator(mname);
						
						if(Starling.juggler.contains(sMediator)){
							Starling.juggler.remove(sMediator);
						}
						
						if(WorldConst.CLEAN_ASSETS&op){
							sendNotification(WorldConst.REMOVE_GPU_LIBS,mname);
						}
						removeCpuDisplay(sMediator.getViewComponent() as flash.display.DisplayObject);
						
					}
					
					
				}
			
				switchProxy.cpuFloatScreens.length=0;
			
			}
			
			
		}
		
		protected function removeCpuDisplay(view:flash.display.DisplayObject):void{
			if(view.parent){
				view.parent.removeChild(view);
			}
		}
		
		
		
		
		
		
	}
}