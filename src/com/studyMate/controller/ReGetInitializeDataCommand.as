package com.studyMate.controller
{
	import com.mylib.framework.CoreConst;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ReGetInitializeDataCommand extends SimpleCommand
	{
		public function ReGetInitializeDataCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.registerMediator(new GetInitializeDataMediator);
			sendNotification(CoreConst.START_GET_INITIALIZE_DATA);
		}
		
	}
}