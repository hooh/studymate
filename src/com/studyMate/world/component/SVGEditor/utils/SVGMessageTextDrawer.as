package com.studyMate.world.component.SVGEditor.utils
{
	import com.lorentz.SVG.data.text.SVGDrawnText;
	import com.lorentz.SVG.data.text.SVGTextToDraw;
	import com.lorentz.SVG.text.ISVGTextDrawer;
	
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	
	public class SVGMessageTextDrawer implements ISVGTextDrawer
	{
		public function SVGMessageTextDrawer()
		{
		}
		
		public function start():void
		{
		}
		
		public function drawText(data:SVGTextToDraw):SVGDrawnText
		{
			var textField:TextField = new TextField();
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.text = data.text;
			textField.embedFonts = true;
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = 'HeiTi';
			textFormat.size = data.fontSize;
			textFormat.bold = data.fontWeight == "bold";
			textFormat.italic = data.fontStyle == "italic";
			textFormat.color = data.color;
			textFormat.letterSpacing = data.letterSpacing;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textField.setTextFormat(textFormat);
			
			var lineMetrics:TextLineMetrics = textField.getLineMetrics(0);
			
			return new SVGDrawnText(textField, textField.textWidth, 2, lineMetrics.ascent + 2);
		}
		
		public function end():void
		{
		}
	}
}