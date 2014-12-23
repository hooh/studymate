package com.studyMate.world.screens.wordcards
{
	import com.byxb.extensions.starling.display.ParallaxSprite;
	import com.byxb.geom.InfiniteRectangle;
	import com.byxb.geom.Tiling;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.geom.Rectangle;

	public class RiverBgParallaxSprite extends ParallaxSprite
	{
		
		
		public function RiverBgParallaxSprite()
		{
			super(new Rectangle(0, 0, WorldConst.stageWidth, WorldConst.stageHeight), 1, 1);
			
			var boundR:InfiniteRectangle=InfiniteRectangle.FULL_RECT
				
			boundR.y = 475;
			addTileable(Assets.getWordCardAtlas().getTextures("river"),0.08,boundR.clone(), null, Tiling.TILE_X);
			
			

		}
	}
}