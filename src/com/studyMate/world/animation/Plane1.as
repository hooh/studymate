package com.studyMate.world.animation
{
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	
	public class Plane1 extends Sprite
	{
		private var propeller:MovieClip;
		private var jungle:Juggler;
		private var planeBody:Image;
		
		private var flow1:MovieClip;
		private var flow2:MovieClip;
		
		
		
		public function Plane1(_jungle:Juggler)
		{
			super();
			jungle = _jungle;
			
			planeBody = new Image(Assets.getRAnimationTexture("animation/plane_01"));
			addChild(planeBody);
			
			propeller = new MovieClip(Assets.getRAnimationAtlas().getTextures("animation/Propeller_01"));
			
			addChild(propeller);
			propeller.x = 168;
			propeller.y = 10;
			
			flow1 = new MovieClip(Assets.getRAnimationAtlas().getTextures("animation/airflow_1"));
			addChild(flow1);
			flow1.x = 30;
			flow1.y = 60;
			jungle.add(flow1);
			
			
			flow2 = new MovieClip(Assets.getRAnimationAtlas().getTextures("animation/airflow_2"));
			addChild(flow2);
			flow2.x = -30;
			flow2.y = 40;
			jungle.add(flow2);
			
			
			jungle.add(propeller);
			
			
		}
	}
}