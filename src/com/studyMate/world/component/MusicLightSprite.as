package com.studyMate.world.component
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import starling.display.Image;
	import starling.display.Sprite;

	public class MusicLightSprite extends Sprite
	{
		private var light:Image;

		public function MusicLightSprite(type:String="light1",x:Number=0,y:Number=0,
										 fromRotation:Number=0,toRotation:Number=0,duration:Number=0,delay:Number=0)
		{
			light = new Image(Assets.getMusicSeriesTexture(type));
			light.pivotX = light.width>>1;
			if(type == "light1")
				light.pivotY = light.height;
			
			light.x = x;
			light.y = y;
			light.rotation = fromRotation;
			addChild(light);
			TweenMax.to(light,duration,{delay:delay,rotation:toRotation,yoyo:true,repeat:int.MAX_VALUE,repeatDelay:0.1});
			
		}

		
		
		override public function dispose():void
		{
			super.dispose();
			TweenLite.killTweensOf(light);
			
			light = null;
			
			removeChildren(0,-1,true);
		}

	}
}