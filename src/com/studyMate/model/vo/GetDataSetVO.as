package com.studyMate.model.vo
{
	public final class GetDataSetVO
	{
		public var completeNotice:String;
		public var parameters:Array;
		public var cmd:String;
		public var dataIdx:int;
		public var encode:String;
		
		
		public function GetDataSetVO(cmd:String,parameters:Array,completeNotice:String,dataIdx:int,encode:String="byte")
		{
			this.cmd = cmd;
			this.parameters = parameters;
			this.completeNotice = completeNotice;
			this.dataIdx = dataIdx;
			this.encode=encode;
		}
	}
}