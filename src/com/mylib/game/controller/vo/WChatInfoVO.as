package com.mylib.game.controller.vo
{
	

	public class WChatInfoVO
	{
		public var id:int;
		public var sendId:String;
		public var name:String;
		public var content:String;
		public var time:String;
		
		public function WChatInfoVO(_id:int,_sendId:String,_name:String,_content:String,_time:String)
		{
			id = _id;
			sendId = _sendId;
			name = _name;
			content = _content;
			time = _time;
			
		}
	}
}