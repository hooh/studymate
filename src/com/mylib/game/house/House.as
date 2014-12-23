package com.mylib.game.house
{
	import com.studyMate.world.screens.ui.TaskTips;
	
	import starling.display.Sprite;
	import starling.extensions.PixelImageTouch;
	
	public class House extends Sprite
	{
		private var bg:PixelImageTouch;
		private var taskTips:TaskTips;
		

		public function House(_name:String,pixelImg:PixelImageTouch,_x:Number=0,_y:Number=0,isTaskTips:Boolean=true,taskNum:String="")
		{
			super();
			name = _name;
			x = _x;
			y = _y;
			
			bg = pixelImg;
			bg.pivotY = bg.height;
			bg.y = bg.height;
			addChild(bg);
			
			
			if(isTaskTips){
				taskTips = new TaskTips((bg.width*2)/3,0,taskNum);
				addChild(taskTips);
			}
			
			pivotX = width/2;
			pivotY = height;
			
			
			
		}
		
		
		
		override public function dispose():void
		{
			super.dispose();
			
			removeChildren(0,-1,true);
		}
	}
}