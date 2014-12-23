package com.mylib.game.fightGame
{
	import com.greensock.TweenLite;
	
	import flash.geom.Rectangle;
	
	import feathers.controls.Button;
	import feathers.controls.ProgressBar;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class FightCollectEnergy extends Sprite
	{
		
		private var nowValue:Number;
		
		public function FightCollectEnergy()
		{
			
			addEventListener(Event.ADDED_TO_STAGE, initProBar);
		}
		
		
		private var list:Vector.<Button> = new Vector.<Button>;
		private function initProBar(e:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, initProBar);
			
			var energy:Button;
			for(var i:int=0;i<3;i++){
				
				energy = new Button;
				energy.width = 30;
				energy.height = 15;
				energy.y = 36-18*i;
				energy.visible = false;
				addChild(energy);
				
				list.push(energy);
				
			}
		}
		
		public function updateData(_value:Number):void{
			if(!list)
				return;
			for (var i:int = 0; i < list.length; i++) 
			{
				list[i].visible = false;
			}
			
			
			for (i = 0; i < _value; i++) 
			{
				list[i].visible = true;
			}
		}
		
		
		
		override public function dispose():void
		{
			super.dispose();
			
			
			removeChildren(0,-1,true);
			
			removeEventListener(Event.ADDED_TO_STAGE, initProBar);
		}
		
	}
}