package com.studyMate.module.engLearn.reward.particalLayer
{
	import starling.core.Starling;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	
	
	/**
	 * note
	 * 2014-12-11上午9:36:42
	 * Author wt
	 *
	 */	
	
	public class SnowParticle extends PDParticleSystem implements IRewardPt
	{
		public function SnowParticle(autoStart:Boolean=true)
		{
			super(Assets.store["rewardSnow"], Assets.getRewardTexture("snowPartical"));
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