package com.studyMate.world.controller
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class HideStartupLoadingCommand extends SimpleCommand
	{
		public function HideStartupLoadingCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			if(ShowStartupLoadingCommand.loading){
				
				
				ShowStartupLoadingCommand.loading.stop();
				
				
				
				if(ShowStartupLoadingCommand.loading.parent){
					ShowStartupLoadingCommand.loading.parent.removeChild(ShowStartupLoadingCommand.loading);
				}
				
				
			}
			
			
		}
		
	}
}