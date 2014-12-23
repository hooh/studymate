package com.mylib.framework.model.vo
{
	public class BeatVO
	{
		public var data:Array;
		
		
		public function BeatVO()
		{
			data = [];
		}
		
		public function addData(_d:String):void{
			data.push(_d);
		}
		
		
	}
}