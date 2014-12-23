package com.studyMate.view.component.myDrawing.graph
{
	public class Ellipse extends GraphBase
	{
		protected var startX:Number;
		protected var startY:Number;
		
		public function Ellipse(c:uint = 0) 
		{
			super(c);			
		}
		
		override public function begin(xx:Number, yy:Number):void 
		{
			startX = xx;
			startY = yy;
		}
		
		override public function draw(xx:Number, yy:Number):void 
		{
			this.graphics.clear();
			this.graphics.lineStyle(2,color);
			this.graphics.drawEllipse(startX, startY, xx - startX, yy - startY);
		}
	}
}