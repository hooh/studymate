package com.studyMate.module.game.gameEditor
{
	import com.studyMate.world.model.vo.DressSuitsVO;
	
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class DMManagItemRender extends Sprite
	{
		private var sexTF:TextField;
		
		public function DMManagItemRender()
		{
			super();

			sexTF = new TextField(60,30,"","arial",12,0xffffff);
			sexTF.hAlign = HAlign.LEFT;
			addChild(sexTF);
			
		}
		
		public function set data(_d:DressSuitsVO):void{
			
			
			sexTF.text = _d.sex;
			
		}
	}
}