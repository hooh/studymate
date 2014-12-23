package com.mylib.game.controller.vo
{
	

	public class UserLocInfoVO
	{
		public var id:String;
		public var x:Number;
		public var y:Number;
		
		public function UserLocInfoVO(_id:String,_x:Number,_y:Number)
		{
			id = _id;
			x = _x;
			y = _y;
			
		}
	}
}