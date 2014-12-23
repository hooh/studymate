package com.studyMate.world.screens
{
	import com.byxb.extensions.starling.display.CameraSprite;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.card.GameCharaterData;
	import com.mylib.game.house.ServerNpcVo;
	import com.mylib.game.ui.HPTextPool;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.module.underWorld.api.UnderWorldConst;
	import com.studyMate.world.component.MyNPCList;
	import com.studyMate.world.component.NPCList;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.model.vo.GameTaskVO;
	
	import feathers.controls.Button;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class CardBattleFieldMediator extends SceneMediator
	{
		public static const NAME:String = "CardBattleFieldMediator";
		
		private var myCardPlayerList:Vector.<ServerNpcVo>;
		private var gameTaskList:Vector.<GameTaskVO>;
		
//		private var basement:BasementMediator;
		
		private var gameHolder:Sprite;
		
		public function CardBattleFieldMediator(_myCardPlayerList:Vector.<ServerNpcVo>,_gameTaskList:Vector.<GameTaskVO>,viewComponent:Object=null, camera:CameraSprite=null)
		{
			myCardPlayerList = _myCardPlayerList;
			gameTaskList = _gameTaskList.concat();
			
			super(NAME, viewComponent, camera);
		}
		
		
		
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [];
		}
		
		override public function onRegister():void
		{
			if(!facade.hasProxy(HPTextPool.NAME)){
				facade.registerProxy(new HPTextPool);
			}
			
			gameHolder = new Sprite();
			gameHolder.x = 320;
			view.addChild(gameHolder);
			
		
			
//			basement = new BasementMediator();
//			facade.registerMediator(basement);
//			
//			gameHolder.addChild(basement.view);
			
			
			
			initMyNpcList();
			
			
			
		}
		
		private var npcList:MyNPCList;
		private var teamControlSp:Sprite;
		private var teamTF:TextField;
		private var taskTF:TextField;
		private var addNpcBtn:Button;
		private var startGameBtn:Button;
		private function initMyNpcList():void{
			
			npcList = new MyNPCList();
			npcList.y = 0;
			npcList.visible = false;
			camera.parent.addChild(npcList);
			
			teamControlSp = new Sprite();
			teamControlSp.visible = false;
			camera.parent.addChild(teamControlSp);
			
			
			addNpcBtn = new Button();
			addNpcBtn.x = 420;
			addNpcBtn.y = 150;
			addNpcBtn.label = "加入军团";
			addNpcBtn.addEventListener(Event.TRIGGERED,addNpcBtnHandle);
			teamControlSp.addChild(addNpcBtn);
			
			
			startGameBtn = new Button();
			startGameBtn.x = 420;
			startGameBtn.y = 200;
			startGameBtn.label = "开始远征";
			startGameBtn.isEnabled = false;
			startGameBtn.addEventListener(Event.TRIGGERED,startGameBtnHandle);
			teamControlSp.addChild(startGameBtn);
			
			teamTF = new TextField(640,30,"您的军团： ","HuaKanT",28);
			teamTF.x = 600;
			teamTF.y = 180;
			teamTF.hAlign = HAlign.LEFT;
			teamControlSp.addChild(teamTF);
			
			taskTF = new TextField(640,30,"","HuaKanT",28);
			taskTF.x = 600;
			taskTF.y = 100;
			taskTF.hAlign = HAlign.LEFT;
			teamControlSp.addChild(taskTF);
			
			
		}
		private var teamStr:String="";
		private var herodata:Vector.<GameCharaterData> = new Vector.<GameCharaterData>;
		private var monsterdata:Vector.<GameCharaterData> = new Vector.<GameCharaterData>;
		
		private function addNpcBtnHandle(event:Event):void{
			if(npcList.selectedItem){
				
				if(herodata.length < currentGameTask.playerNumber){
//				if(basement.heros.length < currentGameTask.playerNumber){
					teamStr += (npcList.selectedItem as GameCharaterData).name+", ";
					teamTF.text = "您的军团： "+teamStr;
					
//					basement.addHero((npcList.selectedItem as GameCharaterData).clone());
					
					herodata.push((npcList.selectedItem as GameCharaterData).clone());
					
					startGameBtn.isEnabled = true;
				}else{
					sendNotification(WorldConst.DIALOGBOX_SHOW,
						new DialogBoxShowCommandVO(camera.parent,640,381,null,"副本限制了最多"+currentGameTask.playerNumber+"人哦!"));
				}
				
				
			}
			
		}
		private function startGameBtnHandle(event:Event):void{
			for(var i:int=0;i<gtScript.length;i++){
//				basement.addMonster((facade.retrieveMediator(IslandsMapMediator.NAME) as IslandsMapMediator).getCPByNpcId(gtScript[i]));				
				monsterdata.push((facade.retrieveMediator(IslandsMapMediator.NAME) as IslandsMapMediator).getCPByNpcId(gtScript[i]));
			}
			
			addNpcBtn.isEnabled = false;
			startGameBtn.isEnabled = false;
			
			sendNotification(UnderWorldConst.ADD_HERO,herodata);
			sendNotification(UnderWorldConst.ADD_MONSTER,monsterdata);
		}
		
		
		private var currentGameTask:GameTaskVO;
		private var gtScript:Array;
		private function initGameTask():void{
			gtScript = [];
			for(var i:int=0;i<gameTaskList.length;i++){
				if(gameTaskList[i].name == "boss1"){
					
					currentGameTask = gameTaskList[i].clone();
					
					var gt:Array = gameTaskList[i].script.split(",");
					
					for(var j:int=0;j<gt.length;j++){
						
						gtScript.push(gt[j]);
						
					}
					
					break;
				}
			}
			
		}
		
		
		
		override public function run():void
		{
			teamControlSp.visible = true;
			addNpcBtn.isEnabled = true;
			
			var npcidList:Array = new Array;
			
			for(var i:int=0;i<myCardPlayerList.length;i++)
				npcidList.push(myCardPlayerList[i].npcId);
					
			var cpList:Vector.<GameCharaterData> = (facade.retrieveMediator(IslandsMapMediator.NAME) as IslandsMapMediator).
				getCPListByNpcidList(npcidList);		
			
			
			npcList.updateDateByCplist(cpList);
			npcList.visible = true;
			
			
			
			initGameTask();
			
			if(currentGameTask)
				taskTF.text = "当前副本： "+currentGameTask.name;
		}
		
		override public function pause():void
		{
			startGameBtn.isEnabled = false;
			addNpcBtn.isEnabled = false;
			teamControlSp.visible = false;
			npcList.visible = false;
			teamStr = "";
			teamTF.text = "您的军团： ";
			taskTF.text = "当前副本： ";
			
//			basement.reset();
		}
		
		
		
		
		
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
			
		}
		
		
	}
}