package com.mylib.game.charater.logic.ai
{
	import starling.events.Event;
	
	public class EnterFightEvent extends Event
	{
		public static const READY:String = "ready";
		
		public function EnterFightEvent(type:String, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles, data);
		}
	}
}