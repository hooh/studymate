package com.studyMate.world.screens.effects
{
	import starling.core.Starling;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	
	public class SwimWater extends PDParticleSystem
	{
		public function SwimWater()
		{
			super(Assets.store["swimwater"], Assets.getAtlas().getTexture("bg/swimwater"));
		}
		
		public override function start(duration:Number=Number.MAX_VALUE):void
		{
			Starling.juggler.add(this);
			super.start(duration);
		}
		
		public override function dispose():void
		{
			Starling.juggler.remove(this);
			super.dispose();
		}
		
		
		public function removeAnimation():void{
			Starling.juggler.remove(this);
		}
		
		
		
	}
}