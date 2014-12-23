package com.studyMate.world.screens.component.perInfoViewFrame
{
	import com.byxb.utils.centerPivot;
	import com.studyMate.world.model.vo.RelListItemSpVO;
	
	import feathers.controls.PageIndicator;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class FriListSp extends Sprite
	{
		private var firInfoList:FriendInfoList;
		private var pageIndicator:PageIndicator = new PageIndicator();
		
		public function FriListSp()
		{
			super();
			
			var bg:Image = new Image(Assets.getPersonalInfoTexture("tabg_friList"));
			bg.x = 58;
			bg.y = 57;
			addChild(bg);
			
			
			firInfoList = new FriendInfoList(6,pageIndicator);
			firInfoList.x = 111;
			firInfoList.y = 135;
			addChild(firInfoList);
			
			addEventListener(Event.ADDED_TO_STAGE,addDerectBtn);
//			addDerectBtn();
		}
		
		private function addDerectBtn(e:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE,addDerectBtn);
			
			addChild(pageIndicator);
			pageIndicator.width = 100;
			centerPivot(pageIndicator);
			pageIndicator.x = 227;
			pageIndicator.y = 500;
			pageIndicator.direction = PageIndicator.DIRECTION_HORIZONTAL;
			pageIndicator.gap = 3;
			pageIndicator.touchable = false;
			pageIndicator.normalSymbolFactory = function():DisplayObject{
				return new Image(Assets.getPersonalInfoTexture("pageIndicator00"));};
			pageIndicator.selectedSymbolFactory = function():DisplayObject{
				return new Image(Assets.getPersonalInfoTexture("pageIndicator01"));};
			
			var preBtn:Button = new Button(Assets.getPersonalInfoTexture("derectBtn"));
			preBtn.name = "preBtn";
			preBtn.x = 41;
			preBtn.y = 235;
			addChild(preBtn);
			preBtn.addEventListener(Event.TRIGGERED,derectHandle);
			
			var nextBtn:Button = new Button(Assets.getPersonalInfoTexture("derectBtn"));
			nextBtn.name = "nextBtn";
			nextBtn.scaleX = -1;
			nextBtn.x = 545;
			nextBtn.y = 235;
			addChild(nextBtn);
			nextBtn.addEventListener(Event.TRIGGERED,derectHandle);
			
		}
		private function derectHandle(e:Event):void{
			var clickBtn:Button = e.target as Button;
			if(clickBtn.name == "preBtn"){
				firInfoList.clickDerect(true);
			}else if(clickBtn.name == "nextBtn"){
				firInfoList.clickDerect(false);
			}
		}
		
		
		
		public function updateFriList(_friList:Vector.<RelListItemSpVO>):void{
			
			firInfoList.updateList(_friList);
			
			
		}
		
		
		override public function dispose():void
		{
			super.dispose();
			removeEventListener(Event.ADDED_TO_STAGE,addDerectBtn);
			removeChildren(0,-1,true);
		}
	}
}