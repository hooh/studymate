package com.studyMate.view.component
{
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class MyMCButton extends MCButton
	{
		public var _textFormat:TextFormat=null;				
		
		override public function setLabel(_label:String):void
		{
			// TODO Auto Generated method stub
			if(_label){
				label = _label;
				var txt:TextField = pic.getChildByName("txt") as TextField;
				if(txt){
					if(_textFormat){
						txt.embedFonts = true;
						txt.defaultTextFormat = _textFormat;
					}
					txt.text =  _label;
				}
				
			}
			
		}
		
		
	}
}