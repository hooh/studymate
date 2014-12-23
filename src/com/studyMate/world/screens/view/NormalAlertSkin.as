package com.studyMate.world.screens.view
{
	import com.mylib.framework.utils.AssetTool;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class NormalAlertSkin extends Sprite
	{
		public var closeBtn:Sprite;
		public var yesBtn:Sprite
		public var noBtn:Sprite;
		
		public var bg:Sprite;
		
		public function NormalAlertSkin()
		{
			var bgClass:Class =  AssetTool.getCurrentLibClass("EduAlert_Background");
			bg = (new bgClass) as Sprite;
			addChild(bg);
		}				
	}
}