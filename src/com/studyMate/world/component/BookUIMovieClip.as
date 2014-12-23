package com.studyMate.world.component
{
	import flash.display.Sprite;
	
	/**
	 *BookButton类的作用是按钮 并且按钮内部保存参数的
	 * @author Edu
	 * 
	 */	
	public class BookUIMovieClip extends  Sprite
	{
		private var _bookName:String;//书本名字
		private var _bookContent:Object;//书本资源
		
		public function get bookContent():Object
		{
			return _bookContent;
		}

		public function set bookContent(value:Object):void
		{
			_bookContent = value;
		}

		public function get bookName():String
		{
			return _bookName;
		}

		public function set bookName(value:String):void
		{
			_bookName = value;
		}

	}
}