package myLib.myTextBase.Keyboard
{
	import myLib.myTextBase.interfaces.ITextInput;
	import myLib.myTextBase.utils.KeyBoardConst;
	
	import flash.display.Sprite;
	
	public class AbstractKeyboard extends Sprite
	{
		protected var _type:String;
		protected var _iTextInput:ITextInput;
		protected var _backgroundColor:uint;
		
		private var _hasKeyboard:Boolean;
		
		
		
		public function AbstractKeyboard()
		{
			super();
		}
		
		public function get backgroundColor():uint
		{
			return _backgroundColor;
		}

		public function set backgroundColor(value:uint):void
		{
			_backgroundColor = value;
		}

		public function get hasKeyboard():Boolean
		{
			return _hasKeyboard;
		}
		
		public function set hasKeyboard(value:Boolean):void
		{
			_hasKeyboard = value;
		}
		
		
		/**________________键盘类型_______________*/		
		public function get type():String
		{
			return _type;
		}
		
		public function set type(value:String):void
		{
			_type = value;
		}
		
		/**________________接收文字信息的文本框_______________*/			 	
		public function get iTextInput():ITextInput{
			return KeyBoardConst.current_Textinput;
		}
		public function set iTextInput(value:ITextInput):void{
			_iTextInput = value;			
		}
		
		/**-------------------------------插入中文-------------------------------------*/
		public function InsertChinese(chineseArr:Array):void{
			
		}
	}
}