package com.mylib.game.fishGame
{
	import com.mylib.game.fishGame.ai.IBoid;
	
	import starling.animation.IAnimatable;
	import starling.display.DisplayObject;

	public interface ILive extends IAnimatable
	{
		function get view():DisplayObject;
		function set view(value:DisplayObject):void;
		function get boid():IBoid;
		function set boid(value:IBoid):void;
		function render():void;
		function start():void;
		function stop():void;
		
		
		
	}
}