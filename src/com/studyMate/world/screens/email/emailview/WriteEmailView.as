package com.studyMate.world.screens.email.emailview
{
	import myLib.myTextBase.TextFieldHasKeyboard;
	import com.studyMate.world.screens.email.emailrender.WriteEmailItemRenderer;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import feathers.controls.List;
	import feathers.controls.ScrollText;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class WriteEmailView extends Sprite
	{
		
		private var background:Image;
		private var texture:Texture;
		public var contact:Button;
		public var send:Button;
		public var successTip:Image;
		public var changeKeyboard:Button
		
		public var addressee:TextField;
		public var title:TextFieldHasKeyboard;
		public var mailtext:TextFieldHasKeyboard;
		public var croomList:List

		public var mailtext1:ScrollText


		
		public function WriteEmailView()
		{
			
			background = new Image(Assets.getTexture("writeEmailBackground"));
			background.x = 2;
			addChild(background);
			
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0x5E9845,1);
			shape.graphics.drawRect(0,0,2,800);
			shape.graphics.endFill();
			addChild(shape);
			
//			var inputTypeBtn:ChatViewlSimpleBtn = new ChatViewlSimpleBtn(true,Assets.getChatViewTexture("keyborad2Btn"),Assets.getChatViewTexture("keyborad1Btn"));
//			inputTypeBtn.x = 100;
//			inputTypeBtn.y = 348;
//			addChild(inputTypeBtn);
//			inputTypeBtn.addBtnListener(Event.TRIGGERED,changInputHandler);
			
			texture = Assets.getEmailAtlasTexture("contacts");
			contact = new Button(texture);
			contact.x = 1000;
			contact.y = 10;
			addChild(contact);
			
			texture = Assets.getEmailAtlasTexture("changeInputBtn");
			changeKeyboard = new  Button(texture);
			changeKeyboard.scaleX = 0.7;
			changeKeyboard.scaleY = 0.7;
			changeKeyboard.x = 930;
			changeKeyboard.y = 10;
			addChild(changeKeyboard);
			
			
			texture = Assets.getEmailAtlasTexture("send");
			send = new Button(texture);
			send.x = 1080;
			send.y = 10;
			addChild(send);
			
			texture = Assets.getEmailAtlasTexture("success");
			successTip = new Image(texture);
			successTip.x = 450;
			successTip.y = 300;
			successTip.visible = false;
			addChild(successTip);
			
			addressee = new TextField();
			var _addresseeformat:TextFormat = new TextFormat("HeiTi",24,0x4D4D48,false);
			addressee.x = 180;
			addressee.y = 30;
			addressee.width = 800;
			addressee.height = 50;
			addressee.scrollH = 20;
			addressee.restrict = "";
			addressee.border = false;
			addressee.defaultTextFormat = _addresseeformat;
			Starling.current.nativeOverlay.addChild(addressee);	
			
			title = new TextFieldHasKeyboard();
			var _titleformat:TextFormat = new TextFormat("HeiTi",26,0x000000,true);
			title.x = 180;
			title.y = 90;
			title.width = 800;
			title.height = 50;
			title.border = false
			title.maxChars = 20;
			title.defaultTextFormat = _titleformat;
			Starling.current.nativeOverlay.addChild(title);
			
			mailtext = new TextFieldHasKeyboard();
			var _mailformat:TextFormat = new TextFormat("HeiTi",24,0x000000,true);
			mailtext.x = 100;
			mailtext.y = 130;
			mailtext.maxChars = 600;
			mailtext.width = 900;
			mailtext.height = 500;
			mailtext.border = false;
			mailtext.wordWrap = true;
			mailtext.multiline = true;
			mailtext.defaultTextFormat = _mailformat;
			mailtext.prompt = "请在此输入正文内容";
			Starling.current.nativeOverlay.addChild(mailtext);
			
			
			
			croomList = new List();
			croomList.x = 950;
			croomList.y = 60;
			croomList.width = 200;
			croomList.height = 400;
			croomList.visible = false;
			croomList.itemRendererType = WriteEmailItemRenderer;
			addChild(croomList);
			
		}
		
		override public function dispose():void
		{
			Starling.current.nativeOverlay.removeChild(mailtext);
			Starling.current.nativeOverlay.removeChild(title);
			Starling.current.nativeOverlay.removeChild(addressee);
			addressee = null;
			mailtext = null;
			title = null;
			super.dispose();
		}
		
	}
}