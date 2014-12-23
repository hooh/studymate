package com.mylib.game.fightGame
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.charater.logic.FighterControllerMediator;
	import com.mylib.game.charater.logic.ai.HeroGoAI;
	import com.mylib.game.model.FightCharaterPoolProxy;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	import de.polygonal.core.ObjectPool;
	
	import feathers.controls.Button;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
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
	import starling.utils.VAlign;
	
	public class FightRollMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "FightRollMediator";
		public static const VideoTest:String = NAME + "VideoTest";
		private static const VoTest:String = NAME + "VoTest";
		
		private static const GET_EQUIPMENT_COMPLETE:String = NAME + "GetEquipmentComplete";
		private static const GIVE_ONE_POINT:String = NAME + "GiveOnePoin";
		private static const SEL_LRFIGHT_INFO:String = NAME + "SelLrfightInfo";
		
		
		private var charaterSp:Sprite;
		private var myBlood:FightBloodBar;
		private var enemyBlood:FightBloodBar;
		
		private var roller:CircleRoller;
		
		
		private var fightState:Sprite;
		
		private var pool:FightCharaterPoolProxy;
		private var me:FighterControllerMediator;
		private var enemy:FighterControllerMediator;
		private var enemyNameTF:TextField;
		
		public function FightRollMediator()
		{
			super(NAME, new Sprite);
		}
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		private var roundSp:Sprite;	//回合
		override public function onRegister():void
		{
			
			var bg:Image = new Image(Assets.getFightGameTexture("fighting_bg"));
			bg.x = 4;
			bg.y = 7;
			view.addChild(bg);

			roundSp = new Sprite;
			roundSp.x = 2;
			roundSp.y = 1;
			view.addChild(roundSp);
			
			
			//人物容器
			charaterSp = new Sprite;
			view.addChild(charaterSp);
			
			
			//血槽
			myBlood = new FightBloodBar();
			myBlood.x = 25;
			myBlood.y = 25;
			view.addChild(myBlood);
			
			enemyBlood = new FightBloodBar();
			enemyBlood.x = 422;
			enemyBlood.y = 25;
			view.addChild(enemyBlood);
			
			enemyNameTF = new TextField(65,20,"","HeiTi",15,0xae9053);
			enemyNameTF.hAlign = HAlign.LEFT;
			enemyNameTF.nativeFilters = [new DropShadowFilter(1,90,0xffffff,0.75,0,0,10)];
			enemyNameTF.border = true;
			enemyNameTF.x = 410;
			enemyNameTF.y = 162;
			view.addChild(enemyNameTF);
			
			
			//摇点圈
			roller = new CircleRoller();
			roller.speed = 60;
			view.addChild(roller);
			roller.x = 194;	
			roller.y = 97;
			
			canTouch = true;
			view.addEventListener(TouchEvent.TOUCH,touchHandle);
			
			
			//摇点结果
			initResultTips();
			createCharater();
			
			//添加回合结束提示
			vfBtn = new Button;
			vfBtn.label = "观看录像";
			vfBtn.width = 130;
			vfBtn.height = 38;
			vfBtn.x = 243;
			vfBtn.y = 145;
//			vfBtn.visible = false;
			vfBtn.addEventListener(Event.TRIGGERED,vfBtnHandle);
			view.addChild(vfBtn);
			
			myEnergy = new FightCollectEnergy;
			myEnergy.x = 44;
			myEnergy.y = 86;
			view.addChild(myEnergy);
			enEnergy = new FightCollectEnergy;
			enEnergy.x = 290;
			enEnergy.y = 86;
			view.addChild(enEnergy);
			
		}
		private var vfBtn:Button;
		private var myEnergy:FightCollectEnergy;
		private var enEnergy:FightCollectEnergy;
		
		private var enemyId:String = "";
		private var enemyDress:String = "face_face1";
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName())
			{
				
				case GET_EQUIPMENT_COMPLETE:
					if(!result.isEnd){
						//是对手的装备
						if(PackData.app.CmdOStr[1] == enemyId)
							enemyDress = PackData.app.CmdOStr[2];
						
					}else{
						//测试回合过度
						/*if(gameVo.round != "0" && gameVo.round != "1" && gameVo.apoint1 == -1 && gameVo.apoint2 == -1 && gameVo.apoint3 == -1 && 
							gameVo.bpoint1 == -1 && gameVo.bpoint2 == -1 && gameVo.bpoint3 == -1){
							
							gameVo.fstatus = "V";
						}*/
						
						showFightInfo();
						
					}
					
					
					break;
				case GIVE_ONE_POINT:
					if(!result.isErr){
						trace("出招结果："+PackData.app.CmdOStr[0]);
						
						var _ablood:int = int(PackData.app.CmdOStr[4]);
						var _bblood:int = int(PackData.app.CmdOStr[5]);
						
						if(_ablood < 0)	_ablood = 0;
						if(_bblood < 0)	_bblood = 0;
						
						
						//自己是挑战者
						if(PackData.app.CmdOStr[2] == PackData.app.head.dwOperID.toString()){
							myBlood.updateBar(_ablood);
							enemyBlood.updateBar(_bblood);
						}else{
							myBlood.updateBar(_bblood);
							enemyBlood.updateBar(_ablood);
						}
						
						
						
						//显示蓄气
						var energy:int = 0;
						if(gameVo.apoint1 == -1)	energy = 1;
						else if(gameVo.apoint2 == -1)	energy = 2;
						else if(gameVo.apoint3 == -1)	energy = 3;
						myEnergy.updateData(energy);
						
						sendNotification(FightGameMediator.UPDATE_ITEM,["Point",gameVo.fid,hurtPoint]);
						
					}else{
						trace("出错了？出招结果："+PackData.app.CmdOStr[0]);
					}
					canTouch = true;
					
					break;
				
				case FightVideoView.PLAY_VIDEO_COMPLETE:
					
					vfBtn.isEnabled = true;
					vfBtn.visible = false;
					
					gameVo.fstatus = "B";
					showFightInfo();
//					sendNotification(FightGameMediator.UPDATE_ITEM,["State",gameVo.fid,"B"]);
					
					break;
				case SEL_LRFIGHT_INFO:
					if(!result.isErr){
						vfBtn.isEnabled = true;
						vfBtn.visible = false;
						
//						showFightInfo();
						if(gameVo.aid == PackData.app.head.dwOperID.toString())
							sendNotification(FightGameMediator.UPDATE_ITEM,["State",gameVo.fid,"R",""]);
						else
							sendNotification(FightGameMediator.UPDATE_ITEM,["State",gameVo.fid,"","R"]);
					}else{
						vfBtn.isEnabled = true;
						vfBtn.visible = true;
					}
					
					
					
					break;
				case VoTest:
					if(!result.isErr){
						vfBtn.isEnabled = true;
						vfBtn.visible = false;
						
						if(testvo.aid == PackData.app.head.dwOperID.toString())
							sendNotification(FightGameMediator.UPDATE_ITEM,["State",testvo.fid,"R",""]);
						else
							sendNotification(FightGameMediator.UPDATE_ITEM,["State",testvo.fid,"","R"]);
					}else{
						vfBtn.isEnabled = true;
						vfBtn.visible = true;
					}
					
					break;
				case VideoTest:
					var _vo:FightGameVo = notification.getBody() as FightGameVo;
					//发送观看完提醒
					sendViewTips(_vo);
					
					playFight();
					
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [GET_EQUIPMENT_COMPLETE,GIVE_ONE_POINT,FightVideoView.PLAY_VIDEO_COMPLETE,SEL_LRFIGHT_INFO,VideoTest,VoTest];
		}
		
		
		
		private function initResultTips():void{
			fightState = new Sprite;
			fightState.x = 168;
			fightState.y = 82;
			view.addChild(fightState);
			
			var mis:Image = new Image(Assets.getFightGameTexture("fighting_miss"));
			fightState.addChild(mis);
			mis.touchable = false;
			mis.visible = false;
			
			var hit:Image = new Image(Assets.getFightGameTexture("fighting_fight"));
			fightState.addChild(hit);
			hit.touchable = false;
			hit.visible = false;
			
		}
		//创建人物
		private function createCharater():void{
			if(!facade.hasProxy(ModuleConst.FIGHT_CHARATER_POOL)){
				pool = new FightCharaterPoolProxy(true);
				facade.registerProxy(pool);
				pool.init();
			}else{
				pool = facade.retrieveProxy(ModuleConst.FIGHT_CHARATER_POOL) as FightCharaterPoolProxy;
			}
			pool.charaterPool =facade.retrieveProxy(ModuleConst.HUMAN_POOL) as ObjectPool;
			
			
			
			me = pool.object;
			GlobalModule.charaterUtils.humanDressFun(me.charater,Global.myDressList);
			me.charater.view.x = 25;
			me.charater.view.y = 146;
			charaterSp.addChild(me.charater.view);
			
			enemy = pool.object;
			GlobalModule.charaterUtils.humanDressFun(enemy.charater,"face_face1");
			enemy.charater.view.x = 450;
			enemy.charater.view.y = 146;
			charaterSp.addChild(enemy.charater.view);
			
			
			//出招状态信息
			myInfoSp.x = 66;
			myInfoSp.y = 26;
			view.addChild(myInfoSp);
			enemyInfoSp.x = 311;
			enemyInfoSp.y = 26;
			view.addChild(enemyInfoSp);
			
		}
		private var enemyInfoSp:Sprite = new Sprite;
		private var myInfoSp:Sprite = new Sprite;
		
		
		
		private var gameVo:FightGameVo;
		private var myFightPro:String = "";
		private var enDefenPro:String = "";
		
		private var isChangeItem:Boolean;	//标识是否改变了对手
		public function updateData(_gameVo:FightGameVo):void{
			isChangeItem = false;
			if(!gameVo || gameVo.fid != _gameVo.fid)
				isChangeItem = true;
			
			gameVo = _gameVo;
			
	
			//如果改变了对手，则需要更新人物装备
			if(isChangeItem){
				//刷新，改变对手时，停止转动
				_start = false;
				roller.stop();
				canTouch = true;
				
				//自己是挑战者
				if(gameVo.aid == PackData.app.head.dwOperID.toString())
					enemyId = gameVo.bid;
				else
					enemyId = gameVo.aid;
				
				getEquipment(enemyId);
			}else{
				//测试回合过度
				/*if(gameVo.round != "0" && gameVo.round != "1" && gameVo.apoint1 == -1 && gameVo.apoint2 == -1 && gameVo.apoint3 == -1 && 
					gameVo.bpoint1 == -1 && gameVo.bpoint2 == -1 && gameVo.bpoint3 == -1){
					
					gameVo.fstatus = "V";
				}*/
				
				showFightInfo();
				
			}
			

			
		}
		private function getEquipment(_id:String):void{
			TweenLite.killTweensOf(getEquipment);
			if(Global.isLoading){
				TweenLite.delayedCall(2,getEquipment,[_id]);
				return;
			}
			
			
			PackData.app.CmdIStr[0] = CmdStr.GET_CHARATER_EQUIPMENT;
			PackData.app.CmdIStr[1] = _id;
			PackData.app.CmdInCnt = 2;
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(GET_EQUIPMENT_COMPLETE));
			
		}
		private function getPropertyByType(_pro:String,_type:String):String{
			var fightArr:Array = new Array;
			var defenArr:Array = new Array;
			
			var arr:Array = _pro.split(";");
			for (var i:int = 0; i < arr.length; i++) 
			{
				var __proArr:Array = (arr[i] as String).split(",");
				
				if(!__proArr[0])
					continue;
				//正数为伤害
				if(__proArr[0] >= 0)
					fightArr.push(arr[i]);
				else
					defenArr.push(arr[i]);
			}
			
			//伤害值
			if(_type == "fight")
				return fightArr.join(";");
			else//防御值
				return defenArr.join(";");
		}
		
		private function showFightInfo():void{
			vfBtn.visible = false;
			myInfoSp.removeChildren(0,-1,true);
			enemyInfoSp.removeChildren(0,-1,true);
			//改变对手，则刷新人物
			if(isChangeItem){
				if(me){
					me.charater.view.visible = true;
					me.setTo(25,146);
					me.decision =  new HeroGoAI(new Point(110,140),null);
					me.start();
				}
				
				if(enemy){
					enemy.charater.view.visible = true;
					
					enemy.setTo(450,146);
					GlobalModule.charaterUtils.configHumanFromDressList(enemy.charater,enemyDress,null);
					enemy.decision =  new HeroGoAI(new Point(362,140),null);
					enemy.start();
					
					//初始化圈圈
					var myPro:String = GlobalModule.charaterUtils.getEquipProperty(Global.myDressList);	//取个人全装备
					var enemyPro:String = GlobalModule.charaterUtils.getEquipProperty(enemyDress);	//取敌人全装备
					myFightPro = getPropertyByType(myPro,"fight");
					enDefenPro = getPropertyByType(enemyPro,"defen");
					
					roller.clear();
					RollerUtils.setRollerByProperty(roller,myFightPro+";"+enDefenPro);
					roller.refresh();
				}
			}
			
			
			var vo:FightGameDealVo = new FightGameDealVo(gameVo);	//格式化战斗数据
			
			
			//roundSp
			var texture:Texture = Assets.getFightGameTexture("round"+vo.round);
			if(texture){
				var roundIcon:Image = new Image(texture);
				refreshSprite(roundSp,roundIcon);
			}
			
			
			//显示蓄气
			var myEnVal:int = 3;
			var yourEnVal:int = 3;
			//判断是否挑战者
//			var isAsk:Boolean = gameVo.aid == PackData.app.head.dwOperID.toString() ? true : false;
			
			
			//普通状态
			if(vo.fstatus == "B"){
				//计算a、b蓄气
				if(vo.myPoint1 == -1)	myEnVal = 0;
				else if(vo.myPoint2 == -1)	myEnVal = 1;
				else if(vo.myPoint3 == -1)	myEnVal = 2;
				
				if(vo.yourPoint1 == -1)	yourEnVal = 0;
				else if(vo.yourPoint2 == -1)	yourEnVal = 1;
				else if(vo.yourPoint3 == -1)	yourEnVal = 2;
				
				enemyNameTF.text = vo.yourName;
				
				canTouch = true;
				myEnergy.updateData(myEnVal);
				enEnergy.updateData(yourEnVal);
				
				myBlood.updateBar(vo.myBlood,vo.myLrBlood);
				enemyBlood.updateBar(vo.yourBlood,vo.yourLrBlood);
				if(vo.myPoint1 != -1)
					refreshSprite(myInfoSp,getFightInfoSp(vo.myPoint1,vo.myPoint2,vo.myPoint3));
				if(vo.yourPoint1 != -1)
					refreshSprite(enemyInfoSp,getFightInfoSp(-1,-1,-1));
				
				
				
				
//				//自己是挑战者
//				if(isAsk){
//					enemyNameTF.text = gameVo.bname;
//					
//					//如果是等待状态，则显示"上一回合"的数据
//					if(gameVo.astatus == "U"){
//						canTouch = false;
//						vfBtn.visible = true;
//						myEnergy.updateData(3);
//						enEnergy.updateData(3);
//						
//						myBlood.updateBar(gameVo.alrBlood);
//						enemyBlood.updateBar(gameVo.blrBlood);
//						if(gameVo.alrPoint1 != -1)
//							refreshSprite(myInfoSp,getFightInfoSp(gameVo.alrPoint1,gameVo.alrPoint2,gameVo.alrPoint3));
//						if(gameVo.blrPoint1 != -1)
////							refreshSprite(enemyInfoSp,getFightInfoSp(-1,-1,-1));
//							refreshSprite(enemyInfoSp,getFightInfoSp(gameVo.blrPoint1,gameVo.blrPoint2,gameVo.blrPoint3));	//等待状态，显示对手出招
//					}else{
//						canTouch = true;
//						myEnergy.updateData(aenergy);
//						enEnergy.updateData(benergy);
//						
//						myBlood.updateBar(gameVo.ablood,gameVo.alrBlood);
//						enemyBlood.updateBar(gameVo.bblood,gameVo.blrBlood);
//						if(gameVo.apoint1 != -1)
//							refreshSprite(myInfoSp,getFightInfoSp(gameVo.apoint1,gameVo.apoint2,gameVo.apoint3));
//						if(gameVo.bpoint1 != -1)
//							refreshSprite(enemyInfoSp,getFightInfoSp(-1,-1,-1));
//					}
//				}else{
//					enemyNameTF.text = gameVo.aname;
//					
//					//如果是等待状态，则显示"上一回合"的数据
//					if(gameVo.bstatus == "U"){
//						canTouch = false;
//						vfBtn.visible = true;
//						myEnergy.updateData(3);
//						enEnergy.updateData(3);
//						
//						myBlood.updateBar(gameVo.blrBlood);
//						enemyBlood.updateBar(gameVo.alrBlood);
//						if(gameVo.blrPoint1 != -1)
//							refreshSprite(myInfoSp,getFightInfoSp(gameVo.blrPoint1,gameVo.blrPoint2,gameVo.blrPoint3));
//						if(gameVo.alrPoint1 != -1)
////							refreshSprite(enemyInfoSp,getFightInfoSp(-1,-1,-1));
//							refreshSprite(enemyInfoSp,getFightInfoSp(gameVo.alrPoint1,gameVo.alrPoint2,gameVo.alrPoint3));	//等待状态，显示对手出招
//					}else{
//						canTouch = true;
//						myEnergy.updateData(benergy);
//						enEnergy.updateData(aenergy);
//						
//						myBlood.updateBar(gameVo.bblood,gameVo.blrBlood);
//						enemyBlood.updateBar(gameVo.ablood,gameVo.alrBlood);
//						if(gameVo.bpoint1 != -1)
//							refreshSprite(myInfoSp,getFightInfoSp(gameVo.bpoint1,gameVo.bpoint2,gameVo.bpoint3));
//						if(gameVo.apoint1 != -1)
//							refreshSprite(enemyInfoSp,getFightInfoSp(-1,-1,-1));
//					}
//				}
				
			}
			/*else if(gameVo.fstatus.indexOf("Z") != -1){
				//战斗结束-等待状态,显示上回合的血量、本回合的出招
				if(isAsk){
					enemyNameTF.text = gameVo.bname;
					
					//如果是等待状态，则显示"上一回合"的数据
					if(gameVo.astatus == "U"){
						canTouch = false;
						vfBtn.visible = true;
						myEnergy.updateData(3);
						enEnergy.updateData(3);
						
						myBlood.updateBar(gameVo.alrBlood);
						enemyBlood.updateBar(gameVo.blrBlood);
						if(gameVo.apoint1 != -1)
							refreshSprite(myInfoSp,getFightInfoSp(gameVo.apoint1,gameVo.apoint2,gameVo.apoint3));
						if(gameVo.bpoint1 != -1)
//							refreshSprite(enemyInfoSp,getFightInfoSp(-1,-1,-1));
							refreshSprite(enemyInfoSp,getFightInfoSp(gameVo.bpoint1,gameVo.bpoint2,gameVo.bpoint3));	//等待状态，显示对手出招
					}
				}else{
					enemyNameTF.text = gameVo.aname;
					
					//如果是等待状态，则显示"上一回合"的数据
					if(gameVo.bstatus == "U"){
						canTouch = false;
						vfBtn.visible = true;
						myEnergy.updateData(3);
						enEnergy.updateData(3);
						
						myBlood.updateBar(gameVo.blrBlood);
						enemyBlood.updateBar(gameVo.alrBlood);
						if(gameVo.bpoint1 != -1)
							refreshSprite(myInfoSp,getFightInfoSp(gameVo.bpoint1,gameVo.bpoint2,gameVo.bpoint3));
						if(gameVo.apoint1 != -1)
//							refreshSprite(enemyInfoSp,getFightInfoSp(-1,-1,-1));
							refreshSprite(enemyInfoSp,getFightInfoSp(gameVo.apoint1,gameVo.apoint2,gameVo.apoint3));	//等待状态，显示对手出招
					}
				}
				
				
				
				
			}*/
			
			
			
		}
		//观看战斗录像
		private function vfBtnHandle():void{
			//发送观看完提醒
			sendViewTips(gameVo);
			
			playFight();
		}
		//播放录像函数
		private function playFight():void{
			var fightVideo:FightVideoView = new FightVideoView(pool);
			fightVideo.updateData(enemyDress);
//			AppLayoutUtils.uiLayer.addChild(fightVideo);
			AppLayoutUtils.uiLayer.stage.addChild(fightVideo);
			
		}
		
		
		private function getFightInfoSp(_p1:int,_p2:int,_p3:int):Sprite{
			
			var sp:Sprite = new Sprite;
			var point:Image;
			
			if(_p1 != -1){
				if(_p1 == 0)	point = new Image(Assets.getFightGameTexture("fpointM"));
				else	point = new Image(Assets.getFightGameTexture("fpoint"+_p1));
				point.scaleX = 0.7;
				point.scaleY = 0.7;
				sp.addChild(point);
				
				if(_p2 != -1){
					if(_p2 == 0)	point = new Image(Assets.getFightGameTexture("fpointM"));
					else	point = new Image(Assets.getFightGameTexture("fpoint"+_p2));
					point.scaleX = 0.7;
					point.scaleY = 0.7;
					point.x = 34;
					sp.addChild(point);
				}
				if(_p3 != -1){
					if(_p3 == 0)	point = new Image(Assets.getFightGameTexture("fpointM"));
					else	point = new Image(Assets.getFightGameTexture("fpoint"+_p3));
					point.scaleX = 0.7;
					point.scaleY = 0.7;
					point.x = 68;
					sp.addChild(point);
				}
			}else{
				//全是问号
				for (var i:int = 0; i < 3; i++) 
				{
					point = new Image(Assets.getFightGameTexture("fpointQ"));
					point.scaleX = 0.7;
					point.scaleY = 0.7;
					point.x = i*34;
					sp.addChild(point);
				}
			}
			return sp;
		}
		private function refreshSprite(_sp:Sprite,_displayObject:DisplayObject):void{
			if(_sp && _displayObject){
				_sp.removeChildren(0,-1,true);
				
				_sp.addChild(_displayObject);
			}
		}
		
		
		
		
		
		private var beginY:Number;
		private var endY:Number;
		private var _start:Boolean;
		private var canTouch:Boolean;
		private function touchHandle(event:TouchEvent):void
		{
			var touchPoint:Touch = event.getTouch(event.target as DisplayObject);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					beginY = touchPoint.globalY;
				}else if(touchPoint.phase==TouchPhase.ENDED){
					endY = touchPoint.globalY;
					if(Math.abs(endY-beginY) < 10){
						if(!canTouch)
							return;
						
						//出招完成
						if((gameVo.aid == PackData.app.head.dwOperID.toString() && gameVo.apoint3 != -1) ||
							(gameVo.aid != PackData.app.head.dwOperID.toString() && gameVo.bpoint3 != -1)){
							sendNotification(WorldConst.DIALOGBOX_SHOW,
								new DialogBoxShowCommandVO(view.stage,640,381,null,"本回合出招完成，请等待对手出招!"));
							
							return;
						}
						
						_start = !_start;
						
						if(_start){
							roller.start();
						}else{
							roller.stop();
							
							
							canTouch = false;
							getResult();
						}
						
					}
				}
			}
		}
		
		private function getResult():void{
			TweenLite.killTweensOf(fightState);
			
			
			fightState.visible = true;
			TweenLite.to(fightState,0.2,{delay:2,visible:false});
			
			
			/*me.charater.action("fight",8,me.fighter.attackRate*20,false);
			TweenLite.to(me,me.fighter.attackRate*20,{onComplete:attackComplete,onCompleteParams:[me],useFrames:true});
			
			enemy.charater.action("die",8,enemy.fighter.attackRate*20,false);
			TweenLite.to(enemy,enemy.fighter.attackRate*20,{onComplete:attackComplete,onCompleteParams:[enemy],useFrames:true});*/
			
			
			
			//取伤害值
			var val:int = RollerUtils.getRollerValueByProperty(roller.value,myFightPro,enDefenPro);
			trace("摇到了-原始分："+roller.value);
			trace("摇到了-标准分："+val);
			
			if(val <= 0){
				fightState.getChildAt(0).visible = true;
				fightState.getChildAt(1).visible = false;
			}else{
				fightState.getChildAt(0).visible = false;
				fightState.getChildAt(1).visible = true;
			}
			
			
			sendFightPoint(val);
		}
		private function attackComplete(ai:FighterControllerMediator):void{

			ai.fighter.idle();

		}
		
		private var hurtPoint:int = 0;
		private function sendFightPoint(_point:int):void{
			trace("打击："+_point);
			TweenLite.killTweensOf(sendFightPoint);
			if(Global.isLoading){
				TweenLite.delayedCall(2,sendFightPoint,[_point]);
				return;
			}
			
			hurtPoint = _point;
			
			PackData.app.CmdIStr[0] = CmdStr.GIVE_ONE_POINT;
			PackData.app.CmdIStr[1] = gameVo.fid;
			PackData.app.CmdIStr[2] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[3] = _point.toString();
			PackData.app.CmdInCnt = 4;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(GIVE_ONE_POINT));
			
			
		}
		private var testvo:FightGameVo;
		private function sendViewTips(_vo:FightGameVo):void{
			TweenLite.killTweensOf(sendViewTips);
			if(Global.isLoading){
				TweenLite.delayedCall(2,sendViewTips,[_vo]);
				return;
			}
			testvo = _vo;
			//开始发送后，禁用播放按钮，返回结果是启用
			vfBtn.isEnabled = false;
			
			PackData.app.CmdIStr[0] = CmdStr.SEL_LRFIGHT_INF;
			PackData.app.CmdIStr[1] = _vo.fid;
			PackData.app.CmdIStr[2] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 3;
//			sendNotification(CoreConst.SEND_11,new SendCommandVO(SEL_LRFIGHT_INFO));
			sendNotification(CoreConst.SEND_11,new SendCommandVO(VoTest));
			
		}
		
		
		
		
		
		
		
		
		
		private function closeBtnHandle(e:Event):void{
			
			view.visible = false;
			
			sendNotification(FightGameMediator.CLICK_ITME,null);
		}
		
		
		
		
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function onRemove():void{
			super.onRemove();
			
//			TweenLite.killTweensOf(me);
			TweenLite.killTweensOf(sendFightPoint);
			TweenLite.killTweensOf(sendViewTips);
			TweenLite.killTweensOf(getEquipment);
			TweenLite.killTweensOf(fightState);
			
			if(me && pool)
				pool.object = me;
			if(enemy && pool)
				pool.object = enemy;
			
			facade.removeProxy(ModuleConst.FIGHT_CHARATER_POOL);
			
			view.removeChildren(0,-1,true);
		}
		
		
		
		
		
	}
}