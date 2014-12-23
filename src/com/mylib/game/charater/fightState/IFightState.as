package com.mylib.game.charater.fightState
{
	import com.mylib.game.charater.logic.FighterControllerMediator;

	public interface IFightState
	{
		function enter():void;
		function exit():void;
		function tick():void;
		function get type():uint;
		function set type(_t:uint):void;
		
		function get skill():uint;
		function set skill(_t:uint):void;
		
		function set charaterState(_c:FighterControllerMediator):void;
		function get charaterState():FighterControllerMediator;
		
		function set casterState(_c:FighterControllerMediator):void;
		function get casterState():FighterControllerMediator;
		
		function get lastTime():int;
		function set lastTime(_num:int):void;
		
		function get enterTime():int;
		function set enterTime(_num:int):void;
		
		
	}
}