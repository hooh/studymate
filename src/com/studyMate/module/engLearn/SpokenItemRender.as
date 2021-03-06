package com.studyMate.module.engLearn
{
	import com.studyMate.world.component.IFlipPageRenderer;
	import com.studyMate.world.screens.WorldConst;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	internal class SpokenItemRender extends Sprite implements IFlipPageRenderer
	{
		public var pageNum:int;
		public var taskArr:Array;
		public var totalLen:int;
		public var totalPage:int;
		public var image:SpokenItem;
		
		public function SpokenItemRender(pageNum:int,taskArr:Array,totalPage:int)
		{
			this.pageNum = pageNum;
			this.taskArr = taskArr;
			this.totalLen = taskArr.length;
			this.totalPage = totalPage;
		}
		
		public function get view():DisplayObject
		{
			return this;
		}
		
		public function disposePage():void
		{
			removeChildren(0,-1,true);
		}
		
		public function displayPage():void
		{
			var curItem:int;
			var lineNum:int = 0;
			var title:String = "";
			if(pageNum < totalPage)
				lineNum = 2;
			else
				lineNum = (totalLen%10)/5+1;
			
			for (var j:int = 0; j < lineNum; j++) 
			{
				for (var k:int = 0; k < 5; k++) 
				{
					curItem = pageNum*10+(j*5+k);
					if(taskArr[curItem] == null)
						break;
					if(curItem < 9)
						title = pageNum.toString()+(curItem+1);
					else
						title = (curItem+1).toString();
					
					//image = new TaskItem(taskArr[curItem] as Object,title);
					image = new SpokenItem(title,taskArr[curItem]);
					image.x = 230+k*(image.width+39)*2-WorldConst.stageWidth>>1;
					image.y = 200+j*(image.height+25)*2-WorldConst.stageHeight>>1;
					addChild(image);
				}
			}
			flatten();	
		}
		
	
	}
}