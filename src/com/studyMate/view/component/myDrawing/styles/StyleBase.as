package com.studyMate.view.component.myDrawing.styles
{
	import flash.text.TextField;
	
	public class StyleBase
	{
		protected var textField:TextField;
		protected var _startChar:int;	//开始的字符,可能为-1；
		protected var currentChar:int;//当前的字符；
		protected var endChar:int;		//结束的字符，一定不为-1；
		protected var _flag:Boolean;	//是否绘画过
		
		public function StyleBase(target:TextField)
		{
			textField = target;
		}
		
		public function begin(xx:Number, yy:Number):void
		{
			_startChar=-1;
			endChar=-1;
			_startChar = textField.getCharIndexAtPoint(xx,yy);//开始的字符
		}
		
		public function draw(xx:Number, yy:Number):void
		{
			//trace("currentChar = "+currentChar);
			currentChar = textField.getCharIndexAtPoint(xx,yy);
			if(currentChar!=_startChar){
				if(currentChar!=-1 && currentChar != endChar){
					_flag=true;
					endChar = currentChar;
				}
			}	
			//trace("------------------------------- ");
		}
		public function end():void
		{
			
		}						

		public function get startChar():int
		{
			return _startChar;
		}

		public function get flag():Boolean
		{
			return _flag;
		}


	}
}