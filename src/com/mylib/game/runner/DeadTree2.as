package com.mylib.game.runner
{
	import starling.textures.Texture;
	
	public class DeadTree2 extends Item
	{
		public function DeadTree2()
		{
			super(Assets.getRunnerGameTexture("deadTree2"));
			type = MapItemType.DEAD_TREE2;
			offsetTop +=40;
		}
	}
}