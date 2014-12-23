package com.mylib.game.card
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class CardTypeSelector extends starling.display.Sprite
	{
		private var typesBg:Image;
		private var frame:Image;
		
		public static const FRAME_SIZE:int=30;
		
		private var _type:int;
		
		public static var bgTexture:Texture;
		public static var frameTexture:Texture;
		
		
		public function CardTypeSelector(bgTexture:Texture,frameTexture:Texture)
		{
			super();
			typesBg = new Image(bgTexture);
			addChild(typesBg);
			
			frame = new Image(frameTexture);
			addChild(frame);
			frame.touchable = false;
			_type = 0;
			
			addEventListener(TouchEvent.TOUCH,touchHandle);
		}
		
		private function touchHandle(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.target as DisplayObject,TouchPhase.ENDED);
			if(touch){
				var p:Point = touch.getLocation(event.target as DisplayObject);
				type = p.x/FRAME_SIZE+1;
			}
		}
		
		public function set type(_i:int):void{
			frame.x = (_i-1)*FRAME_SIZE;
			_type = _i;
		}
		
		public function get type():int{
			return _type;
		}
		
		
		public static function getFrameTexture():Texture{
			var sp:flash.display.Sprite = new flash.display.Sprite;
			
			sp.graphics.lineStyle(4,0);
			sp.graphics.drawRect(0,0,FRAME_SIZE,FRAME_SIZE);
			
			var bmd:BitmapData = new BitmapData(FRAME_SIZE,FRAME_SIZE,true,0);
			bmd.draw(sp);
			
			var result:Texture = Texture.fromBitmapData(bmd);
			bmd.dispose();
			
			return result;
			
		}
		
		public static function getHorizontalTexture():Texture{
			
			var sp:flash.display.Sprite = new flash.display.Sprite;
			
			for (var i:int = 0; i < HeroAttribute.cardColor.length; i++) 
			{
				sp.graphics.beginFill(HeroAttribute.cardColor[i]);
				sp.graphics.drawRect(i*FRAME_SIZE,0,FRAME_SIZE,FRAME_SIZE);
				sp.graphics.endFill();
			}
			
			var bmd:BitmapData = new BitmapData(HeroAttribute.cardColor.length*FRAME_SIZE,FRAME_SIZE);
			bmd.draw(sp);
			var result:Texture = Texture.fromBitmapData(bmd);
			bmd.dispose();
			
			return result;
		}
		
		
	}
}