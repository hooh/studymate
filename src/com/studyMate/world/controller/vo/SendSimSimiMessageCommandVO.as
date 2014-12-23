package com.studyMate.world.controller.vo
{
	public class SendSimSimiMessageCommandVO
	{
		public var msg:String;
		public var lc:String;
		
		
		public function SendSimSimiMessageCommandVO(msg:String,lc:String="ch")
		{
			this.msg = msg;
			this.lc = lc;
		}
	}
}