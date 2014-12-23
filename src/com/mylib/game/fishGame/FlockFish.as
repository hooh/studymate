package com.mylib.game.fishGame
{
	import com.mylib.game.fishGame.ai.FlockBoid;
	
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	
	public class FlockFish extends Animal
	{
		public function FlockFish(posX :Number, posY :Number,vx:Number,vy:Number,_range:Rectangle,texture:String)
		{
			var img:Image = new Image(Assets.getUnderWaterTexture(texture));
			img.pivotX = img.width*0.5;
			img.pivotY = img.height*0.5;
			
			super(img, new FlockBoid(posX,posY,vx,vy,_range));
		}
		
		public function get flockBoid():FlockBoid{
			return boid as FlockBoid;
		}
		
	}
}