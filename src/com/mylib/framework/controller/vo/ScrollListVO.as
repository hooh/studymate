package com.mylib.framework.controller.vo
{
	import flash.geom.Rectangle;
	

	public class ScrollListVO
	{
		public var itemRender:Class;
		public var gap:int;
		public var data:Array;
		public var range:Rectangle;
		
		
		public function ScrollListVO(itemRender:Class,data:Array,gap:int =4,range:Rectangle=null)
		{
			this.itemRender = itemRender;
			this.data = data;
			this.gap = gap;
			this.range = range;
		}
	}
}