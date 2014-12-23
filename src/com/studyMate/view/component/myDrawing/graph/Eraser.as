package com.studyMate.view.component.myDrawing.graph
{
	import com.studyMate.view.component.myDrawing.CreateDrawFactory;
	
	import flash.geom.Rectangle;

	public class Eraser extends GraphBase
	{
		protected var startX:Number;
		protected var startY:Number;
		protected var rect:Rectangle;
		
		public function Eraser(c:uint=0)
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
			rect = new Rectangle(startX,startY,xx - startX, yy - startY);
			CreateDrawFactory.backBmp.bitmapData.fillRect(rect,0);
		}
	}
}