package com.studyMate.world.screens
{
	import com.byxb.extensions.starling.display.ParallaxSprite;
	import com.byxb.geom.InfiniteRectangle;
	import com.byxb.geom.Tiling;
	import com.studyMate.global.Global;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class OceanBackground extends ParallaxSprite
	{
		public var hill:Sprite;
		
		
		public function OceanBackground()
		{
			super(new Rectangle(0, 0, WorldConst.stageWidth, WorldConst.stageHeight), 1, 1);
//			addStretchable(Assets.getAtlas().getTexture("bg/sky"), 0, new InfiniteRectangle(Number.NEGATIVE_INFINITY, -376, Number.POSITIVE_INFINITY, 285));
			
			//the InfiniteRectangle class lets me create a rectangle using values like Number.POISTIVE_INFINITY without causing values of NaN for width.
			var boundR:InfiniteRectangle=InfiniteRectangle.FULL_RECT;
			
			
			/*boundR.y=-327;
			addTileable(Assets.getAtlas().getTextures("bg/cloud1"), .005, boundR.clone(), null, Tiling.TILE_X);
			
			boundR.y=-267;
			addTileable(Assets.getAtlas().getTextures("bg/cloud2"), .08, boundR.clone(), null, Tiling.TILE_X);*/
			
//			addStretchable(Assets.getAtlas().getTexture("bg/water"), 0, new InfiniteRectangle(Number.NEGATIVE_INFINITY, -154, Number.POSITIVE_INFINITY, 526));
			
			
			
			
			
			boundR.y = 160;
			addTileable(Assets.getAtlas().getTextures("bg/wave"), .12, boundR.clone(), null, Tiling.TILE_X);
			
	//		boundR.y=-218;
	//		hill = addTileable(Assets.getAtlas().getTextures("bg/bghill1"), .15, boundR.clone(), null, Tiling.TILE_X);
			
//			boundR.y=-165;
//			addTileable(Assets.getAtlas().getTextures("bg/shine"), 0.15, boundR.clone(), null, Tiling.TILE_X);
			
			
//			boundR.y=140;
//			addTileable(Assets.getAtlas().getTextures("bg/waterplant1"), .11, boundR.clone(), null, Tiling.TILE_X);
//			
//			
//			
			boundR.y=200;
			boundR.width = 1500;
			boundR.x = -650
			addTileable(Assets.getAtlas().getTextures("bg/seabed"), .12, boundR.clone(), null, Tiling.TILE_X);
			
			//The various boundR y values are set based off coordinates from Photoshop for how the layers stack together.
			/*boundR.y=-134;
			addTileable(Assets.getAtlas().getTextures("bg/ground4"), .1, boundR.clone(), null, Tiling.TILE_X);
			
			boundR.y=-272;
			addTileable(Assets.getAtlas().getTextures("bg/cloud1"), .15, boundR.clone(), null, Tiling.TILE_X);
			
			boundR.y=-182;
			addTileable(Assets.getAtlas().getTextures("bg/cloud2"), .15, boundR.clone(), null, Tiling.TILE_X);
			
			boundR.y=-159;
			addTileable(Assets.getAtlas().getTextures("bg/cloud3"), .15, boundR.clone(), null, Tiling.TILE_X);
			
			boundR.y=-177;
			addTileable(Assets.getAtlas().getTextures("bg/cloud4"), .15, boundR.clone(), null, Tiling.TILE_X);
			
			boundR.y=-288;
			addTileable(Assets.getAtlas().getTextures("bg/cloud5"), .18, boundR.clone(), null, Tiling.TILE_X);
			
			boundR.y=-54;
			addTileable(Assets.getAtlas().getTextures("bg/ground5"), .2, boundR.clone(), null, Tiling.TILE_X);
			
			boundR.y=-206;
			addTileable(Assets.getAtlas().getTextures("bg/Mountain1"), .2, boundR.clone(), null, Tiling.TILE_X);
			
			boundR.y=-206;
			addTileable(Assets.getAtlas().getTextures("bg/Mountain2"), .2, boundR.clone(), null, Tiling.TILE_X);
			
			addStretchable(Assets.getAtlas().getTexture("bg/stretchMountain"), .2, new InfiniteRectangle(Number.NEGATIVE_INFINITY, -40, Number.POSITIVE_INFINITY, 100));
			
			boundR.y=-90;
			addTileable(Assets.getAtlas().getTextures("bg/ground3"), .5, boundR.clone(), null, Tiling.TILE_X);
			
			addStretchable(Assets.getAtlas().getTexture("bg/stretchGround3"), .5, new InfiniteRectangle(Number.NEGATIVE_INFINITY, -10, Number.POSITIVE_INFINITY, 100));
			
			boundR.y=-92;
			addTileable(Assets.getAtlas().getTextures("bg/ground2"), .8, boundR.clone(), null, Tiling.TILE_X);
			
			addStretchable(Assets.getAtlas().getTexture("bg/stretchGround2"), .8, new InfiniteRectangle(Number.NEGATIVE_INFINITY, -15, Number.POSITIVE_INFINITY, 100));
			
			addScrollable(Assets.getTexture("ground"), 1, new InfiniteRectangle(Number.NEGATIVE_INFINITY, 30, Number.POSITIVE_INFINITY, Number.POSITIVE_INFINITY), new Point(0, -30), Tiling.TILE_X | Tiling.TILE_Y);
			
			boundR.y=-57
			addTileable(Assets.getAtlas().getTextures("bg/ground1"), 1, boundR.clone(), null, Tiling.TILE_X);*/
		}
	}
}