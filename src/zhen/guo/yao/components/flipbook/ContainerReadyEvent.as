package zhen.guo.yao.components.flipbook 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author yaoguozhen
	 */
	public class ContainerReadyEvent extends Event 
	{
		public static const READY:String = "ready";
		public static const NEXT:String = "next";
		public static const PREV:String = "prev";
		public static const COVER:String = "cover";
		internal static const JUMP_NEXT:String = "jump_next";
		internal static const JUMP_PREV:String = "jump_prev";
		

		public var containerType:String;
		
		public function ContainerReadyEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new ContainerReadyEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ContainerReadyEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}