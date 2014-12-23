package com.mylib.game.charater.item
{
	import com.byxb.utils.centerPivot;
	import com.greensock.TweenLite;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	
	public class SpeakFrame extends Sprite
	{
		public var bg:Image;
		public var textField:TextField;
		
		
		
		/**
		 *标记是否真正使用 
		 */		
		public var inUse:Boolean;
		
		
		public function SpeakFrame(font:String="mycomic")
		{
			super();
			bg = new Image(Assets.getAtlasTexture("item/speakFrame1"));
//			bg.scaleY = 0.5;
			centerPivot(bg);
			addChild(bg);
			
			textField = new TextField(90,55,"",font,24);
			addChild(textField);
			textField.y-=6;
			textField.autoScale = true;
			centerPivot(textField)
			
			
		}
		
		public function set text(str:String):void{
			
			textField.text = str;
			
		}
		
		public function get text():String{
			return textField.text;
		}
		
		public function set dir(_dir:int):void{
			
			bg.scaleX = _dir;
			
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			bg.dispose();
			textField.dispose();
			
			removeChildren(0,-1,true);
			
		}
		
	}
}