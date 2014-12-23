package com.studyMate.world.screens.component
{
	import com.byxb.utils.centerPivot;
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.game.controller.vo.PChatInfoVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.controller.vo.DisplayChatViewCommandVO;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.model.vo.RelListItemSpVO;
	import com.studyMate.world.screens.ChatViewMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.view.WifiAlertSkin;
	
	import feathers.controls.Scroller;
	import feathers.controls.supportClasses.LayoutViewPort;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class ChatFriendList extends Sprite
	{
		private var relList:Vector.<RelListItemSpVO>;
		private var scroll:Scroller;
		private var viewPort:LayoutViewPort;
		
		public function ChatFriendList(_relList:Vector.<RelListItemSpVO>)
		{
			relList = _relList;
			
			
			addEventListener(Event.ADDED_TO_STAGE, initListBg);
		}
		
		
		private var friIcon:Image;	//好友列表箭头
		private function initListBg():void{
			var friListBg:Image = new Image(Assets.getChatViewTexture("friListBg"));
			addChild(friListBg);
			
			var friBtn:Button = new Button(Assets.getChatViewTexture("friListBtn"));
			friBtn.x = 13;
			friBtn.y = 105;
			addChild(friBtn);
			friBtn.addEventListener(Event.TRIGGERED,friBtnHandle);
			
			friIcon = new Image(Assets.getChatViewTexture("friListIcon"));
			centerPivot(friIcon);
			friIcon.scaleX = -1;
			friIcon.x = 8;
			friIcon.y = 166;
			addChild(friIcon);
			
			initList();
			
		}
		
		
		
		private function initList():void{
			
			scroll = new Scroller();
			
			scroll.x = 55;
			scroll.y = 8;
			scroll.width = 135;
			scroll.height = 428;
			
			
			viewPort = new LayoutViewPort();
			scroll.viewPort = viewPort;
			addChild(scroll);
			
			freshList();
		}
		
		public function freshList():void{
			
			viewPort.removeChildren(0,-1,true);
			
			var chatFriListItem:ChatFriendListItem;
			
			for(var i:int=0;i<relList.length;i++){
				
				chatFriListItem = new ChatFriendListItem(relList[i]);
				chatFriListItem.y = getVPHeight();
				
				if(currentItem && currentItem.relList.rstdId == relList[i].rstdId)
					clickItem(chatFriListItem);
				
				viewPort.addChild(chatFriListItem);
				
				chatFriListItem.addEventListener(TouchEvent.TOUCH,itemClickHandle);
			}
			
		}
		
		public function updateList(_pchatVo:PChatInfoVO):void{
			
			if(relList){
				
				var newRelList:Vector.<RelListItemSpVO> = new Vector.<RelListItemSpVO>;
				var updateItem:RelListItemSpVO;
				var idfind:Boolean;
				for(var i:int=0;i<relList.length;i++){
					//相同id，顶置
					if(relList[i].rstdId == _pchatVo.sendId){
						
						updateItem = relList[i];
						updateItem.isShake = true;
						updateItem.messNum++;
						
						relList.splice(i,1);
						
						idfind = true;
						break;
					}
				}
				
				//未找到好友，新建item。
				if(!idfind){
					updateItem = new RelListItemSpVO;
					updateItem.rstdId = _pchatVo.sendId;
					updateItem.realName = _pchatVo.sendName;
					updateItem.relaType = "S";
					updateItem.isShake = true;
					updateItem.messNum++;
					
					
					addStranger([_pchatVo.sendId,"S"]);
				}
				
				newRelList.push(updateItem);
				
				for(var j:int=0;j<relList.length;j++)
					newRelList.push(relList[j]);
				
				relList = newRelList;
				
//				freshList();
				
				
				
				
			}
		}
		
		//陌生人发信息，加为“陌生人”列表
		private function addStranger(_data:Array):void{
			TweenLite.killTweensOf(addStranger);
			if(Global.isLoading){
				TweenLite.delayedCall(2,addStranger,[_data]);
				return;
			}
			//轮询中2次通信，通知切换界面缓存
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.DO_SWITCH_STOP);
			
			PackData.app.CmdIStr[0] = CmdStr.INSERT_STD_RELAT;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = _data[0];
			PackData.app.CmdIStr[3] = _data[1];
			PackData.app.CmdInCnt = 4;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(ChatViewMediator.UPDATE_FIREND_LIST));
			
		}
		
		
		
		
		
		public var currentItem:ChatFriendListItem;
		private var beginY:Number;
		private var endY:Number;
		private function itemClickHandle(e:TouchEvent):void{
			var touchPoint:Touch = e.getTouch(e.currentTarget as ChatFriendListItem);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					beginY = touchPoint.globalY;
				}else if(touchPoint.phase==TouchPhase.ENDED){
					endY = touchPoint.globalY;
					if(Math.abs(endY-beginY) < 10){
						
						
						
						
						if(!currentItem  || (e.currentTarget as ChatFriendListItem) != currentItem){
							clickItem(e.currentTarget as ChatFriendListItem);
							
							(e.currentTarget as ChatFriendListItem).stopShake();
							
							
							Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SHOW_CHAT_VIEW,
								new DisplayChatViewCommandVO(true,"PC"));
							
							Facade.getInstance(CoreConst.CORE).sendNotification(ChatViewMediator.SHOW_FRIEND_CHAT,(e.currentTarget as ChatFriendListItem).relList.rstdId);
							
							
						}
					}
				}
			}
			
		}
		
		//默认好友列表点击
		/*public function defaultListClick():void{
		if(viewPort && viewPort.numChildren>0){
		
		clickItem(viewPort.getChildAt(0) as ChatFriendListItem);
		
		
		Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SHOW_CHAT_VIEW,"PC");
		
		Facade.getInstance(CoreConst.CORE).sendNotification(ChatViewMediator.SHOW_FRIEND_CHAT,(viewPort.getChildAt(0) as ChatFriendListItem).relList.rstdId);
		
		}
		}*/
		
		public function clickItem(_listItem:ChatFriendListItem):void{
			
			//			for(var i:int=0;i<viewPort.numChildren;i++)
			//				(viewPort.getChildAt(i) as ChatFriendListItem).bgVisible = false;
			
			if(currentItem)
				currentItem.bgVisible = false;
			
			if(_listItem)
				_listItem.bgVisible = true;
			
			currentItem = _listItem;
			
		}
		public function clickItemById(_friId:String):void{
			
			if(!viewPort)
				return;
			
			var isFriend:Boolean = false;
			for (var i:int = 0; i < viewPort.numChildren; i++) 
			{
				if((viewPort.getChildAt(i) as ChatFriendListItem).relList.rstdId == _friId){
					
					isFriend = true;
					clickItem(viewPort.getChildAt(i) as ChatFriendListItem);
					(viewPort.getChildAt(i) as ChatFriendListItem).stopShake();
					Facade.getInstance(CoreConst.CORE).sendNotification(ChatViewMediator.SHOW_FRIEND_CHAT,_friId);
					
					if(scroll)
						scroll.scrollToPosition(0,viewPort.getChildAt(i).y,1);
					break;
				}
			}
			if(!isFriend){
//				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(this.stage,640,381,
//					addStranger,"他还不是你好友哦，是否加为好友呢？",null,[_friId,"F"]));
				
				var alertVO:AlertVo = new AlertVo("他还不是你好友哦，是否加为好友呢？",true,"yesHandler","noHandler",false,[[_friId,"F"]],addStranger);
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.ALERT_SHOW,alertVO);
			}
			
			//显示好友列表
			if(this.x > 310){
				TweenLite.killTweensOf(this);
				TweenLite.killTweensOf(friIcon);
				
				TweenLite.to(this,0.3,{x:180});
				TweenLite.to(friIcon,0.3,{rotation:Math.PI});
			}
		}
		
		
		
		private function getVPHeight():Number{
			/*var height:Number =0 ;
			for(var i:int=0;i<viewPort.numChildren;i++){
			trace("高度："+viewPort.getChildAt(i).height);
			height+= viewPort.getChildAt(i).height+15;
			}
			return height;*/
			//			trace("高度："+viewPort.numChildren*(46+15));
			
			return viewPort.numChildren*(46+15);
		}
		
		
		
		
		private function friBtnHandle(e:Event):void{
			if(this.x > 310){
				TweenLite.killTweensOf(this);
				TweenLite.killTweensOf(friIcon);
				
				TweenLite.to(this,0.3,{x:180});
				TweenLite.to(friIcon,0.3,{rotation:Math.PI});
				
				
			}else if(this.x < 190){
				TweenLite.killTweensOf(this);
				TweenLite.killTweensOf(friIcon);
				
				TweenLite.to(this,0.3,{x:317});
				TweenLite.to(friIcon,0.3,{rotation:0});
			}
		}
		
		
		
		override public function dispose():void
		{
			super.dispose();
			TweenLite.killTweensOf(this);
			TweenLite.killTweensOf(friIcon);
			
			TweenLite.killTweensOf(addStranger);
			removeEventListener(Event.ADDED_TO_STAGE, initListBg);
			
			removeChildren(0,-1,true);
		}
	}
}