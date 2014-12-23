package myLib.myTextBase.extendsFeather
{
	import flash.text.TextField;
	
	import feathers.core.ITextEditor;
	
	public interface ItextEditorExtends extends ITextEditor
	{
		function get selectionAnchorPosition():int;
		function get selectionActivePosition():int;
		function insertText(value:String):void;
		
		function get stageTextField():StageTextFieldExtends;
		function get measureTextField():TextField;
		
		
		
	}
}