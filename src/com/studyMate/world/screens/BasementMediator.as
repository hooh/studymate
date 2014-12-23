package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.mylib.api.ICharaterUtils;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.card.AllotNPCPanel;
	import com.mylib.game.card.FightEffectFactoryProxy;
	import com.mylib.game.card.GameCharater;
	import com.mylib.game.card.GameCharaterData;
	import com.mylib.game.card.HeroAttribute;
	import com.mylib.game.card.HeroFightManager;
	import com.mylib.game.card.SkeletonType;
	import com.mylib.game.charater.logic.FighterControllerMediator;
	import com.mylib.game.charater.logic.ai.MonsterIdleAI;
	import com.mylib.game.controller.vo.HeroFightVO;
	import com.mylib.game.model.FightCharaterPoolProxy;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.module.underWorld.api.IBasement;
	import com.studyMate.world.model.vo.IslandDataVO;
	
	import flash.geom.Rectangle;
	
	import de.polygonal.core.ObjectPool;
	
	import feathers.controls.Button;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.display.Sprite;
	import starling.events.Event;

	public class BasementMediator extends Mediator implements IMediator,IBasement
	{
		public var monsters:Vector.<GameCharater>;
		public var heros:Vector.<GameCharater>;
		private var pool:FightCharaterPoolProxy;
		
		private var charaterHolder:Sprite;
		
		private var startBtns:Vector.<Button>;
		
		private var uiLayer:Sprite;
		
		private var allotBtn:Button;
		
		private var data:IslandDataVO;
		private var npcList:Vector.<GameCharaterData>;
		
		
		
		public static const START_FIGHT_REC:String = "startFightRec";
		
		private var hfvo:HeroFightVO;
		
		
		
		public function BasementMediator(baseName:String="",data:IslandDataVO=null,npcList:Vector.<GameCharaterData>=null)
		{
			super(ModuleConst.BASEMENT+baseName, new Sprite);
			monsters = new Vector.<GameCharater>;
			heros = new Vector.<GameCharater>;
			startBtns = new Vector.<Button>;
			this.data = data;
			this.npcList = npcList;
			
		}
		
		
		override public function handleNotification(notification:INotification):void
		{
			
			var dvo:DataResultVO = notification.getBody() as DataResultVO;
			
			switch(notification.getName())
			{
				case getMediatorName()+START_FIGHT_REC:
				{
					if(!dvo.isErr){
						var monster:GameCharater = dvo.para[0];
						
						goFight(monster,PackData.app.CmdOStr[1]);
					}
					
					
					
					break;
				}
					
				default:
				{
					break;
				}
			}
		}
		
		public function goFight(monster:GameCharater,taskId:String):void{
			charaterHolder.setChildIndex(monster.fighter.charater.view,0);
			close();
			hfvo = new HeroFightVO(heros,monster,HeroAttribute.GOLD,charaterHolder);
			hfvo.taskId = taskId;
			hfvo.basement = this;
			sendNotification(HeroFightManager.FIGHT,hfvo);
		}
		
		
		override public function listNotificationInterests():Array
		{
			return [getMediatorName()+START_FIGHT_REC];
		}
		
		public function advanceTime(time:Number):void
		{
			// TODO Auto Generated method stub
			sendNotification(WorldConst.SORT_CONTAINER,charaterHolder);
		}
		
		
		public function addMonster(gameCharater:GameCharaterData):void{
			
			if(gameCharater.skeleton==SkeletonType.BMP){
				(Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.FIGHT_CHARATER_POOL) as FightCharaterPoolProxy).charaterPool = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.BMP_FIGHTER_POOL) as ObjectPool;
			}else{
				(Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.FIGHT_CHARATER_POOL) as FightCharaterPoolProxy).charaterPool = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.HUMAN_POOL) as ObjectPool;
			}
			
			var fighter:FighterControllerMediator;
			fighter = (Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.FIGHT_CHARATER_POOL) as FightCharaterPoolProxy).object;
			fighter.decision = new MonsterIdleAI();
			fighter.charater.range = new Rectangle(monsters.length*200+300,0,100,0);
			
			fighter.setTo(fighter.charater.range.x,fighter.charater.range.y);
			var monster:GameCharater = new GameCharater(gameCharater,fighter);
			(Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CHARATER_UTILS) as ICharaterUtils).humanDressFun(fighter.charater,gameCharater.equiment);
			
			var btn:Button = new Button;
			btn.label = "fight";
			btn.x = fighter.charater.range.x;
			btn.y = fighter.charater.range.y;
			btn.name = monsters.length.toString();
			btn.addEventListener(Event.TRIGGERED,fightBtnHandle);
			startBtns.push(btn);
			view.addChild(btn);
			
			charaterHolder.addChild(fighter.charater.view);
			
			fighter.start();
			monsters.push(monster);
			
		}
		
		public function reputMoster(monster:GameCharater):void{
			charaterHolder.addChild(monster.fighter.charater.view);
			
			monster.fighter.decision = new MonsterIdleAI();
			monster.fighter.charater.range = new Rectangle(monsters.indexOf(monster)*200+300,0,100,0);
			
			monster.data.hp = monster.data.fullHP;
			
			monster.fighter.start();
		}
		
		
		public function close():void{
			for each (var i:Button in startBtns) 
			{
				i.visible = false;
			}
		}
		
		public function open():void{
			for each (var i:Button in startBtns) 
			{
				i.visible = true;
			}
		}
		
		
		
		
		public function addHero(gameCharater:GameCharaterData):void{
			var hero:GameCharater = new GameCharater(gameCharater,null);
			heros.push(hero);
		}
		
		
		private function fightBtnHandle(event:Event):void
		{
			var target:Button = event.currentTarget as Button;
			var monster:GameCharater = monsters[int(target.name)];
			target.visible = false;
			var hfvo:HeroFightVO = new HeroFightVO(heros,monster,HeroAttribute.GOLD,null);
			hfvo.update();
			PackData.app.CmdIStr[0] = CmdStr.INUP_PLAYER_TASK;
			PackData.app.CmdIStr[1] = "0";
			PackData.app.CmdIStr[2] = Global.player.operId;
			PackData.app.CmdIStr[3] = monster.data.allotId;
			PackData.app.CmdIStr[4] = hfvo.remainTime.toString();
			PackData.app.CmdInCnt = 5;
			
			sendNotification(CoreConst.SEND_11,new SendCommandVO(getMediatorName()+START_FIGHT_REC,[monster]));
			
			
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		
		override public function onRemove():void
		{
			super.onRemove();
			
			reset();
			
			
			
		}
		
		public function reset():void{
			recycleHeros();
			
			for (var j:int = 0; j < monsters.length; j++) 
			{
				TweenLite.killTweensOf(monsters[j].fighter);
				(Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.FIGHT_CHARATER_POOL) as FightCharaterPoolProxy).object = monsters[j].fighter;
			}
			
			uiLayer.removeChildren(0,-1,true);
			monsters.length = 0;
			
		}
		
		private function recycleHeros():void{
			
			if(hfvo){
				sendNotification(HeroFightManager.STOP,hfvo);
			}
			
			heros.length = 0;
		}
		
		
		
		
		override public function onRegister():void
		{
			super.onRegister();
			
			if(!facade.hasProxy(ModuleConst.FIGHT_CHARATER_POOL)){
				pool = new FightCharaterPoolProxy(true);
				facade.registerProxy(pool);
				pool.init();
			}else{
				pool = facade.retrieveProxy(ModuleConst.FIGHT_CHARATER_POOL) as FightCharaterPoolProxy;
			}
			
			if(!facade.hasProxy(FightEffectFactoryProxy.NAME)){
				facade.registerProxy(new FightEffectFactoryProxy());
			}
			
			charaterHolder = new Sprite;
			view.addChild(charaterHolder);
			
			uiLayer = new Sprite;
			view.addChild(uiLayer);
			
			allotBtn = new Button;
			allotBtn.label = "来人";
			allotBtn.addEventListener(Event.TRIGGERED,allotBtnHandle);
			view.addChild(allotBtn);
			
			
		}
		
		private function allotBtnHandle(event:Event):void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(AllotNPCPanel,[data,npcList,this],SwitchScreenType.SHOW,AppLayoutUtils.gpuLayer)]);
		}
		
	}
}