package com.studyMate.world.controller
{
	import com.studyMate.world.controller.vo.SendSimSimiMessageCommandVO;
	import com.studyMate.world.model.SimSimiProxy;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class SendSimSimiMessageCommand extends SimpleCommand implements ICommand
	{
		public function SendSimSimiMessageCommand()
		{
			
			
			
		}
		
		override public function execute(notification:INotification):void
		{
			var vo:SendSimSimiMessageCommandVO = notification.getBody() as SendSimSimiMessageCommandVO;
			var proxy:SimSimiProxy = facade.retrieveProxy(SimSimiProxy.NAME) as SimSimiProxy;
			
			proxy.sendMessage(vo.msg,vo.lc);
			
		}
		
	}
}