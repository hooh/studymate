package com.studyMate.controller
{
	import com.mylib.framework.controller.SystemNotificationMediator;
	import com.studyMate.view.LoadingMediator;
	import com.studyMate.view.LoadingViewMediator;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	
	public final class NotificationPrepCommand extends SimpleCommand implements ICommand
	{
		public function NotificationPrepCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.registerMediator(new SystemNotificationMediator());
			facade.registerMediator(new LoadingMediator);
			facade.registerMediator(new LoadingViewMediator());
		}
		
	}
}