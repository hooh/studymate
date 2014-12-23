package com.studyMate.controller
{
	import com.mylib.framework.model.SoundProxy;
	import com.studyMate.model.vo.SoundVO;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class SoundStopCommand extends SimpleCommand implements ICommand
	{
		public function SoundStopCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var proxy:SoundProxy = facade.retrieveProxy(SoundProxy.NAME) as SoundProxy;
			
			proxy.stop(notification.getBody() as SoundVO);
			
			
			
		}
		
	}
}