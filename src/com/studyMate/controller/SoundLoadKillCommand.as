package com.studyMate.controller
{
	import com.mylib.framework.model.SoundProxy;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class SoundLoadKillCommand extends SimpleCommand implements ICommand
	{
		public function SoundLoadKillCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var proxy:SoundProxy = facade.retrieveProxy(SoundProxy.NAME) as SoundProxy;
			
			proxy.killAll();
		}
		
	}
}