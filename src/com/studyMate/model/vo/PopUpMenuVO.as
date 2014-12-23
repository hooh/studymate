package com.studyMate.model.vo
{
	import flash.display.DisplayObjectContainer;

	public class PopUpMenuVO
	{
		public var holder:DisplayObjectContainer;
		public var word:String;
		public var x:Number;
		public var y:Number;
		public function PopUpMenuVO(_holder:DisplayObjectContainer,_word:String="",_x:Number=0,_y:Number=0)
		{
			this.x = _x;
			this.y = _y;
			this.word = _word;
			this.holder = _holder;
		}
	}
}