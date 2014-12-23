package com.studyMate.world.pages
{
	import com.studyMate.world.component.IFlipPageRenderer;
	import com.studyMate.world.model.vo.GameListInfoVO;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	public class GameMarketPage extends Sprite implements IFlipPageRenderer
	{
		public var pageNum:int;
		public var glist:Vector.<GameListInfoVO>;
		public var totalLen:int;
		public var totalPage:int;
		public var image:GameMarketItem;
		
		public function GameMarketPage(pageNum:int,glist:Vector.<GameListInfoVO>,totalPage:int)
		{
			this.pageNum = pageNum;
			this.glist = glist;
			this.totalLen = glist.length;
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
			if(pageNum < totalPage)
				lineNum = 4;
			else
				lineNum = (totalLen%20)/5+1;
			for (var j:int = 0; j < lineNum; j++) 
			{
				for (var k:int = 0; k < 5; k++) 
				{
					curItem = pageNum*20+(j*5+k);
					if(curItem >= totalLen)
						break;
					image = new GameMarketItem(glist[curItem] as GameListInfoVO);
					image.x = (158+216*k)-640;
					image.y = (129+144*j)-381;
					
					addChild(image);
				}
			}
//			flatten();
		}
	}
}