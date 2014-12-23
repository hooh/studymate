package com.mylib.game.house
{
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;

	public class HouseItemSprite extends Sprite
	{
		
		private var texture:Texture;
		
		private var priceTF:TextField;
		
		private var houseVo:HouseInfoVO;
		
		
		public function HouseItemSprite(_houseVo:HouseInfoVO)
		{
			this.houseVo = _houseVo;
			
			init();
		}
		
		private function init():void{
			
			houseVo.houseImg = new Image(Assets.getHapIslandHouseTexture(houseVo.data));
			houseVo.houseImg.x = (340-houseVo.houseImg.width)>>1;
			
			addChild(houseVo.houseImg);


			
			priceTF = new TextField(340,33,"RMB："+houseVo.price.toString()+"万","HuaKanT",28,0x0033CC);
			priceTF.hAlign = HAlign.CENTER;
			priceTF.y = 360;
			addChild(priceTF);
			
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			removeChildren(0,-1,true);
		}

	}
}