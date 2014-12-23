package com.studyMate.controller
{
	import com.studyMate.model.GameServiceProxy;
	import com.studyMate.model.vo.ExecuteGameServiceCommandVO;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ExecuteGameServiceCommand extends SimpleCommand implements ICommand
	{
		public function ExecuteGameServiceCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var proxy:GameServiceProxy = facade.retrieveProxy(GameServiceProxy.NAME) as GameServiceProxy;
			var vo:ExecuteGameServiceCommandVO = notification.getBody() as ExecuteGameServiceCommandVO;
			proxy.execute(vo.commands,vo.operation);
		}
		
	}
}