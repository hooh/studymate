package com.studyMate.world.screens.email.emailview
{
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class CollectEmailView extends Sprite
	{
		
		private var background:Image;
		public var delBtn:Button;
		public var finshBtn:Button;
		public var editorBtn:Button;
		
		public var sendname:TextField;
		public var title:TextField;
		public var mailtext:TextField;
		
		public var _title:TextField;
		public var _label:TextField;
		public var shape:Shape;
		private var noEmail:Image;


		
		public var hideBackground:Shape;
		
		public function CollectEmailView()
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
			
			
			 _label = new TextField(100,50,"收件人：","HeiTi",16,0x595653,false);
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
			
			mailtext = new TextField(700,500,"","HeiTi",18,0x000000,false);
			mailtext.x = 455;
			mailtext.y = 150;
			mailtext.border = false;
			mailtext.hAlign = HAlign.LEFT;
			mailtext.vAlign = VAlign.TOP;
			mailtext.touchable = true;
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
			
			var _tip:TextField = new TextField(600,200,"无收藏邮件","宋体",60,0x999999,true);
			_tip.x = 465;
			_tip.y = noEmail.y-1.2*noEmail.height;
			_tip.hAlign = HAlign.LEFT;
			shape.addChild(_tip);
			
		}
	}
}