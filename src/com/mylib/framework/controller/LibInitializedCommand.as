package com.mylib.framework.controller
{
	import com.mylib.framework.CoreConst;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class LibInitializedCommand extends SimpleCommand
	{
		public function LibInitializedCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			sendNotification(CoreConst.START_GET_INITIALIZE_DATA);
		}
		
	}
}