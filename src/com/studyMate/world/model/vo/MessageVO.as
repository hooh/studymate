package com.studyMate.world.model.vo
{
	public class MessageVO
	{
		public var msgId:String;
		public var rid:String;
		public var maketime:String;
		public var msgImportant:String;
		public var readFlag:String;
		public var readtime:String;
		public var sid:String;
		public var sopcode:String;
		public var msgType:String;
		public var relaId:String;
		public var dealFlag:String;
		public var relaInfo:String;
		public var msgText:String;
		
		public function MessageVO(msgId:String,  
								  rid:String,
								  sid:String,
								  sopcode:String,
								  msgImportant:String,
								  maketime:String,
								  readFlag:String,
								  readtime:String,
								  msgType:String, 
								  relaId:String, 
								  dealFlag:String,
								  relaInfo:String,
								  msgText:String){
			this.msgId = msgId;
			this.rid = rid;
			this.maketime = maketime;
			this.readFlag = readFlag;
			this.readtime = readtime;
			this.sid = sid;
			this.sopcode = sopcode;
			this.msgType = msgType;
			this.relaId = relaId;
			this.dealFlag = dealFlag;
			this.relaInfo = relaInfo;
			this.msgText = msgText.replace(/\r\n/g,"\n");
			this.msgImportant = msgImportant;
		}
	}
}