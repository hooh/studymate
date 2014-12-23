package zhen.guo.yao.components.flipbook 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author yaoguozhen
	 */
	internal class StaticMask extends Sprite 
	{
		
		public function StaticMask():void
		{
		   
		}
		public function draw(pageWidth:Number,pageHeight:Number,startCorner:String, dPoint:Point, bPoint:Point, aPoint:Point = null):void
		{
			graphics.clear();
			graphics.beginFill(0x00ff00);
			graphics.moveTo(dPoint.x, dPoint.y);
			graphics.lineTo(bPoint.x, bPoint.y);
			
			if(aPoint!=null)//如果没有a点
			{
				switch(startCorner)
				{
					case HotName.RIGHT_UP:
					     graphics.lineTo(pageWidth, pageHeight);
					     graphics.lineTo(pageWidth, 0);
					    break;
					case HotName.RIGHT_DOWN:
					     graphics.lineTo(pageWidth, 0);
					     graphics.lineTo(pageWidth, pageHeight);
					    break;	
					case HotName.LEFT_UP:
					     graphics.lineTo(0, pageHeight);
					     graphics.lineTo(0, 0);
					    break;	
					case HotName.LEFT_DOWN:
					     graphics.lineTo(0, 0);
					     graphics.lineTo(0, pageHeight);
					    break;	
				}
			}
			else
			{
				switch(startCorner)
				{
					case HotName.RIGHT_UP:
					     graphics.lineTo(pageWidth, 0);
					    break;
					case HotName.RIGHT_DOWN:
					     graphics.lineTo(pageWidth, pageHeight);
					    break;	
					case HotName.LEFT_UP:
					     graphics.lineTo(0, 0);
					    break;	
					case HotName.LEFT_DOWN:
					     graphics.lineTo(0, pageHeight);
					    break;	
				}
			}
		}
		public function clear():void
		{
			graphics.clear();
		}
	}

}