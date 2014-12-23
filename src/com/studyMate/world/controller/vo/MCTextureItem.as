package com.studyMate.world.controller.vo
{
	import flash.display.MovieClip;

	public class MCTextureItem
	{
		public var mc:MovieClip;
		public var prefix:String;
		public var type:uint;
		
		
		public function MCTextureItem(_mc:MovieClip,_prefix:String=null)
		{
			mc=_mc;
			prefix = _prefix;
		}
	}
}