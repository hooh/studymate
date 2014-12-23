package com.studyMate.world.screens
{
	import com.byxb.extensions.starling.display.ParallaxSprite;
	import com.byxb.geom.InfiniteRectangle;
	import com.byxb.geom.Tiling;
	
	import flash.geom.Rectangle;
	
	
	public class HappyIslandBackground extends ParallaxSprite
	{
		public function HappyIslandBackground()
		{
			super(new Rectangle(0, 0, WorldConst.stageWidth, WorldConst.stageHeight), 1, 1);
			
			var boundR:InfiniteRectangle=InfiniteRectangle.FULL_RECT;
			//			addStretchable(Assets.getAtlas().getTexture("bg/sky"),1,new InfiniteRectangle(Number.NEGATIVE_INFINITY, -396, Number.POSITIVE_INFINITY, 762));
			
			
			boundR.x=-640;
			boundR.y=115;
			addTileable(Assets.getHappyIslandAtlas().getTextures("hapIsland_GroundChr"),1,boundR.clone(), null, Tiling.TILE_X); //分开两张图
			
			boundR.x=70;//这里调坐标没用貌似。
			boundR.y=10;
			addTileable(Assets.getHappyIslandAtlas().getTextures("hapIsland_TreesChr"),.87,boundR.clone(), null, Tiling.TILE_X); //分开两张图
			
			
			boundR.x=-640;
			boundR.y=290;
			addTileable(Assets.getHappyIslandAtlas().getTextures("IceBG"),1.2,boundR.clone(), null, Tiling.TILE_X); //分开两张图
			
			//			boundR.y=325;
			
		}
	}
}