package com.mylib.framework.controller
{
	import com.mylib.framework.model.UpdaterMediator;
	import com.studyMate.global.Global;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class RunUpdateCommand extends SimpleCommand
	{
		public function RunUpdateCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			if(!Global.use3G&&!facade.hasMediator(UpdaterMediator.NAME)){
//				facade.registerMediator(new UpdaterMediator);
			}
		}
		
	}
}