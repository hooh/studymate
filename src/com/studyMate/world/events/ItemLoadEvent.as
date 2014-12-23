package com.studyMate.world.events
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class ItemLoadEvent extends Event
	{
		//自定义事件类型,加载完成
		public static const ITEM_LOAD_COMPLETE:String = "itemLoadComplete";
		//自定义事件类型，加载失败或者加载为空
		public static const ITEM_LOAD_FAILD:String = "itemLoadFaild";
		//自定义事件参数
		private var _Item:DisplayObject;//对象
		
		public function ItemLoadEvent(type:String)
		{
			super(type);
		}
		
		public function set Item(_displayobject:DisplayObject):void{
			_Item = _displayobject;
		}
		
		public function get Item():DisplayObject{
			return _Item;
		}
	}
}