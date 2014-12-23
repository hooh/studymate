package com.studyMate.world.screens.wordcards
{
	import starling.core.Starling;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;

	public class Raindrop extends PDParticleSystem
	{
		public function Raindrop(autoStart:Boolean=true)
		{
			super(Assets.store["rain"], Assets.getWordCardAtlasTexture("rain"));
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
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
		}
	}
}