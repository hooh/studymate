package com.mylib.game.runner
{
	
	
	public class Bucket extends Item
	{
		public function Bucket()
		{
			super(Assets.getRunnerGameTexture("bucket"));
			type = MapItemType.BUCKET;
		}
	}
}