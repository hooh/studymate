package com.mylib.game.fightGame
{
	import com.byxb.utils.centerPivot;
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.filters.GlowFilter;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	
	public class FightGameItem extends Sprite
	{
		private var waitAttactSp:Sprite;	//战斗面板
		private var tipBtnSp:Sprite;	//等待面板
		private var selectSp:Sprite;	//领取奖励
		
		private var stateSp:Sprite = new Sprite;	//状态
		private var roundSp:Sprite = new Sprite;	//回合
		private var myInfoSp:Sprite = new Sprite;	//我的出招信息
		private var enemyInfoSp:Sprite  = new Sprite;	//对手出招信息
		private var enemyNameTF:TextField;	//对手名称
		private var myBloodBar:BloodProgressBar;	//自己血槽
		private var enemyBloodBar:BloodProgressBar;	//对手血槽

		
		private var gameVo:FightGameVo;
		
		private var infoItemSp:Sprite;
		
		public function FightGameItem()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init():void{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			infoItemSp = new Sprite;
//			infoItemSp.x = 5;
			addChild(infoItemSp);
			
			
			//战斗信息面板
			waitAttactSp = new Sprite;
			waitAttactSp.visible = false;
			infoItemSp.addChild(waitAttactSp);
			
			//信息按键按钮
			tipBtnSp = new Sprite;
			tipBtnSp.visible = false;
			infoItemSp.addChild(tipBtnSp);
			
			//选项按钮面板
			selectSp = new Sprite;
			selectSp.visible = false;
			infoItemSp.addChild(selectSp);
			
			
			stateSp.x = 225;
			stateSp.y = 47;
			infoItemSp.addChild(stateSp);
			
			//对手、我名称
			enemyNameTF = new TextField(65,20,"","HeiTi",15,0xae9053,true);
			enemyNameTF.hAlign = HAlign.LEFT;
//			enemyNameTF.nativeFilters = [new DropShadowFilter(1,90,0xffffff,0.75,0,0,15)];
			enemyNameTF.nativeFilters = [new GlowFilter(0xffffff,1,5,5,20)];
//			enemyNameTF.border = true;
			infoItemSp.addChild(enemyNameTF);
			
			initWaitAttSp();
			initTipBtnSp();
		}
//		private var roundTipsTF:TextField;
		private function initWaitAttSp():void{
			var bg:Image = new Image(Assets.getFightGameTexture("itemFightBg"));
			bg.x = 4;
			bg.y = 26;
			waitAttactSp.addChild(bg);
			
			roundSp.y = 21;
			waitAttactSp.addChild(roundSp);
			
			
			
			//血槽
			enemyBloodBar = new BloodProgressBar();
			enemyBloodBar.x = 228;
			enemyBloodBar.y = 123;
			enemyBloodBar.rotation = -Math.PI/2;
			waitAttactSp.addChild(enemyBloodBar);
			myBloodBar = new BloodProgressBar();
			myBloodBar.x = 190;
			myBloodBar.y = 123;
			myBloodBar.rotation = -Math.PI/2;
			waitAttactSp.addChild(myBloodBar);
			
			
			
			//出招状态信息
			myInfoSp.x = 30;
			myInfoSp.y = 47;
			waitAttactSp.addChild(myInfoSp);
			enemyInfoSp.x = 279;
			enemyInfoSp.y = 48;
			waitAttactSp.addChild(enemyInfoSp);
			
			
			//回合结束提示
//			roundTipsTF = new TextField(110,30,"","HeiTi",18);
//			roundTipsTF.x = 16;
//			roundTipsTF.y = 90;
//			roundTipsTF.border = true;
//			waitAttactSp.addChild(roundTipsTF);
			
			
			
		}
		
		private var tipsClickBg:Image;
		private function initTipBtnSp():void{
			var bg:Image = new Image(Assets.getFightGameTexture("itemNormalBg"));
			tipBtnSp.addChild(bg);
			
			tipsClickBg = new Image(Assets.getFightGameTexture("itemNormalBg_down"));
			tipsClickBg.visible = false;
			tipBtnSp.addChild(tipsClickBg);
		}
		
		
		
		
		public function get fgameVO():FightGameVo{
			return gameVo;
		}
		
		public function updateData(_vo:FightGameVo):void{

			gameVo = _vo;
			removeEventListener(TouchEvent.TOUCH,touchHandle);
			
			
			var _icon:Image;
			var vo:FightGameDealVo = new FightGameDealVo(_vo);	//格式化战斗数据

			
			//战斗中
			if(_vo.fstatus == "B"){

				var texture:Texture;
				
				
				//两边出招完成---即有未读回合过度信息
				if(vo.myStatus == "U"){
					
					waitAttactSp.visible = false;
					tipBtnSp.visible = true;
					selectSp.visible = false;
					stateSp.removeChildren(0,-1,true);
					
					
					_icon = new Image(Assets.getFightGameTexture("stateIcon_play"));
					centerPivot(_icon);
					refreshSprite(stateSp,_icon);
					
					//对手名称
					enemyNameTF.x = 405;
					enemyNameTF.y = 73;
					enemyNameTF.text = vo.yourName;
					
					clickType = 2;
					addEventListener(TouchEvent.TOUCH,touchHandle);
					
					return;
					
				}
				
				
				
				//自己出招完成
				if(vo.myPoint1 != -1 && vo.myPoint2 != -1 && vo.myPoint3 != -1){
					//对手还没出招完
					if(vo.yourPoint1 == -1 || vo.yourPoint2 == -1 || vo.yourPoint3 == -1){
						waitAttactSp.visible = true;
						tipBtnSp.visible = false;
						selectSp.visible = false;
						stateSp.removeChildren(0,-1,true);
						
						//回合标识
						texture = Assets.getFightGameTexture("round"+vo.round);
						if(texture){
							var roundIcon:Image = new Image(texture);
							refreshSprite(roundSp,roundIcon);
						}
						//我的出招信息
						showInfo(vo.myPoint1,vo.myPoint2,vo.myPoint3,vo.yourPoint1);
						
						
						//对手名称
						enemyNameTF.x = 405;
						enemyNameTF.y = 95;
						enemyNameTF.text = vo.yourName;
						
						myBloodBar.updateBar(vo.myBlood,vo.myLrBlood);
						enemyBloodBar.updateBar(vo.yourBlood,vo.yourLrBlood);
					}
					//else	对手已经出招

				}else{
					//自己还没出招完
					waitAttactSp.visible = false;
					tipBtnSp.visible = true;
					selectSp.visible = false;
					stateSp.removeChildren(0,-1,true);
					
					
					_icon = new Image(Assets.getFightGameTexture("stateIcon_fight"));
					centerPivot(_icon);
					refreshSprite(stateSp,_icon);
					
					//对手名称
					enemyNameTF.x = 405;
					enemyNameTF.y = 73;
					enemyNameTF.text = vo.yourName;
					
					clickType = 1;
					addEventListener(TouchEvent.TOUCH,touchHandle);
				}
				
				
				
			}else if(_vo.fstatus == "A"){

				//自己还没出招完
				waitAttactSp.visible = false;
				tipBtnSp.visible = true;
				selectSp.visible = false;
				stateSp.removeChildren(0,-1,true);
				//主动挑战
				if(vo.myId == _vo.aid){
					
					_icon = new Image(Assets.getFightGameTexture("stateIcon_wait"));
					centerPivot(_icon);
					refreshSprite(stateSp,_icon);
					
					
					clickType = 4;
					

				}else{
					//被挑战
					_icon = new Image(Assets.getFightGameTexture("stateIcon_applyU"));
					centerPivot(_icon);
					refreshSprite(stateSp,_icon);

					clickType = 3;
				}
				
				//对手名称
				enemyNameTF.x = 405;
				enemyNameTF.y = 73;
				enemyNameTF.text = vo.yourName;
				addEventListener(TouchEvent.TOUCH,touchHandle);

				
				
			}else if(_vo.fstatus.indexOf("Z") != -1){
				//如果已经播放动画，则直接显示结果
				if(vo.myStatus == "R"){
					waitAttactSp.visible = false;
					tipBtnSp.visible = true;
					selectSp.visible = false;
					stateSp.removeChildren(0,-1,true);
					
					//赢了
					if((vo.isAsk && vo.fstatus == "ZA") || (!vo.isAsk && _vo.fstatus == "ZB")){
						clickType = 5;
						_icon = new Image(Assets.getFightGameTexture("stateIcon_win"));
					}else{
						//输了
						clickType = 6;
						_icon = new Image(Assets.getFightGameTexture("stateIcon_lose"));
					}
					centerPivot(_icon);
					refreshSprite(stateSp,_icon);
					
					//对手名称
					enemyNameTF.x = 405;
					enemyNameTF.y = 73;
					enemyNameTF.text = vo.yourName;
					addEventListener(TouchEvent.TOUCH,touchHandle);
					
					return;
				}
	
				//处理还没播放动画，则提醒观看
				waitAttactSp.visible = false;
				tipBtnSp.visible = true;
				selectSp.visible = false;
				stateSp.removeChildren(0,-1,true);
				
				
				_icon = new Image(Assets.getFightGameTexture("stateIcon_play"));
				centerPivot(_icon);
				refreshSprite(stateSp,_icon);
				
				//对手名称
				enemyNameTF.x = 405;
				enemyNameTF.y = 73;
				enemyNameTF.text = vo.yourName;
				
				clickType = 2;
				addEventListener(TouchEvent.TOUCH,touchHandle);
			}
		}
		private function refreshSprite(_sp:Sprite,_displayObject:DisplayObject):void{
			
			if(_sp && _displayObject){
				_sp.removeChildren(0,-1,true);
				
				_sp.addChild(_displayObject);
			}
		}
		private function showInfo(_mp1:int,_mp2:int,_mp3:int,_ep1:int=0):void{
			var myWait:Image;
			var enemyWait:Image;
			
			//自己已出招信息
			if(_mp1 != -1){
				
				refreshSprite(myInfoSp,getFightInfoSp(_mp1,_mp2,_mp3));
			}else{
				
				myWait = new Image(Assets.getFightGameTexture("pleaseAttack"));
				refreshSprite(myInfoSp,myWait);
			}
			
		}
		private function getFightInfoSp(_p1:int,_p2:int,_p3:int):Sprite{
			
			var sp:Sprite = new Sprite;
			var point:Image;
			
			if(_p1 != -1){
				if(_p1 == 0)	point = new Image(Assets.getFightGameTexture("fpointM"));
				else	point = new Image(Assets.getFightGameTexture("fpoint"+_p1));
				sp.addChild(point);
				
				if(_p2 != -1){
					if(_p2 == 0)	point = new Image(Assets.getFightGameTexture("fpointM"));
					else	point = new Image(Assets.getFightGameTexture("fpoint"+_p2));
					point.x = 52;
					sp.addChild(point);
				}
				if(_p3 != -1){
					if(_p3 == 0)	point = new Image(Assets.getFightGameTexture("fpointM"));
					else	point = new Image(Assets.getFightGameTexture("fpoint"+_p3));
					point.x = 105;
					sp.addChild(point);
				}
			}else{
				//全是问号
				for (var i:int = 0; i < 3; i++) 
				{
					point = new Image(Assets.getFightGameTexture("fpointQ"));
					point.x = i*52;
					sp.addChild(point);
				}
			}
			return sp;
		}
		
		//显示战斗历史
		public function showFightHistory(_vo:FightGameVo):void{
			removeEventListener(TouchEvent.TOUCH,touchHandle);
			
			var fightIcon:Image;
			var isFinish:Boolean = false;
			var vo:FightGameDealVo = new FightGameDealVo(_vo);
			
			waitAttactSp.visible = true;
			tipBtnSp.visible = false;
			selectSp.visible = false;
			stateSp.removeChildren(0,-1,true);
			
			if(vo.fstatus.indexOf("Z") != -1 && vo.myStatus == "R")	isFinish = true;	//判断是否结束
			
			//战斗中，回合数 减 1
			var useRound:int = int(vo.round);
			if(!isFinish)	useRound = (int(vo.round)) - 1;
			var texture:Texture = Assets.getFightGameTexture("round"+useRound);
			if(texture){
				var roundIcon:Image = new Image(texture);
				refreshSprite(roundSp,roundIcon);
			}
			
			
			
			//对手名称
			enemyNameTF.x = 405;
			enemyNameTF.y = 95;
			enemyNameTF.text = vo.yourName;
			
			//我的出招信息
			showInfo(vo.myPoint1,vo.myPoint2,vo.myPoint3,vo.yourPoint1);
			myBloodBar.updateBar(vo.myBlood,vo.myLrBlood);
			enemyBloodBar.updateBar(vo.yourBlood,vo.yourLrBlood);
			
			//结束了，用本回合数据；未结束，用上回合数据
			if(isFinish){
				refreshSprite(myInfoSp,getFightInfoSp(vo.myPoint1,vo.myPoint2,vo.myPoint3));
				refreshSprite(enemyInfoSp,getFightInfoSp(vo.yourPoint1,vo.yourPoint2,vo.yourPoint3));
			}else{
				refreshSprite(myInfoSp,getFightInfoSp(vo.myLrPoint1,vo.myLrPoint2,vo.myLrPoint3));
				refreshSprite(enemyInfoSp,getFightInfoSp(vo.yourLrPoint1,vo.yourLrPoint2,vo.yourLrPoint3));
			}
		}
		
		
		
		
		/**
		 * 点击类别：        0 = 默认值，不操作<br>
		 * 1 = 我出招        2 = 播放战斗动画<br>
		 * 3 = 被挑战信息        4 = 主动挑战信息<br>
		 * 5 = 战斗胜利       6 = 战斗失败<br>
		 */		
		private var clickType:int = 0;
		
		
		private var beginY:Number;
		private var endY:Number;
		private function touchHandle(event:TouchEvent):void
		{
			
			var touchPoint:Touch = event.getTouch(event.target as DisplayObject);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					tipsClickBg.visible = true;
					beginY = touchPoint.globalY;
				}else if(touchPoint.phase==TouchPhase.ENDED){
					tipsClickBg.visible = false;
					endY = touchPoint.globalY;
					if(Math.abs(endY-beginY) < 10){
						//根据点击类别进行操作
						switch(clickType){
							case 1://我出招
								
								Facade.getInstance(CoreConst.CORE).sendNotification(FightGameMediator.CLICK_ITME,this);
								
								
								break;
							case 2://播放战斗动画
								viewFight();
								
								break;
							case 3://被挑战信息
								showSelectSp(1);
								
								break;
							case 4://主动挑战信息
								showSelectSp(0);
								
								
								break;
							case 5://战斗胜利
								
								getReward();
								
								break;
							case 6://战斗失败
								
								break;
						}
					}
				}
			}
		}
		//看战斗动画
		private function viewFight():void{
			Facade.getInstance(CoreConst.CORE).sendNotification(FightRollMediator.VideoTest,gameVo);
		}

		
		private function showSelectSp(_type:int=0):void{
			//先移除item监听
			removeEventListener(TouchEvent.TOUCH,touchHandle);
			
			var btnsp:Sprite = new Sprite;
			stateSp.removeChildren(0,-1,true);
			
			//0 主动挑战
			if(_type == 0){
				
				var cancleBtn:Button = new Button(Assets.getFightGameTexture("cancleFightBtn"));
				cancleBtn.addEventListener(Event.TRIGGERED,cancleBtnHandle);
				btnsp.addChild(cancleBtn);
				
				var goonWaitBtn:Button = new Button(Assets.getFightGameTexture("goonWaitBtn"));
				goonWaitBtn.x = 174;
				goonWaitBtn.addEventListener(Event.TRIGGERED,goonWaitBtnHandle);
				btnsp.addChild(goonWaitBtn);
				
			}else if(_type == 1){
				//1 被挑战
				var rejectBtn:Button = new Button(Assets.getFightGameTexture("rejectFightBtn"));
				rejectBtn.addEventListener(Event.TRIGGERED,cancleBtnHandle);
				btnsp.addChild(rejectBtn);
				
				var accepBtn:Button = new Button(Assets.getFightGameTexture("acceptFightBtn"));
				accepBtn.x = 174;
				accepBtn.addEventListener(Event.TRIGGERED,aceptBtnHandle);
				btnsp.addChild(accepBtn);
				
				
			}
			
			centerPivot(btnsp);
			refreshSprite(stateSp,btnsp);
			
		}
		private function goonWaitBtnHandle(e:Event):void{
			stateSp.removeChildren(0,-1,true);
			var _icon:Image = new Image(Assets.getFightGameTexture("stateIcon_wait"));
			centerPivot(_icon);
			refreshSprite(stateSp,_icon);
			
			clickType = 4;
			TweenLite.delayedCall(0.1,function():void{
				
				addEventListener(TouchEvent.TOUCH,touchHandle);
			});
		}
		private function aceptBtnHandle(e:Event):void{
			sendApply(true);
		}
		private function cancleBtnHandle(e:Event):void{
			
			sendApply(false);
		}
		
		
		
		private function sendApply(_isAccept:Boolean):void{
			TweenLite.killTweensOf(sendApply);
			if(Global.isLoading){
				TweenLite.delayedCall(2,sendApply,[_isAccept]);
				return;
			}
			
			var _res:String = "Y";
			if(!_isAccept)	_res = "N";
			
			PackData.app.CmdIStr[0] = CmdStr.RESP_CHANLLENGE;
			PackData.app.CmdIStr[1] = gameVo.fid;
			PackData.app.CmdIStr[2] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[3] = _res;
			PackData.app.CmdInCnt = 4;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(FightGameMediator.RESP_CHANLLENGE));

		}
		private function getReward():void{
			TweenLite.killTweensOf(getReward);
			
			if(Global.isLoading){
				TweenLite.delayedCall(2,getReward);
				return;
			}
			
			PackData.app.CmdIStr[0] = CmdStr.AFF_FIGHT_RESULT;
			PackData.app.CmdIStr[1] = gameVo.fid;
			PackData.app.CmdIStr[2] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 3;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(FightGameMediator.RES_FIGHT_REWARD));
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			removeEventListener(TouchEvent.TOUCH,touchHandle);
			
			
			TweenLite.killTweensOf(sendApply);
			TweenLite.killTweensOf(getReward);
			
			removeChildren(0,-1,true);
		}
		
	}
}