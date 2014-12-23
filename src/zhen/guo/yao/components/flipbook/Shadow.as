package zhen.guo.yao.components.flipbook
{
	import flash.display.Sprite;
	import flash.geom.*
    import flash.display.*
	
	internal class Shadow extends Sprite 
	{		
		private var fillType:String = GradientType.LINEAR;
		private var colors:Array = [0x000000, 0xffffff];
		private var alphas:Array = [1, 0];
		private var ratios:Array = [0x00, 0xFF];
		private var matr:Matrix = new Matrix();
        private var spreadMethod:String = SpreadMethod.REFLECT;
		
		private var _shadowWidth:Number = 0.08;//阴影占pageWidth的比例
		
		public function Shadow():void
		{
			
		}
		//计算阴影的长度
		private function getLength(pageWidth:Number,pageHeight:Number):Number
		{
			return Math.sqrt(pageWidth * pageWidth+pageHeight * pageHeight);
		}
		//生成阴影
		//页面宽度、页面高度、是不是不动的阴影
		public function creat(pageWidth:Number,pageHeight:Number,isDown:Boolean):void
		{
			var length:Number
			if (isDown)
			{
				length = pageHeight;//以页面高度当做阴影长度
			}
			else
			{
				length = getLength(pageWidth, pageHeight);//以页面对角线长度当做阴影长度
			}
			matr.createGradientBox(pageWidth*_shadowWidth, pageWidth*_shadowWidth, 0, 0, 0);
			this.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);  
			this.graphics.drawRect(-pageWidth*_shadowWidth,-1*length/2,pageWidth*_shadowWidth*2,length);
		}
	}
	
}