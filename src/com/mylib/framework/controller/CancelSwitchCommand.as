package com.mylib.framework.controller
{
	import com.mylib.api.ISwitchScreenProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.PrepareViewProxy;
	import com.mylib.framework.model.SwitchScreenProxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.screens.HappyIslandMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class CancelSwitchCommand extends SimpleCommand
	{
		public function CancelSwitchCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var vo:SwitchScreenVO = notification.getBody() as SwitchScreenVO;
			
			if(!Global.isSwitching){
				return;
			}
			
			var prepareViewProxy:PrepareViewProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(PrepareViewProxy.NAME) as PrepareViewProxy;
			if(!vo&&prepareViewProxy.views&&prepareViewProxy.views.length>=prepareViewProxy.currentIdx){
				if(prepareViewProxy.currentIdx>0){
					vo = prepareViewProxy.views[prepareViewProxy.currentIdx-1];
				}else{
					Global.isSwitching = false;
				}
				prepareViewProxy.views.length = 0;
			}
			
			if(!vo){
				sendNotification(WorldConst.SET_MODAL,false);
				return;
			}
			
			
			
			if(vo.type == SwitchScreenType.SWITCH){
				var proxy:ISwitchScreenProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy;
				
				if(proxy.gpuStack.lastTwoScreen().mediator is vo.mediatorClass){
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.POP_SCREEN_DATA);
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.POP_SCREEN);
				}
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SET_MODAL,false);
				Global.isSwitching = false;
				
			}else if(vo.type == SwitchScreenType.SHOW){
				
				
			}
			prepareViewProxy.views.length = 0;
			
			
			
		}
		
		
		
	}
}