package com.mylib.game.charater.logic
{
	public interface IFightDecision extends IDecision
	{
		function makeFightDecision(ai:FighterControllerMediator):void;
		function makeEscapeDecision(ai:FighterControllerMediator):void;
		function makeHurtDecision(attacker:FighterControllerMediator,me:FighterControllerMediator):void;
	}
}