package com.studyMate.world.screens
{
	import com.byxb.extensions.starling.display.ParallaxSprite;
	import com.byxb.geom.InfiniteRectangle;
	import com.byxb.geom.Tiling;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.BlendMode;
	
	
	public class EnglishIslandBackground extends ParallaxSprite
	{
		public function EnglishIslandBackground()
		{
			super(new Rectangle(0, 0, WorldConst.stageWidth, WorldConst.stageHeight), 1, 1);
			
			var boundR:InfiniteRectangle=InfiniteRectangle.FULL_RECT;

			boundR.x=-640;
			boundR.y=-90;
			addTileable(Assets.getAtlas().getTextures("bg/engIslandBg01"),.85,boundR.clone(), null, Tiling.TILE_X); //分开两张图
			
			/*boundR.y = 11;
			addTileable(Assets.getAtlas().getTextures("bg/engIsland_cotree01"),.85,boundR.clone(), null, Tiling.TILE_X);						
			boundR.y = -40;
			addTileable(Assets.getAtlas().getTextures("bg/engIsland_cotree02"),.85,boundR.clone(), null, Tiling.TILE_X);*/
			
			boundR.x=-640;
			boundR.y=10;
			addTileable(Assets.getAtlas().getTextures("bg/engIslandBg02"),1,boundR.clone(), null, Tiling.TILE_X); //分开两张图
			
			boundR.y=325;
//			addTileable(Assets.getAtlas().getTextures("bg/engIsland_water"), 1.5, boundR.clone(), null, Tiling.TILE_X);
			
		}
	}
}