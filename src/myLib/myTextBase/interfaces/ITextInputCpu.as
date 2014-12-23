package myLib.myTextBase.interfaces
{
	import flash.events.Event;
	
	public interface ITextInputCpu extends ITextInput
	{
			
		function dispatchEvent(event:Event):Boolean;
		function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void;
		function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
	}
}