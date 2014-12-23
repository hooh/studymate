package com.studyMate.world.screens.transen
{
	import com.studyMate.utils.BitmapFontUtils;
	
	import feathers.controls.Label;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class WordCard extends Sprite
	{
		
		private var bg:Image;
		private var textField:Label;
		
		public var strIndex:int;
		
		public var type:String;
		
		public static const SIGN0:String = "/";
		public static const SIGN1:String = "[";
		public static const SIGN2:String = "]";
		public static const SIGN3:String = "(";
		public static const SIGN4:String = ")";
		
		
		
		
		
		
		public function WordCard(tname:String="bg_00000",type:String="")
		{
			super();
			this.type = type;
			
			
			createBackground(tname);
			if(type==""){
				textField = BitmapFontUtils.getLabel();
				textField.text = type;
				textField.x = 10;
				textField.y = 6;
				addChild(textField);
			}else{
				pivotY = -60;
			}
			
		}
		
		private function createBackground(tname:String):void{
			
			bg = new Image(BitmapFontUtils.getTexture(tname));
			
			
			addChild(bg);
			
			
		}
		
		
		public function set text(_txt:String):void{
			
			textField.text = _txt;
			
			
			
			
		}
		
		public function get text():String{
			if(textField){
				return textField.text;
			}else{
				return type;
			}
		}
		
		
		
		
		
		
		
	}
}