package com.studyMate.world.screens.component.drawGetWord
{
	import com.greensock.TweenLite;
	import myLib.myTextBase.TextFieldHasKeyboard;
	import com.studyMate.world.screens.component.drawGetWord.GridCore;
	
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import mx.utils.StringUtil;
	
	import fl.controls.Button;
	import fl.controls.ComboBox;
	
	public class ElementGrid extends GridCore
	{

		private var tf:TextFormat;
		
		public function ElementGrid()
		{
			oldColor = 0xDDDDDD;
			newColor = 0xAAAAAA;
			gap = 30;
			tf = new TextFormat(null,14);
		}
		

		
		
		override protected function  makeElement(str:String):Sprite{
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
			
			/*var btn1:Button = new Button();			
			btn1.label = " + ";
			btn1.x = 900;
			holder.addChild(btn1);
			btn1.addEventListener(MouseEvent.CLICK,addClickHandler);*/
			
			var myComboBox:ComboBox = new ComboBox();
			myComboBox.addItem({label:""});
			myComboBox.addItem({label:"名词性性从句"});
			myComboBox.addItem({label:"形容词性从句"});
			myComboBox.addItem({label:"副词性从句"});
			myComboBox.addEventListener(Event.CHANGE, changeHandler);
			myComboBox.x = 900
			holder.addChild(myComboBox);

			
			var btn2:Button = new Button();			
			btn2.label = " ↑ ";
			btn2.x = 1000;
			holder.addChild(btn2);
			btn2.addEventListener(MouseEvent.CLICK,UpChangeElement);
			
			var btn3:Button = new Button();			
			btn3.label = "进入分析";
			btn3.x = 1100;
			btn3.visible = false;
			holder.addChild(btn3);
			btn3.addEventListener(MouseEvent.CLICK,EnterAnalysisHandler);
			
			/*if(str=="简单句" || str=="从句"){
				var btn3:Button = new Button();			
				btn3.label = "成分";
				btn3.x = 1100;
				holder.addChild(btn3);
				//btn3.addEventListener(MouseEvent.CLICK,analyseHandler);
			}*/
			TweenLite.killDelayedCallsTo(delayFunction);
			TweenLite.delayedCall(0.2,delayFunction);
			
			function delayFunction():void{
				useKeyBoard = false;
				stage.focus = contentTextField;
			}
			function changeHandler(e:Event):void{
				var cb:ComboBox = e.currentTarget as ComboBox;
				var item:Object = cb.selectedItem;
				if(item.label!=""){
					btn3.visible = true;
				}else{
					btn3.visible = false;
				}
			}
						
			
			return holder;										
		}
		
	
		private function EnterAnalysisHandler(e:MouseEvent):void{
			var sp:Sprite = e.target.parent as Sprite;
			var txt:TextField = sp.getChildAt(1) as TextField;
			if(StringUtil.trim(txt.text)!="")
				this.dispatchEvent(new DataEvent(DataEvent.DATA,true,false,txt.text));
				
			
		}

		
	}
}