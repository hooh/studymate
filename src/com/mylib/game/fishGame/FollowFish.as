package com.mylib.game.fishGame
{
	import com.mylib.game.fishGame.ai.FollowBoid;
	
	import starling.display.Image;
	
	public class FollowFish extends Animal
	{
		public function FollowFish(ox:int,oy:int)
		{
			var img:Image = new Image(Assets.getUnderWaterTexture("fish/fish_01"));
			img.pivotX = img.width*0.5;
			img.pivotY = img.height*0.5;
			super(img, new FollowBoid(ox,oy,20));
		}
		
		public function get followBoid():FollowBoid{
			return boid as FollowBoid;
		}
		
		
	}
}