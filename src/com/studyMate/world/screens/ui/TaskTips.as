package com.studyMate.world.screens.ui
{
	import com.byxb.utils.centerPivot;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class TaskTips extends Sprite
	{
		public var bg:Image;
		public var textField:TextField;

		public function TaskTips(_x:Number=0,_y:Number=0,text:String="null")
		{
			super();
			x = _x-12;
			y = _y-5;
			
			bg = new Image(Assets.getAtlasTexture("bg/taskNumBg"));
			centerPivot(bg);
			addChild(bg);
			
			textField = new TextField(37,37,"","HeiTi",20,0);
			addChild(textField);
			textField.x-=3;
			//textField.y-=5;
			textField.autoScale = true;
			textField.text = text;
			centerPivot(textField);
			
		}
	}
}