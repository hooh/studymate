package com.mylib.game.fightGame
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.model.vo.tcp.PackData;
	
	import feathers.controls.Scroller;
	import feathers.controls.supportClasses.LayoutViewPort;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	public class FightGameScroller extends Sprite
	{
		private var scroll:Scroller;
		private var viewPort:LayoutViewPort;
		private var myGameList:Vector.<FightGameVo>;
		
		public var rollIdx:int = -1;
		private var clickItem:FightGameItem;
		private var fightRollMediator:FightRollMediator;
		
		public function FightGameScroller()
		{
			super();
			fightRollMediator = Facade.getInstance(CoreConst.CORE).retrieveMediator(FightRollMediator.NAME) as FightRollMediator;
			
			scroll = new Scroller();
			scroll.width = 671;
			scroll.height = 545;
			
			viewPort = new LayoutViewPort();
			scroll.viewPort = viewPort;
			addChild(scroll);
			
		}

		
		public function removeAll():void{
			if(rollIdx == -1){
				viewPort.removeChildren(0,-1,true);
				return;
			}
			if(viewPort.numChildren > rollIdx)
				viewPort.removeChildAt(rollIdx);
			viewPort.removeChildren(0,-1,true);
		}
		public function addItem(_item:Sprite):void{//112
			if(viewPort.numChildren > 0){
				var preItem:DisplayObject = viewPort.getChildAt(viewPort.numChildren-1);
				_item.y = preItem.y + preItem.height + 14;
			}else
				_item.y = 0;
			viewPort.addChild(_item);
		}
		
		public function updateData(_myGameList:Vector.<FightGameVo>,_showRollIdx:int=-1,_reRender:Boolean=true):void{
			myGameList = _myGameList;
			//不需要重新刷新战斗列表，则只更新数据;
			if(!_reRender)
				return;
			
			removeAll();
			rollIdx = _showRollIdx;
			var item:FightGameItem;
			for(var i:int=0;i<myGameList.length;i++){
				//刷新非Roll界面
				if(i != _showRollIdx){

					item = new FightGameItem();
					addItem(item);
					item.updateData(myGameList[i]);
					
				}else{
					var myVo:FightGameDealVo = new FightGameDealVo(myGameList[i]);
					
					//战斗结束，并且自己看动画了，才跳进item视图
//					if(myGameList[i].fstatus.indexOf("Z") != -1 && mystatus == "R"){
					
					
					//战斗中-没观看动画   //战斗中，已经楚昭完
					if((myVo.fstatus != "B" && myVo.myStatus == "U") ||
						(myVo.fstatus == "B" && (myVo.myPoint1 != -1 && myVo.myPoint2 != -1 && myVo.myPoint3 != -1))){
						rollIdx = -1;
						item = new FightGameItem();
						addItem(item);
						item.updateData(myGameList[i]);
					}else{
						//显示战斗界面
						rollIdx = _showRollIdx;
						addItem(fightRollMediator.view);
						fightRollMediator.view.visible = true;
						fightRollMediator.updateData(myGameList[i]);
					}
				}
			}
		}
		public function showHistory():Boolean{
			if(!myGameList)
				return false;
			
			removeAll();
			var item:FightGameItem;
			for(var i:int=0;i<myGameList.length;i++){
				//如果是等待中的，或者第一回合的，则跳过历史记录显示
				if(myGameList[i].fstatus == "A" || myGameList[i].round == "1")
					continue;
				
				item = new FightGameItem();
				addItem(item);
//				item.updateData(myGameList[i]);
				item.showFightHistory(myGameList[i]);
			}
			return true;
		}
		
		
		
		
		
		public function showRollItem(_clickItem:FightGameItem):void{
			clickItem = _clickItem;
			var _clickIdx:int = -1;
			
			for (var i:int = 0; i < viewPort.numChildren; i++) 
			{
				if(_clickItem == viewPort.getChildAt(i))
					_clickIdx = i;
			}
			
			updateData(myGameList,_clickIdx);
		}
		
		
		override public function dispose():void
		{
			super.dispose();
			removeChildren(0,-1,true);
		}
	}
}