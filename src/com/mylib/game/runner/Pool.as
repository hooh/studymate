package com.mylib.game.runner
{
	
	public class Pool extends Item
	{
		public function Pool()
		{
			super(Assets.getRunnerGameTexture("pool"));
			type = MapItemType.POOL;
			pivotY -=20;
			this.offsetTop +=50;
		}
	}
}