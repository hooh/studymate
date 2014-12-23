package com.studyMate.view.component.myDrawing.graph
{
	public class SLine extends GraphBase
	{
		private var px1:Number;
		private var py1:Number;
		
		public function SLine(c:uint=0)
		{
			super(c);
		}
		
		override public function begin(xx:Number, yy:Number):void 
		{
			px1 = xx;
			py1 = yy;
		}
		
		override public function draw(xx:Number, yy:Number):void 
		{
			this.graphics.clear();
			this.graphics.lineStyle(2, color);
			this.graphics.moveTo(px1,py1);
			this.graphics.lineTo(xx,yy);			
		}
	}
}