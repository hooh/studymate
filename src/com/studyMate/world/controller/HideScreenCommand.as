package com.studyMate.world.controller
{
	import com.mylib.api.ISwitchScreenProxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import starling.display.DisplayObject;
	
	public class HideScreenCommand extends SimpleCommand implements ICommand
	{
		public function HideScreenCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var hideViews:Vector.<SwitchScreenVO> = notification.getBody() as Vector.<SwitchScreenVO>;
			
			
			var len:int = hideViews.length;
			var vo:SwitchScreenVO;
			var view:*;
			var mname:String;
			var idx:int;
			for (var i:int = 0; i < len; i++) 
			{
				vo = hideViews[i];
				if(!facade.hasMediator(vo.mediatorName)){
					continue;
				}
				view = facade.retrieveMediator(vo.mediatorName).getViewComponent();
				
				
				mname = vo.mediatorName;
				facade.removeMediator(mname);
				
				if(view){
					hideMediator(vo,view);
				}
				
				sendNotification(WorldConst.REMOVE_GPU_LIBS,mname);
			}
			
		}
		
		protected function hideMediator(vo:SwitchScreenVO,view:*):void{
			if(view is starling.display.DisplayObject){
				hideGpuMediator(vo,view);
			}else if(view is flash.display.DisplayObject){
				hideCpuMediator(vo,view);
			}
			
		}
		
		
		
		protected function hideGpuMediator(vo:SwitchScreenVO,view:starling.display.DisplayObject):void{
			var mname:String = vo.mediatorName;
			var idx:int;
			var switchScreenProxy:ISwitchScreenProxy = facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy;
			(view as starling.display.DisplayObject).removeFromParent(true);
			
			idx = switchScreenProxy.gpuMediators.indexOf(mname);
			
			if(idx>=0){
				switchScreenProxy.gpuMediators.splice(idx,1);
			}
			
			idx = switchScreenProxy.gpuFloatScreens.indexOf(vo);
			if(idx>=0){
				switchScreenProxy.gpuFloatScreens.splice(idx,1);
			}
			
			
		}
		
		protected function hideCpuMediator(vo:SwitchScreenVO,view:flash.display.DisplayObject):void{
			var mname:String = vo.mediatorName;
			var idx:int;
			var switchScreenProxy:ISwitchScreenProxy = facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy;
			
			removeCpuDisplay(view);
			
			idx = switchScreenProxy.cpuMediators.indexOf(mname);
			
			if(idx>=0){
				switchScreenProxy.cpuMediators.splice(idx,1);
			}
			
			idx = switchScreenProxy.cpuFloatScreens.indexOf(vo);
			if(idx>=0){
				switchScreenProxy.cpuFloatScreens.splice(idx,1);
			}
			
		}
		
		protected function removeCpuDisplay(view:flash.display.DisplayObject):void
		{
				if(view.parent){
					view.parent.removeChild(view);
				}
		}
		
		
		
		
	}
}