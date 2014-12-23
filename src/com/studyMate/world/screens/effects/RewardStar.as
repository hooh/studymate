package com.studyMate.world.screens.effects
{
	import starling.core.Starling;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	
	public class RewardStar extends PDParticleSystem
	{
		public function RewardStar(autoStart:Boolean=true)
		{
			super(Assets.store["rewardStar"], Assets.getAtlas().getTexture("reward/littleStar"));
			if (autoStart)
			{
				addEventListener(Event.ADDED_TO_STAGE, onStage);
			}
		}
		
		
		private function onStage(e:Event):void
		{
			start();
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
		
		
	}
}