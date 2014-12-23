package com.studyMate.world.controller.vo
{
	
	public class EnableScreenCommandVO 
	{
		public var exceptions:Array;
		public var enable:Boolean;
		public function EnableScreenCommandVO(enable:Boolean,...exceptions)
		{
			this.exceptions = exceptions;
			this.enable = enable;
		}
	}
}