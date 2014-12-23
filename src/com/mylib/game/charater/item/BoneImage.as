package com.mylib.game.charater.item
{
	import starling.extensions.PixelImageTouch;
	import starling.textures.Texture;
	
	public class BoneImage extends PixelImageTouch
	{
		
		public var id:String;
		
		public var boneName:String;
		public var localX:Number;
		public var localY:Number;
		public var order:int;
		public var date:String;
		
		
		public function BoneImage(texture:Texture)
		{
			super(texture);
		}
	}
}