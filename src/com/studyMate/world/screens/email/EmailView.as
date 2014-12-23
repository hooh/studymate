package com.studyMate.world.screens.email
{
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class EmailView extends Sprite
	{
		
		internal var unReadBtn:Button;
		internal var readedBtn:Button;
		internal var sendedBtn:Button;
		internal var collectBtn:Button;
		internal var messageBtn:Button;
		public  var NumBtn:Button;
		internal var texture:Texture;
		internal var ground:Image;
		internal var selectBackground:Quad;
		public static var numText:TextField;

	    
		public function EmailView()
		{
			
			selectBackground = new Quad(90,800,0x8CD234);
			addChild(this.selectBackground);
			
			var texture:Texture;
			texture = Assets.getEmailAtlasTexture("rect");
			ground = new Image(texture);
			ground.x = -5;
			ground.y = 20;
			addChild(ground);
			
			texture = Assets.getEmailAtlasTexture("reading");
			unReadBtn = new Button(texture);
			unReadBtn.x = 25;
			unReadBtn.y = 40;
			addChild(unReadBtn);
			
			texture = Assets.getEmailAtlasTexture("Num");
			NumBtn = new Button(texture);
			NumBtn.x = 50;
			NumBtn.y = 40;
			NumBtn.visible = false;
			addChild(NumBtn);
			
			texture = Assets.getEmailAtlasTexture("readed");
			readedBtn = new Button(texture);
			readedBtn.x = 25;
			readedBtn.y = 140;
			addChild(readedBtn);
			
			texture = Assets.getEmailAtlasTexture("sended");
			sendedBtn = new Button(texture);
			sendedBtn.x = 5;
			sendedBtn.y = 215;
			addChild(sendedBtn);
			
			texture = Assets.getEmailAtlasTexture("save");
			collectBtn = new Button(texture);
			collectBtn.x = 5;
			collectBtn.y = 310;
			addChild(collectBtn);
			
			texture = Assets.getEmailAtlasTexture("message");
			messageBtn = new Button(texture);
			messageBtn.x = 5;
			messageBtn.y = 650;
			addChild(messageBtn);
			
			numText = new starling.text.TextField(30, 30, "","HeiTi",16,0xffffff,false);
			numText.x = 48;
			numText.y = 36;
			numText.autoScale = true;
			numText.touchable = false;
			addChild(numText);
			
			
		}
	}
}