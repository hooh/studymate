package com.mylib.game.fishGame
{
	import com.mylib.game.fishGame.ai.WanderBoid;
	
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	
	public class WanderFish1 extends Animal
	{
		public function WanderFish1(posX:Number, posY:Number,range:Rectangle)
		{
			var img:Image = new Image(Assets.getUnderWaterTexture("fish/fish_05"));
			img.pivotX = img.width*0.5;
			img.pivotY = img.height*0.5;
			
			
			super(img, new WanderBoid(posX,posY,50,range));
		}
		
		override public function render():void
		{
			super.render();
		}
		
	}
}