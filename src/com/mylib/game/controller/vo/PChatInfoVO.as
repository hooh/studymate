package com.mylib.game.controller.vo
{
	

	public class PChatInfoVO
	{
		public var id:int;
		
		
		public var sendId:String;
		public var sendName:String;
		
		
		public var recId:String;
		public var recName:String;
		
		public var time:String;
		public var content:String;
		
		/**
		 *	text:文本
		 * 	voice:语音
		 */		
		public var type:String;
		
		
		public function PChatInfoVO(_id:int,_sendId:String,_sendName:String,
									_recId:String,_recName:String,
									_time:String,_type:String,_content:String)
		{
			id = _id;
			
			
			sendId = _sendId;
			sendName = _sendName;
			
			
			recId = _recId;
			recName = _recName;
			
			
			time = _time;
			content = _content;
			
			type= _type;
			
		}
	}
}