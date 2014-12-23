package com.studyMate.view.component
{
	import flash.utils.Timer;
	
	public class SignTimer extends Timer
	{
		public var arg:*;

		public function SignTimer(delay:Number, repeatCount:int=0, ...a:*)
		{
			super(delay, repeatCount);
			arg = a;
		}
	}
}