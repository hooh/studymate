package com.mylib.framework.component
{
	import starling.display.Quad;
	import starling.text.TextField;

	public class DefaultItem extends ItemRenderer
	{
		private var text:TextField;
		public function DefaultItem()
		{
			super();
			
			var bg:Quad = new Quad(400,80,0xffffff);
			bg.alpha = 0.3;
			
			addChild(bg);
			
			text = new TextField(100,40,"");
			addChild(text);
			
		}
		
		override public function set data(_d:*):void
		{
			// TODO Auto Generated method stub
			super.data = _d;
			
			text.text = _d;
			
		}
		
	}
}