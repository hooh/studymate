package com.studyMate.world.screens
{
	import com.byxb.extensions.starling.display.CameraSprite;

	public interface IScene
	{
		function get left():int;
		function set left(_int:int):void;
		function get right():int;
		function set right(_int:int):void;
		
		function pause():void;
		function run():void;
		
		function get width():int;
		
		
		function get x():int;
		
		function set x(value:int):void;
		
		function set camera(_camera:CameraSprite):void;
		function get camera():CameraSprite;
		
		
	}
}