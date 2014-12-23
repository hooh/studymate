package com.mylib.framework.controller
{
	import com.mylib.api.ISwitchScreenProxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.module.ModuleConst;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ScreenPrepareCompleteCommand extends SimpleCommand implements ICommand
	{
		public function ScreenPrepareCompleteCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var _views:Vector.<SwitchScreenVO> = notification.getBody() as Vector.<SwitchScreenVO>;
			
			
			var proxy:ISwitchScreenProxy = facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy;
			proxy.switchViews(_views);
			
			proxy.initScreen(_views);
			
			
		}
		
		
		
		
	}
}