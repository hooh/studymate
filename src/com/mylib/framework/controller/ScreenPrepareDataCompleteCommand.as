package com.mylib.framework.controller
{
	import com.mylib.api.IFileLoadProxy;
	import com.mylib.api.ISwitchScreenProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.PrepareViewProxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ScreenPrepareDataCompleteCommand extends SimpleCommand implements ICommand
	{
		public function ScreenPrepareDataCompleteCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var views:Vector.<SwitchScreenVO> = notification.getBody() as Vector.<SwitchScreenVO>;
			var switchProxy:ISwitchScreenProxy = facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy;
			var sMediator:ScreenBaseMediator;
			var mname:String;
			
			facade.registerCommand(WorldConst.SWITCH_SCREEN_COMPLETE,SwitchScreenCompleteCommand);
			var doClean:Boolean;
			for each (var i:SwitchScreenVO in views) 
			{
				
				if(i.type == SwitchScreenType.SWITCH){
					doClean = true;
					for (var j:int = 0; j < switchProxy.gpuMediators.length; j++) 
					{
						
						sMediator = facade.retrieveMediator(switchProxy.gpuMediators[j]) as ScreenBaseMediator;
						if(sMediator){
							mname = sMediator.getMediatorName();
							sendNotification(WorldConst.CLEAN_SCREEN,WorldConst.GPU);
							AppLayoutUtils.gpuLayer.removeChildren(0,-1,true);
							AppLayoutUtils.gpuLayer.dispose();
							sendNotification(WorldConst.REMOVE_GPU_LIBS,mname);
						}
					}
					break;
				}
					
			}
			
			if(doClean){
				sendNotification(CoreConst.SHOW_STARTUP_LOADING);
				var fileProxy:IFileLoadProxy = facade.retrieveProxy(ModuleConst.FILE_LOAD_PROXY) as IFileLoadProxy;
				fileProxy.disposeLibsDomain();
			}
			
			
			var proxy:PrepareViewProxy = facade.retrieveProxy(PrepareViewProxy.NAME) as PrepareViewProxy;
			proxy.doAssetsLoad();
			
			
			
		}
		

		
	}
}