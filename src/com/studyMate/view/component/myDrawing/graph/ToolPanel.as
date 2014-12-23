package com.studyMate.view.component.myDrawing.graph
{
	import flash.geom.Rectangle;

	public final class ToolPanel
	{
		public static const SLINE:int = 0;
		public static const WAVELINE:int = 1;
		public static const ROUNDRECT:int = 2;
		public static const RECT:int = 3;
		public static const ELLIPSE:int = 4;
		public static const ERASER:int = 5;
		
		
		private static var _currentTool:int = ToolPanel.SLINE;//当前的工具
		
		
		/**
		 * 用来根据选择的工具ID得到向对应的绘制对象的类
		 * 比如0代表线条，其对应的绘制对象类为graph.Line类
		 * 所有的id都在ToolPanel中定义了对应的静态常量
		 */	
		public static function getClassByTool(toolID:int):Class {			
			switch(toolID) {
				case ToolPanel.SLINE:
					return SLine;
					break;
				case ToolPanel.WAVELINE:
					return WaveLine;
					break;3
				case ToolPanel.RECT:
					return Rect;
					break;
				case ToolPanel.ROUNDRECT:
					return RoundRect;
					break;
				case ToolPanel.ELLIPSE:
					return Ellipse;
					break;
				case ToolPanel.ERASER:
					return Eraser;
				default:
					return SLine;
			}
		}
		
		/**
		 *绘制图形的起点 
		 * @param rect 字符的矩形框
		 * @param type 产品,传入该类的静态常量
		 * @return 起点的Y坐标
		 * 
		 */		
		public static function getStartY(rect:Rectangle):Number{
			var numY:Number;
			switch(currentTool){
				case ToolPanel.RECT:
					numY = rect.y;
					break;
				case ToolPanel.SLINE:
					numY = rect.y+rect.height;
					break;
				case ToolPanel.ELLIPSE:
					numY = rect.y;
					break;
				case ToolPanel.ROUNDRECT:
					numY = rect.y;
					break;
				case ToolPanel.WAVELINE:
					numY = rect.y+rect.height-10;
					break;
				case ToolPanel.ERASER:
					numY = rect.y-1;
					break;
				default:
					numY = rect.y+rect.height;
					break;
			}
			return numY;
		}
		
		/**
		 * 绘制图形的重点
		 * @param rect 
		 * @param product
		 * @return 终点的Y坐标
		 * 
		 */		
		public static function getEndY(rect:Rectangle):Number{
			var numY:Number;
			switch(currentTool){
				case ToolPanel.RECT:
					numY = rect.y+rect.height;
					break;
				case ToolPanel.SLINE:
					numY = rect.y+rect.height;
					break;
				case ToolPanel.ELLIPSE:
					numY = rect.y+rect.height;
					break;
				case ToolPanel.ROUNDRECT:
					numY = rect.y+rect.height;
					break;
				case ToolPanel.WAVELINE:
					numY = rect.y+rect.height;
					break;
				case ToolPanel.ERASER:
					numY = rect.y + rect.height+1;
					break;
				default:
					numY = rect.y+rect.height;
					break;
			}
			return numY;
		}

		public static function get currentTool():int
		{
			return _currentTool;
		}

		public static function set currentTool(value:int):void
		{
			if(value>-1 && value < 6){
				_currentTool = value;
			}			
		}

	}
}