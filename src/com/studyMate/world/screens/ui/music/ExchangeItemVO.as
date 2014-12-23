package com.studyMate.world.screens.ui.music
{
	

	public class ExchangeItemVO
	{
		public var isSelected:Boolean;
		public var instid:String ;
		public var Name:String;//名称
		public var size:String;//视频大小
		public var totalTime:String="";//播放时长		
		public var grid:String;		
		public var authorStr:String="";
		
		public function ExchangeItemVO(arr:Array)
		{
			instid = arr[1];
			Name = arr[4];	
			size = arr[11];
			totalTime = arr[16];
			authorStr = String(arr[17]);
		}
	}
}