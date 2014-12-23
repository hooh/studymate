package com.mylib.game.runner
{
	
	
	public class DeadTree extends Item
	{
		public function DeadTree()
		{
			super(Assets.getRunnerGameTexture("deadTree"));
			type = MapItemType.DEAD_TREE;
			offsetTop +=40;
		}
	}
}