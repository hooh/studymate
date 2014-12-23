package com.mylib.game.controller.vo
{
	import com.studyMate.world.controller.vo.PNGTextureItem;

	public class PackPNGTextureCommandVO
	{
		public var fileName:String;
		public var items:Vector.<PNGTextureItem>;
		
		
		public function PackPNGTextureCommandVO(_fileName:String,_items:Vector.<PNGTextureItem>)
		{
			fileName = _fileName;
			items = _items;
		}
	}
}