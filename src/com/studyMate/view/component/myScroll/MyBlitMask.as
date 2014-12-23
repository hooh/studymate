package com.studyMate.view.component.myScroll
{
	import com.greensock.BlitMask;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	public class MyBlitMask extends BlitMask
	{
		public function MyBlitMask(target:DisplayObject, x:Number=0, y:Number=0, width:Number=100, height:Number=100, smoothing:Boolean=false, autoUpdate:Boolean=false, fillColor:uint=0x00000000, wrap:Boolean=false)
		{
			_mouseEvents = [MouseEvent.CLICK, MouseEvent.DOUBLE_CLICK, MouseEvent.MOUSE_DOWN, MouseEvent.MOUSE_MOVE, MouseEvent.MOUSE_OUT, MouseEvent.MOUSE_OVER, MouseEvent.MOUSE_UP, MouseEvent.MOUSE_WHEEL, MouseEvent.ROLL_OUT, MouseEvent.ROLL_OVER];
			super(target, x, y, width, height, smoothing, autoUpdate, fillColor, wrap);
		}
	}
}