package com.studyMate.world.screens
{
	import com.byxb.extensions.starling.display.CameraSprite;
	import com.byxb.extensions.starling.events.CameraUpdateEvent;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.mylib.api.ICharaterUtils;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.controller.FreeScrollerMediator;
	import com.mylib.framework.controller.SwitchScreenCommand;
	import com.mylib.framework.controller.vo.ScrollRadio;
	import com.mylib.framework.controller.vo.TransformVO;
	import com.mylib.framework.model.SwitchScreenProxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.charater.CharaterMenuProxy;
	import com.mylib.game.charater.IHuman;
	import com.mylib.game.charater.PetDogMediator;
	import com.mylib.game.charater.TalkingProxy;
	import com.mylib.game.charater.logic.AIState;
	import com.mylib.game.charater.logic.AbstractBoidMediator;
	import com.mylib.game.charater.logic.BaseCharaterControllerMediator;
	import com.mylib.game.charater.logic.HumanTalkShowProxy;
	import com.mylib.game.charater.logic.IslanderControllerMediator;
	import com.mylib.game.charater.logic.IslandersManagerMediator;
	import com.mylib.game.charater.logic.PetDogControllerMediator;
	import com.mylib.game.charater.logic.PetFactoryProxy;
	import com.mylib.game.charater.logic.ai.CharaterControlAI;
	import com.mylib.game.charater.logic.ai.ExitIslanderAI;
	import com.mylib.game.charater.logic.ai.IslanderAI;
	import com.mylib.game.charater.logic.ai.PetDogFreeAI;
	import com.mylib.game.charater.logic.ai.SantaAI;
	import com.mylib.game.charater.logic.vo.JoinIslandVO;
	import com.mylib.game.controller.MutiCharaterControllerMediator;
	import com.mylib.game.controller.MutiOLTransferMediator;
	import com.mylib.game.controller.MutiOnlineTransferMediator;
	import com.mylib.game.controller.MutiSpeechMediator;
	import com.mylib.game.controller.OnlineLocationMediator;
	import com.mylib.game.fightGame.FightGameMediator;
	import com.mylib.game.fishGame.Balloon;
	import com.mylib.game.house.HouseInfoVO;
	import com.mylib.game.house.IslandNpcHouseMediator;
	import com.mylib.game.house.IslandSysHouseMediator;
	import com.mylib.game.model.CharaterSuitsInfoProxy;
	import com.mylib.game.model.IslanderPoolProxy;
	import com.studyMate.controller.IslandSwitchScreenCommand;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.module.game.api.DressMarketConst;
	import com.studyMate.world.component.ChristmasTreeMediator;
	import com.studyMate.world.component.HeadAdMediator;
	import com.studyMate.world.controller.vo.DisplayChatViewCommandVO;
	import com.studyMate.world.controller.vo.RemindPriMessVO;
	import com.studyMate.world.model.vo.DressSuitsVO;
	import com.studyMate.world.model.vo.LoadSoundEffectVO;
	import com.studyMate.world.model.vo.MessageVO;
	import com.studyMate.world.model.vo.PlaySoundEffectVO;
	import com.studyMate.world.model.vo.RelListItemSpVO;
	import com.studyMate.world.screens.chatroom.WCHolderMediator;
	import com.studyMate.world.screens.component.ButterflyMediator;
	import com.studyMate.world.screens.component.MeteorSp;
	import com.studyMate.world.screens.effects.WindFlower;
	import com.studyMate.world.screens.ui.Windmill;
	import com.studyMate.world.screens.ui.music.MusicHopeMediator;
	import com.studyMate.world.screens.view.AlertChrHopeMediator;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.graphics.Fill;
	import starling.display.graphics.Stroke;
	import starling.display.shaders.vertex.RippleVertexShader;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.PixelHitArea;

	public class HappyIslandMediator extends SceneMediator
	{
		public static const NAME:String = "HappyIslandMediator";
		public static const FINISH_MESSAGE:String = NAME + "Finish_Message";
		private const QRY_STD_PER_ROOM_COMPLETE:String = NAME + "QryStdPerroomComplete";
		private const GET_RELATE_LIST:String = NAME + "GetRelateList";
		private const CHECK_HAPPY_STATUS:String = NAME + "CheckHappyStatus";
		private const SEL_TASK_STATUS:String = NAME + "SelTaskStatus";
		private const QRY_EQUIPMENT:String = NAME + "QryEquipment";
		
		private var vo:SwitchScreenVO;
		
		private var cloudRange01:Rectangle = new Rectangle(-740,-681,3300,100);
		private var cloudRange02:Rectangle = new Rectangle(-1640,-581,4000,100);
		
		public var islanderPool:IslanderPoolProxy;
		private var range:Rectangle = new Rectangle(-640,200,1280,80);
		private var manager:IslandersManagerMediator;
		private var maxIslander:int = 5;
		private var playerNum:int;
		private var MAX_ISLANDER:int;
		private var timeCount:Number=0;
		private var dog:PetDogMediator;
		private var dogController:PetDogControllerMediator;
//		private var butterfly:AbstractBoidMediator;
		private var windFlower:WindFlower;
		private var npcsuitProxy:CharaterSuitsInfoProxy;
		
		private var _background:HappyIslandBackground;
		
		private var pathHolder:Sprite;
		private var charaterHolder:Sprite;
		private var sysHouseHolder:Sprite;
		private var npcHouseHolder:Sprite;
		
		private var hit_1:PixelHitArea;
		
		private var gift:GiftManagementMediator;
		
		private var addHouseBtn:Button;
		private var houseList:Vector.<HouseInfoVO>;
		
		private var tvo:TransformVO;
		
		private var bgImg:Image;
		private var bgHolder:Sprite;
		
		private var talkBtn:Button;
		private var fightBtn:Button;
		private var dresslist:Vector.<DressSuitsVO> = new Vector.<DressSuitsVO>;
		private var front:HappyIslandFrontground;
		
		public function HappyIslandMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function prepare(vo:SwitchScreenVO):void
		{
			this.vo = vo;
			//发送命令字，取自己的房子列表
			houseList = new Vector.<HouseInfoVO>;
			
			/*getHouseList(PackData.app.head.dwOperID.toString());*/
			
			/*Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);*/
			
			
			//如果选择在学校，则不进入娱乐岛
			if(Global.use3G){
				
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.CANCEL_SWITCH,vo);
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.TOAST,new ToastVO("嘘！您在学校，还不能进来玩哦，会被老师发现的~O(∩_∩)O~",3));
			}else{
				
//				if(Global.dressDatalist && Global.dressDatalist.length == 0){
//					//取商城所有装备
//					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.GET_SERVER_EQUIPMENT,[QRY_EQUIPMENT]);
//				}else{
					//检查是否进入娱乐岛
					checkHappyStatus();
//				}
				
			}
		}
		
		override public function activate():void
		{
			super.activate();
			trace("@VIEW:HappyIslandMediator:");
			
//			view.root.stage.color = 0xAEDBF0;
			
			
			if(!facade.hasMediator(FreeScrollerMediator.NAME)){
				Global.isFirstSwitch = false;
				sendNotification(WorldConst.SWITCH_SCREEN,[
					new SwitchScreenVO(FreeScrollerMediator,tvo,SwitchScreenType.SHOW,view),
				]);
				
				Global.isFirstSwitch = true;
				
			}
			
			wholderMediator.displayHolder(true);
			facade.registerMediator(new OnlineLocationMediator());
			
			
			
			
		}
		
		override public function deactivate():void
		{
			super.deactivate();
			sendNotification(WorldConst.SET_ROLL_SCREEN,false);
			
			facade.removeMediator(FreeScrollerMediator.NAME);
			
			wholderMediator.displayHolder(false);
			facade.removeMediator(OnlineLocationMediator.NAME);
			
		}
		
		private function checkHappyStatus():void{
			
			PackData.app.CmdIStr[0] = CmdStr.SEL_HAPPY_STATUS;
			PackData.app.CmdIStr[1] = "S_HAPPY_ISLAND_O";
			PackData.app.CmdIStr[2] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 3;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(CHECK_HAPPY_STATUS));
			
			
		}
		
		override public function onRegister():void
		{
			sendNotification(WorldConst.SHOW_MAIN_MENU);
			sendNotification(WorldConst.SHOW_LEFT_MENU);
//			sendNotification(WorldConst.HAPPY_SHOWCHAT);
//			sendNotification(CoreConst.MANUAL_LOADING,true);

			
			var path:String = File.documentsDirectory.resolvePath(Global.localPath+"mp3/mainambient.mp3").url
//			SoundAS.loadSound(path,"mainambient");		
//			SoundAS.play("mainambient",0.4);
//			sendNotification(CoreConst.LOAD_EFFECT_SOUND,new LoadSoundEffectVO(path,"mainambient"));						
//			sendNotification(CoreConst.PLAY_EFFECT_SOUND,new PlaySoundEffectVO("mainambient",0.4));
				
				
			
			bgImg = new Image(Assets.getTexture("HapIsland_MountBg"));
			bgImg.touchable = false;
			bgImg.y = 285;
			view.addChild(bgImg);
			

			camera = new CameraSprite(new Rectangle(0, 0, WorldConst.stageWidth, WorldConst.stageHeight), null, .3, .1, .01);
			view.addChild(camera);
			
			_background = new HappyIslandBackground;
			_background.touchable = false;
			camera.addChild(_background);
			camera.addEventListener(CameraUpdateEvent.CAMERA_UPDATE, updateBackground);
			camera.moveTo(0, 0, 1, 0, false);
			_background.show(new Rectangle(-Global.stageWidth*0.5,-Global.stageHeight*0.5,Global.stageWidth,Global.stageHeight));
			
//			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(HorizontalScrollerMediator,[0,0],SwitchScreenType.SHOW,view)]);
			
			bgHolder = new Sprite;
			view.addChild(bgHolder);
			
			var local:Point = new Point(0,0);
			var edge:Rectangle = new Rectangle(0,0,0,0);
			tvo = new TransformVO(local,edge);
			
			tvo.radio = new ScrollRadio(0.5,0.5,0,0.1);
			
			sendNotification(WorldConst.SWITCH_SCREEN,[
				new SwitchScreenVO(FreeScrollerMediator,tvo,SwitchScreenType.SHOW,view),
			]);
			

			view.root.stage.color = 0x24426B;
			
			pathHolder = new Sprite;
			camera.addChild(pathHolder);
			sysHouseHolder = new Sprite();
			camera.addChild(sysHouseHolder);
			
			npcHouseHolder = new Sprite();
			camera.addChild(npcHouseHolder);
			
			
			charaterHolder = new Sprite();
			camera.addChild(charaterHolder);
			
			sendNotification(WorldConst.SWITCH_SCREEN,[
				new SwitchScreenVO(HeadAdMediator,null,SwitchScreenType.SHOW,pathHolder,530,-280)
			]);
			
			sendNotification(WorldConst.SWITCH_SCREEN,[
				new SwitchScreenVO(ChristmasTreeMediator,null,SwitchScreenType.SHOW,pathHolder,-320,-225)
			]);
			
			
			//房子点击热区
			hit_1 = new PixelHitArea ( Assets.store["HapIslandHouseTexture"],0.5);
			facade.registerMediator(new CharaterControllerMediator(pathHolder,range));

			facade.registerMediator(new IslandSysHouseMediator(sysHouseHolder,hit_1));
			/*facade.registerMediator(new IslandNpcHouseMediator(npcHouseHolder,hit_1,houseList));*/

			setHSRange();
//			(facade.retrieveMediator(HorizontalScrollerMediator.NAME) as HorizontalScrollerMediator).leftEdge = -2000;
//			(facade.retrieveMediator(HorizontalScrollerMediator.NAME) as HorizontalScrollerMediator).rightEdge = 4000;
			
			createWindmill();
			
//			createWater();
			createWindFlower();
			
			
//			var cloud01:Image =new Image(Assets.getHappyIslandTexture("hapIsland_Cloud01"));
//			var cloud02:Image =new Image(Assets.getHappyIslandTexture("hapIsland_Cloud02"));
//			sendNotification(WorldConst.RANDOM_ACTION,{displayObject:cloud01,holder:camera,range:cloudRange01,randomAction:false});
//			sendNotification(WorldConst.RANDOM_ACTION,{displayObject:cloud02,holder:camera,range:cloudRange02,randomAction:false});
			
			
//			facade.registerCommand(WorldConst.SWITCH_SCREEN,IslandSwitchScreenCommand);
			initIslandManager();
			
			
			gift = new GiftManagementMediator(charaterHolder,range,camera);
			facade.registerMediator(gift);
			//			sendNotification(WorldConst.GET_READ_GIFT);
			
			//面板-按钮
//			createFrontPanel();
			
			//多人在线逻辑
			createMutiCharater();
			//流星
			var sp:MeteorSp = new MeteorSp();
			view.addChild(sp);
			
			callSanta();
			this.backHandle = quitHandle;
			
			
			/*var btn:Button = new Button(Assets.getAtlasTexture("mainMenu/menuTalkBtn"));
			btn.x = 200;
			btn.y = 210;
			btn.addEventListener(Event.TRIGGERED,menuBtnHandle);
			view.addChild(btn);*/
//			front = new HappyIslandFrontground;
//			front.touchable = false;
//			camera.addChild(front);
//			front.show(new Rectangle(-Global.stageWidth*0.5,-Global.stageHeight*0.5,Global.stageWidth,Global.stageHeight));
//			
//			sendNotification(CoreConst.FLOW_RECORD,new RecordVO("ENTER_VIEW_MARK","HappyIslandMediator",0));
			
			
//			camera.moveTo(900,0,1,0,false);
			
			trace("@VIEW:HappyIslandMediator:");
			
		}
		
		private function menuBtnHandle(event:Event):void{
			sendNotification(WorldConst.OPEN_MENU);
			
		}
		
		private function quitHandle():void{
			if(!Global.isLoading){
				
				sendNotification(WorldConst.MUTICONTROL_STOP);
				sendNotification(WorldConst.POP_SCREEN);
			}
		}
		
		
		
/**初始化风车、水、多人在线、面板控制等*****************************************************************************************************/
		
		private function createWindmill():void{
			//加入风车
			var windmill:Windmill = new Windmill(-235,20,Math.random()*4+2);
			pathHolder.addChild(windmill);
			
			windmill = new Windmill(230,20,Math.random()*4+2);
			pathHolder.addChild(windmill);						
		}
		private function createWater():void{
			var w:Number = view.stage.stageWidth;
			var h:Number = view.stage.stageHeight;
			var waterColorTop:uint = 0x08acff;
			var waterColorBottom:uint = 0x0073ad;
			var waterColorSurface:uint = 0x3cb6c9;
			
			var waterHeight:Number = h-100;
			var waterFill:Fill = new Fill();
			waterFill.addVertex(0, waterHeight, waterColorTop,0.4 );
			waterFill.addVertex(w, waterHeight, waterColorTop,0.4 );
			waterFill.addVertex(w, h, waterColorBottom,0 );
			waterFill.addVertex(0, h, waterColorBottom,0 );
			waterFill.touchable = false;
			bgHolder.addChild(waterFill);
			
			var waterSurfaceThickness:Number = 20;
			var waterSurfaceStroke:Stroke = new Stroke();
			waterSurfaceStroke.material.vertexShader = new RippleVertexShader();
			for ( var i:int = 0; i < 50; i++ )
			{
				var ratio:Number = i / 49;
				waterSurfaceStroke.addVertex( ratio * w, waterHeight - waterSurfaceThickness*0.25, waterSurfaceThickness, waterColorSurface, 0.8, waterColorTop, 0.3);
			}
			waterSurfaceStroke.touchable = false;
			bgHolder.addChild(waterSurfaceStroke);
		}
		private function createWindFlower():void{
			windFlower = new WindFlower;
			windFlower.x = 400;
			windFlower.y = -390
			windFlower.touchable = false;
			camera.addChild(windFlower);
		}
		
		private var captain:IslanderControllerMediator;
		private var wholderMediator:WCHolderMediator;
		private function createMutiCharater():void{
			captain = islanderPool.object;
			var charaterControlAI:CharaterControlAI = new CharaterControlAI();
			
			captain.charater.velocity = 3.5;
			captain.decision = charaterControlAI;
			
			
			
			GlobalModule.charaterUtils.configHumanFromDressList(captain.charater,Global.myDressList,range);
			charaterHolder.addChild(captain.charater.view);
			
			captain.fsm.changeState(AIState.IDLE);
			captain.setTo(Math.random()*1200-600,180);
			captain.start();
			captain.charater.view.alpha = 1;

			captain.touchable = true;
			
			sendNotification(WorldConst.ADD_CHARATER_CONTROL,captain);
			sendNotification(WorldConst.UPDATE_PLAYER_MAP,"happy_island");
			sendNotification(WorldConst.UPDATE_PLAYER_CHARATER,captain.charater);
			
			//气球的
//			var ball:Balloon = new Balloon;
//			sysHouseHolder.addChild(ball);
//			ball.y = -70;
//			ball.x = -117
//			ball.setTail(-10,58);
//			ball.fix = true;
//			ball.addEventListener(TouchEvent.TOUCH,touchHandle);
			//加入多人在线逻辑

			facade.registerProxy(new CharaterMenuProxy());
//			facade.registerMediator(new MutiSpeechMediator());
//			facade.registerMediator(new MutiOLTransferMediator());
			facade.registerMediator(new MutiCharaterControllerMediator(charaterHolder,range));
			
			
			
			//初始化世界聊天框
			wholderMediator = new WCHolderMediator;
			wholderMediator.holder = view;
			facade.registerMediator(wholderMediator);
			
			//测试新多人在线
			facade.registerMediator(new OnlineLocationMediator());
		}
		
		private function touchHandle(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.target as DisplayObject,TouchPhase.ENDED);
			if(touch){
				
				(event.currentTarget as Balloon).fix = false;
				(event.currentTarget as Balloon).fly();
			}
			
			
		}		
		
		
		
		
		private function createFrontPanel():void{
//			sendNotification(WorldConst.CREATE_TALKINGBOX);
			talkBtn = new Button(Assets.getAtlasTexture("mainMenu/menuTalkBtn"));
			talkBtn.x = 20;
			talkBtn.y = 110;
			talkBtn.addEventListener(Event.TRIGGERED,talkBtnHandle);
//			view.addChild(talkBtn);
			
			fightBtn = new Button(Assets.getAtlasTexture("mainMenu/fightGame1Btn"));
			fightBtn.x = 20;
			fightBtn.y = 175;
			fightBtn.addEventListener(Event.TRIGGERED,fightBtnHandle);
//			view.addChild(fightBtn);
			


			if(PackData.app.head.dwOperID.toString() == "63" || PackData.app.head.dwOperID.toString() == "67")
				canTalk = true;
			
			/*var chatView:ChatViewMediator = new ChatViewMediator(relListItemSpVoList,canTalk);
			facade.registerMediator(chatView);
			chatView.createWorldChatSp();
			view.addChild(chatView.view);*/
		}

/**取好友列表**********************************************************************************************/
		private var canTalk:Boolean = true;
		private var relListItemSpVoList:Vector.<RelListItemSpVO> = new Vector.<RelListItemSpVO>;
		private var GMFile:File = Global.document.resolvePath(Global.localPath+"systemFile/GMList.edu");
		private var GMId:Array = new Array;
		
		//读edu - GMList.txt取客服列表
		private function getGMList():void{
			var stream:FileStream = new FileStream();
			if(GMFile.exists){
				stream.open(GMFile,FileMode.READ);
				var str:String = stream.readMultiByte(stream.bytesAvailable,PackData.BUFF_ENCODE);
				
				var strArr:Array = str.split("\r\n");
				
				var relListItemSpVo:RelListItemSpVO;
				var itemArr:Array;
				for(var i:int=0;i<strArr.length;i++){
					
					if(strArr[i] != ""){
						itemArr = strArr[i].split(",");
						trace("GM"+i + strArr[i]);
						
						relListItemSpVo = new RelListItemSpVO();
						relListItemSpVo.userId = PackData.app.head.dwOperID.toString();
						relListItemSpVo.rstdId = itemArr[0];
						relListItemSpVo.rstdCode = itemArr[1];
						relListItemSpVo.realName = itemArr[2];
						relListItemSpVo.relaType = itemArr[3];
						
						
						relListItemSpVoList.push(relListItemSpVo);
						
						GMId.push(itemArr[0]);
						
					}
					
				}
				stream.close();
			}else{
				stream.open(GMFile,FileMode.WRITE);
				stream.writeMultiByte("\r\n",PackData.BUFF_ENCODE);
				stream.close();
				
			}
			
			getRelateList();
		}
		//取好友列表
		private function getRelateList():void{
			PackData.app.CmdIStr[0] = CmdStr.QRY_STD_RELATLIST;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 2;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(GET_RELATE_LIST));
		}
		//检查是否完成任务，判断能否聊天
		private function checkTaskState():void{
			
			
			PackData.app.CmdIStr[0] = CmdStr.SEL_TASK_STATUS;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 2;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(SEL_TASK_STATUS));
			
			
			
		}
		
		
		
/**系统房子、个性化房子*****************************************************************************************************/
		
		public function setHSRange(scrToLeft:Boolean=false,scrToRight:Boolean=false):void{
			var ledge:uint = 0;
			var redge:uint = 0;
			
			if(npcHouseHolder.numChildren > 1)
				redge = (npcHouseHolder.numChildren-1)*320;
			if(sysHouseHolder.numChildren > 3)
				ledge = (sysHouseHolder.numChildren-3)*100;
			
			redge += 1100;
			
			left = ledge;
			right = redge;
			
			tvo.range.left = -left;
			tvo.range.width = right;
			
			
			
			range.x = -640-ledge;
			range.width = 1280+ledge+redge;
			
			
			
			sendNotification(CharaterControllerMediator.UPDATE_CHARATER_CONTROLHOLDER,range);
			
			if(scrToLeft){
				trace("ledge:"+ledge);
				camera.moveTo(ledge,0,1,0,false);
			}else if(scrToRight){
				trace("redge:"+redge);
			}
		}
		
		private function addHouseHandle(event:Event):void{	
			//ndNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(HouseStoreMediator,npcHouseHolder,SwitchScreenType.SHOW, view.stage)]);
			
		}
		
/**事件监听*****************************************************************************************************/	
		
		private function updateBackground(e:CameraUpdateEvent):void{
			if(_background)
			_background.show(e.viewport);
			if(front)
			front.show(e.viewport);
			
		}

		//聊天按钮
		private function talkBtnHandle(e:Event):void{
			
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SHOW_CHAT_VIEW,
				new DisplayChatViewCommandVO(true,"PC"));

		}
		//战斗提醒
		private function fightBtnHandle(e:Event):void{
			
			remindFightBtn(false);
			
			sendNotification(WorldConst.SWITCH_SCREEN,
				[new SwitchScreenVO(FightGameMediator,null,SwitchScreenType.SHOW,view,640,0)]);
			
			sendNotification(WorldConst.SHOW_CHAT_VIEW,
				new DisplayChatViewCommandVO(false));
		}
		
		private var idArray:Array = new Array();
		private function remindTalkBtn(_isShake:Boolean):void{
			TweenLite.killTweensOf(talkBtn);
			talkBtn.x = 20;
			talkBtn.y = 110;
			
			//提醒
			if(_isShake){
				
				TweenMax.to(talkBtn,0.3,{x:talkBtn.x+2,y:talkBtn.y+2,repeat:int.MAX_VALUE,yoyo:true,ease:Linear.easeNone});
			}
			
		}
		
		private function remindFightBtn(_isShake:Boolean):void{
			TweenLite.killTweensOf(fightBtn);
			fightBtn.x = 20;
			fightBtn.y = 175;
			
			//提醒
			if(_isShake){
				TweenMax.to(fightBtn,0.3,{x:fightBtn.x+2,y:fightBtn.y+2,repeat:int.MAX_VALUE,yoyo:true,ease:Linear.easeNone});
			}
		}
		
/**岛民、小狗、蝴蝶*****************************************************************************************************/		
		private var islandnpc:Array = new Array;
		override public function advanceTime(time:Number):void
		{
			sendNotification(WorldConst.SORT_CONTAINER,charaterHolder);
			if(manager.islanders.length>maxIslander){
				timeCount+= time;
				
				if(timeCount>10){
					dismissIslander();
					timeCount = 0;
				}
				
			}else{
				/*callIslander(npcsuitProxy.npcSuitsMap.find("npc"+(int(Math.random()*8)+1).toString()));*/
				
				if(playerNum>MAX_ISLANDER){
					return;
				}
				
				var npclist:Array = npcsuitProxy.getNpcList().concat();
				
				var npc:String;
				if(islandnpc.length < npclist.length){
					npc = npclist[int(Math.random()*npclist.length)]
					
					if(islandnpc.indexOf(npc) == -1){
						callIslander(npc,npcsuitProxy.getDress(npc));
						islandnpc.push(npc);
					}
				}
			}
		}
		private function initIslandManager():void{
			manager = new IslandersManagerMediator();
			facade.registerMediator(manager);
			
			islanderPool = new IslanderPoolProxy(true);
			facade.registerProxy(islanderPool);
			islanderPool.init();
			
			
			runEnterFrames = true;
			
			//小狗
			var petCreater:PetFactoryProxy = facade.retrieveProxy(PetFactoryProxy.NAME) as PetFactoryProxy;
			dog = petCreater.getPetDog("petDog1","dog1",range);
			GlobalModule.charaterUtils.humanDressFun(dog,"bmpNpc_bmp1");
//			dog.actor.switchCostume("head","face","normal");
			dog.velocity = 3;
			dogController = new PetDogControllerMediator("my dog",dog);
			dogController.decision = new PetDogFreeAI;
			dogController.fsm.changeState(AIState.IDLE);
			dogController.setTo(100,170);
			dogController.start();
			dogController.go(500,200);
			charaterHolder.addChild(dogController.charater.view);
			
			//蝴蝶
//			butterfly = new ButterflyMediator("butterfly",camera);
//			butterfly.start();
			
			//获取NPC装备列表
			npcsuitProxy = new CharaterSuitsInfoProxy();
			facade.registerProxy(npcsuitProxy);
			
			/*var size:int = npcsuitProxy.npcSuitsMap.size;*/
			var size:int = npcsuitProxy.getSize();
			MAX_ISLANDER = maxIslander = size-1;

		}
		
		protected function dismissIslander():void{
			var islander:IslanderControllerMediator = manager.findFreeIslander(null);
			if(islander){
				islander.decision = new ExitIslanderAI(500,100,islander.islanderDecision);
				islander.go(manager.getIslanderHome(islander).x,manager.getIslanderHome(islander).y);
				
				if(islandnpc.indexOf(islander.charater.charaterName) != -1)
					islandnpc.splice(islandnpc.indexOf(islander.charater.charaterName),1);
			}
			
		}
		
		protected function callIslander(name:String,dress:String):void{
			
			var controller:IslanderControllerMediator = islanderPool.object;
			var islanderAI:IslanderAI = new IslanderAI();
			
			controller.charater.charaterName = name;
			controller.charater.velocity = Math.random()*3+0.5;
			controller.decision = islanderAI;
			if(dress)
				(Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CHARATER_UTILS) as ICharaterUtils).configHumanFromDressList(controller.charater,dress,range);
			else
				(Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CHARATER_UTILS) as ICharaterUtils).configHumanFromDressList(controller.charater,"set2,face_face1,sword",range);
			charaterHolder.addChild(controller.charater.view);
			sendNotification(IslandersManagerMediator.JOIN_ISLAND,new JoinIslandVO(controller,new Point(Math.random()*1000-500,130)));
			controller.setTo(Math.random()*1000-500,200);
			controller.start();
			controller.charater.view.alpha = 0;
			controller.touchable = true;
			TweenLite.to(controller.charater.view,1,{alpha:1,onComplete:controller.fsm.changeState,onCompleteParams:[AIState.DECISION]});
			/*controller.fsm.changeState(AIState.REST);
			controller.go(Math.random()*range.width+range.x,Math.random()*range.height+range.y);*/
			
		}
		
		protected function callSanta():void{
			var controller:IslanderControllerMediator = islanderPool.object;
			
			controller.charater.charaterName = "santa";
			controller.charater.velocity = 0.5;
			controller.decision = new SantaAI;
			(Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CHARATER_UTILS) as ICharaterUtils).configHumanFromDressList(controller.charater,npcsuitProxy.getDress("npc3"),range);
			charaterHolder.addChild(controller.charater.view);
			sendNotification(IslandersManagerMediator.JOIN_ISLAND,new JoinIslandVO(controller,new Point(Math.random()*1000-500,130)));
			controller.setTo(Math.random()*1000-500,200);
			controller.start();
			controller.charater.view.alpha = 0;
			controller.touchable = true;
			TweenLite.to(controller.charater.view,1,{alpha:1,onComplete:controller.fsm.changeState,onCompleteParams:[AIState.DECISION]});
			
		}
		
		private function recoverSanta(santa:IslanderControllerMediator):void{
			santa.charater.run();
			santa.start();
		}
		
/**消息接收处理、移除回收等*****************************************************************************************************/		
		
		override public function handleNotification(notification:INotification):void
		{			
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName())
			{
				case QRY_EQUIPMENT:
					if(!result.isEnd){
						
						var dressSuitVo:DressSuitsVO = new DressSuitsVO();
						dressSuitVo.equipId = PackData.app.CmdOStr[1];
						dressSuitVo.name = PackData.app.CmdOStr[2];
						dressSuitVo.price = PackData.app.CmdOStr[3];
						dressSuitVo.property = PackData.app.CmdOStr[6];
						dressSuitVo.goldprice = PackData.app.CmdOStr[8];
						dresslist.push(dressSuitVo);
						
					}else{
						Global.dressDatalist = dresslist;
						
						//检查是否进入娱乐岛
						checkHappyStatus();
						
					}
					break;
				case SEL_TASK_STATUS:
					if(!result.isErr){
						
						var _status:String = PackData.app.CmdOStr[1];
						
						if(_status == "Y")
							canTalk = true;
						else
							canTalk = false;
						
						
//						getGMList();
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
						
					}else{
						canTalk = true;
						
						//出错了，直接允许进入娱乐岛
//						getGMList();
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
					}
					break;
				case CHECK_HAPPY_STATUS:
					if(!result.isErr){
						
						var status:String = PackData.app.CmdOStr[1] as String;
						//允许进入
						if(status == "Y"){
							
							checkTaskState();
							
						}else{
							//不允许进入
							Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.CANCEL_SWITCH,vo);
							Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.TOAST,new ToastVO("您今天任务还没完成哦，完成后再来吧。。O(∩_∩)O~",3));
						}
					}else{
						
						
						checkTaskState();
					}
					
					break;
				case WorldConst.UPDATE_CAMERA:
					if(camera){
						
						var local:Point = notification.getBody() as Point;
						camera.moveTo(-local.x/tvo.scale,-local.y/tvo.scale,tvo.scale,0,false);
						bgHolder.y = local.y;
						
						/*if(local.y<-200){
							tvo.range.y = -2000;
							tvo.range.height = 0;
							
							(facade.retrieveMediator(FreeScrollerMediator.NAME) as FreeScrollerMediator).targetX = 0;
							(facade.retrieveMediator(FreeScrollerMediator.NAME) as FreeScrollerMediator).targetY = -600;
							
							
							camera.moveTo(0,600,tvo.scale,0,false);
						}else{
							tvo.range.y = 0;
						}*/
						
					}
//						camera.moveTo(-(notification.getBody() as int),0,1,0,false);
					break;
				case WorldConst.GET_GIFT : 
					var msg:MessageVO  = notification.getBody() as MessageVO;
					gift.dropGift(msg);
					break;
				case BaseCharaterControllerMediator.CLICK_CHARATER:
					var talkProxy:TalkingProxy = facade.retrieveProxy(TalkingProxy.NAME) as TalkingProxy;
					var npc:IslanderControllerMediator = notification.getBody() as IslanderControllerMediator;
					//正在离开的NPC不参与对话
					if(npc.decision is IslanderAI){
						(facade.retrieveProxy(HumanTalkShowProxy.NPC) as HumanTalkShowProxy).endPlayerDialogue(npc.charater as IHuman);
						
						npc.fsm.changeState(AIState.IDLE);
						npc.fsm.changeState(AIState.TALK);
						
						talkProxy.talk(captain,npc);
						
//						sendNotification(WorldConst.SHOW_TALKINGBOX,false);
						
					}else if(npc.decision is ExitIslanderAI){
						talkProxy.playerSay(npc.charater,"我妈妈喊我吃饭了！88");
					}else if(npc.decision is SantaAI){
//						npc.decision = null;
						TweenLite.killTweensOf(recoverSanta);
						npc.pause();
						npc.charater.action("trip",4,20,false);
						TweenLite.delayedCall(3,recoverSanta,[npc]);
					}
					
					break;
				case WorldConst.REMIND_PRIVATE_MESS:
					
					var remindVo:RemindPriMessVO = notification.getBody() as RemindPriMessVO;
					
					var isShake:Boolean = false;
					
					//添加id提醒
					if(remindVo.operation){
						if(idArray.indexOf(remindVo.sendId) == -1)
							idArray.push(remindVo.sendId);
						
						isShake = true;
						
					}else{
						//取消id提醒,存在id
						if(idArray.indexOf(remindVo.sendId) != -1)
							idArray.splice(idArray.indexOf(remindVo.sendId),1);
						
						if(idArray.length > 0)
							isShake = true;
						else
							isShake = false;
					}
					remindTalkBtn(isShake);
					
					break;
				case GET_RELATE_LIST:
					
					if(!result.isEnd){
						//不是GM 的id才加入好友列表
						if(GMId.indexOf(PackData.app.CmdOStr[2]) == -1){
							var relListItemSpVo:RelListItemSpVO = new RelListItemSpVO();
							relListItemSpVo.userId = PackData.app.CmdOStr[1];
							relListItemSpVo.rstdId = PackData.app.CmdOStr[2];
							relListItemSpVo.rstdCode = PackData.app.CmdOStr[3];
							relListItemSpVo.realName = PackData.app.CmdOStr[4];
							relListItemSpVo.relaType = PackData.app.CmdOStr[5];
							
							
							
							relListItemSpVoList.push(relListItemSpVo);
						}
					}else{
						
						//取列表完成
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
					}
					break;
				case WorldConst.REMIND_FIGHT_GAME:
					var _isShake:Boolean = notification.getBody() as Boolean;
					
					remindFightBtn(_isShake);
					
					break;
				case WorldConst.MARK_OTHER_PLAYER_CHARATER:
					playerNum++;
					maxIslander--;
					if(maxIslander<0){
						maxIslander = 0;
					}
					break;
				case WorldConst.CHARATER_LEAVE:
					playerNum--;
					maxIslander++;
					if(maxIslander>MAX_ISLANDER){
						maxIslander = MAX_ISLANDER;
					}
					
					
					break;
				
			}
		}
		override public function listNotificationInterests():Array
		{
			return [WorldConst.UPDATE_CAMERA,WorldConst.GET_TEXT_MESSAGE,WorldConst.GET_GIFT,FINISH_MESSAGE,
				BaseCharaterControllerMediator.CLICK_CHARATER,WorldConst.REMIND_PRIVATE_MESS,GET_RELATE_LIST,
				CHECK_HAPPY_STATUS,SEL_TASK_STATUS,WorldConst.REMIND_FIGHT_GAME,QRY_EQUIPMENT,WorldConst.MARK_OTHER_PLAYER_CHARATER,
				WorldConst.CHARATER_LEAVE
			
			];
		}
		
		override public function onRemove():void
		{
			super.onRemove();
//			sendNotification(WorldConst.HAPPY_HIDECHAT);
			Assets.disposeTexture("HapIsland_MountBg");
			TweenLite.killTweensOf(talkBtn);
			TweenLite.killTweensOf(fightBtn);
			view.root.stage.color = 0xffffff;
//			SoundAS.removeSound("mainambient");
//			sendNotification(CoreConst.REMOVE_EFFECT_SOUND,'mainambient');
			
			sendNotification(CoreConst.MANUAL_LOADING,false);
			facade.registerCommand(WorldConst.SWITCH_SCREEN,SwitchScreenCommand);
			runEnterFrames = false;
			(facade.retrieveProxy(HumanTalkShowProxy.NPC) as HumanTalkShowProxy).clean();
			
			islanderPool.object = captain;
			for (var i:int = 0; i < manager.islanders.length; i++){
				islanderPool.object = manager.islanders[i];
			}
			facade.removeMediator(IslandSysHouseMediator.NAME);
			facade.removeMediator(IslandNpcHouseMediator.NAME);
			facade.removeMediator(CharaterControllerMediator.NAME);
//			facade.removeMediator(MutiOnlineControllerMediator.NAME);
			facade.removeMediator(MutiCharaterControllerMediator.NAME);
			facade.removeMediator(MutiOnlineTransferMediator.NAME);
			facade.removeMediator(GiftManagementMediator.NAME);
			facade.removeMediator(IslandersManagerMediator.NAME);
			facade.removeProxy(IslanderPoolProxy.NAME);
			facade.removeProxy(CharaterSuitsInfoProxy.NAME);
//			facade.removeMediator(MiniGameMediator.NAME);
			facade.removeMediator(MutiOLTransferMediator.NAME);
			facade.removeMediator(ChatViewMediator.NAME);
//			facade.removeMediator(MutiSpeechMediator.NAME);
			facade.removeMediator(OnlineLocationMediator.NAME);
			facade.removeMediator(WCHolderMediator.NAME);
			
			facade.removeProxy(CharaterMenuProxy.NAME);
			
			sendNotification(WorldConst.UPDATE_PLAYER_CHARATER,null);
			sendNotification(WorldConst.HIDE_LEFT_MENU);
			sendNotification(WorldConst.HIDE_MAIN_MENU);
			sendNotification(WorldConst.DESTROY_TALKINGBOX);
			sendNotification(WorldConst.STOP_RANDOM_ACTION);
			
			camera.removeChildren(0,-1,true);
			camera.dispose();
			
			bgHolder.removeChildren(0,-1,true);
			bgHolder.dispose();
			TweenLite.killTweensOf(recoverSanta);
			pathHolder.removeChildren(0,-1,true);
			pathHolder.dispose();
			_background.dispose();
			PixelHitArea.dispose();
//			butterfly.dispose();
			windFlower.dispose();
			dog.dispose();
			dogController.dispose();
			
			islandnpc = [];
		}
		/*public function get view():Sprite{
			return getViewComponent() as Sprite;
		}*/
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
	}
}