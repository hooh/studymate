package com.studyMate.world.screens.view
{
	import com.mylib.framework.utils.AssetTool;
	
	import flash.display.Sprite;
	
	public class WifiAlertSkin extends Sprite
	{

		public var bg:Sprite;
		
		public function WifiAlertSkin()
		{
			var bgClass:Class =  AssetTool.getCurrentLibClass("EduAlert_Wifigroup");
			bg = (new bgClass) as Sprite;
			addChild(bg);
		}
	}
}