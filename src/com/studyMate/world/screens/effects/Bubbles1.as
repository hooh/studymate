package com.studyMate.world.screens.effects
{
	import starling.core.Starling;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	
	public class Bubbles1 extends PDParticleSystem
	{
		public function Bubbles1(autoStart:Boolean=true)
		{
			super(Assets.store["bubbles1"], Assets.getAtlas().getTexture("bg/Bubbles"));
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
		
		public function pause():void{
			Starling.juggler.remove(this);
		}
		
		public function resume():void{
			Starling.juggler.add(this);
		}
	}
}