package com.mylib.game.runner
{
	import starling.textures.Texture;
	
	public class Rock extends Item
	{
		public function Rock()
		{
			super(Assets.getRunnerGameTexture("rock"));
			type = MapItemType.ROCK;
		}
	}
}