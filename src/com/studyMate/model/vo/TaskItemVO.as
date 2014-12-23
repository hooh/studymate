package com.studyMate.model.vo
{
	public final class TaskItemVO
	{
		
		public var rrl:String;
		public var status:String;   
		public var type:String;
		public var bugStype:Object;
		public function TaskItemVO(rrl:String,status:String,type:String=null,bugStype:Object=null)
		{
			this.rrl     = rrl;
			this.status   = status;
			this.type    = type;
			this.bugStype = bugStype;
		}
	}
}