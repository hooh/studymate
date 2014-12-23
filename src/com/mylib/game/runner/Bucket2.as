package com.mylib.game.runner
{
	import starling.textures.Texture;
	
	public class Bucket2 extends Item
	{
		public function Bucket2()
		{
			super(Assets.getRunnerGameTexture("bucket2"));
			type = MapItemType.BUCKET2;
		}
	}
}