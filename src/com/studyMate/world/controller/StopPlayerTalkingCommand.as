package com.studyMate.world.controller
{
	import com.mylib.game.charater.TalkToSomeoneProxy;
	import com.mylib.game.charater.TalkingProxy;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class StopPlayerTalkingCommand extends SimpleCommand
	{
		public function StopPlayerTalkingCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var talkToSomeone:TalkToSomeoneProxy = facade.retrieveProxy(TalkToSomeoneProxy.NAME) as TalkToSomeoneProxy;
			talkToSomeone.stopTalking();
			
			var talking:TalkingProxy = facade.retrieveProxy(TalkingProxy.NAME) as TalkingProxy;
			talking.stopTalking();
		}
		
	}
}