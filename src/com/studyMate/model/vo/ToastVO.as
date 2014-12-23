package com.studyMate.model.vo
{
	public final class ToastVO
	{
		public var msg:String="";
		public var position:String;
		public var time:Number;
		
		/**
		 * 
		 * @param msg			信息
		 * @param time			显示时长
		 * 
		 * @param position
		 * 
		 */		
		public function ToastVO(msg:String="",time:Number=1,position:String="m")
		{
			this.msg = msg;
			this.position = position;
			this.time = time;
		}
	}
}