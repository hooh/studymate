package com.studyMate.model.vo
{
	public class SysNoticeVO
	{
		
		
		public var id:int = 0;	//广播标识
		public var level:String = "";	//广播控制
		public var text:String = "";;	//广播文本内容
		
		
		public var priority:int = 0;	//广播控制-优先级
		public var times:int = 0;	//广播控制 -播放次数
		
		public var delay:Number = 0;	//广播控制-播放间隔
		public var delayCount:Number = 0;
		
		public var isHad:Boolean = false;	//用于超时删除
		
		public function SysNoticeVO()
		{
		}
	}
}