package com.studyMate.world.screens.effects
{
	import starling.core.Starling;
	import starling.extensions.PDParticleSystem;
	
	public class PaperEff extends PDParticleSystem
	{
		public function PaperEff()
		{
			super(Assets.store["paper"], Assets.getRunnerGameTexture("paper"));
		}
		
		
		public override function start(duration:Number=Number.MAX_VALUE):void
		{
			if(!Starling.juggler.contains(this)){
				Starling.juggler.add(this);
			}
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