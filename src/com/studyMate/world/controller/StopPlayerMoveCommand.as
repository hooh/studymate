package com.studyMate.world.controller
{
	import com.studyMate.world.screens.MyCharaterControllerMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class StopPlayerMoveCommand extends SimpleCommand
	{
		public function StopPlayerMoveCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var controler:MyCharaterControllerMediator = facade.retrieveMediator(MyCharaterControllerMediator.NAME) as MyCharaterControllerMediator;
			controler.stopPlayerMovePath();
			controler.cleanLine();
		}
		
	}
}