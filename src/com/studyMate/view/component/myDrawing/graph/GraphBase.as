package com.studyMate.view.component.myDrawing.graph
{
	
	
	import flash.display.Sprite;
	
	/**
	 * 定义各种绘制图形的基类
	 * 所有绘制的形状都继承自此类，并重写了begin方法和draw方法
	 * begin在开始画线时调用，draw在鼠标移动画线时不停调用
	 */
	
	public class GraphBase extends Sprite
	{
		protected var color:uint;
		
		public function GraphBase(c:uint = 0) 
		{
			color = c;
			this.mouseEnabled = false;
			this.mouseChildren = false;
			
			//DrawType.registerGraphBase(this);
			
		}
		
		public function begin(xx:Number, yy:Number):void { }
		
		public function draw(xx:Number, yy:Number):void { }
		
	}
}