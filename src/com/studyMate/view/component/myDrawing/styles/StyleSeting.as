package com.studyMate.view.component.myDrawing.styles
{
	import com.studyMate.view.component.myDrawing.helpFile.IsLetter;
	
	import flash.text.TextField;
	import flash.text.TextFormat;

	internal class StyleSeting extends StyleBase
	{
		private var hasUnderLineTextformat:TextFormat;//有下划线
		
		public function StyleSeting(target:TextField,type:String)
		{
			super(target);
			switch(type){
				case TypeFormat.hasUnderLine :
					hasUnderLineTextformat = new TextFormat(null,null,null,null,null,true);
					break;
				case TypeFormat.noUnderLine:
					hasUnderLineTextformat = new TextFormat(null,null,null,null,null,false);
					break;
				case TypeFormat.color:
					hasUnderLineTextformat = new TextFormat(null,null,0x0000FF);

					break;
			}
			
		}
		
		override public function begin(xx:Number, yy:Number):void
		{
			super.begin(xx,yy);			
		}
		
		override public function draw(xx:Number, yy:Number):void
		{
			super.draw(xx,yy);
			if(flag){
				//trace("这个currentChar="+currentChar);
				if(currentChar!=-1){
					textField.setTextFormat(hasUnderLineTextformat,currentChar,currentChar+1);
				}				
			}			
		}
		
		override public function end():void
		{
			if(flag){
				if(startChar>endChar){
					var temp:int = _startChar;
					_startChar = endChar;
					endChar = temp;
				}
																				
				var _start:int = IsLetter.search(textField.text,startChar,"Left");
				//trace("开始的char="+startChar);
				//trace("测试的头="+ _start);
				
				
				var _end:int = IsLetter.search(textField.text,endChar,"Right");
				//trace("结束的Char="+endChar);
				//trace("测试的尾="+ _end);
				
				textField.setTextFormat(hasUnderLineTextformat,_start,_end+1);
				_flag = false;
			}			
		}
		
		
	}
}