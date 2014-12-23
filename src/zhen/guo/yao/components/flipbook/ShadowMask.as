package zhen.guo.yao.components.flipbook 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author yaoguozhen
	 */
	internal class ShadowMask extends Sprite 
	{
		
		public function ShadowMask() :void
		{
			
		}
		public function creat(pageWidth:Number,pageHeight:Number):void
		{
			this.graphics.beginFill(0x0000ff); 
			this.graphics.drawRect(0,0,pageWidth,pageHeight);
		}
		
	}

}