package com.studyMate.world.controller.vo
{
	
	public class RemindPriMessVO 
	{
		public var operation:Boolean;	//true 添加		false 移除
		public var sendId:String;
		
		public function RemindPriMessVO(_operation:Boolean=true,_sendId:String="")
		{
			this.operation = _operation;
			this.sendId = _sendId;
		}
	}
}