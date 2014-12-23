package com.mylib.game.fightGame
{
	import com.greensock.TweenLite;
	
	import flash.geom.Rectangle;
	
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class BloodProgressBar extends Sprite
	{
		
		private var fillSkin:Scale9Image;
		private var nowBlood:Scale9Image;
		
		private var nowValue:Number;
		
		public function BloodProgressBar()
		{
			
			addEventListener(Event.ADDED_TO_STAGE, initProBar);
		}
		
		
		
		private function initProBar(e:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, initProBar);

			
			
			var bgTexture:Scale9Textures = new Scale9Textures(Assets.getFightGameTexture("bloodProBg"),new Rectangle(17,2,87,37));
			var bg:Scale9Image = new Scale9Image(bgTexture);
			bg.width = 120;
			addChild(bg);
			
			var fillTexture:Scale9Textures = new Scale9Textures(Assets.getFightGameTexture("bloodProFillGreen"),new Rectangle(8,0,2,22));
			fillSkin = new Scale9Image(fillTexture);
			fillSkin.useSeparateBatch = false;
			fillSkin.x = 5;
			fillSkin.y = 10;
			fillSkin.width = 107;
			addChild(fillSkin);
			
			
			
			
			var nowBloodTexture:Scale9Textures = new Scale9Textures(Assets.getFightGameTexture("bloodProFillRed"),new Rectangle(8,0,2,22));
			nowBlood = new Scale9Image(nowBloodTexture);
			nowBlood.useSeparateBatch = false;
			nowBlood.x = 5;
			nowBlood.y = 10;
			nowBlood.width = 107;
			addChild(nowBlood);
			
			nowValue = 6;

			
			
		}
		
		public function updateBar(_nowVal:Number,_lrVal:Number=0):void{

			updateGreen(_lrVal);
			
			//更新红血条
			updateRed(_nowVal);
			
		}
		
		private function updateGreen(_value:Number):void{
			TweenLite.killTweensOf(fillSkin);
			
			var _width:Number = (_value/6)*107;
			TweenLite.to(fillSkin,0.3,{width:_width});
		}
		
		private function updateRed(_value:Number):void{
			TweenLite.killTweensOf(nowBlood);
			
			var _width:Number = (_value/6)*107;
			TweenLite.to(nowBlood,0.3,{width:_width});
		}
		
		
		
		override public function dispose():void
		{
			super.dispose();
			
			TweenLite.killTweensOf(fillSkin);
			TweenLite.killTweensOf(nowBlood);
			
			removeChildren(0,-1,true);
			
			removeEventListener(Event.ADDED_TO_STAGE, initProBar);
		}
		
	}
}