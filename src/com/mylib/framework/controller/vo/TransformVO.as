package com.mylib.framework.controller.vo
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class TransformVO
	{
		public var range:Rectangle;
		public var location:Point;
		public var scale:Number;
		public var maxScale:Number;
		public var minScale:Number;
		
		public var radio:ScrollRadio;
		
		public var mask:Rectangle;
		
		
		public function TransformVO(location:Point,range:Rectangle=null,scale:Number=1,minScale:Number=1,maxScale:Number=2,mask:Rectangle=null)
		{
			this.range = range;
			this.location = location;
			this.scale = scale;
			this.minScale = minScale;
			this.maxScale = maxScale;
			this.mask = mask;
		}
	}
}