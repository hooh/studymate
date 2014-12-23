package com.studyMate.world.screens
{
	import flash.filters.GlowFilter;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class NumberTips extends Sprite{
		private var bg:Image;
		private var textField:TextField;
		private var _number:int;
		
		public function NumberTips()
		{
			super();
			bg = new Image(Assets.getAtlasTexture("mainMenu/numTips"));
			addChild(bg);
			
			textField = new TextField(27,22,"","comic",16,0xffdf0b);
			addChild(textField);
			textField.x = 1; textField.y = 3;
			textField.autoScale = true;
			textField.nativeFilters = [new GlowFilter(0x874d06,1,4,4,20)];
		}

		public function get number():int
		{
			return _number;
		}

		public function set number(value:int):void
		{
			_number = value;
			textField.text = number.toString();
		}

	}
}