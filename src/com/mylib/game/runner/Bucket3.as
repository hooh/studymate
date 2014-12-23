package com.mylib.game.runner
{
	import starling.textures.Texture;
	
	public class Bucket3 extends Item
	{
		public function Bucket3()
		{
			super(Assets.getRunnerGameTexture("bucket3"));
			type = MapItemType.BUCKET3;
		}
	}
}