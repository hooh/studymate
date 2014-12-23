package com.studyMate.world.controller
{
	import com.mylib.game.charater.DialogBoxShowProxy;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class DialogBoxShowCommand extends SimpleCommand implements ICommand
	{
		public function DialogBoxShowCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var dialogBoxShow:DialogBoxShowProxy = facade.retrieveProxy(DialogBoxShowProxy.NAME) as DialogBoxShowProxy;
			dialogBoxShow.show(notification.getBody() as DialogBoxShowCommandVO);
			
		}
	}
}