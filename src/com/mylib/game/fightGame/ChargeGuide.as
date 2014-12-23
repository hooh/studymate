package com.mylib.game.fightGame
{
	import com.greensock.TimelineLite;
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class ChargeGuide extends Sprite
	{
		private var originalFinger:Image;
		private var moveFinger:Image;
		private var dir:Image;
		private var wait:Image;
		private var timeline:TimelineMax;
		
		public function ChargeGuide()
		{
			
			dir =  new Image(Assets.getFightGameTexture("rightdirGuide"));
			addChild(dir);
			dir.x = 20;
			dir.alpha = 0.5;
			originalFinger =  new Image(Assets.getFightGameTexture("Tap"));
			addChild(originalFinger);
			originalFinger.alpha = 0.3;
			
			moveFinger =  new Image(Assets.getFightGameTexture("Tap"));
			addChild(moveFinger);
			
			wait =  new Image(Assets.getFightGameTexture("wait"));
			addChild(wait);
			wait.x = 260;
			wait.y = -20;
			wait.alpha = 0;
			timeline = new TimelineMax;
			timeline.repeat(999);
			timeline.repeatDelay(2);
			timeline.append(TweenMax.to(moveFinger,1.5,{x:270}));
			timeline.append(TweenMax.to(moveFinger,0.5,{rotation:-Math.PI/180*20}));
			timeline.append(TweenMax.to(wait,0.2,{alpha:1}));
			
		}
		
		public function play():void{
			moveFinger.x = 0;
			timeline.play();
		}
		
		public function stop():void{
			timeline.pause();
		}
		
		
	}
}