package com.studyMate.controller.login
{
	import com.studyMate.global.Global;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class LoginFailCommand extends SimpleCommand implements ICommand
	{
		public function LoginFailCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			Global.player = null;
			Global.hasLogin = false;
		}
		
	}
}