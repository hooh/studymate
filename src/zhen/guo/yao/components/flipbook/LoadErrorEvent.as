package zhen.guo.yao.components.flipbook 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author yaoguozhen
	 */
	public class LoadErrorEvent extends Event 
	{
		public static const LOAD_ERROR:String = "loadError";
        public var pageURL:String = "";
		
		public function LoadErrorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new LoadErrorEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("LoadErrorEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}