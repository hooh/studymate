package com.studyMate.world.screens.email.emailview
{
	import flash.text.TextFormat;
	
	import feathers.controls.ScrollText;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class ReadedEmailView extends Sprite
	{
		
		private var background:Image;
		public var editorBtn:Button;
		public var reviceBtn:Button;
		public var delBtn:Button;
		public var finshBtn:Button;
		
		public var sendname:TextField;
		public var title:TextField;
		public var mailtext:TextField;
		
		public var _title:TextField;
		public var _label:TextField;
		
		public var hideBackground:Shape;
		
//		public var mailtext1:ScrollText
		
		public var msgTextField2:ScrollText;
		
		public var shape:Shape;
		private var noEmail:Image;

		
		public function ReadedEmailView()
		{
			background = new Image(Assets.getTexture("emailBackground"));
			addChild(background);
			
			
			hideBackground = new Shape();
			hideBackground.graphics.beginFill(0xfff4d1,1);
			hideBackground.graphics.drawRect(422,0,800,800);
			hideBackground.graphics.endFill();
			addChild(hideBackground);
			
			editorBtn = new Button(Assets.getEmailAtlasTexture("editor"));
			editorBtn.x = 310;
			editorBtn.y = 10;
			addChild(editorBtn);
			
			reviceBtn = new Button(Assets.getEmailAtlasTexture("revice"));
			reviceBtn.x = 1120;
			reviceBtn.y = 5;
			reviceBtn.visible  = false;
			addChild(reviceBtn);
			
			
			delBtn = new Button(Assets.getEmailAtlasTexture("alldel"));
			delBtn.x = 190;
			delBtn.y = 10;
			delBtn.visible = false;
			addChild(delBtn);
			
			finshBtn = new Button(Assets.getEmailAtlasTexture("finish"));
			finshBtn.x = 310;
			finshBtn.y = 10;
			finshBtn.visible = false;
			addChild(finshBtn);
			
			_label = new TextField(100,50,"发件人：","HeiTi",16,0x595653,false);
			_label.x = 450;
			_label.y = 20;
			_label.visible = false;
			addChild(_label)
			
			
			sendname = new TextField(600,50,"","HeiTi",16,0x595653,false);
			sendname.x = 530;
			sendname.y = 20;
			sendname.hAlign = HAlign.LEFT;
			addChild(sendname);
			
			_title = new TextField(100,50,"主题：","HeiTi",18,0x595653,false);
			_title.x = 460;
			_title.y = 70;
			_title.visible = false;
			addChild(_title);	
			
			title = new TextField(600,50,"","HeiTi",24,0x595653,false);
			title.x = 540;
			title.y = 70;
			title.hAlign = HAlign.LEFT;
			addChild(title);
			
			mailtext = new TextField(700,400,"","HeiTi",18,0x000000,false);
			mailtext.x = 455;
			mailtext.y = 150;
			mailtext.vAlign = VAlign.TOP
			mailtext.hAlign = HAlign.LEFT;
			addChild(mailtext);
			
			shape = new Shape();
			shape.graphics.beginFill(0xE0E0E0,1);
			shape.graphics.drawRect(0,0,1200,800);
			shape.graphics.endFill();
			shape.x =2;
			shape.visible = false;
			addChild(shape);
			
			noEmail = new Image(Assets.getEmailAtlasTexture("unreadLogo"));
			noEmail.x = 520;
			noEmail.y = 310;
			shape.addChild(noEmail);
			
			var _tip:TextField = new TextField(600,200,"无已读邮件","宋体",60,0x999999,true);
			_tip.x = 465;
			_tip.y = noEmail.y-1.2*noEmail.height;
			_tip.hAlign = HAlign.LEFT;
			shape.addChild(_tip);
			
			
		}
	}
}