package com.studyMate.world.controller.vo
{
	
	public class DisplayChatViewCommandVO 
	{
		public var visible:Boolean;
		public var chanel:String;
		public var friId:String;
		
		public function DisplayChatViewCommandVO(_visible:Boolean=true,_chanel:String="",_friId:String="")
		{
			this.visible = _visible;
			this.chanel = _chanel;
			this.friId = _friId;
		}
	}
}