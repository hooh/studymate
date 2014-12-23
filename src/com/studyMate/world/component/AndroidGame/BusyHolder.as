package com.studyMate.world.component.AndroidGame
{
	import com.studyMate.global.Global;
	
	import flash.geom.Rectangle;
	
	import feathers.controls.ProgressBar;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class BusyHolder extends Sprite
	{
		
		private var proBar:ProgressBar;
		
		public function BusyHolder()
		{
			
			var quad:Quad = new Quad(Global.stageWidth, Global.stageHeight, 0);
//			var quad:Quad = new Quad(Global.stageWidth, 500, 0);
			quad.alpha = 0.3;
			addChild(quad);
			
			
			addEventListener(Event.ADDED_TO_STAGE, initProBar);
			
		}
		
		private function initProBar(e:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, initProBar);
			Starling.current.stage.touchable = false;
			
			proBar = new ProgressBar();
			proBar.minimum = 0;
			proBar.maximum = 1;
			proBar.value = 0;
			proBar.width = 380;
			addChild(proBar);
			proBar.x = (Global.stageWidth-proBar.width)>>1;
			proBar.y = Global.stageHeight>>1;
			
			
			
			//progressBar换肤
			var bgTexture:Scale9Textures = new Scale9Textures(Assets.getAtlasTexture("item/progressBg"),new Rectangle(3,3,745,10));
			var fillTexture:Scale9Textures = new Scale9Textures(Assets.getAtlasTexture("item/progressFill"),new Rectangle(4,3,1,10));
			var backgroundSkin:Scale9Image = new Scale9Image(bgTexture);
			backgroundSkin.width = 380;
			proBar.backgroundSkin = backgroundSkin;
			var fillSkin:Scale9Image = new Scale9Image(fillTexture);
			fillSkin.width = 9;
			proBar.fillSkin = fillSkin;
		}
		
		public function updateProBar(_value:Number):void{
			
			proBar.value = _value;
			
		}
		
		override public function dispose():void
		{
			super.dispose();
			Starling.current.stage.touchable = true;
			
			removeChildren(0,-1,true);
			
			removeEventListener(Event.ADDED_TO_STAGE, initProBar);
		}
		
		
		
	}
}