package com.studyMate.model.vo
{
	public final class AppleVO
	{
		public var x:Number;
		public var y:Number;
		public var rotation:Number;
		
		public function AppleVO(arr:Array)
		{
			x = arr[1];
			y = arr[2];
			rotation = arr[3];
		}
	}
}