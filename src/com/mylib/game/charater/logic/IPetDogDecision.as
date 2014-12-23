package com.mylib.game.charater.logic
{
	public interface IPetDogDecision extends IDecision
	{
		function makeRestDecision(controller:PetDogControllerMediator):void;
		function makeRandomGODecision(controller:PetDogControllerMediator):void;
	}
}