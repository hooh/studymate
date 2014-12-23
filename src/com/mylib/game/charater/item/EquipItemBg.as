package com.mylib.game.charater.item
{
	import com.studyMate.utils.BitmapFontUtils;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class EquipItemBg extends Sprite
	{

		
		public function EquipItemBg()
		{
			super();
			
			this.touchable = false;
			
			var bg:Image = new Image(BitmapFontUtils.getTexture("DressMarket/itemBg_lvl1_00000"));
			bg.x = 8;
			bg.y = 1;
			bg.visible = false;
			
			addChild(bg);
			
		}
		
		
		override public function dispose():void
		{

			super.dispose();
			removeChildren(0,-1,true);
		}
		
	}
}