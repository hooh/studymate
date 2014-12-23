package com.studyMate.world.pages
{
	import com.studyMate.world.component.IFlipPageRenderer;
	import com.studyMate.world.screens.WorldConst;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	public class TaskPerforPage extends Sprite implements IFlipPageRenderer
	{
		private var pageNum:int;
		private var taskPerforArr:Array;
		private var totalLen:int;
		private var totalPage:int;
		private var cellLen:int;
		private var image:TaskPerItem;
		
		public function TaskPerforPage(pageNum:int,taskPerforArr:Array,cellLen:int,totalPage:int){
			this.pageNum = pageNum;
			this.taskPerforArr = taskPerforArr;
			this.cellLen = cellLen;
			this.totalLen = taskPerforArr.length/cellLen;
			this.totalPage = totalPage;
		}
		
		public function get view():DisplayObject{
			return this;
		}
		
		public function disposePage():void{
			removeChildren(0,-1,true);
		}
		
		public function displayPage():void{
			var curItem:int;
			var lineNum:int = 0;
			if(pageNum < totalPage){
				lineNum = 2;
			}else{
				lineNum = (totalLen%10)/5 + 1;
			}
			for(var i:int=0; i<lineNum; i++){
				for(var j:int=0; j<5; j++){
					curItem = (pageNum * 10 + i * 5 + j) * cellLen;
					if(taskPerforArr[curItem] == null) break;
					var rrl:String = taskPerforArr[curItem].toString();
					var timeBegin:String = taskPerforArr[curItem+1].toString();
					var learnSec:String = taskPerforArr[curItem+2].toString();
					var rightNum:String = taskPerforArr[curItem+3].toString();
					var totalNum:String = taskPerforArr[curItem+4].toString();
					image = new TaskPerItem(rrl,timeBegin,learnSec,rightNum,totalNum);
					image.x = 230+j*(image.width+39)*2-WorldConst.stageWidth>>1;
					image.y = 330+i*(image.height+25)*2-WorldConst.stageHeight>>1;
					addChild(image);
				}
			}
			flatten();
		}
	}
}