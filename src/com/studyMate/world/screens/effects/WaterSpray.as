package com.studyMate.world.screens.effects
{
	import starling.core.Starling;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	
	public class WaterSpray extends PDParticleSystem
	{
		public function WaterSpray()
		{
			super(Assets.store["waterspray"], Assets.getAtlas().getTexture("bg/swimwater"));
		}
		
		public override function start(duration:Number=Number.MAX_VALUE):void
		{
			Starling.juggler.add(this);
			super.start(duration);
			
		}
		
		public override function dispose():void
		{
			super.dispose();
			Starling.juggler.remove(this);
		}
		
		public function removeAnimation():void{
			Starling.juggler.remove(this);
		}
		
		
	}
}