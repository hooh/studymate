package com.studyMate.controller
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class CheckVersionCompleteCommand extends SimpleCommand
	{
		public function CheckVersionCompleteCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
		}
		
	}
}