package com.studyMate.world.controller
{
	import com.mylib.game.charater.logic.PetDogFollowAIMediator;
	import com.studyMate.world.controller.vo.AddPetDogAICommandVO;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class AddPetDogAICommand extends SimpleCommand implements ICommand
	{
		public function AddPetDogAICommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var vo:AddPetDogAICommandVO = notification.getBody() as AddPetDogAICommandVO;
			
			
			var ai:PetDogFollowAIMediator = new PetDogFollowAIMediator(vo.dog.getMediatorName()+"AI",vo.dog,vo.holder);
			
			ai.start();
			
			
		}
		
	}
}