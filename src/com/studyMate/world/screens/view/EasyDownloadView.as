package com.studyMate.world.screens.view
{
	import com.mylib.framework.utils.AssetTool;
	
	import fl.controls.RadioButton;
	import fl.controls.TextInput;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	
	public class EasyDownloadView extends Sprite
	{
		public var userName:TextInput;
		public var password:TextInput;
		public var confirm:SimpleButton;

		
		public var ipBtn4:RadioButton;
		public var ipBtn5:RadioButton;

		
		public function EasyDownloadView()
		{
			var skinClass:Class = AssetTool.getCurrentLibClass("EasyDownloadViewSkin");
			var ui:Sprite = new skinClass as Sprite;
			this.addChild(ui);
			userName = ui.getChildByName("userName") as TextInput;
			password = ui.getChildByName("password") as TextInput;
			confirm = ui.getChildByName("confirm") as SimpleButton;

			ipBtn4 = ui.getChildByName("ipBtn4") as RadioButton;
			ipBtn5 = ui.getChildByName("ipBtn5") as RadioButton;

		}
	}
}