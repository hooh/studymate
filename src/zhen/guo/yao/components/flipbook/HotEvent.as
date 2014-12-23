package zhen.guo.yao.components.flipbook 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author yaoguozhen
	 */
	public class HotEvent extends Event 
	{
		public static const PRESSED:String = "pressed";
		public static const RELEASED:String = "released";
		public static const DRAGED:String = "draged";
		
		public var hotName:String;
		public function HotEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new HotEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("HotEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}