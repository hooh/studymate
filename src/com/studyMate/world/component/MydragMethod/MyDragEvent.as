package com.studyMate.world.component.MydragMethod
{
	import flash.events.Event;
	
	public class MyDragEvent extends Event
	{
		public static const START_EFFECT:String = "KeyBoardStartDrag";//开始拖动特效
		
		public static const END_EFFECT:String = "KeyBoardStopDrag";//结束拖动特效
		
		public var localX:Number;//本地坐标
	
		public var localY:Number;//本地坐标
		
		public function MyDragEvent(type:String,_localX:Number=0,_LocalY:Number=0)
		{
			localX = _localX;
			localY = _LocalY
			super(type);
		}
	}
}