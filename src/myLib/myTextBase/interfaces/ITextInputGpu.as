package myLib.myTextBase.interfaces
{
	import starling.events.Event;

	public interface ITextInputGpu extends ITextInput
	{
		function dispatchEvent(event:Event):void;
		function addEventListener(type:String, listener:Function):void;
		function removeEventListener(type:String, listener:Function):void;
		function dispatchEventWith(type:String, bubbles:Boolean=false, data:Object=null):void
		
	}
}