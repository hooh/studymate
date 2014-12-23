package com.studyMate.world.screens.menu
{
	import com.studyMate.world.component.IFlipPageRenderer;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;

	public class MenuPage extends Sprite implements IFlipPageRenderer
	{
		public var pageNum:Array;
		public var totalPage:int;
		
		public function MenuPage(pageNum:Array,totalPage:int)
		{
			this.pageNum = pageNum;
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
		
			for(var i:int = 0;i<pageNum.length;i++){
				if(i<4){
					pageNum[i].x = -450 + 250*i;
					pageNum[i].y = -200;
				}else{
					pageNum[i].x = -450 + 250*(i-4);
					pageNum[i].y = 100;
				}
				addChild(pageNum[i]);
	
			}
		}
	}
}