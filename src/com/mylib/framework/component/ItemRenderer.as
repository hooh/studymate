package com.mylib.framework.component
{
	import com.mylib.api.IItemRender;
	
	import starling.display.Sprite;
	
	public class ItemRenderer extends Sprite implements IItemRender
	{
		public function ItemRenderer()
		{
			super();
		}
		
		public function set data(_d:*):void
		{
		}
		
		public function get data():*
		{
			return null;
		}
		
		public function reset():void
		{
		}
	}
}