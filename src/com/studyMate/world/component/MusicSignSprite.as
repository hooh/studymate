package com.studyMate.world.component
{
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.filters.GlowFilter;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class MusicSignSprite extends Sprite
	{
		public function MusicSignSprite(title:String)
		{
			var bg:Image = new Image(Assets.getMusicSeriesTexture("signBg"));
			addChild(bg);
			
			var titleTF:TextField = new TextField(155,59,title,"HuaKanT",33,0xffffff,true);
			titleTF.nativeFilters = [new GlowFilter(0xff0064,0.75,5,5,2)];
			titleTF.hAlign = HAlign.CENTER;
			titleTF.vAlign = VAlign.CENTER;
			addChild(titleTF);

			
			var i:int;
			var light:Sprite;
			for(i=0;i<5;i++){
				light = creatSetlight(0.2*i);
				light.x = 20+i*25;
				light.y = -5;
				addChild(light);
			}
			
			for(i=0;i<2;i++){
				light = creatSetlight(0.8+0.2*i);
				light.x = 135;
				light.y = 15*(i+1);
				addChild(light);
			}
			
			for(i=0;i<5;i++){
				light = creatSetlight(2.2-0.2*i);
				light.x = 20+i*25;
				light.y = 45;
				addChild(light);
			}
			
			for(i=0;i<2;i++){
				light = creatSetlight(2.4+0.2*i);
				light.x = 7;
				light.y = 15*(2-i);
				addChild(light);
			}
			
		}
		
		private var timelineList:Vector.<TimelineMax> = new Vector.<TimelineMax>;
		private function creatSetlight(delay:Number=0):Sprite{
			var holder:Sprite = new Sprite;
			var timeLine:TimelineMax = new TimelineMax;
			for(var i:int = 1; i < 4; i++){
				var img:Image = new Image(Assets.getMusicSeriesTexture("signLight"+i));
				img.alpha = 0;
				holder.addChild(img);
				timeLine.append(TweenMax.to(img, 0.2, {alpha:1, yoyo:true, ease:Linear.easeNone, repeat:1,repeatDelay:0.1}));
			}
			timeLine.repeat(-1);
			timeLine.play();
			timeLine.delay(delay);
			timelineList.push(timeLine);
			
			return holder;
		}
		
		
		override public function dispose():void
		{
			super.dispose();
			
			for(var i:int=0;i<timelineList.length;i++)
				timelineList[i].clear();
			timelineList.length = 0;
			timelineList = null;
			removeChildren(0,-1,true);
		}

	}
}