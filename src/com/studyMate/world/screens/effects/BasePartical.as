package com.studyMate.world.screens.effects
{
	import starling.core.Starling;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	
	public class BasePartical extends PDParticleSystem
	{
		public function BasePartical(config:XML, texture:Texture,autoStart:Boolean=true)
		{
			super(config,texture);
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