package com.mylib.game.drawing
{
	import flash.display.IGraphicsData;

	public class DrawingDataVO
	{
		public var operID:int;
		public var name:String;
		public var picId:String;
		public var picData:Vector.<IGraphicsData>;
		public var time:String;
		
		
		
		public function DrawingDataVO(_operID:int,_name:String,_time:String,_picId:String,_picData:Vector.<IGraphicsData>)
		{
			this.operID = _operID
			this.name = _name;
			this.picId = _picId;
			this.picData = _picData;
			this.time = _time;
			
			
			
		}
	}
}