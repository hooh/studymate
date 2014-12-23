package com.studyMate.world.screens.ui
{
	import com.mylib.game.charater.ICharater;
	
	import starling.animation.IAnimatable;
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class CharaterInterativeObject implements ICharaterInteractiveObject,IAnimatable
	{
		protected var _charater:ICharater;
		protected var _display:DisplayObject;
		public var isBusy:Boolean;
		
		public function CharaterInterativeObject(displayObj:DisplayObject,charater:ICharater=null)
		{
			_charater = charater;
			display = displayObj;
			
		}
		
		protected function touchHandle(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.target as DisplayObject,TouchPhase.ENDED);
			
			if(touch){
				takeAction(charater);
			}
			
			
			
		}
		
		public function advanceTime(time:Number):void
		{
			// TODO Auto Generated method stub
			
		}
		
		
		public function get display():DisplayObject
		{
			return _display;
		}
		
		public function set display(d:DisplayObject):void
		{
			if(_display){
				_display.removeEventListener(TouchEvent.TOUCH,touchHandle);
			}
			
			
			_display = d;
			_display.addEventListener(TouchEvent.TOUCH,touchHandle);
		}
		
		
		public function takeAction(charater:ICharater):void
		{
			
			
		}
		
		public function stopAction(charater:ICharater):void
		{
			// TODO Auto Generated method stub
			
		}
		
		
		public function dispose():void
		{
			if(_display){
				_display.removeEventListener(TouchEvent.TOUCH,touchHandle);
			}
			_display = null;
			_charater = null;
		}
		
		
		public function registerCharater(charater:ICharater):void
		{
			_charater = charater;
		}
		
		public function get charater():ICharater
		{
			// TODO Auto Generated method stub
			return _charater;
		}
		
		
	}
}