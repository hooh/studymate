package myLib.myTextBase.Keyboard
{
	import flash.events.Event;
	
	internal class MyDragEvent extends Event
	{
		public static const START_EFFECT:String = "KeyBoardStartDrag";//开始拖动特效
		
		public static const END_EFFECT:String = "KeyBoardStopDrag";//结束拖动特效
		
		public function MyDragEvent(type:String)
		{
			super(type);
		}
	}
}