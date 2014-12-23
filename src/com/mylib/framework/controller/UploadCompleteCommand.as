package com.mylib.framework.controller
{
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class UploadCompleteCommand extends SimpleCommand implements ICommand
	{
		public function UploadCompleteCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			trace("upload complete");
		}
		
	}
}