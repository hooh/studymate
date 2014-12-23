package com.mylib.game.card
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.controller.vo.HeroFightVO;
	import com.mylib.game.ui.HPTextPool;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.model.vo.GameTaskVO;
	import com.studyMate.world.model.vo.IslandDataVO;
	import com.studyMate.world.model.vo.NPCRawDataVO;
	import com.studyMate.world.screens.BasementMediator;
	import com.studyMate.world.screens.CardGameStageMediator;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Sprite;
	
	public class GameSceneMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "GameSceneMediator";
		private const ISLAND_LIST_REC:String = NAME+"islandListRec";
		private const TASK_LIST_REC:String = NAME+"taskListRec";
		private const NPC_LIST_REC:String = NAME+"npcListRec";
		private const PLAYER_NPC_LIST_REC:String = NAME + "playerNpcListRec";
		private var levelList:Vector.<IslandDataVO>;
		private var basements:Dictionary;
		private var taskList:Vector.<GameTaskVO>;
		private var npcList:Vector.<NPCRawDataVO>;
		private var playersData:Vector.<GameCharaterData>;
		private var npcLevelData:Vector.<PlayerLevelNpcRawVO>;
		private var playerNpcRawData:Vector.<NPCRawDataVO>;
		private const PLAY_NPC_LAND_REC:String = "palyerNpcLandRec";
		private const PLAYER_TASK_REC:String = "playerTaskRec";
		private var playerTaskList:Vector.<PlayerTaskRawVO>;
		
		
		
		public function GameSceneMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			
			
			for each (var basement:BasementMediator in basements) 
			{
				facade.removeMediator((basement as IMediator).getMediatorName());
			}
			
		}
		
		override public function handleNotification(notification:INotification):void
		{
			
			var vo:DataResultVO;
			switch(notification.getName())
			{
				case ISLAND_LIST_REC:
				{
					vo = notification.getBody() as DataResultVO;
					
					if(vo.isEnd){
						
						PackData.app.CmdIStr[0] = CmdStr.QRY_GAME_TASK_INFO;
						PackData.app.CmdInCnt = 1;
						taskList.length = 0;
						Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(TASK_LIST_REC));
						
						
						
						
					}else if(vo.isErr){
						
					}else{
						
						var islandDataVO:IslandDataVO = new IslandDataVO(PackData.app.CmdOStr[2],
							PackData.app.CmdOStr[3],PackData.app.CmdOStr[4],PackData.app.CmdOStr[8],PackData.app.CmdOStr[10],
							PackData.app.CmdOStr[9],PackData.app.CmdOStr[6],PackData.app.CmdOStr[7],PackData.app.CmdOStr[5]);
						islandDataVO.id = PackData.app.CmdOStr[1];
						levelList.push(islandDataVO);
						
						
						
					}
					break;
				}
				case TASK_LIST_REC:{
					vo = notification.getBody() as DataResultVO;
					
					if(vo.isEnd){
						
						PackData.app.CmdIStr[0] = CmdStr.QRY_NPC_ROLE_INFO;
						PackData.app.CmdInCnt = 1;
						npcList.length=0;
						Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(NPC_LIST_REC));
						
						
						
					}else if(vo.isErr){
						
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
						taskList.push(dataVO);
						
						
					}
					
					break;
				}
				case NPC_LIST_REC:{
					vo = notification.getBody() as DataResultVO;
					
					if(vo.isEnd){
						playersData = CardGameStageMediator.genPlayerData(npcList);
						
						PackData.app.CmdIStr[0] = CmdStr.QRY_PLAY_NPC_LAND;
						PackData.app.CmdIStr[1] = "*";
						PackData.app.CmdIStr[2] = Global.player.operId;
						PackData.app.CmdIStr[3] = "*";
						PackData.app.CmdIStr[4] = "*";
						PackData.app.CmdInCnt = 5;
						
						Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(PLAY_NPC_LAND_REC));
						
						
					}else if(vo.isErr){
						
					}else{
						var npcRaw:NPCRawDataVO = new NPCRawDataVO(PackData.app.CmdOStr[1],PackData.app.CmdOStr[2],PackData.app.CmdOStr[3],PackData.app.CmdOStr[4],
							PackData.app.CmdOStr[5],PackData.app.CmdOStr[6],PackData.app.CmdOStr[7],PackData.app.CmdOStr[8],PackData.app.CmdOStr[9],PackData.app.CmdOStr[10]);
						npcList.push(npcRaw);
					}
					
					break;
				}
				case PLAY_NPC_LAND_REC:{
				
					vo = notification.getBody() as DataResultVO;
					
					if(vo.isEnd){
						
						PackData.app.CmdIStr[0] = CmdStr.QRY_STD_NPC_LIST;
						PackData.app.CmdIStr[1] = Global.player.operId;
						PackData.app.CmdInCnt = 2;
						Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(PLAYER_NPC_LIST_REC));
						
						
						
					}else if(vo.isErr){
						
					}else{
						
						var playerLevelNpcRaw:PlayerLevelNpcRawVO = new PlayerLevelNpcRawVO(PackData.app.CmdOStr[1],PackData.app.CmdOStr[3],PackData.app.CmdOStr[4]);
						npcLevelData.push(playerLevelNpcRaw);
						
						
					}
					
					break;
				}
				case PLAYER_NPC_LIST_REC:{
					vo = notification.getBody() as DataResultVO;
					
					if(vo.isEnd){
						PackData.app.CmdIStr[0] = CmdStr.QRY_PLAYERTASK_BYID;
						PackData.app.CmdIStr[1] = Global.player.operId;
						PackData.app.CmdInCnt = 2;
						
						Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(PLAYER_TASK_REC));
						
						
						
					}else if(vo.isErr){
						
					}else{
						
						
						for (var i:int = 0; i < npcList.length; i++) 
						{
							if(npcList[i].id==PackData.app.CmdOStr[3]){
								
								playerNpcRawData.push(npcList[i]);
								
							}
							
						}
						
					}
					break;
				}
				case PLAYER_TASK_REC:{
				
					vo = notification.getBody() as DataResultVO;
					
					if(vo.isEnd){
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY);
					}else if(vo.isErr){
						
					}else{
						
						
						playerTaskList.push(new PlayerTaskRawVO(PackData.app.CmdOStr[1],PackData.app.CmdOStr[3],PackData.app.CmdOStr[4],PackData.app.CmdOStr[5]));
						
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
			return [ISLAND_LIST_REC,TASK_LIST_REC,NPC_LIST_REC,PLAY_NPC_LAND_REC,PLAYER_NPC_LIST_REC,PLAYER_TASK_REC];
		}
		
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			
			levelList = new Vector.<IslandDataVO>;
			taskList = new Vector.<GameTaskVO>;
			npcList = new Vector.<NPCRawDataVO>;
			npcLevelData = new Vector.<PlayerLevelNpcRawVO>;
			playerNpcRawData = new Vector.<NPCRawDataVO>;
			playerTaskList = new Vector.<PlayerTaskRawVO>;
			
			
			PackData.app.CmdIStr[0] = CmdStr.QRY_LAND_INFO;
			PackData.app.CmdInCnt = 1;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(ISLAND_LIST_REC));
			
			
			
			
		}
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			Assets.getUnderWorldAtlas();
			if(!facade.hasProxy(HPTextPool.NAME)){
				facade.registerProxy(new HPTextPool);
			}
			
			basements = new Dictionary(true);
			var basement:BasementMediator;
			for (var i:int = 0; i < levelList.length; i++) 
			{
				basement = new BasementMediator("level"+i,levelList[i],playersData);
				basements[levelList[i].id.toString()] = basement;
				facade.registerMediator(basement);
				basement.view.y = i*160;
				view.addChild(basement.view);
			}
			
			buildTask();
			runTask();
		}
		
		private function runTask():void{
			
			for (var i:int = 0; i < playerTaskList.length; i++) 
			{
				var founded:Boolean = false;
				
				for each (var j:BasementMediator in basements) 
				{
					var basement:BasementMediator = j;
					for (var k:int = 0; k < j.monsters.length; k++) 
					{
						var monsters:Vector.<GameCharater> = basement.monsters;
						if(monsters[k].data.allotId==playerTaskList[i].taskId){
							founded = true;
							
							var hfvo:HeroFightVO = new HeroFightVO(basement.heros,monsters[k],HeroAttribute.GOLD,null);
							hfvo.updateDamage();
							
							var nowsec:uint = Global.nowDate.time*0.001;
							if(nowsec<playerTaskList[i].endTime){
								monsters[k].data.hp = hfvo.averageDamage*(playerTaskList[i].endTime-nowsec);
							}else{
								monsters[k].data.hp = 0;
							}
							
							
							basement.goFight(monsters[k],playerTaskList[i].id);
							break;
						}
						
					}
					if(founded){
						break;
					}
				}
				
			}
			
		}
		
		
		
		private function buildTask():void{
			
			var basement:BasementMediator;
			var taskVO:GameTaskVO;
			var monsterData:GameCharaterData;
			for (var i:int = 0; i < taskList.length; i++) 
			{
				taskVO = taskList[i];
				basement = basements[taskVO.islandIDs];
				
				for (var j:int = 0; j < playersData.length; j++) 
				{
					if(playersData[j].id==taskVO.script){
						
						monsterData = playersData[j];
						monsterData.allotId = taskVO.id;
						basement.addMonster(monsterData.clone());
						
					}
					
				}
			}
			
			for (i = 0; i < npcLevelData.length; i++) 
			{
				
				basement = basements[npcLevelData[i].levelId];
				
				
				for (j = 0; j < playersData.length; j++) 
				{
					
					if(playersData[j].id==npcLevelData[i].npcId){
						playersData[j].allotId = npcLevelData[i].id;
						basement.addHero(playersData[j]);
					}
				}
				
				
				
				
			}
			
		}
		
		
	}
}