package com.studyMate.world.screens
{
	import com.studyMate.world.model.vo.MessageVO;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class GiftSprite extends Sprite
	{
		public var msg:MessageVO;
		
		public function GiftSprite(msg:MessageVO){
			var giftTexture:Texture = Assets.getAtlasTexture("item/gift1");
			var img:Image = new Image(giftTexture);
			this.addChild(img);
			this.msg = msg;
		}
		
	}
}