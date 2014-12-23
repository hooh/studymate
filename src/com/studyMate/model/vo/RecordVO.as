package com.studyMate.model.vo
{
	public final class RecordVO
	{
		
		public var cmd:String;
		public var mark:String;
		public var num:int;
		
		public function RecordVO(cmd:String,mark:String,num:int)
		{
			this.cmd = cmd;
			this.mark = mark;
			this.num = num;
		}
	}
}