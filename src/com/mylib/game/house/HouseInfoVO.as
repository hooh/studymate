package com.mylib.game.house
{
	import starling.display.Image;

	public class HouseInfoVO
	{
		public var id:String;
		public var relatId:String;
		public var name:String;
		public var data:String;
		public var type:String;
		public var x:Number;
		public var y:Number;
		public var width:Number = 0;
		public var height:Number = 0;
		public var maxNumber:int;
		public var price:Number = 0;
		
		
		public var status:String = "n";
		
		
		public var dealOperId:String;
		public var dealTime:String;
		
		public var buildTime:Number=-1;
		public var createTime:Number=0;
		public var finishTime:Number=0;

		public var houseImg:Image;
		public var isServerHad:Boolean;
		public var isModify:Boolean;
		
		public function HouseInfoVO(_data:String="",_x:Number=0,_y:Number=0)
		{
			data = _data;
			x = _x;
			y = _y;
			
			
		}
	}
}