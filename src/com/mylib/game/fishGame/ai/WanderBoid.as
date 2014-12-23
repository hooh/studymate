package com.mylib.game.fishGame.ai
{
	import flash.geom.Rectangle;

	public class WanderBoid extends FollowBoid
	{
		public var range:Rectangle;
		
		public function WanderBoid(posX:Number, posY:Number, totalMass:Number,range:Rectangle)
		{
			this.range = range;
			super(posX, posY, totalMass);
		}
		
		
		override protected function customBehavior():void
		{
			steering.incrementBy(wander());
			
			if (position.x >= range.right ) {
				position.x = range.right;
				velocity.x*=-1;
			}else if(position.x < range.left){
				position.x = range.left;
				velocity.x*=-1;
			}
			
			if(position.y >= range.bottom){
				position.y = range.bottom;
				velocity.y*=-1;
				
			}else if(position.y < range.top){
				position.y = range.top;
				velocity.y*=-1;
			}
			
			
		}
		
		
	}
}