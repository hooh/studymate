package com.studyMate.world.component.AndroidGame.GameMarket
{
	import com.studyMate.world.component.IFlipPageRenderer;
	import com.studyMate.world.component.AndroidGame.AndroidGameVO;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	public class GameMarketPage extends Sprite implements IFlipPageRenderer
	{
		private var itemList:Vector.<AndroidGameVO> = new Vector.<AndroidGameVO>;
		
		public function GameMarketPage()
		{
			
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
			var item:GameMarketItem;
			for(var i:int=0;i<itemList.length;i++){
				
//				trace(itemList[i].gameName);
				
				item = new GameMarketItem(itemList[i]);
				item.x = 66 + 241 * (int(i%5)) -640;
				item.y = 138 + 125 * (int(i/5))-381;
				addChild(item);
			}
			
		}
		
		
		public function addItem(_vo:AndroidGameVO, _isRender:Boolean=true):void{
			
			itemList.push(_vo);
			
			
			if(_isRender){
				var item:GameMarketItem = new GameMarketItem(_vo);
				item.x = 66 + 241 * (int((itemList.length-1)%5)) -640;
				item.y = 138 + 125 * (int((itemList.length-1)/5))-381;
				addChild(item);
			}
		}
	}
}