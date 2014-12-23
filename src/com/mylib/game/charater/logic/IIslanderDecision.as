package com.mylib.game.charater.logic
{
	public interface IIslanderDecision extends IDecision
	{
		function makeRestDecision(controller:IslanderControllerMediator):void;
		function makeSitDecision(controller:IslanderControllerMediator):void;
		function makeTalkDecision(controller:IslanderControllerMediator):void;
		function makeRandomGODecision(controller:IslanderControllerMediator):void;
		function makeFindTalkPartner(controller:IslanderControllerMediator):void;
		function get target():IslanderControllerMediator;
		function set target(value:IslanderControllerMediator):void;
	}
}