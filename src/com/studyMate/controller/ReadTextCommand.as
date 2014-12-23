package com.studyMate.controller
{
	import com.mylib.framework.model.TTSProxy;
	import com.studyMate.model.vo.ReadTextVO;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ReadTextCommand extends SimpleCommand implements ICommand
	{
		public function ReadTextCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
			var vo:ReadTextVO = notification.getBody() as ReadTextVO;
			
			var proxy:TTSProxy = facade.retrieveProxy(TTSProxy.NAME) as TTSProxy;
			
			proxy.completeNotification = vo.completeNotification;
			proxy.completeNotificationParameters = vo.completeNotificationParameters;
			
			proxy.speak(vo.text,vo.pitch,vo.speechRate);
			
		}
		
		
		
		
		
	}
}