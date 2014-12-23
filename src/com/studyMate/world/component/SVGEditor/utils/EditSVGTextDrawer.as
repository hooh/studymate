package com.studyMate.world.component.SVGEditor.utils
{
	import com.lorentz.SVG.data.text.SVGDrawnText;
	import com.lorentz.SVG.data.text.SVGTextToDraw;
	import com.lorentz.SVG.text.ISVGTextDrawer;
	
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	
	/**
	 * SVG textField文本解释类
	 * @author wangtu
	 * 
	 */	
	public class EditSVGTextDrawer implements ISVGTextDrawer
	{
		public function EditSVGTextDrawer()
		{
		}
		
		public function start():void
		{
		}
		
		public function drawText(data:SVGTextToDraw):SVGDrawnText
		{
			var textField:TextField = new TextField();
			textField.mouseEnabled = false;
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.wordWrap = true;
			textField.multiline = true;
			textField.embedFonts = true;
			
			textField.width = data.width;
			var textFormat:TextFormat = new TextFormat();
//			textFormat.font = data.fontFamily;
			textFormat.font = "HeiTi";
			textFormat.size = data.fontSize;
//			textFormat.bold = data.fontWeight;
//			textFormat.italic = data.fontStyle;
			textFormat.color = data.color;
			textFormat.letterSpacing = data.letterSpacing;
			textField.defaultTextFormat = textFormat;
			textField.embedFonts = true;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			var temp:String = data.text;
			temp = 	temp.replace(/<br\/>/g,"\n")
			textField.text = temp;
			
			return new SVGDrawnText(textField, data.width, 0, 0);
		}
		
		public function end():void
		{
//			trace("end");
		}
	}
}