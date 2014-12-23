package com.studyMate.controller
{
	import com.studyMate.model.GameServiceProxy;
	import com.studyMate.model.vo.UpdateGameServiceCommandVO;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class UpdateGameServiceCommand extends SimpleCommand implements ICommand
	{
		public function UpdateGameServiceCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var proxy:GameServiceProxy = facade.retrieveProxy(GameServiceProxy.NAME) as GameServiceProxy;
			var vo:UpdateGameServiceCommandVO = notification.getBody() as UpdateGameServiceCommandVO;
			proxy.update(vo.gameList,vo.time,vo.operation);
		}
		
	}
}