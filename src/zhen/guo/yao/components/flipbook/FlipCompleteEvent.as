package zhen.guo.yao.components.flipbook 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author yaoguozhen
	 */
	public class FlipCompleteEvent extends Event 
	{
		public static const FLIP_COMPLETE:String = "flipComplete";
		
		public var flipType:String;
		
		public function FlipCompleteEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new FlipCompleteEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("FlipCompleteEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}