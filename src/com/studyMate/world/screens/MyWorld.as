package com.studyMate.world.screens
{
	import de.nulldesign.nd2d.display.World2D;
	
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import net.hires.debug.Stats;

	public class MyWorld extends World2D
	{
		public static var stats:Stats = new Stats();
		public function MyWorld()
		{
			super(Context3DRenderMode.AUTO, 60);
			
			
			
		}
		
		override protected function addedToStage(event:Event):void
		{
			super.addedToStage(event);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			camera.reset();
			setActiveScene(new MainMenuScene);
			
			addChild(stats);
			start();
		}
		
		
		override protected function context3DCreated(e:Event):void
		{
			
			super.context3DCreated(e);
			
			if (context3D)
			{
				trace(context3D.driverInfo);
			}
		}
	}
}