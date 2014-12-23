package com.studyMate.world.screens
{
	import com.byxb.extensions.starling.display.ParallaxSprite;
	import com.byxb.geom.InfiniteRectangle;
	import com.byxb.geom.Tiling;
	
	import flash.geom.Rectangle;
	
	import starling.textures.Texture;
	
	public class OceanMapBG extends ParallaxSprite
	{
		public function OceanMapBG()
		{
			super(new Rectangle(0, 0, WorldConst.stageWidth, WorldConst.stageHeight+1000), 1, 1);
			
			var boundR:InfiniteRectangle=InfiniteRectangle.FULL_RECT;
			
			boundR.x=0;
			
			addTileable(Vector.<starling.textures.Texture>([Assets.getTexture("oceanBG")]),1,boundR.clone(), null, Tiling.TILE_X|Tiling.TILE_Y); 
			this.getChildAt(0).pivotX = 100;
			this.getChildAt(0).pivotY = 300;
		}
	}
}