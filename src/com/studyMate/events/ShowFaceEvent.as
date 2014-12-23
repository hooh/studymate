package com.studyMate.events
{
	import com.studyMate.view.component.BookUIMovieClip;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**
	 *显示封面的类 
	 * @author Edu
	 * 
	 */	
	public class ShowFaceEvent extends Event
	{
		//显示封面
		public static const SHOW_FACE:String = "showFace";
		
		private var _Item:BookUIMovieClip;//对象
		
		public function ShowFaceEvent(type:String)
		{
			super(type);
		}
		
		
		public function get Item():BookUIMovieClip
		{
			return _Item;
		}

		public function set Item(value:BookUIMovieClip):void
		{
			_Item = value;
		}

	}
}