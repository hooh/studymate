package com.studyMate.world.component.AndroidGame.GameMarket
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class GameMarketItemIcon extends Image
	{
		
		private var sp:Sprite;
		
		public function GameMarketItemIcon(_bitmap:Bitmap,_name:String,_price:String="")
		{
			
			var bitdata:BitmapData = new BitmapData(202,72,true,0x00000000);
			sp = new Sprite;
			sp.addChild(_bitmap);
			
			
			
			var tf:TextFormat = new TextFormat("HuaKanT",18,0x402e00);
			var nameTF:TextField = new TextField();
			tf.align = TextFormatAlign.LEFT;
			nameTF.embedFonts = true;
			nameTF.defaultTextFormat = tf;
			nameTF.antiAliasType = AntiAliasType.ADVANCED;
			nameTF.width = 120;
			nameTF.height= 23;
			nameTF.x = _bitmap.width + 10;
			nameTF.y = 3;
			if(_name.length > 6)	nameTF.text = _name.substr(0,3)+"..."+_name.substr(_name.length-2,2);
			else	nameTF.text = _name;
			
			sp.addChild(nameTF);
			
			bitdata.draw(sp);
			
			
			super(Texture.fromBitmapData(bitdata,false));
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(texture)
				texture.dispose();
			if(sp && sp.numChildren > 0)
				sp.removeChildren(0,sp.numChildren-1);
		}
	}
}