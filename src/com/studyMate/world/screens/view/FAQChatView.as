package com.studyMate.world.screens.view
{
	import com.mylib.framework.utils.AssetTool;
	import com.studyMate.view.component.myScroll.Scroll;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import myLib.myTextBase.TextFieldHasKeyboard;
	
	public class FAQChatView extends Sprite
	{
		
		public var UI:Sprite;
		public var scroll:Scroll;
		public var inputTxt:TextFieldHasKeyboard;		
						
		public var sendBtn:SimpleButton;
		public var closeBtn:SimpleButton;
		public var dragBtn:SimpleButton;
		public var cameraBtn:SimpleButton;
		public var changeKeyboardBtn:SimpleButton
		public var upMoreBtn:Sprite;
		public var downMoreBtn:Sprite
		
		public var allMsgIco:Sprite;
		public var noMsgIco:Sprite;
		public var changeMsgBtn:SimpleButton;
		
		public var mainUI:Sprite;
		
		
		public function FAQChatView()
		{
			
		}
		//使用init的原因是。在onRegister里初始化。避免其中的输入框无焦点的bug，由（switchScreen和popUpScreen导致的）
		public function init():void{
			var tf3:TextFormat = new TextFormat("HeiTi",20,0);			
			var mainUIClass:Class = AssetTool.getCurrentLibClass("FAQChatMain");
			mainUI = new mainUIClass();
			this.addChild(mainUI);			
			
			sendBtn = mainUI.getChildByName("sendBtn") as SimpleButton;
			closeBtn = mainUI.getChildByName("closeBtn") as SimpleButton;
			dragBtn = mainUI.getChildByName("dragBtn") as SimpleButton;
			cameraBtn = mainUI.getChildByName("cameraBtn") as SimpleButton;
			upMoreBtn = mainUI.getChildByName("upMoreBtn") as Sprite;
			downMoreBtn = mainUI.getChildByName("downMoreBtn") as Sprite;
			changeKeyboardBtn = mainUI.getChildByName("changeKeyboardBtn") as SimpleButton;
			
			changeMsgBtn = mainUI.getChildByName("changeMsgBtn") as SimpleButton;
			allMsgIco = mainUI.getChildByName("allMsgBtn") as Sprite;
			noMsgIco = mainUI.getChildByName("noReadMsgBtn") as Sprite;
//			moreBtn.visible = false;
			
			
			inputTxt = new TextFieldHasKeyboard();
			inputTxt.defaultTextFormat = tf3;
			inputTxt.embedFonts = false;
			inputTxt.type = TextFieldType.INPUT;
			inputTxt.maxChars = 100;
			inputTxt.wordWrap = true;
			inputTxt.multiline = true;
			inputTxt.x = 38;
			inputTxt.y = 450;
			inputTxt.width = 550;
			inputTxt.height = 74;
			inputTxt.restrict = "^`&#\\";
			mainUI.addChild(inputTxt);			
			
			UI = new Sprite();
			scroll = new Scroll();
			scroll.y = 72;
			scroll.x = 10;
			scroll.width = 730;
			scroll.height = 353;
		}
	}
}