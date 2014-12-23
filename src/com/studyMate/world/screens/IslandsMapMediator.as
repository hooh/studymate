package com.studyMate.world.screens
{
	import com.byxb.extensions.starling.display.CameraSprite;
	import com.byxb.extensions.starling.events.CameraUpdateEvent;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.controller.FreeScrollerMediator;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.card.GameCharaterData;
	import com.mylib.game.house.HouseInfoVO;
	import com.mylib.game.house.ServerNpcVo;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.model.vo.GameTaskVO;
	import com.studyMate.world.model.vo.LoadSoundEffectVO;
	import com.studyMate.world.model.vo.NPCRawDataVO;
	import com.studyMate.world.model.vo.PlaySoundEffectVO;
	import com.studyMate.world.screens.effects.WindFlower;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import feathers.controls.Button;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.graphics.Fill;
	import starling.display.graphics.Stroke;
	import starling.display.shaders.vertex.RippleVertexShader;
	import starling.events.Event;
	import starling.extensions.PixelHitArea;

	public class IslandsMapMediator extends SceneSwitcherMediator
	{
		public static const NAME:String = "IslandsMapMediator";
		private static const QRY_STD_PER_ROOM_COMPLETE:String = NAME + "QryStdPerroomComplete";
		private static const QRY_NPC_INOF_COMPLETE:String = NAME + "QryNpcInfoComplete";
		private static const QRY_STD_NPC_LIST_COMPLETE:String = NAME + "QryStdNpcListComplete";
		private static const QRY_GAME_TASK_COMPLETE:String = NAME + "QryGameTaskComplete";
		
		private var vo:SwitchScreenVO;
		
		private var cloudRange01:Rectangle = new Rectangle(-740,-681,3300,100);
		private var cloudRange02:Rectangle = new Rectangle(-1640,-581,4000,100);
		
		private var _background:HappyIslandBackground;
		private var hit_1:PixelHitArea;
		
		private var preBtn:Button;
		private var nextBtn:Button;
		
		private var windFlower:WindFlower;
		
		private var bgHolder:Sprite;
		
		private var isDown:Boolean;
		
		private var underY:int;
		private var underOffset:int;
		private var freeScroller:FreeScrollerMediator;
		
		private var cardPlayerList:Vector.<GameCharaterData>;
		private var npcRawDataList:Vector.<NPCRawDataVO>;
		private var gameTaskList:Vector.<GameTaskVO>;
		public var myCardPlayerList:Vector.<ServerNpcVo>;
		
		public function IslandsMapMediator(viewComponent:Object=null)
		{
			super(NAME,viewComponent);
		}
		override public function prepare(vo:SwitchScreenVO):void
		{
			this.vo = vo;
			houseList = new Vector.<HouseInfoVO>;
			cardPlayerList = new Vector.<GameCharaterData>;
			npcRawDataList = new Vector.<NPCRawDataVO>;
			gameTaskList = new Vector.<GameTaskVO>;
			
			myCardPlayerList = new Vector.<ServerNpcVo>;
			
			
			getHouseList(PackData.app.head.dwOperID.toString());
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			view.root.stage.color = 0xb4f3f4;
			
			sendNotification(CoreConst.MANUAL_LOADING,true);
			
//			SoundAS.loadSound(MyUtils.getSoundPath("mainambient.mp3"),"mainambient");
//			SoundAS.play("mainambient",0.4);
			sendNotification(CoreConst.LOAD_EFFECT_SOUND,new LoadSoundEffectVO(MyUtils.getSoundPath("mainambient.mp3"),"mainambient"));						
			sendNotification(CoreConst.PLAY_EFFECT_SOUND,new PlaySoundEffectVO("mainambient",0.4));
			
			bgHolder = new Sprite;
			view.addChild(bgHolder);
			
			
			var bg:Image = new Image(Assets.getTexture("HapIsland_MountBg"));
//			bg.blendMode = BlendMode.NONE;
			bg.touchable = false;
			bg.y = 210;
			bgHolder.addChild(bg);

			
			createWater();
			
			sendNotification(CoreConst.SWITCH_MODULE,[new SwitchScreenVO(ModuleConst.UNDER_WORLD,null,SwitchScreenType.SHOW,bgHolder)]);
			
			
			camera = new CameraSprite(new Rectangle(0, 0, WorldConst.stageWidth, WorldConst.stageHeight), null, .3, .1, .01);
			_background = new HappyIslandBackground;
			_background.touchable = false;
			camera.addChild(_background);
			camera.addEventListener(CameraUpdateEvent.CAMERA_UPDATE, updateBackground);
			_background.show(new Rectangle(-Global.stageWidth*0.5,-Global.stageHeight*0.5,Global.stageWidth,Global.stageHeight));
			

			underY = -1400;
			underOffset = 170;
			
			createWindFlower();
			var cloud01:Image =new Image(Assets.getHappyIslandTexture("hapIsland_Cloud01"));
			var cloud02:Image =new Image(Assets.getHappyIslandTexture("hapIsland_Cloud02"));
			sendNotification(WorldConst.RANDOM_ACTION,{displayObject:cloud01,holder:camera,range:cloudRange01,randomAction:false});
			sendNotification(WorldConst.RANDOM_ACTION,{displayObject:cloud02,holder:camera,range:cloudRange02,randomAction:false});

			
			createIsland();
			
			index = 1;
			
			
			nextBtn = new Button();
			nextBtn.label = "远征战场 =》";
			nextBtn.x = 600;
			view.addChild(nextBtn);
			nextBtn.addEventListener(Event.TRIGGERED,nextSceneHandle);
			
			preBtn = new Button();
			preBtn.label = "《= 圣地家园";
			preBtn.x = 400;
			view.addChild(preBtn);
			preBtn.addEventListener(Event.TRIGGERED,preSceneHandle);
			freeScroller = facade.retrieveMediator(FreeScrollerMediator.NAME) as FreeScrollerMediator;
			freeScroller.radioYD = 0;
			freeScroller.radioYU = 0.5;
		}
		private function createIsland():void{
			var _s:Vector.<SceneMediator> = new Vector.<SceneMediator>;
			hit_1 = new PixelHitArea ( Assets.store["HapIslandHouseTexture"],0.5);
			
			var gardenIsland:GardenIslandMediator = new GardenIslandMediator(hit_1,houseList,new Sprite(),camera);
			facade.registerMediator(gardenIsland);
			_s.push(gardenIsland);
			gardenIsland.x = 0;
			gardenIsland.left = 0;
			gardenIsland.right = 640;
			
			
			var squareIsland:SquareIslandMediator = new SquareIslandMediator(hit_1,new Sprite(),camera);
			facade.registerMediator(squareIsland);
			_s.push(squareIsland);
			squareIsland.x = 10000;
			squareIsland.left = 10000-640;
			squareIsland.right = 10000+640;
			
			
			var cardBattleField:CardBattleFieldMediator = new CardBattleFieldMediator(myCardPlayerList,gameTaskList,new Sprite(),camera);
			facade.registerMediator(cardBattleField);
			_s.push(cardBattleField);
			cardBattleField.x = 12000;
			cardBattleField.left = 12000;
			cardBattleField.right = 12000+1280;
			
			
			
			scenes = _s;
		}
		
		
		private function createWater():void{
			
			var w:Number = view.stage.stageWidth;
			var h:Number = view.stage.stageHeight;
			var waterColorTop:uint = 0x08acff;
			var waterColorBottom:uint = 0x0073ad;
			var waterColorSurface:uint = 0x3cb6c9;
			
			var waterHeight:Number = h-80;
			var waterFill:Fill = new Fill();
			waterFill.addVertex(0, waterHeight, waterColorTop,0.3 );
			waterFill.addVertex(w, waterHeight, waterColorTop,0.3 );
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
			windFlower.y = 300;
			windFlower.touchable = false;
			camera.addChild(windFlower);
		}
		
		
/***家园、广场、战场导航切换***********************************************************/
		
		private function preSceneHandle(event:Event):void
		{
			index--;
			
			updateDreBtn();
		}
		
		private function nextSceneHandle(event:Event):void
		{
			index++;
			
			updateDreBtn();
		}
		private function updateDreBtn():void{
			nextBtn.visible = true;
			preBtn.visible = true;
			
			switch(index){
				case 0:
					nextBtn.label = "黄金海岸 =》";
					preBtn.visible = false;
					break;
				case 1:
					nextBtn.label = "远征战场 =》";
					preBtn.label = "《= 圣地家园";
					break;
				case 2:
					nextBtn.visible = false;
					preBtn.label = "《= 黄金海岸";
					break;
			}
		}
		
/***房子、NPC数据处理系列函数***********************************************************/		
		
		//根据房子id取npc列表
		public function getCPListByHouseId(_id:String):Vector.<GameCharaterData>{
			
			var npcidList:Array = new Array;
			
			for(var i:int=0;i<myCardPlayerList.length;i++){
				if(_id == myCardPlayerList[i].npcHouseId){
					npcidList.push(myCardPlayerList[i].npcId);
					
				}
			}
			
			return getCPListByNpcidList(npcidList);
		}
		
		//根据npcId列表返回cardPlayer列表
		public function getCPListByNpcidList(npcidList:Array):Vector.<GameCharaterData>{
			var cpList:Vector.<GameCharaterData> = new Vector.<GameCharaterData>;
			
			var cp:GameCharaterData;
			for(var i:int=0;i<npcidList.length;i++){
				cp = getCPByNpcId(npcidList[i]);
				
				if(cp)
					cpList.push(cp);
			}
			
			return cpList;
		}
		
		//根据npcId返回cardPlayer
		public function getCPByNpcId(_id:String):GameCharaterData{
			var cp:GameCharaterData;
			
			
			for(var i:int=0;i<cardPlayerList.length;i++){
				if(_id == cardPlayerList[i].id){
					
					cp = cardPlayerList[i].clone();
					
					break;
				}
			}
			
			return cp;
		}
		
/***进入界面，从后台获取个人房间列表***********************************************************/		

		private var houseList:Vector.<HouseInfoVO>;
		//根据id从后台取房子列表
		private function getHouseList(_id:String):void{
			PackData.app.CmdIStr[0] = CmdStr.QRY_STD_PER_ROOM;
			PackData.app.CmdIStr[1] = _id;
			PackData.app.CmdInCnt = 2;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(QRY_STD_PER_ROOM_COMPLETE));
		}
		
		//获取服务器所有NPC
		private function getAllNpcInfo():void{
			PackData.app.CmdIStr[0] = CmdStr.QRY_NPC_ROLE_INFO;
			PackData.app.CmdInCnt = 1;
			
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(QRY_NPC_INOF_COMPLETE));
		}
		
		private function getMyNpcInfo():void{
			PackData.app.CmdIStr[0] = CmdStr.QRY_STD_NPC_LIST;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 2;
			
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(QRY_STD_NPC_LIST_COMPLETE));
		}
		
		//获取服务器所有任务
		private function getGameTask():void{
			PackData.app.CmdIStr[0] = CmdStr.QRY_GAME_TASK_INFO;
			PackData.app.CmdInCnt = 1;
			
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(QRY_GAME_TASK_COMPLETE));
			
			
		}
		
		
		
		private var isRun:Boolean=true;
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			
			super.handleNotification(notification);
			switch(notification.getName())
			{
				case QRY_STD_PER_ROOM_COMPLETE:
					var _houseVo:HouseInfoVO;
					if(!result.isEnd){
						_houseVo = new HouseInfoVO();
						_houseVo.relatId = PackData.app.CmdOStr[1];
						_houseVo.name = PackData.app.CmdOStr[4];
						_houseVo.data = PackData.app.CmdOStr[5];
						_houseVo.x = PackData.app.CmdOStr[8];
						_houseVo.y = PackData.app.CmdOStr[9];
						_houseVo.maxNumber = PackData.app.CmdOStr[10];
						_houseVo.createTime = PackData.app.CmdOStr[14];
						_houseVo.finishTime = PackData.app.CmdOStr[15];
						houseList.push(_houseVo);
						
					}else{
						
						getAllNpcInfo();
						
					}
					
					break;
				case QRY_NPC_INOF_COMPLETE:
					
					if(result.isEnd){
						cardPlayerList = CardGameStageMediator.genPlayerData(npcRawDataList);
						
						getMyNpcInfo();
						
					}else if(result.isErr){
						
					}else{
						var vo:NPCRawDataVO = new NPCRawDataVO(PackData.app.CmdOStr[1],PackData.app.CmdOStr[2],PackData.app.CmdOStr[3],PackData.app.CmdOStr[4],PackData.app.CmdOStr[5],PackData.app.CmdOStr[6],
							PackData.app.CmdOStr[7],PackData.app.CmdOStr[8],PackData.app.CmdOStr[9],PackData.app.CmdOStr[10]);
						npcRawDataList.push(vo);
					}
					
					break;
				case QRY_STD_NPC_LIST_COMPLETE:
					if(result.isEnd){
						
						getGameTask();
						
					}else if(result.isErr){
						
					}else{
						var npcinfo:ServerNpcVo = new ServerNpcVo();
						npcinfo.npcHouseId = PackData.app.CmdOStr[2]; 
						npcinfo.npcId = PackData.app.CmdOStr[3];
						
						myCardPlayerList.push(npcinfo);
						
					}
					
					break;
				case QRY_GAME_TASK_COMPLETE:
					if(result.isEnd){
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
					
					}else if(result.isErr){
						
					}else{
						
						var dataVO:GameTaskVO = new GameTaskVO();
						dataVO.id = PackData.app.CmdOStr[1];
						dataVO.cd = PackData.app.CmdOStr[12];
						dataVO.description =PackData.app.CmdOStr[3];
						dataVO.islandIDs = PackData.app.CmdOStr[9];
						dataVO.isMainLine = PackData.app.CmdOStr[10];
						dataVO.name = PackData.app.CmdOStr[2];
						dataVO.orderNum = PackData.app.CmdOStr[11];
						dataVO.playerNumber = PackData.app.CmdOStr[6];
						dataVO.reward = PackData.app.CmdOStr[8];
						dataVO.script = PackData.app.CmdOStr[5];
						dataVO.time = PackData.app.CmdOStr[7];
						dataVO.type = PackData.app.CmdOStr[4];
						gameTaskList.push(dataVO);
					}
					
					
					break;
				case WorldConst.UPDATE_CAMERA:{
					var local:Point = notification.getBody() as Point;
					if(bgHolder){
						bgHolder.y = local.y;
					}
					
					if(isDown){
						if(local.y>underY+underOffset && index ==1){
							
							if(local.y>-2){
								isDown = false;
								freeScroller.radioYD = 0;
								
								if(!isRun){
									(facade.retrieveMediator(SquareIslandMediator.NAME) as SquareIslandMediator).run();
									nextBtn.visible = true;
									preBtn.visible = true;
									isRun = true;
								}
							}else{
								tvo.range.y = 0;
//								TweenLite.to(bgHolder,1,{y:0});
								
								camera.moveTo(-local.x/tvo.scale,-local.y,tvo.scale,0,false);
								freeScroller.centerY = 0;
								freeScroller.targetY = 0;
							}
							
							
						}
					}else{
						if(local.y<-underOffset && index ==1){
							if(local.y<underY+2){
								isDown = true;
								freeScroller.radioYD = 0.5;
								
								if(isRun){
									(facade.retrieveMediator(SquareIslandMediator.NAME) as SquareIslandMediator).pause();
									nextBtn.visible = false;
									preBtn.visible = false;
									
									isRun = false;
								}
							}else{
								tvo.range.y = -1000;
								tvo.range.height = 0;
//								TweenLite.to(bgHolder,1,{y:underY});
								camera.moveTo(-local.x/tvo.scale,-local.y,tvo.scale,0,false);
								freeScroller.centerY = underY;
								freeScroller.targetY = underY;
							}
							
							
						}
					}
					
					break;
				}
				default:
				{
					break;
				}
			}
		}
		override public function listNotificationInterests():Array
		{
			return super.listNotificationInterests().concat(QRY_STD_PER_ROOM_COMPLETE,
				QRY_NPC_INOF_COMPLETE,QRY_GAME_TASK_COMPLETE,QRY_STD_NPC_LIST_COMPLETE);
		}

		
		private function updateBackground(e:CameraUpdateEvent):void{
			_background.show(e.viewport);
		}
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
//			SoundAS.removeSound("mainambient");
			sendNotification(CoreConst.REMOVE_EFFECT_SOUND,'mainambient');
			facade.removeMediator(GardenIslandMediator.NAME);
			facade.removeMediator(SquareIslandMediator.NAME);
			facade.removeMediator(CardBattleFieldMediator.NAME);
			facade.removeMediator(ModuleConst.UNDER_WORLD);
			
			
			sendNotification(WorldConst.STOP_RANDOM_ACTION);
			
			
			view.root.stage.color = 0xffffff;
		}
		
		
		
		
	}
}