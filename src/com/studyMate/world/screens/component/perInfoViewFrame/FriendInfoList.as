package com.studyMate.world.screens.component.perInfoViewFrame
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.world.controller.vo.CharaterInfoVO;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.model.vo.RelListItemSpVO;
	import com.studyMate.world.screens.CharaterInfoMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import mx.utils.StringUtil;
	
	import feathers.controls.PageIndicator;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	
	public class FriendInfoList extends Sprite
	{
		private static const NAME:String = "SearchSp";
		public static const DEL_FRIEND:String = NAME + "DelFriend";
		public static const ADD_FRIEND:String = NAME + "AddFriend";
		
		private var itemSp:Sprite = new Sprite;
		private var btnSp:Sprite = new Sprite;
		private var itemNum:int;
		private var pageIndicator:PageIndicator;
		
		private var isFriList:Boolean;
		private var btnTexture:Texture;
		
		public function FriendInfoList(_itemNum:int,_pageIndicator:PageIndicator,_isFriList:Boolean=true)
		{
			super();
			
			itemNum = _itemNum;
			pageIndicator = _pageIndicator;
			isFriList = _isFriList;
			
			
			addChild(itemSp);
			addChild(btnSp);
			addTextField();
		}
		private function addTextField():void{
			if(isFriList)
				btnTexture = Assets.getPersonalInfoTexture("delFriBtn");
			else
				btnTexture = Assets.getPersonalInfoTexture("addFriBtn");
			
			var itemTF:TextField;
			var btn:Button;
			for (var i:int = 0; i < itemNum; i++) 
			{
				itemTF = new TextField(260,27,"","HeiTi",18,0,true);
				itemTF.name = i.toString();
				itemTF.y = 15 + 60*i;
				itemTF.hAlign = HAlign.LEFT;
				itemTF.touchable = false;
				itemSp.addChild(itemTF);
				itemTF.addEventListener(TouchEvent.TOUCH,itemHandle);
				
				
				btn = new Button(btnTexture);
				btn.name = i.toString();
				btn.x = 244;
				btn.y = 5 + 60*i;
				btn.visible = false;
				btnSp.addChild(btn);
				btn.addEventListener(Event.TRIGGERED,btnHandle);
			}
		}
		
		
		public function clickDerect(_isLeft:Boolean):void{
			//向左
			if(_isLeft){
				if(curIdx > 0){
					curIdx--;
					setTextByIdx();
				}
			}else{
				//向右
				if(curIdx < (totalPage-1)){
					curIdx++;
					setTextByIdx();
				}
			}
		}
		private function itemHandle(e:TouchEvent):void{
			var _itemTF:TextField = e.currentTarget as TextField;
			var touch:Touch = e.getTouch(_itemTF,TouchPhase.ENDED);
			if(touch && !Global.isLoading){
				
				
				var _itemIdx:int = int(_itemTF.name);
				
				var idx:int = curIdx*6+_itemIdx;
				var friVo:RelListItemSpVO = friList[idx];
				
				
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,
					[new SwitchScreenVO(CharaterInfoMediator,new CharaterInfoVO(friVo),
						SwitchScreenType.SHOW,AppLayoutUtils.uiLayer,640,381)]);
			}
		}
		
		
		
		private var curIdx:int = 0;
		private var totalPage:int;
		private var friList:Vector.<RelListItemSpVO>
		public function updateList(_friList:Vector.<RelListItemSpVO>):void{
			friList = _friList;
			
			var div:int = _friList.length/6;
			var rem:int = _friList.length%6;
			if(rem == 0)
				totalPage = div;
			else
				totalPage = div + 1;
			
			curIdx = 0;
			pageIndicator.pageCount = totalPage;
			pageIndicator.selectedIndex = curIdx;

			
			//设置文字
			setTextByIdx();
		}
		
		private function setTextByIdx():void{
			pageIndicator.selectedIndex = curIdx;
			
			var item:TextField;
			var btn:Button;
			var friVo:RelListItemSpVO;
			var sex:String;
			for (var i:int = 0; i < itemSp.numChildren; i++) 
			{
				item = itemSp.getChildAt(i) as TextField;
				btn = btnSp.getChildAt(i) as Button;
				item.text = "";
				item.touchable = false;
				btn.visible = false;
				
				
				var idx:int = curIdx*6+i;
				if(idx < friList.length){
					friVo = friList[idx];
					
					sex = friVo.gender == "0" ? "女":"男";
					item.text = getItemStr(friVo.realName,sex,getAge(friVo.birth));
					item.touchable = true;
					btn.visible = true;
				}
			}
		}
		private function getItemStr(_name:String,_sex:String,_age:String):String{
			if(StringUtil.trim(_name).length > 2)
				return _name+"\t"+_sex+"            "+_age;
			else
				return _name+"\t\t"+_sex+"            "+_age;
		}
		private function getAge(_bir:String):String{
			if(_bir.length == 8){
				var birYear:int = int(_bir.substr(0,4));
				var nowYear:int = Global.nowDate.getFullYear();
				
				return (nowYear-birYear).toString();
			}
			return "";
		}
		
		private function btnHandle(e:Event):void{
			var _btn:Button = e.target as Button;
			var _btnIdx:int = int(_btn.name);
			
			
			var idx:int = curIdx*6+_btnIdx;
			var friVo:RelListItemSpVO = friList[idx];
			
			//好友列表，删除好友操作
			if(isFriList){
				trace("点击了"+_btnIdx+"  删除："+friVo.realName);
				
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(parent.parent,
					parent.parent.width>>1,parent.parent.height>>1,doDel,"确定要删除好友 "+friVo.realName+" ？",null,friVo.rstdId));
			}else{
				//搜索，增加好友操作
				trace("点击了"+_btnIdx+"  增加："+friVo.realName);
				
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(parent.parent,
					parent.parent.width>>1,parent.parent.height>>1,doAdd,"确定加 "+friVo.realName+" 为好友？",null,friVo.rstdId));
			}
			
		}
		private function doDel(_delId:String):void{
			if(!Global.isLoading)
				Facade.getInstance(CoreConst.CORE).sendNotification(DEL_FRIEND,_delId);
		}
		private function doAdd(_delId:String):void{
			if(!Global.isLoading)
				Facade.getInstance(CoreConst.CORE).sendNotification(ADD_FRIEND,_delId);
			
			
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			for (var i:int = 0; i < itemSp.numChildren; i++) 
			{
				var _item:TextField = itemSp.getChildAt(i) as TextField;
				_item.removeEventListener(TouchEvent.TOUCH,itemHandle);
			}
			super.dispose();
			removeChildren(0,-1,true);
		}
		
		
		
	}
}