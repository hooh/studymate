package com.mylib.game.card
{
	import flash.display.BitmapData;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class CardValueDisplay
	{
		protected var _data:Vector.<CValue>;
		protected var _textField:TextField;
		protected var tf:TextFormat;
		protected var texture:Texture;
		public var view:Image;
		
		public function CardValueDisplay()
		{
			_textField = new TextField();
			_textField.width = 100;
			_textField.height = 24;
			tf = new TextFormat("arial",14);
		}
		
		public function set data(cards:Vector.<CValue>):void{
			_data = cards;
			
		}
		
		public function refresh():void{
			
			var card:CValue;
			_textField.text = "";
			for (var i:int = 0; i < _data.length; i++) 
			{
				card = _data[i];
				if(card){
					_textField.appendText(card.value.toString()+" ");
					tf.color = HeroAttribute.getCardColor(card.type);
					_textField.setTextFormat(tf,_textField.text.length-card.value.toString().length-1,_textField.text.length);
					
				}
			}
			
			if(texture){
				texture.dispose();
			}
			
			if(view){
				view.dispose();
			}
			
			var bmd:BitmapData = new BitmapData(_textField.width,_textField.height,true,0);
			bmd.draw(_textField);
			texture = Texture.fromBitmapData(bmd);
			view = new Image(texture);
			bmd.dispose();
		}
		
		public function dispose():void
		{
			if(texture){
				texture.dispose();
			}
			tf =null;
			_textField = null;
			
		}
		
		
	}
}