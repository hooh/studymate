package com.studyMate.module.engLearn.ui
{
	import flash.geom.Rectangle;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class SpokenSea extends Sprite implements IAnimatable
	{
		private var sp:Sprite ;
		private var sp1:Sprite ;
		private var rect:Rectangle;
		private var rect1:Rectangle;
		public function SpokenSea()
		{			
			var sea:Image = new Image(Assets.getEgLearnSpokenTexture('spokenSea'));
			sea.y = 586;
			this.addChild(sea);
			
			
			sea = new Image(Assets.getEgLearnSpokenTexture('spokenSea'));
			sea.y = 3;
			sp =new Sprite();
			sp.addChild(sea);
			rect = new Rectangle(0,287,1280,15);
			sp.clipRect =rect;
			sp.y = 586;
			this.addChild(sp);
			
			sea = new Image(Assets.getEgLearnSpokenTexture('spokenSea'));
			sea.y = -2;
			sp1 =new Sprite();
			sp1.addChild(sea);
			rect1 = new Rectangle(0,100,1280,10);
			sp1.clipRect =rect1;
			sp1.y = 586;
			this.addChild(sp1);
			
			
			Starling.juggler.add(this);
		}
		
		override public function dispose():void
		{
			Starling.juggler.remove(this);
			super.dispose();
		}
		
		private var recth:Number;
		public function advanceTime(time:Number):void
		{
			rect.y -=1;
			rect1.y -= 0.8;
//			rect.height -=  2;
//			rect1.height -= 1;
//			rect.height -=0.5
			sp.clipRect =rect;
			if(rect.y<0){
				rect.y = 287;
//				rect.height = 15;
			}
					
//			rect1.height -= 0.6
			sp1.clipRect = rect1;
			if(rect1.y<0){
				rect1.y = 290;
//				rect1.height = 10;
			}
//			trace('jinru 动画');
			
		}
	}
}