package com.mylib.game.fightGame
{
	import com.byxb.utils.centerPivot;
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.fightGame.popUpBox.fightInputBox;
	import com.mylib.game.fightGame.popUpBox.fightTipsBox;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.PopUpCommandVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import myLib.myTextBase.GpuTextInput;
	import myLib.myTextBase.utils.SoftKeyBoardConst;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.filters.GlowFilter;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class FightGameMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "FightGameMediator";
		private static const QRY_FIGHT_BY_UID:String = NAME + "QryFightByUid";
		private static const SEL_FIGHT_CTRL:String = NAME + "SelFightCtrl";
		
		public static const RESP_CHANLLENGE:String = NAME + "RespChanllenge";
		public static const CLICK_ITME:String = NAME + "ClickItem";
		public static const UPDATE_ITEM:String = NAME + "UpdateItemPoint";
		public static const RES_FIGHT_REWARD:String = NAME + "ResFightReward";
		
		private var vo:SwitchScreenVO;
		private var oper:int = 0;	//0:初次进入	1:接受 拒绝后操作
		private var bgHolder:Sprite;
		private var refreshBtn:Button;
		private var times:int = 0;
		private var timesIcon:Image;
		private var timesTF:TextField;
		private var searchInput:GpuTextInput;
		
		private var fightRollMediator:FightRollMediator;
		private var fightGameScroll:FightGameScroller;
		
		public function FightGameMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function prepare(vo:SwitchScreenVO):void
		{
			this.vo = vo;
			
			oper = 0;
			
			getFightTimes();
			
		}
		override public function onRegister():void
		{
			sendNotification(WorldConst.HIDE_LEFT_MENU);
			sendNotification(WorldConst.HIDE_MAIN_MENU);
			
			sendNotification(WorldConst.SET_ROLL_SCREEN,false);
			sendNotification(WorldConst.POPUP_SCREEN,new PopUpCommandVO(this,true));

			
			initBg();
			sendNotification(WorldConst.MUTICONTROL_START);
			sendNotification(SoftKeyBoardConst.USE_SIMPLE_KEYBOARD,true);
		}
		private var myGameList:Vector.<FightGameVo> = new Vector.<FightGameVo>;
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName())
			{
				case SEL_FIGHT_CTRL:
					if(!result.isErr)
						times = PackData.app.CmdOStr[2];
					getMyGameList();
					break;
				case QRY_FIGHT_BY_UID:
					if(!result.isEnd){
						var gamevo:FightGameVo = new FightGameVo();
						
						gamevo.fid = PackData.app.CmdOStr[1];
						
						gamevo.aid = PackData.app.CmdOStr[2];
						gamevo.aname = PackData.app.CmdOStr[3];
						gamevo.bid = PackData.app.CmdOStr[4];
						gamevo.bname = PackData.app.CmdOStr[5];
						gamevo.ablood = PackData.app.CmdOStr[6];
						gamevo.bblood = PackData.app.CmdOStr[7];
						gamevo.fstatus = PackData.app.CmdOStr[8];
						gamevo.round = PackData.app.CmdOStr[9];
						gamevo.apoint1 = PackData.app.CmdOStr[10];
						gamevo.apoint2 = PackData.app.CmdOStr[11];
						gamevo.apoint3 = PackData.app.CmdOStr[12];
						gamevo.bpoint1 = PackData.app.CmdOStr[13];
						gamevo.bpoint2 = PackData.app.CmdOStr[14];
						gamevo.bpoint3 = PackData.app.CmdOStr[15];
						gamevo.alrBlood = PackData.app.CmdOStr[16];
						gamevo.blrBlood = PackData.app.CmdOStr[17];
						gamevo.alrPoint1 = PackData.app.CmdOStr[18];
						gamevo.alrPoint2 = PackData.app.CmdOStr[19];
						gamevo.alrPoint3 = PackData.app.CmdOStr[20];
						gamevo.blrPoint1 = PackData.app.CmdOStr[21];
						gamevo.blrPoint2 = PackData.app.CmdOStr[22];
						gamevo.blrPoint3 = PackData.app.CmdOStr[23];
						gamevo.astatus = PackData.app.CmdOStr[24];
						gamevo.bstatus = PackData.app.CmdOStr[25];
						
						myGameList.push(gamevo);
					}else{
						if(oper == 0){
							//初次进入
							
							oper = -1;
							Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
						}else if(oper == 1)
							//重新取列表
							fightGameScroll.updateData(myGameList,fightGameScroll.rollIdx,!isShowHistory);
					}
					break;
				case RESP_CHANLLENGE:
					if(!result.isErr){
						//接受/拒绝 成功
						if(PackData.app.CmdOStr[0] == "000"){
							updateGameList();
						}
						times = PackData.app.CmdOStr[2];
						timesTF.text = times.toString();
					}
					break;
				case CLICK_ITME:
					
					currentItem = notification.getBody() as FightGameItem;

					fightGameScroll.showRollItem(currentItem);
					
					break;
				case UPDATE_ITEM:
					var data:Array = notification.getBody() as Array;
					
					if(data[0] == "Point")	updateItemPoint(data[1],data[2]);
					else	updateItemState(data[1],data[2],data[3]);
					break;
				case WorldConst.APPLY_FIGHT:
					//挑战成功
					if(PackData.app.CmdOStr[0] == "000"){
						updateGameList();
					}
					times = PackData.app.CmdOStr[3];
					timesTF.text = times.toString();
					break;
				case RES_FIGHT_REWARD:
					if(!result.isErr){
						if(tipsBox)	tipsBox.showBox("成功领取赏银！");
						
						updateGameList();
					}
					break;
				
			}
		}
		override public function listNotificationInterests():Array
		{
			return [SEL_FIGHT_CTRL,QRY_FIGHT_BY_UID,RESP_CHANLLENGE,CLICK_ITME,UPDATE_ITEM,WorldConst.APPLY_FIGHT,RES_FIGHT_REWARD];
		}
		
		private var backBtn:Button;
		private var isShowHistory:Boolean = false;	//是否在显示战斗记录状态
		private function initTabBar():void{
			var tabBar:Sprite = new Sprite;
			tabBar.x = 2;
			tabBar.y = 73;
			view.addChild(tabBar);
			
			var applyBtn:Button = new Button(Assets.getFightGameTexture("applyBtn_up"),"",
				Assets.getFightGameTexture("applyBtn_down"));
			applyBtn.addEventListener(Event.TRIGGERED,applyBtnHandle);
			tabBar.addChild(applyBtn);
			
			var randomBtn:Button = new Button(Assets.getFightGameTexture("randomBtn_up"),"",
				Assets.getFightGameTexture("randomBtn_down"));
			randomBtn.y = 70;
			randomBtn.addEventListener(Event.TRIGGERED,randomBtnHandle);
			tabBar.addChild(randomBtn);
			
			var historyBtn:Button = new Button(Assets.getFightGameTexture("historyBtn_up"),"",
				Assets.getFightGameTexture("historyBtn_down"));
			historyBtn.y = 140;
			historyBtn.addEventListener(Event.TRIGGERED,recordBtnHandle);
			tabBar.addChild(historyBtn);
			
			
		}
		private function initBg():void{
			initTabBar();
			
			var bg:Image = new Image(Assets.getTexture("gameHolderBg"));
			bg.x = 55;
			bg.y = 2;
			view.addChild(bg);
			
			var closeBtn:Button = new Button(Assets.getFightGameTexture("closeBtn"));
			closeBtn.x = 552;
			closeBtn.y = 29;
			closeBtn.addEventListener(Event.TRIGGERED,closeBtnHandle);
			view.addChild(closeBtn);
			
			timesIcon = new Image(Assets.getFightGameTexture("fightTimesIcon"));
			centerPivot(timesIcon);
			timesIcon.x = 308;
			timesIcon.y = 30;
			view.addChild(timesIcon);
			timesTF = new TextField(48,38,times.toString(),"HeiTi",28,0xffffff,true);
			timesTF.hAlign = HAlign.LEFT;
			timesTF.vAlign = VAlign.TOP;
			timesTF.x = 336;
			timesTF.y = 7;
			timesTF.nativeFilters = [new GlowFilter(0,1,5,5,10)];
//			timesTF.border = true;
			view.addChild(timesTF);
			

			//战斗记录后退按钮
			backBtn = new Button(Assets.getFightGameTexture("backToFight"));
			backBtn.x = 486;
			backBtn.y = 670;
			backBtn.visible = false;
			backBtn.addEventListener(Event.TRIGGERED,backBtnHandle);
			view.addChild(backBtn);
			
			
			
			bgHolder = new Sprite;
			bgHolder.x = 103;
			bgHolder.y = 120;
			view.addChild(bgHolder);
			
			
			
			
			
			
			fightRollMediator = new FightRollMediator();
			facade.registerMediator(fightRollMediator);
			fightGameScroll = new FightGameScroller();
			bgHolder.addChild(fightGameScroll);
			fightGameScroll.updateData(myGameList);

			//初始化弹出框
			tipsBox = new fightTipsBox;
			AppLayoutUtils.gpuPopUpLayer.addChild(tipsBox);
			inputBox = new fightInputBox;
			AppLayoutUtils.gpuPopUpLayer.addChild(inputBox);
		}
		private var tipsBox:fightTipsBox;
		private var inputBox:fightInputBox;
		

		//请求挑战
		private function applyBtnHandle(e:Event):void{
			if(inputBox)	inputBox.showBox(applyFight);
		}
		//随机对手
		private function randomBtnHandle(e:Event):void{
			
			if(tipsBox)	tipsBox.showBox("亲，确定要随机一个对手吗？",doRandom);
		}
		private function doRandom():void{
			applyFight("*");
		}
		//查看战斗记录
		private function recordBtnHandle(e:Event):void{
			if(Global.isLoading)
				return;
			
			//成功显示历史记录
			if(fightGameScroll.showHistory()){
				isShowHistory = true;
				backBtn.visible = true;
				
			}else{
				isShowHistory = false;
				backBtn.visible = false;
			}
		}
		private function backBtnHandle(e:Event):void{
			if(Global.isLoading)
				return;
			
			isShowHistory = false;
			backBtn.visible = false;
			fightGameScroll.updateData(myGameList);
		}
		
		
		//更新游戏列表
		public function updateGameList():void{
			oper = 1;
			
			getMyGameList();
			
		}
		
		
		
		
		
		private var currentItem:FightGameItem;
		private function updateItemPoint(_fid:String,_point:int):void{
			if(!myGameList)
				return;
			for (var i:int = 0; i < myGameList.length; i++) 
			{
				if(myGameList[i].fid == _fid){
					//自己挑战
					if(myGameList[i].aid == PackData.app.head.dwOperID.toString()){
						
						if(myGameList[i].apoint1 == -1)
							myGameList[i].apoint1 = _point;
						else if(myGameList[i].apoint2 == -1)
							myGameList[i].apoint2 = _point;
						else if(myGameList[i].apoint3 == -1)
							myGameList[i].apoint3 = _point;
						
					}else{
						if(myGameList[i].bpoint1 == -1)
							myGameList[i].bpoint1 = _point;
						else if(myGameList[i].bpoint2 == -1)
							myGameList[i].bpoint2 = _point;
						else if(myGameList[i].bpoint3 == -1)
							myGameList[i].bpoint3 = _point;
					}
					
					fightGameScroll.updateData(myGameList,fightGameScroll.rollIdx);
					
					/*var fightRollMediator:FightRollMediator = Facade.getInstance(CoreConst.CORE).retrieveMediator(FightRollMediator.NAME) as FightRollMediator;
					//更新当前战斗框信息
					if(fightRollMediator){
						fightRollMediator.view.visible = true;
						fightRollMediator.updateData(myGameList[i]);
					}*/
					
					break;
				}
			}
			
		}
		private function updateItemState(_fid:String,_astatus:String = "",_bstatus:String = ""):void{
			if(!myGameList)
				return;
			for (var i:int = 0; i < myGameList.length; i++) 
			{
				if(myGameList[i].fid == _fid){
					if(_astatus != "")	myGameList[i].astatus = _astatus;
					if(_bstatus != "")	myGameList[i].bstatus = _bstatus;
					
					fightGameScroll.updateData(myGameList,fightGameScroll.rollIdx);
					break;
				}
			}
		}
		
		//请求战斗
		private function applyFight(_id:String):void{
			TweenLite.killTweensOf(applyFight);
			
			if(_id == PackData.app.head.dwOperID.toString()){
				if(tipsBox)	tipsBox.showBox("大侠不能向自己发起战斗哦！");
				return;
			}
			
			if(Global.isLoading){
				TweenLite.delayedCall(2,applyFight,[_id]);
				return;
			}
			
			PackData.app.CmdIStr[0] = CmdStr.CHALLENGE_SB;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = Global.player.realName;
			PackData.app.CmdIStr[3] = _id;
			PackData.app.CmdInCnt = 5;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(WorldConst.APPLY_FIGHT));
			
			
		}
		//获取个人挑战次数
		private function getFightTimes():void{
			PackData.app.CmdIStr[0] = CmdStr.SEL_FIGHT_CTRL;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 2;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(SEL_FIGHT_CTRL));
			
		}
		//获取个人战斗列表
		private function getMyGameList():void{
			TweenLite.killTweensOf(getMyGameList);
			if(Global.isLoading){
				TweenLite.delayedCall(2,getMyGameList);
				return;
			}
			
			//清空
			myGameList.splice(0,myGameList.length);
			
			PackData.app.CmdIStr[0] = CmdStr.QRY_FIGHT_BY_UID;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 2;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(QRY_FIGHT_BY_UID));
			
			
		}
		
		
		private function closeBtnHandle(e:Event):void{
			
			vo.type = SwitchScreenType.HIDE;
			sendNotification(WorldConst.SWITCH_SCREEN,[vo]);
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class{
			return Sprite;
		}
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
			
			sendNotification(SoftKeyBoardConst.USE_SIMPLE_KEYBOARD,false);
			sendNotification(WorldConst.SET_ROLL_SCREEN,true);
			sendNotification(WorldConst.REMOVE_POPUP_SCREEN,this);
			sendNotification(WorldConst.SHOW_MAIN_MENU);
			sendNotification(WorldConst.SHOW_LEFT_MENU);
			
			facade.removeMediator(FightRollMediator.NAME);
			
			TweenLite.killTweensOf(getMyGameList);

			
			if(tipsBox)	tipsBox.removeFromParent(true);
			if(inputBox) inputBox.removeFromParent(true);
			
			view.removeChildren(0,-1,true);
		}
		
	}
}