package com.mylib.game.charater.item
{
	import com.byxb.utils.centerPivot;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class DialogBox extends Sprite
	{
		public var bg:Image;
//		public var btn:Image;
		public var textField:TextField;
		
		private var styleSp:Sprite;
		private var style1:Sprite;
//		private var style2:Sprite;

		public function DialogBox(font:String="mycomic")
		{
			super();
			
			styleSp = new Sprite();
			style1 = new Sprite();
			style1.name = "style1";
//			style2 = new Sprite();
//			style2.name = "style2";
			
			styleSp.addChild(style1);
//			styleSp.addChild(style2);
			addChild(styleSp);
			
			initStyle();
			
			var sp:Sprite = new Sprite();
			sp.name = "text";
			addChild(sp);
			
			textField = new TextField(250,120,"",font,24);
			textField.name = "dBText";
			sp.addChild(textField);
			textField.y-=6;
			textField.autoScale = true;
			textField.visible = false;
			centerPivot(textField);
			textField.vAlign = VAlign.CENTER;
			textField.hAlign = HAlign.CENTER;
//			textField.x = width>>1;
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			super.dispose();
			
//			removeChildren(0,-1,true);
			
		}
		
		
		public function set text(str:String):void{
			textField.text = str;
		}
		
		
		
		private function initStyle():void{
			bg = new Image(Assets.getAtlasTexture("dialogBox/dialogBox1_1"));
			bg.name = "dialogBox";
			bg.x = -(bg.width/2);
			bg.y = -(bg.height/2);
			style1.addChild(bg);
//			btn = new Image(Assets.getAtlasTexture("dialogBox/dialogBox1_2"));
//			btn.name = "enterBtn";
//			btn.x = 80;
//			btn.y = 40;
//			style1.addChild(btn);
			
			
//			bg = new Image(Assets.getAtlasTexture("dialogBox/dialogBox2_1"));
//			bg.name = "dialogBox";
//			bg.x = -(bg.width/2);
//			bg.y = -(bg.height/2);
//			style2.addChild(bg);
		}
		
		public function setStyle(styName:String):void{
			
			switch(styName){
				case "style1":
					style1.visible = true;
//					style2.visible = false;
					
					textField.width = 250;
					textField.height = 120;
					textField.fontSize = 24;
					break;
				case "style2":
					style1.visible = false;
//					style2.visible = true;
					
					textField.width = 180;
					textField.height = 90;
					textField.fontSize = 18;
					
					break;
			}
			
			centerPivot(textField);
			
		}
	}
}