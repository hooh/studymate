package com.studyMate.module.engLearn
{
	import myLib.myTextBase.TextFieldHasKeyboard;
	
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	internal class WordLearningTXTView extends Sprite
	{
		public var inputTXT:TextFieldHasKeyboard;//输入框文本
		public var text_holder:Sprite;//容器存放text文本
		public var wrongTXT:TextField;//错误输入 一行	
		public var wordTXT:TextField;//单词        二行
		public var symbolTXT:TextField;//音标      三行
		public var chineseTXT:TextField;//目标单词 四行
		//public var playSoundBtn:Button;
		
		/**------提示文本----------*/
		public var EN_TIP:TextField;
		public var ZHONG_TIP:TextField;
		public var BOTTOM_TIP:TextField;
		
		public var appleTXT:TextField;
		
		//public var changeInput:Button;
		
		public function WordLearningTXTView()
		{
			/*playSoundBtn = new Button();
			playSoundBtn.label = "读音";
			playSoundBtn.x = 116;
			playSoundBtn.y = 167;
			this.addChild(playSoundBtn);*/
			
			
			text_holder = new Sprite();
			text_holder.x = 242;
			text_holder.y = 210;
			text_holder.mouseChildren = false;
			text_holder.mouseEnabled = false;
			this.addChild(text_holder);			
			/**------------样式---------------------*/
			var tf:TextFormat = new TextFormat("HeiTi",33,0xFFFFFF);
			var tf1:TextFormat = new TextFormat("HeiTi",33,0x5F4D3D);//淡蓝
			var tf2:TextFormat = new TextFormat("arial",33,0);//灰色音标	
			//var tf2:TextFormat = new TextFormat("HeiTi",33,0);//灰色音标	
			/**------------文本---------------------*/
			
			/*changeInput = new Button();
			changeInput.label = "切换系统键盘";
			changeInput.emphasized = true;
			changeInput.toggle = true;
			changeInput.x = 5;
			changeInput.y = 110;
			changeInput.setStyle("textFormat", new TextFormat("HeiTi",14,0x8080FF));
			this.addChild(changeInput);*/
			
			
			inputTXT = new TextFieldHasKeyboard();//输入文本
			inputTXT.defaultTextFormat = tf;
			//inputTXT.embedFonts = true;
			//inputTXT.filters = new Array( new GlowFilter(0X000000,0.8,2,2,100)        );
			inputTXT.x = 213;
			inputTXT.y = 114;
			inputTXT.width = 512;
			inputTXT.height = 55;
			inputTXT.maxChars = 30;
			inputTXT.restrict = "^`\/";
			this.addChild(inputTXT);
			
			EN_TIP = new TextField();	//"En"---提示文本	
			EN_TIP.width = 46;
			EN_TIP.x = 162;
			EN_TIP.y = 106;
			var EnTf:TextFormat = new TextFormat("HeiTi",33,0xFFEA73);
			EN_TIP.embedFonts = true;
			EN_TIP.mouseEnabled = false;
			EN_TIP.selectable = false;
			EN_TIP.defaultTextFormat = EnTf;
			EN_TIP.filters = new Array(new GlowFilter(0x879719,1,4,4,100)   );
			EN_TIP.text = "En";
			this.addChild(EN_TIP);
			
			ZHONG_TIP = new TextField();//"中"-----提示文本
			ZHONG_TIP.x = 164;
			ZHONG_TIP.y = 106;
			ZHONG_TIP.width = 46;
			var zhongTf:TextFormat = new TextFormat("HeiTi",33,0xFCD072);
			ZHONG_TIP.embedFonts = true;
			ZHONG_TIP.mouseEnabled = false;
			ZHONG_TIP.selectable = false;
			ZHONG_TIP.defaultTextFormat = zhongTf;
			ZHONG_TIP.filters = new Array(new GlowFilter(0xB5572D,1,4,4,100)   );
			ZHONG_TIP.text = "中";
			this.addChild(ZHONG_TIP);
			ZHONG_TIP.visible = false;
			
			BOTTOM_TIP = new TextField();
			BOTTOM_TIP.width = 200;
			BOTTOM_TIP.x = 572;
			BOTTOM_TIP.y = 706;
			BOTTOM_TIP.embedFonts = true;
			BOTTOM_TIP.antiAliasType = AntiAliasType.ADVANCED;
			BOTTOM_TIP.mouseEnabled = false;
			BOTTOM_TIP.selectable = false;
			var bottmTf:TextFormat = new TextFormat("HuaKanT",30,0xF1AE4E);
			BOTTOM_TIP.defaultTextFormat = bottmTf;
			BOTTOM_TIP.filters = new Array(new GlowFilter(0x57473C,1,2,2,100,BitmapFilterQuality.HIGH)   );
			this.addChild(BOTTOM_TIP);
			
			
			appleTXT = new TextField();//统计苹果树
			appleTXT.embedFonts = true;
			appleTXT.x = 1145;
			appleTXT.y = 150;
			appleTXT.width = 80;
			appleTXT.height = 55;
			appleTXT.defaultTextFormat = EnTf;
			appleTXT.antiAliasType = AntiAliasType.ADVANCED;
			appleTXT.filters = new Array(new GlowFilter(0xB5572D,1,4,4,100)   );
			//appleTXT.text = "0";
			appleTXT.selectable=false;
			appleTXT.mouseEnabled = false;
			this.addChild(appleTXT);			
			
			
			wrongTXT = new TextField();//错误文本
			wrongTXT.embedFonts = true;
			wrongTXT.x = 810;
			wrongTXT.y = 105;
			wrongTXT.width = 328;
			wrongTXT.height = 55;
			wrongTXT.defaultTextFormat = tf1;
			wrongTXT.antiAliasType = AntiAliasType.ADVANCED;
			wrongTXT.selectable = false;
			wrongTXT.mouseEnabled = false;
			this.addChild(wrongTXT);
			//text_holder.addChild(wrongTXT);
			
			wordTXT = new TextField();//单词
			wordTXT.embedFonts = true;
			wordTXT.width = 600;
			//wordTXT.y = 30;
			//wordTXT.height = 55;
			wordTXT.defaultTextFormat = tf;
			wordTXT.antiAliasType = AntiAliasType.ADVANCED;
			wordTXT.selectable = false;
			wordTXT.mouseEnabled = false;
			text_holder.addChild(wordTXT);
			
			symbolTXT = new TextField();//音标	
			symbolTXT.embedFonts = true;
			symbolTXT.width = 600;
			//symbolTXT.height=55;
			symbolTXT.y = 50;
			symbolTXT.defaultTextFormat = tf2;
			symbolTXT.antiAliasType = AntiAliasType.ADVANCED;
			symbolTXT.selectable = false;
			symbolTXT.mouseEnabled = false;
			text_holder.addChild(symbolTXT);
			
			chineseTXT = new TextField();//目标答案
			chineseTXT.embedFonts = true;
			chineseTXT.antiAliasType = AntiAliasType.ADVANCED;
			chineseTXT.width = 600;
			chineseTXT.height = 160;
			
			chineseTXT.wordWrap = true;
			//chineseTXT.multiline = true;
//			chineseTXT.autoSize = TextFieldAutoSize.LEFT;
			//chineseTXT.height=165;
			chineseTXT.y = 95;
			chineseTXT.defaultTextFormat = tf;
			chineseTXT.selectable = false;
			chineseTXT.mouseEnabled = false;
			text_holder.addChild(chineseTXT);	
		}
	}
}