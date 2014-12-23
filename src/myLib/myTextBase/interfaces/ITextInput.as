package myLib.myTextBase.interfaces
{
	

	public interface ITextInput 
	{
		function set prompt(str:String):void
		//是否正在使用软键盘,true为是
		function get useKeyboard():Boolean;
		//设定是否使用软键盘，true为使用
		function set useKeyboard(value:Boolean):void;
		//设定最大字符数
		function set maxChars(value:int):void;//最大字符数
		function get maxChars():int;
		//设定焦点
		function setFocus():void;//焦点
		//插入文本
		function insertText(value:String):void;
		//相对于 text 字符串开头的字符位置
		function get selectionAnchorPosition():int;
		//当前焦点
		function get selectionActivePosition():int;
		//选择指定范围的字符
//		function selectRange(value:int,value1:int=-1):void;
		function selectTextRange(startIndex:int, endIndex:int = -1):void
		//文本
		function get text():String;
		function set text(value:String):void;	
		
		
	}
}