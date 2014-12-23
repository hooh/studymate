package com.mylib.game.card
{
	public class PlayerTaskRawVO
	{
		public var id:String;
		public var taskId:String;
		public var beginTime:uint;
		public var endTime:uint;
		
		public function PlayerTaskRawVO(id:String,taskId:String,begtime:String,endtime:String)
		{
			this.id = id;
			this.taskId = taskId;
			this.beginTime = parseInt(begtime);
			this.endTime = parseInt(endtime);
			
			
		}
	}
}