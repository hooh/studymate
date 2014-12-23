package com.studyMate.world.screens.ui
{
	import com.mylib.game.charater.ICharater;
	
	import starling.display.DisplayObject;

	public interface ICharaterInteractiveObject
	{
		
		function registerCharater(charater:ICharater):void;
		
		function takeAction(charater:ICharater):void;
		
		function stopAction(charater:ICharater):void;
		
		function get charater():ICharater;
		
		function get display():DisplayObject;
		
		function set display(d:DisplayObject):void;
		
		function dispose():void;
		
		
		
	}
}