package com.studyMate.world.screens.component.drawGetWord
{
	import com.studyMate.view.component.myDrawing.helpFile.IsLetter;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextLineMetrics;

	/**
	 * 屏幕画句子取得单词
	 * @author wangtu
	 * 
	 * 设定目标文本 MaintextField
	 * 设定接收文本	receive
	 * 
	 * 使用范例
	   DrawGetWord.getInstance().MaintextField = temptf;//画线文本
	   DrawGetWord.getInstance().receive = test;	//接收文本
	 * 
	 */	
	public class DrawGetWord
	{
		private var _MaintextField:TextField;
		private var _receive:TextField;
		private var BeginIndex:int;
		
		private var startChar:int;//因为上下滑动。starChar可变		
		private var endChar:int;		
		
		private var hasText:Boolean;
		
		private static var instance:DrawGetWord;
		
		public function DrawGetWord()
		{			

		}
		public static function getInstance():DrawGetWord{
			if (instance == null){
				instance = new DrawGetWord();
			}
			return instance as DrawGetWord;
		}
		
		private function addToStageHandler(e:Event):void{
			_MaintextField.removeEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
			_MaintextField.stage.addEventListener(MouseEvent.MOUSE_DOWN, startDraw);
		}		
		private function removeToStageHandler(e:Event):void{			
			_MaintextField.removeEventListener(Event.REMOVED_FROM_STAGE,removeToStageHandler);
			_MaintextField.stage.removeEventListener(MouseEvent.MOUSE_DOWN, startDraw);
			if(_MaintextField.stage.hasEventListener(MouseEvent.MOUSE_UP))	_MaintextField.stage.removeEventListener(MouseEvent.MOUSE_UP, stopDraw);
			if(_MaintextField.stage.hasEventListener(MouseEvent.MOUSE_MOVE))	_MaintextField.stage.removeEventListener(MouseEvent.MOUSE_MOVE, drawing);	
			instance = null;			
		}
		private function startDraw(e:MouseEvent):void{	
			if(_receive==null) return;
			startChar = _MaintextField.getCharIndexAtPoint(_MaintextField.mouseX,_MaintextField.mouseY);			
			if(startChar != -1){
				hasText = false;
				startChar =  IsLetter.search(_MaintextField.text,startChar,"Left");//第一个字符		
				_MaintextField.setSelection(startChar,startChar);
				_MaintextField.stage.addEventListener(MouseEvent.MOUSE_UP, stopDraw,false,3);
				_MaintextField.stage.addEventListener(MouseEvent.MOUSE_MOVE, drawing);
			}		
		}
		private function drawing(e:MouseEvent):void {//鼠标移动时，调用绘制对象的draw方法					
			var currentChar:int = _MaintextField.getCharIndexAtPoint(_MaintextField.mouseX,_MaintextField.mouseY);			
			if(currentChar != -1){
				hasText = true;
				if(currentChar != endChar){//滑动的是字符 && 字符不是老字符，则进入画线
					if(currentChar<startChar){	
						_MaintextField.setSelection(0,0);
						return;
				
					}else{
						endChar = currentChar;//则赋值
					}
					_MaintextField.setSelection(startChar,endChar);
				}
			}else{
				if(_MaintextField.hitTestPoint(_MaintextField.mouseX,_MaintextField.mouseY))
					hasText = true;
				else {
					hasText = false;//出界则取消所有特权
					startChar = -1;
				}
			}									
		}
		
		private function stopDraw(e:MouseEvent):void {
			_MaintextField.setSelection(0,0);
			if(hasText){	//Moveing过		
				var beginChar:int = IsLetter.search(_MaintextField.text,startChar,"Left");//第一个字符
				var finishChar:int = IsLetter.search(_MaintextField.text,endChar,"Right");	//最后一个字符
				//trace("获取文本="+_MaintextField.text.substring(beginChar,finishChar+1));

					var str:String = _MaintextField.text.substring(beginChar,finishChar+1)+" ";
					_receive.replaceText(BeginIndex,BeginIndex,str);
					BeginIndex +=  str.length;

			}else if(startChar!=-1){//直接点击
				finishChar = IsLetter.search(_MaintextField.text,startChar,"Right");	//最后一个字符
				//trace("获取文本="+_MaintextField.text.substring(startChar,finishChar+1));

					str = _MaintextField.text.substring(startChar,finishChar+1)+ " ";
					_receive.replaceText(BeginIndex,BeginIndex,str);
					BeginIndex +=  str.length;

			}			
			startChar = -1;
			_MaintextField.stage.removeEventListener(MouseEvent.MOUSE_UP, stopDraw);
			_MaintextField.stage.removeEventListener(MouseEvent.MOUSE_MOVE, drawing);		
		}	
		
		
		public function get receive():TextField
		{
			return _receive;
		}

		public function set receive(value:TextField):void
		{
			_receive = value;
			if(_receive==null) return;
			_receive.addEventListener(MouseEvent.MOUSE_UP,_receiveMouseUpHandler);
		}

		public function get MaintextField():TextField
		{
			return _MaintextField;
		}

		public function set MaintextField(value:TextField):void
		{
			_MaintextField = value;			
			if(_MaintextField.stage)	_MaintextField.stage.addEventListener(MouseEvent.MOUSE_DOWN, startDraw);
			else _MaintextField.addEventListener(Event.ADDED_TO_STAGE,addToStageHandler);					
			_MaintextField.addEventListener(Event.REMOVED_FROM_STAGE,removeToStageHandler);
		}
		private function _receiveMouseUpHandler(e:MouseEvent):void{
			BeginIndex = _receive.selectionBeginIndex;
		}
	}
}