package com.studyMate.module.game
{
	import com.byxb.utils.centerPivot;
	import com.mylib.game.charater.item.DressMarketItem;
	import com.mylib.game.charater.item.EquipItemBg;
	import com.mylib.game.fightGame.CircleChart;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.world.model.vo.DressSeriesItemVO;
	import com.studyMate.world.model.vo.DressSuitsVO;
	
	import feathers.controls.PageIndicator;
	import feathers.controls.ScrollContainer;
	import feathers.layout.TiledRowsLayout;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class DressMarketScroller extends Sprite
	{
		private var layout:TiledRowsLayout;
		private var container:ScrollContainer;
		private var equipCircle:CircleChart;
		
		private var equipContainer:ScrollContainer;
		
		//服装数据
		private var dressSuitsVoList:Vector.<DressSuitsVO>;
		
		public function DressMarketScroller(_dressSuitsVoList:Vector.<DressSuitsVO>)
		{
			super();
			
			dressSuitsVoList = _dressSuitsVoList;
			/*var len:int = dressSuitsVoList.length;
			for(var i:int=0;i<len;i++){
				dressSuitsVoList.push(dressSuitsVoList[i]);
			}
			var len2:int = dressSuitsVoList.length;
			for(i=0;i<len2;i++){
				dressSuitsVoList.push(dressSuitsVoList[i]);
			}
			var len3:int = dressSuitsVoList.length;
			for(i=0;i<len3;i++){
				dressSuitsVoList.push(dressSuitsVoList[i]);
			}*/
			
			
			createContainer();
			
			
			//装备预览圈
			equipCircle = new CircleChart;
		}
		private var pageIndicator:PageIndicator;
		private var preBtn:Button;
		private var nextBtn:Button;
		private function createContainer():void{
			layout = new TiledRowsLayout();
			layout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			layout.gap = 10;
			layout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_LEFT;
			layout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_TOP;
			layout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_CENTER;
			layout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_MIDDLE;
			layout.useSquareTiles = false;
			
			container = new ScrollContainer();
			container.layout = layout;
			container.snapScrollPositionsToPixels = true;
			container.snapToPages = true;
			container.x = 43;
			container.width = 765;
			container.height = 591;
			addChild(container);
			container.addEventListener(Event.SCROLL,containerChangeHandle);
//			container.isEnabled = false;
			
			equipContainer = new ScrollContainer();
			equipContainer.layout = layout;
			equipContainer.snapScrollPositionsToPixels = true;
			equipContainer.snapToPages = false;
			equipContainer.x = 43;
			equipContainer.width = 775;
			equipContainer.height = 611;
			addChild(equipContainer);
			equipContainer.touchable = false;
			
			
			pageIndicator = new PageIndicator();
			addChild(pageIndicator);
			pageIndicator.width = 100;
			centerPivot(pageIndicator);
			pageIndicator.x = 428;
			pageIndicator.y = 590;
			pageIndicator.direction = PageIndicator.DIRECTION_HORIZONTAL;
			pageIndicator.gap = 3;
			pageIndicator.touchable = false;
			pageIndicator.normalSymbolFactory = function():DisplayObject{
				return new Image(Assets.getDressSeriesTexture("DressMarket/pageIndicator00"));};
			pageIndicator.selectedSymbolFactory = function():DisplayObject{
				return new Image(Assets.getDressSeriesTexture("DressMarket/pageIndicator01"));};
			
			preBtn = new Button(Assets.getDressSeriesTexture("DressMarket/derectBtn"));
			preBtn.name = "preBtn";
			preBtn.y = 244;
			preBtn.visible = false;
			addChild(preBtn);
			preBtn.addEventListener(Event.TRIGGERED,derectHandle);
			
			nextBtn = new Button(Assets.getDressSeriesTexture("DressMarket/derectBtn"));
			nextBtn.name = "nextBtn";
			nextBtn.scaleX = -1;
			nextBtn.x = 845;
			nextBtn.y = 244;
			nextBtn.visible = false;
			addChild(nextBtn);
			nextBtn.addEventListener(Event.TRIGGERED,derectHandle);
			
			
		}
		private function derectHandle(e:Event):void{
			preBtn.visible = false;
			nextBtn.visible = false;
			
			var clickBtn:Button = e.target as Button;
			if(clickBtn.name == "preBtn"){
				if(container.horizontalPageIndex > 0){
					container.scrollToPageIndex(container.horizontalPageIndex-1,0,0);
					
					preBtn.visible = (container.horizontalPageIndex > 0);
					nextBtn.visible = true;
				}
			}else if(clickBtn.name == "nextBtn"){
				if(container.horizontalPageIndex < (container.horizontalPageCount-1)){
					container.scrollToPageIndex(container.horizontalPageIndex+1,0,0);
					
					preBtn.visible = true;
					nextBtn.visible = (container.horizontalPageIndex <(container.horizontalPageCount-1));
				}
			}
				
			
			
		}
		private function containerChangeHandle(e:Event):void{
			if(equipContainer && container){
				equipContainer.horizontalScrollPosition = container.horizontalScrollPosition;
				pageIndicator.selectedIndex = container.horizontalPageIndex;
			}
		}
		
		public function showItemByType(_suitType:String,_sex:String):void{
			while(container.numChildren > 0)
				container.removeChildAt(container.numChildren-1,true);
			while(equipContainer.numChildren > 0)
				equipContainer.removeChildAt(equipContainer.numChildren-1,true);
			
			var equipBg:EquipItemBg;
			var itemBtn:DressMarketItem;
			var len:int = dressSuitsVoList.length;
			for(var i:int=0;i<len;i++){
				//不显示，跳过
				if(!dressSuitsVoList[i].isShow)	continue;
				if((dressSuitsVoList[i].suitType == _suitType 
					&& (dressSuitsVoList[i].sex == _sex || dressSuitsVoList[i].sex == "B") 
					&& (dressSuitsVoList[i].level == "0" || dressSuitsVoList[i].level == "1"))){
					var len2:int = dressSuitsVoList[i].equipments.length;
					
					itemBtn = new DressMarketItem(equipCircle,dressSuitsVoList[i],getNextLvlSuitvo(dressSuitsVoList[i].name));
					itemBtn.width = 145;
					itemBtn.height = 189;
					var img:DisplayObject = GlobalModule.charaterUtils.getNormalEquipImg(dressSuitsVoList[i],1);
					img.x = (itemBtn.width>>1)-(img.width>>1);
					img.y = (itemBtn.height>>1)-(img.height>>1)-30;
					img.name = "Item";
					
//					itemBtn.addEquipment(img);
					equipBg = new EquipItemBg();
					equipBg.addChild(img);
					equipBg.name = dressSuitsVoList[i].name;
					equipContainer.addChild(equipBg);
					
					container.addChild(itemBtn);
				}
			}
			
			setPageCount();
			
		}
		private function setPageCount():void{
			if(pageIndicator && container){
				var div:int = container.numChildren/15;
				var rem:int = container.numChildren%15;
				if(rem == 0)
					pageIndicator.pageCount = div;
				else
					pageIndicator.pageCount = div + 1;
				
				preBtn.visible = false;
				nextBtn.visible = false;
				if(pageIndicator.pageCount > 1)
				{
					nextBtn.visible = true;
				}
				if(container.horizontalPageIndex > 0){
					container.scrollToPageIndex(0,0,0);
				}
			}
		}
		public function getNextLvlSuitvo(_dressName:String):DressSuitsVO{
			
			
			var itemVo:DressSeriesItemVO = GlobalModule.charaterUtils.getNextLevelEquip(_dressName);
			if(itemVo){
				for (var i:int = 0; i < dressSuitsVoList.length; i++) 
				{
					if(dressSuitsVoList[i].name == itemVo.name){
						return dressSuitsVoList[i];
					}
				}
			}
			return null;
		}
		public function updateEquipImg(_nowImg:String,_upImg:String):void{
			if(!equipContainer)
				return;
			
			for (var i:int = 0; i < equipContainer.numChildren; i++) 
			{
				var equipBg:EquipItemBg = equipContainer.getChildAt(i) as EquipItemBg;
				if(equipBg.name == _nowImg){
					equipContainer.removeChild(equipBg,true);
					
					var newImg:DisplayObject = GlobalModule.charaterUtils.getEquipImgByName(_upImg);
					newImg.x = (145>>1)-(newImg.width>>1);
					newImg.y = (189>>1)-(newImg.height>>1)-30;
					newImg.name = "Item";
					equipBg = new EquipItemBg();
					equipBg.addChild(newImg);
					equipBg.name = _upImg;
					equipContainer.addChildAt(equipBg,i);
				}
			}
		}
		
		
		
		override public function dispose():void
		{
			if(container)
				container.removeEventListener(Event.SCROLL,containerChangeHandle);
			super.dispose();
			equipCircle.dispose();
			removeChildren(0,-1,true);
		}
		
	}
}