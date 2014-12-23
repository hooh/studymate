package com.mylib.game.beetleGame
{
	import com.mylib.game.fishGame.Animal;
	import com.mylib.game.fishGame.ai.WanderBoid;
	
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import starling.display.Image;
	
	public class WanderBeetle extends Animal
	{
		public function WanderBeetle(posX:Number, posY:Number,range:Rectangle)
		{
			var img:Image = new Image(Assets.getEgAtlasTexture("word/bug"));//问号
			img.pivotX = img.width*0.5;
			img.pivotY = img.height*0.5;
			
			var wander:WanderBoid = new WanderBoid(posX,posY,10,range);
			wander.maxVelocity = 0.1;
			wander.maxForce = 0.1;
			wander.circleDistance = 0.2;
			wander.circleRadius = 0.4;
			wander.angleChange = 0.1
			wander.velocity = new Vector3D(0.1,0.05);
//			super(img, new WanderBeetleBoid(posX,posY,1,range));.
			
			super(img, wander);
		}
		
		override public function render():void
		{
			super.render();
		}
		
		public function dispose():void{
			this.stop();
			this.view.dispose();
		}
	}
}