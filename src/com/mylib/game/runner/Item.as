package com.mylib.game.runner
{
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class Item extends Image
	{
		public var type:uint;
		public var offsetTop:int;
		
		public function Item(texture:Texture)
		{
			super(texture);
			this.pivotX = 0
			this.pivotY = height;
		}
	}
}