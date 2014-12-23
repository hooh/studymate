package com.studyMate.world.screens.component.drawGetWord
{
	import com.studyMate.view.component.myScroll.Scroll;
	
	import fl.controls.Button;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class BaseAnalysisUI extends Sprite
	{
		private var masks:Sprite = new Sprite();
		private var grid:SentenceGrid;
		private var scroll:Scroll;
		private var temptf:TextField;
		private var tf:TextFormat; 
		
		public function BaseAnalysisUI(str:String = null)
		{
			masks.graphics.beginFill(0,0.8);
			masks.graphics.drawRect(0,0,1280,768);
			masks.graphics.endFill();
			
			tf = new TextFormat(null,40);
			temptf = new TextField();
			temptf.width = 1024;
			temptf.autoSize = TextFieldAutoSize.LEFT;
			temptf.wordWrap = true;
			temptf.multiline = true;
			temptf.defaultTextFormat = tf;
			if(str==null)
				temptf.text = "If you like spicy food, it is possible that hundreds of years ago, when there were no fridges, people in your country started using spices to keep the food from spoiling."	;								
			else 
				temptf.text = str;
			this.addChild(temptf);
			
			var edit:Button = new Button();
			edit.label = "编辑文本";
			edit.x = 1100;
			this.addChild(edit);
			edit.addEventListener(MouseEvent.CLICK,editHandler);
			
			var word:SentenceElement = new SentenceElement(false);
			word.y = 150;
			this.addChild(word);
			word.addEventListener(MouseEvent.CLICK,wordClickHandler);
			
			grid = new SentenceGrid();
			grid.DrawSentence(temptf);		
			
			scroll = new Scroll();
			scroll.y = 200;
			scroll.width = 1280;
			scroll.height = 550;			
			scroll.viewPort = grid;
			this.addChild(scroll);
						
		}
		
		private function wordClickHandler(e:MouseEvent):void
		{
			var btn:Button = e.target as Button;
			grid.addElement(btn.label);
			scroll.update();
		}
		
		private function editHandler(e:MouseEvent):void{
			this.addChild(masks);
			
			var txt:TextField = new TextField();
			txt.type = TextFieldType.INPUT;
			txt.width = 1024;
			txt.height = 500;
			txt.border = true;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.wordWrap = true;
			txt.multiline = true;
			var tf:TextFormat = new TextFormat(null,40,0xFFFFFF);
			txt.defaultTextFormat = tf;	
			txt.text = temptf.text
			this.addChild(txt);
			
			var btn:Button = new Button();
			btn.label = "编辑完成";
			btn.x = 500;
			btn.y = 516;
			this.addChild(btn);
			btn.addEventListener(MouseEvent.CLICK,complete);
			
			function complete(e:MouseEvent):void{
				temptf.text = txt.text;
				this.removeChild(masks);
				this.removeChild(txt);
				this.removeChild(btn);
			}
		}
		
	}
}