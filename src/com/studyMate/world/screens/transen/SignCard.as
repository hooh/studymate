package com.studyMate.world.screens.transen
{
	import com.studyMate.utils.BitmapFontUtils;
	
	import starling.display.Image;
	import starling.display.Sprite;

	public class SignCard extends Sprite
	{
		private var bg:Image;
		public function SignCard(tname:String)
		{
			createBackground(tname);
		}
		
		
		public function createBackground(_tname:String):void{
			
			bg = new Image(BitmapFontUtils.getTexture(_tname));
			
			
			addChild(bg);
			
			
		}
		
	}
}