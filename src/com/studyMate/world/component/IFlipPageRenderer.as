package com.studyMate.world.component
{
	import starling.display.DisplayObject;

	public interface IFlipPageRenderer
	{
		function get view():DisplayObject;
		function disposePage():void;
		function displayPage():void;
		function dispose():void;
	}
}