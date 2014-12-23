package com.studyMate.controller
{
	import com.studyMate.global.Global;
	import com.studyMate.view.MainViewMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class InitRootCommand extends SimpleCommand
	{
		public function InitRootCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.registerMediator(new MainViewMediator(Global.root));
		}
		
	}
}