package com.mylib.game.charater.logic
{
	public interface IDecision
	{
		function makeDecision(ai:BaseCharaterControllerMediator):void;
		function makeTargetingDecision(ai:BaseCharaterControllerMediator):void;
		function makeArriveDecision(ai:BaseCharaterControllerMediator):void;
		function dispose():void;
	}
}