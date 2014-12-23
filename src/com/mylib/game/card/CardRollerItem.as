package com.mylib.game.card
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class CardRollerItem extends Sprite
	{
		protected var txt:TextField;
		public function CardRollerItem()
		{
			txt = new TextField();
			
			var tf:TextFormat = new TextFormat("arial",20);
			txt.width = 40;
			txt.height = 30;
			txt.autoSize = TextFieldAutoSize.NONE;
			txt.defaultTextFormat = tf;
			addChild(txt);
			color = 0;
		}
		
		public function set color(_uint:uint):void{
			
			this.graphics.clear();
			this.graphics.beginFill(_uint);
			this.graphics.drawRect(0,0,txt.width,txt.height);
			this.graphics.endFill();
			
			
		}
		
		public function set text(_txt:String):void{
			txt.text = _txt;
			
		}
		
		
	}
}