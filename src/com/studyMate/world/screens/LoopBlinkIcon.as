package com.studyMate.world.screens
{
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class LoopBlinkIcon extends Sprite
	{
		private var timeLine:TimelineMax;
		
		public function LoopBlinkIcon()
		{
			super();
			timeLine = new TimelineMax();
		}
		
		public function addIcon(name:String, icon:Texture):void{
			var img:Image = getChildByName(name) as Image;
			if(img) return;
				
			img = new Image(icon);
			img.name = name;
			img.alpha = 0; img.touchable = false;
			addChild(img);
			restrTimeLine();
		}
		
		public function removeIcon(name:String):void{
			removeChild(getChildByName(name), true);
			restrTimeLine();
		}
		
		public function clearBlink():void{
			timeLine.clear();
			removeChildren(0, -1, true);
		}
		
		private function restrTimeLine():void{
			timeLine.clear();
			for(var i:int = 0; i < numChildren; i++){
				var img:Image = getChildAt(i) as Image;
				img.alpha = 0;
				timeLine.append(TweenMax.to(img, 1, {alpha:1, yoyo:true, ease:Linear.easeInOut, repeat:1}));
			}
			timeLine.repeat(-1);
			timeLine.play();
		}
	}
}