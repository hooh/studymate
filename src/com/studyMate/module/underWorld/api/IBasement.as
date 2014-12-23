package com.studyMate.module.underWorld.api
{
	import com.mylib.game.card.GameCharaterData;
	
	import starling.display.Sprite;

	public interface IBasement
	{
		function addMonster(gameCharater:GameCharaterData):void;
		function reset():void;
		function addHero(gameCharater:GameCharaterData):void;
		function get view():Sprite;
	}
}