package com.studyMate.model.vo
{
	public class JumpUriVO
	{
		public var scheme:String;
		public var target:String;
		
		
		public function JumpUriVO(scheme:String,target:String)
		{
			this.scheme = scheme;
			this.target = target;
		}
	}
}