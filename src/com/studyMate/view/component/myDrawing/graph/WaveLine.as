package com.studyMate.view.component.myDrawing.graph
{
	import com.mylib.framework.utils.AssetTool;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;

	public class WaveLine extends GraphBase
	{
		protected var startX:Number;
		protected var startY:Number;
		private var matrix:Matrix;
		private var bmd:BitmapData;
		
		public function WaveLine(c:uint=0)
		{
			super(c);
			var waveLineClass:Class=AssetTool.getCurrentLibClass("draw_wave_line.png");
			
			bmd = new waveLineClass as BitmapData;
			matrix = new Matrix();
		}
		
		override public function begin(xx:Number, yy:Number):void 
		{
			startX = xx;
			startY = yy;
		}
		
		override public function draw(xx:Number, yy:Number):void 
		{
			if(bmd){
				this.graphics.clear();
				trace("高度 = "+ (yy - startY));
				this.graphics.beginBitmapFill(bmd,matrix,true);
				this.graphics.drawRect(startX, startY, xx - startX, yy - startY);	
			}			
		}
	}
}