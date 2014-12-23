package com.mylib.game.controller.vo
{
	import com.studyMate.world.controller.vo.MCTextureItem;

	public class PackMCTextureCommandVO
	{
		public var fileName:String;
		public var items:Vector.<MCTextureItem>;
		
		
		public function PackMCTextureCommandVO(_fileName:String,_items:Vector.<MCTextureItem>)
		{
			fileName = _fileName;
			items = _items;
		}
	}
}