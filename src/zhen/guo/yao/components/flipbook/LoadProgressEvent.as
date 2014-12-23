package zhen.guo.yao.components.flipbook 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author yaoguozhen
	 */
	public class LoadProgressEvent extends Event 
	{
		public var per:Number;
		public static const LOAD_PROGRESS:String = "loadProgress";
		
		public function LoadProgressEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new LoadProgressEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("LoadProgress", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}