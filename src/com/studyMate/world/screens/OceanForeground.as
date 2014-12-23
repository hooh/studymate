package com.studyMate.world.screens
{
	import com.byxb.extensions.starling.display.ParallaxSprite;
	import com.byxb.geom.InfiniteRectangle;
	import com.byxb.geom.Tiling;
	
	import flash.geom.Rectangle;
	
	public class OceanForeground extends ParallaxSprite
	{
		public function OceanForeground()
		{
			super(new Rectangle(0, 0, WorldConst.stageWidth, WorldConst.stageHeight), 1.2, .2);
			
			var boundR:InfiniteRectangle=InfiniteRectangle.FULL_RECT;
			
			boundR.y=100;
			addTileable(Assets.getAtlas().getTextures("fg/wave1"), .2, boundR.clone(), null, Tiling.TILE_X);
			
			
			
		}
	}
}