package com.studyMate.world.controller.vo
{
	import com.mylib.game.charater.PetDogMediator;
	
	import starling.display.Sprite;

	public class AddPetDogAICommandVO
	{
		public var dog:PetDogMediator;
		public var holder:Sprite
		public function AddPetDogAICommandVO(dog:PetDogMediator,holder:Sprite)
		{
			this.dog = dog;
			this.holder = holder;
		}
	}
}