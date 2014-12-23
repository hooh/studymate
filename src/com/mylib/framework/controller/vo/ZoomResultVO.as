package com.mylib.framework.controller.vo
{
	import flash.geom.Point;

	public class ZoomResultVO
	{
		public var location:Point;
		public var scale:Number
		
		public function ZoomResultVO(scale:Number,location:Point)
		{
			this.scale = scale;
			this.location = location;
			
			
		}
	}
}