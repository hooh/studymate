package com.studyMate.world.screens.component.drawGetWord
{
	import com.greensock.TweenLite;
	import myLib.myTextBase.TextFieldHasKeyboard;
	
	import fl.controls.Button;
	
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import com.studyMate.world.screens.component.drawGetWord.GridCore;
	
	public class SentenceGrid extends GridCore
	{
		private var tf:TextFormat;
		
		public function SentenceGrid()
		{
			oldColor = 0xDDDDDD;
			newColor = 0xAAAAAA;
			tf = new TextFormat(null,14);
		}
		
		/**----------成分分析----------------*/
		private function analyseHandler(e:MouseEvent):void{
			var holder:Sprite = e.target.parent as Sprite;
			var i:int = this.getChildIndex(holder);	//下标
			e.target.mouseEnabled = false;
			var chenfenSp:Sprite = new Sprite();
			chenfenSp.y = holder.height+10;
			
			var word:WordElement = new WordElement();
			word.x = 36;
			chenfenSp.addChild(word);
			var grid:ElementGrid = new ElementGrid();
			grid.y = 36;		
			grid.x = 36;
			chenfenSp.addChild(grid);
			
			word.addEventListener(MouseEvent.CLICK,wordClickHandler);
			function wordClickHandler(e:MouseEvent):void{
				var btn:Button = e.target as Button;
				grid.addElement(btn.label);
								
				chenfenSp.graphics.clear();
				chenfenSp.graphics.beginFill(0xAAAAAA);
				chenfenSp.graphics.drawRect(0,0,1200,chenfenSp.height);
				chenfenSp.graphics.endFill();
				
				refreshScreen(i);
			}
			holder.addChild(chenfenSp);
		}
		
		
		
		override protected function makeElement(str:String):Sprite
		{
			var holder:Sprite = new Sprite();
			var headTextField:TextField = new TextField();
			headTextField.height = 50;
			headTextField.autoSize = TextFieldAutoSize.LEFT;
			headTextField.text = str;
			holder.addChild(headTextField);
			
			var contentTextField:TextFieldHasKeyboard = new TextFieldHasKeyboard();
			contentTextField.width = 650;
			contentTextField.height = 50;
			contentTextField.wordWrap = true;
			contentTextField.multiline = true;
			contentTextField.x = 140;
			contentTextField.border  = true;
			contentTextField.defaultTextFormat = tf;
			contentTextField.addEventListener(FocusEvent.FOCUS_IN,focusInHandler,false,2);
			//contentTextField.addEventListener(FocusEvent.FOCUS_OUT,focusOutHandler);
			holder.addChild(contentTextField);
			
			var btn:Button = new Button();			
			btn.label = "删除";
			btn.x = 800;
			holder.addChild(btn);
			btn.addEventListener(MouseEvent.CLICK,removeElement);
			
			var btn1:Button = new Button();			
			btn1.label = " + ";
			btn1.x = 900;
			holder.addChild(btn1);
			btn1.addEventListener(MouseEvent.CLICK,insertElement);
			
			var btn2:Button = new Button();			
			btn2.label = " ↑ ";
			btn2.x = 1000;
			holder.addChild(btn2);
			btn2.addEventListener(MouseEvent.CLICK,UpChangeElement);
			
			if(str=="简单句" || str=="从句"){
				var btn3:Button = new Button();			
				btn3.label = "成分";
				btn3.x = 1100;
				holder.addChild(btn3);
				btn3.addEventListener(MouseEvent.CLICK,analyseHandler);
			}
			TweenLite.killDelayedCallsTo(delayFunction);
			TweenLite.delayedCall(0.2,delayFunction);
			
			function delayFunction():void{
				useKeyBoard = false;
				stage.focus = contentTextField;
				trace("holder.height = "+holder.height);
			}
			
			return holder;
		}
		
	}
}