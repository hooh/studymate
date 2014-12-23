package com.studyMate.module.engLearn
{
	import com.studyMate.view.component.myScroll.Scroll;
	import myLib.myTextBase.TextFieldHasKeyboard;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	internal class ReadCPUView extends Sprite
	{
		
		public var readScroller:Scroll;
		//public var readHolder:Sprite;		
		//public var readTextField:SimpleMenuTextField;	//文章显示对象
		public var readingHolder:Sprite
		public var questionScroller:Scroll;
		public var questionHolder:Sprite
		public var tipHolder:Sprite;
		public var questionCount:TextField;//第几题
		public var answerTA:TextFieldHasKeyboard;//答案
		public var reasonTA:TextFieldHasKeyboard;//理由
		public var tipsScroll:Scroll;
		
		
		//private var textFormat:TextFormat;
		
		public function ReadCPUView()
		{
			/*textFormat = new TextFormat("arial",24);
			textFormat.align = TextFormatAlign.JUSTIFY;
			textFormat.leading = 5;*/
			readScroller = new Scroll();
			readScroller.x = 0;
			readScroller.y = 71;
			readScroller.width = 664;
			readScroller.height = 670;
			readScroller.state = 'VERTICAL';
			
			readingHolder = new Sprite();
			readingHolder.x = 40;			
			/*readScroller.viewPort = readingHolder;
			this.addChild(readScroller);*/
			
			questionScroller = new Scroll();
			questionScroller.x = 708;
			questionScroller.y = 30;
			questionScroller.width = 590;
			questionScroller.height = 432;
			
			questionHolder = new Sprite();			
			//questionHolder.x = 708;
			//questionHolder.y = 30;
			//questionScroller.viewPort = questionHolder;
			//this.addChild(questionScroller);
			
			tipHolder = new Sprite();
			//tipHolder.x = 712;
			//tipHolder.y = 256;
			tipHolder.mouseChildren =false;			
			tipsScroll = new Scroll();
			tipsScroll.x = 712;
			tipsScroll.y = 202;
			tipsScroll.width = 550;
			tipsScroll.height = 202;
			tipsScroll.viewPort = tipHolder;
			this.addChild(tipsScroll);
			tipsScroll.visible = false;
			tipsScroll.graphics.beginFill(0xA49584,0.9);
			tipsScroll.graphics.drawRoundRect(0,0,546,200,20,20);
			tipsScroll.graphics.endFill();
			/*tipHolder.graphics.beginFill(0xA49584,0.9);
			tipHolder.graphics.drawRoundRect(0,0,522,200,20,20);
			tipHolder.graphics.endFill();*/
			//tipHolder.visible = false;
			//tipHolder.mouseEnabled = false;
			
			questionCount = new TextField();
			questionCount.x = 700;
			questionCount.y = 465;
			this.addChild(questionCount);
			
			var tf:TextFormat = new TextFormat(null,27);
			answerTA = new TextFieldHasKeyboard();
			answerTA.width = 510;answerTA.height = 45;
			answerTA.x = 745;answerTA.y = 528;
			answerTA.defaultTextFormat = tf;
			answerTA.maxChars = 150;
			answerTA.prompt = "请输入答案";
			answerTA.restrict = "^`\/";
			this.addChild(answerTA);
			
			reasonTA = new TextFieldHasKeyboard();
			reasonTA.width = 510;reasonTA.height = 45;
			reasonTA.x = 745;reasonTA.y = 590;
			reasonTA.defaultTextFormat = tf;
			reasonTA.maxChars = 150;
			reasonTA.prompt = "请输入理由";
			reasonTA.restrict = "^`\/";
			this.addChild(reasonTA);
		}
	}
}