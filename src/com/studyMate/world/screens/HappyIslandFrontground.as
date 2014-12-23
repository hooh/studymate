package com.studyMate.world.screens
{
	import com.byxb.extensions.starling.display.ParallaxSprite;
	import com.byxb.geom.InfiniteRectangle;
	import com.byxb.geom.Tiling;
	
	import flash.geom.Rectangle;
	
	public class HappyIslandFrontground extends ParallaxSprite
	{
		public function HappyIslandFrontground()
		{
			super(new Rectangle(0, 0, WorldConst.stageWidth, WorldConst.stageHeight), 1, 1);
			
			var boundR:InfiniteRectangle=InfiniteRectangle.FULL_RECT;
			
			boundR.x=-640;
			boundR.y=-110;
			addTileable(Assets.getHappyIslandAtlas().getTextures("front_tree3"),2,boundR.clone(), null, Tiling.TILE_X); //分开两张图
		}
	}
}