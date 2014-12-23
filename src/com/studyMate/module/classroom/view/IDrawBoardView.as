package com.studyMate.module.classroom.view
{
	import flash.display.IGraphicsData;
	
	/**
	 * 实现画板界面接口
	 * 2014-6-4上午10:12:48
	 * Author wt
	 *
	 */	
	
	public interface IDrawBoardView
	{
		function get stroke_color():uint;
		function get stroke_size():uint;
		
		function get readGraphicsData():Vector.<IGraphicsData>	;
		function set drawGraphicsData(graphicsData:Vector.<IGraphicsData>):void;
	}
}