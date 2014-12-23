package com.mylib.framework.controller
{
	import com.greensock.TweenLite;
	import com.mylib.api.ISwitchScreenProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.PrepareViewProxy;
	import com.mylib.framework.model.SwitchScreenProxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.module.ModuleUtils;
	import com.studyMate.world.screens.CleanCpuMediator;
	import com.studyMate.world.screens.CleanGpuMediator;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.system.System;
	
	import org.as3commons.logging.api.getLogger;
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class SwitchScreenCommand extends SimpleCommand implements ICommand
	{
		
		
		
		public function SwitchScreenCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var proxy:PrepareViewProxy = facade.retrieveProxy(PrepareViewProxy.NAME) as PrepareViewProxy;
			if(proxy.views&&proxy.views.length){
				return;
			}
			var source:Array;
			if(notification.getBody() is Array){
				source = notification.getBody() as Array;
			}else{
				source = [notification.getBody()];
			}
			
			
			var viewsData:Vector.<SwitchScreenVO> = new Vector.<SwitchScreenVO>;
			
			var showViewsData:Vector.<SwitchScreenVO> =  new Vector.<SwitchScreenVO>;
			var thisExecuteMark:Boolean;
			for (var i:int = 0; i < source.length; i++) 
			{
				if(source[i].mediatorClass is String){
					source[i].mediatorClass = ModuleUtils.getModuleClass(source[i].mediatorClass);
				}
				
				if((source[i] as SwitchScreenVO).type==SwitchScreenType.HIDE){
					showViewsData.push(source[i]);
				}else{
					
					if((source[i] as SwitchScreenVO).type==SwitchScreenType.SWITCH){
						
						//上一个界面还没切换完。
						if(Global.isSwitching&&!thisExecuteMark){
							sendNotification(CoreConst.SHOW_BUSY);
							return;
						}
						sendNotification(WorldConst.SET_MODAL,true);
						thisExecuteMark = true;
						Global.isSwitching = true;
						viewsData.unshift(source[i]);
					}else{
						viewsData.push(source[i]);
					}
					
					
				}
			}
			
			
			var switchProxy:ISwitchScreenProxy = facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy;
			if(notification.getType()==WorldConst.POP){
				switchProxy.pushStackType = SwitchScreenProxy.POP;
			}else if(notification.getType()==WorldConst.REPLACE){
				switchProxy.pushStackType = SwitchScreenProxy.REPLACE;
			}else if(viewsData.length){
				switchProxy.pushStackType = SwitchScreenProxy.PUSH;
			}
			
			if(showViewsData.length){
				sendNotification(WorldConst.HIDE_SCREEN,showViewsData);
			}
			
			if(viewsData.length){
				var j:int=0;
				var k:int = 0;
				//忽略重复请求
				if(proxy.views&&proxy.views.length){
					for (j = 0; j < proxy.views.length; j++) 
					{
						for (k = 0; k < viewsData.length; k++) 
						{
							if(proxy.views[j].mediatorClass==viewsData[k].mediatorClass){
								sendNotification(CoreConst.SHOW_BUSY);
								return;
							}
						}
					}
					
				}
				
				
				var switchScreenProxy:ISwitchScreenProxy = facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy;
				var screen:ScreenBaseMediator;
				for (j = 0; j < switchScreenProxy.gpuMediators.length; j++) 
				{
					for (k = 0; k < viewsData.length; k++) 
					{
						
						screen = facade.retrieveMediator(switchScreenProxy.gpuMediators[j]) as ScreenBaseMediator;
						if(!(screen is CleanGpuMediator)&& (screen is viewsData[k].mediatorClass)){
							sendNotification(CoreConst.SHOW_BUSY);
							return;
						}
					}
				}
				
				for (j = 0; j < switchScreenProxy.cpuMediators.length; j++) 
				{
					for (k = 0; k < viewsData.length; k++) 
					{
						
						screen = facade.retrieveMediator(switchScreenProxy.cpuMediators[j]) as ScreenBaseMediator;
						if(!(screen is CleanCpuMediator)&& (screen is viewsData[k].mediatorClass)){
							sendNotification(CoreConst.SHOW_BUSY);
							return;
						}
					}
				}
				
				
				
				
				proxy.views = viewsData;
				
				
				/*if(Global.isFirstSwitch){
					trace("*************************delay10");
					Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("delay 10","SwitchScreenCommand",0));

					TweenLite.killDelayedCallsTo(delaySwitch);
					TweenLite.delayedCall(10,delaySwitch,null,true);
				}else{
					trace("***no delay");*/
					proxy.doPrepare();
				//}
				
				if(Global.isSwitching){
					Global.isFirstSwitch = false;
				}
				
				
			}
			
			
			
		}
		
		private static function delaySwitch():void{
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("delaySwitch s","SwitchScreenCommand",0));

//			System.pauseForGCIfCollectionImminent();
			var proxy:PrepareViewProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(PrepareViewProxy.NAME) as PrepareViewProxy;
			proxy.doPrepare();
			
			
//			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("delaySwitch e","SwitchScreenCommand",0));

		}
		
		
		
	}
}