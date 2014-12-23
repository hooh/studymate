package com.studyMate.world.component.AndroidGame
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
	
	public class MyGameItemIcon extends Image
	{
		private var sp:Sprite;
		
		public function MyGameItemIcon(_bitmap:Bitmap,_name:String)
		{
			
			var matrix:Matrix = new Matrix();
			matrix.tx = 24;
			
			var bitdata:BitmapData = new BitmapData(120,110,true,0x00000000);
			sp = new Sprite;
			sp.addChild(_bitmap);
			
			
			
			var tf:TextFormat = new TextFormat("HuaKanT",18,0x402e00);
			var nameTF:TextField = new TextField();
			tf.align = TextFormatAlign.CENTER;
			nameTF.embedFonts = true;
			nameTF.defaultTextFormat = tf;
			nameTF.antiAliasType = AntiAliasType.ADVANCED;
			nameTF.width = 120;
			nameTF.height= 23;
			nameTF.x = (_bitmap.width - nameTF.width)>>1;
			nameTF.y = _bitmap.height + 15;
			if(_name.length > 6)	nameTF.text = _name.substr(0,3)+"..."+_name.substr(_name.length-2,2);
			else	nameTF.text = _name;
			
			sp.addChild(nameTF);
			
			bitdata.draw(sp,matrix);
			
//			var item:Image = new Image(Texture.fromBitmapData(bitdata,false));
//			item.x = -24;
//			
			
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