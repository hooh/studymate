package com.mylib.game.fishGame
{
	import com.mylib.game.fishGame.ai.PathBoid;
	
	import starling.display.Image;

	public class LeaderFish extends Animal
	{
		public function LeaderFish(ox:int,oy:int)
		{
			var img:Image = new Image(Assets.getUnderWaterTexture("fish/fish_02"));
			img.pivotX = img.width*0.5;
			img.pivotY = img.height*0.5;
			
			super(img,new PathBoid(ox,oy,20));
		}
		
		public function get pathBoid():PathBoid{
			return boid as PathBoid;
		}

	}
}