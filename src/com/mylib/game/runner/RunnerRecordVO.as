package com.mylib.game.runner
{
	public class RunnerRecordVO
	{
		public var operId:uint;
		public var name:String;
		public var mapId:uint;
		public var distance:uint;
		public var eqList:String
		public var data:String;
		
		public function RunnerRecordVO(operId:uint,name:String,mapId:uint,distance:uint,eqList:String,data:String)
		{
			this.operId = operId;
			this.mapId = mapId;
			this.distance = distance;
			this.data = data;
			this.eqList =  eqList;
			this.name  = name;
			
			
		}
	}
}