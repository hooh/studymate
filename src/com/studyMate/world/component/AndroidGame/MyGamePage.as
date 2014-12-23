package com.studyMate.world.component.AndroidGame
{
	import com.studyMate.world.component.IFlipPageRenderer;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	public class MyGamePage extends Sprite implements IFlipPageRenderer
	{
		private var itemList:Vector.<AndroidGameVO> = new Vector.<AndroidGameVO>;
		
		public function MyGamePage()
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
			
			var item:MyGameItem;
			for(var i:int=0;i<itemList.length;i++){
//				trace(itemList[i].gameName);
				item = new MyGameItem(itemList[i]);
				item.x = 66 + 177 * (int(i%7)) -640;
				item.y = 138 + 190 * (int(i/7))-381;
				addChild(item);
			}
			showDel(delStat);
		}
		
		
		public function addItem(_vo:AndroidGameVO, _isRender:Boolean=true):void{
			itemList.push(_vo);
			
			if(_isRender){
				var item:MyGameItem = new MyGameItem(_vo);
				item.x = 66 + 177 * (int((itemList.length-1)%7)) -640;
				item.y = 138 + 190 * (int((itemList.length-1)/7))-381;
				addChild(item);
			}
			
		}
		
		private var delStat:Boolean = false;;
		public function showDel(_isshow:Boolean):void{
			delStat = _isshow;
			for(var i:int=0;i<numChildren;i++){
				
				(getChildAt(i) as MyGameItem).showDelBtn(_isshow);
				
				
			}
			
		}
	}
}