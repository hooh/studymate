package com.studyMate.world.controller
{
	import com.mylib.game.charater.DialogBoxShowProxy;
	import com.mylib.game.charater.TalkToSomeoneProxy;
	import com.mylib.game.charater.TalkingProxy;
	import com.mylib.game.charater.logic.HumanTalkShowProxy;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ConfigDependedModelCommand extends SimpleCommand
	{
		public function ConfigDependedModelCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
			
			facade.registerProxy(new HumanTalkShowProxy(HumanTalkShowProxy.NPC));
			facade.registerProxy(new HumanTalkShowProxy(HumanTalkShowProxy.PLAYER));
			facade.registerProxy(new TalkToSomeoneProxy());
			facade.registerProxy(new TalkingProxy());
			facade.registerProxy(new DialogBoxShowProxy);
		}
		
	}
}