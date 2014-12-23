package com.studyMate.world.component.weixin.interfaces
{
	import starling.display.DisplayObject;
	
	public interface ITryListenView 
	{
		function get pauseDisplayObject():DisplayObject
		function get playDisplayObject():DisplayObject;
		function get sureDisplayObject():DisplayObject;
		function get cancelDisplayObject():DisplayObject;
		
	}
}