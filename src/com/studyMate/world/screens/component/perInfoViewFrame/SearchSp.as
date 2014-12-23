package com.studyMate.world.screens.component.perInfoViewFrame
{
	import com.byxb.utils.centerPivot;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import myLib.myTextBase.GpuTextInput;
	import com.studyMate.world.model.vo.RelListItemSpVO;
	import com.studyMate.world.screens.PersonalInfoViewMediator;
	
	import flash.text.TextFormat;
	
	import feathers.controls.PageIndicator;
	import feathers.events.FeathersEventType;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class SearchSp extends Sprite
	{
		private static const NAME:String = "SearchSp";
		
		private var firInfoList:FriendInfoList;
		private var pageIndicator:PageIndicator = new PageIndicator();
		
		private var searchTextInput:FriSearchTextInput;
		
		public function SearchSp()
		{
			super();
			
			var bg:Image = new Image(Assets.getPersonalInfoTexture("perInfo_searchBg"));
			bg.x = 64;
			bg.y = 111;
			addChild(bg);
			
			searchTextInput = new FriSearchTextInput;
			searchTextInput.x = 110;
			searchTextInput.y = 65;
			addChild(searchTextInput);
			
			
			var searchBtn:Button = new Button(Assets.getPersonalInfoTexture("searchBtn"));
			searchBtn.x = 380;
			searchBtn.y = 65;
			addChild(searchBtn);
			searchBtn.addEventListener(Event.TRIGGERED,searchBtnHandle);
			
			
			//加列表
			firInfoList = new FriendInfoList(5,pageIndicator,false);
			firInfoList.x = 111;
			firInfoList.y = 190;
			addChild(firInfoList);
			
			addEventListener(Event.ADDED_TO_STAGE,addDerectBtn);
			
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
		

		private function searchBtnHandle(e:Event):void{
			if(searchTextInput)
				searchTextInput.doSearch();
			
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