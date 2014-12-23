package com.studyMate.view
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import starling.display.Image;
	
	public class BusyIndicator extends Image
	{
		public var isWorking:Boolean;
		public var isPlaying:Boolean;
		
		public function BusyIndicator()
		{
			if(Assets.getAtlasTexture("busy")){
				super(Assets.getAtlasTexture("busy"));
				pivotX = width*0.5;
				pivotY = height*0.5;
				isWorking = true;
				touchable = false;
			}
			
		}
		
		public function play():void{
			stop();
			isPlaying = true;
			TweenMax.to(this,1,{rotation:360*Math.PI/180+rotation,repeat:-1,ease:Linear.easeNone});
		}
		
		public function stop():void{
			isPlaying = false;
			TweenLite.killTweensOf(this);
		}
		
		
	}
}