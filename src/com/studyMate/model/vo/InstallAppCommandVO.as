package com.studyMate.model.vo
{
	public class InstallAppCommandVO
	{
		public var type:String;
		public var path:String;
		
		public var completeNotice:String;
		public var completeNoticeParameters:Object;
		
		public function InstallAppCommandVO(_type:String="A",_path:String="",_completeNotice:String="",_completeNoticeParameters:Object=null)
		{
			
			this.type = _type;
			this.path = _path;
			
			this.completeNotice = _completeNotice;
			this.completeNoticeParameters = _completeNoticeParameters;
		}
	}
}