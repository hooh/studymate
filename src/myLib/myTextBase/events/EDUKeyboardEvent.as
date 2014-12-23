package myLib.myTextBase.events
{
	import flash.events.Event;
	
	public class EDUKeyboardEvent extends Event
	{
		
		public static const ENTER:String = 'EDUKeyboardEvent_Enter';
		
		public function EDUKeyboardEvent(type:String)
		{
			super(type);
		}
	}
}