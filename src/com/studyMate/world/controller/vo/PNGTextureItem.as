package com.studyMate.world.controller.vo
{
	import flash.display.DisplayObject;

	public class PNGTextureItem
	{
		public var displayList:Vector.<DisplayObject>;
		public var prefix:String;
		
		
		public function PNGTextureItem(_display:Vector.<DisplayObject>,_prefix:String=null)
		{
			displayList=_display;
			prefix = _prefix;
		}
	}
}