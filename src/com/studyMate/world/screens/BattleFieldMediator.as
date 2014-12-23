package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.mylib.api.ICharaterUtils;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.charater.CharaterUtils;
	import com.mylib.game.charater.HumanMediator;
	import com.mylib.game.charater.effect.FightEffectProxy;
	import com.mylib.game.charater.fightState.FightStateRunnerMediator;
	import com.mylib.game.charater.fightState.FightStateVO;
	import com.mylib.game.charater.fightState.FireState;
	import com.mylib.game.charater.logic.AIGroup;
	import com.mylib.game.charater.logic.AIState;
	import com.mylib.game.charater.logic.BaseCharaterControllerMediator;
	import com.mylib.game.charater.logic.FighterControllerMediator;
	import com.mylib.game.charater.logic.ai.ForceKillerAI;
	import com.mylib.game.charater.logic.ai.JuniorPirateAI;
	import com.mylib.game.charater.logic.ai.SmartAI;
	import com.mylib.game.charater.skill.AttackSkill;
	import com.mylib.game.charater.weapon.WeaponInfor;
	import com.mylib.game.fight.FightHelperMediator;
	import com.mylib.game.model.FightCharaterPoolProxy;
	import com.mylib.game.model.HumanPoolProxy;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.module.ModuleConst;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import de.polygonal.core.ObjectPool;
	
	import org.as3commons.logging.api.getLogger;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class BattleFieldMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "BattleFieldMediator";
		private var pool:HumanPoolProxy;
		private var myAI:FighterControllerMediator;
		private var charaterHolder:Sprite;
		private var pathHolder:Sprite;
		private var range:Rectangle;
		private var enemyPool:FightCharaterPoolProxy;
		private var etime:Number=0;
		
		private var bgToucher:Quad;
		private var triggerMark:Boolean;
		private var point:Point;
		private var startPoint:Point;
		private var count:Number=0;
		private var playerAI:ForceKillerAI;
		private var npcs:Vector.<FighterControllerMediator>;
		
		public function BattleFieldMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function advanceTime(time:Number):void
		{
			sendNotification(WorldConst.SORT_CONTAINER,charaterHolder);
			count+=time;
			if(count>2){
				if(enemyPool.usageCount<5){
					callEnemy();
				}
				count = 0;
			}
		}
		
		
		override public function onRegister():void
		{
			facade.registerMediator(new FightHelperMediator);
			facade.registerMediator(new FightStateRunnerMediator);
			facade.registerProxy(new FightEffectProxy());
			
			range = new Rectangle(100,80,WorldConst.stageWidth-120,WorldConst.stageHeight-200);
			enemyPool = new FightCharaterPoolProxy(true);
			enemyPool.charaterPool = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.HUMAN_POOL) as ObjectPool;
			facade.registerProxy(enemyPool);
			enemyPool.init();
			
			startPoint = new Point;
			point = new Point;
			bgToucher = new Quad(range.width,range.height);
			bgToucher.alpha = 0;
			view.addChild(bgToucher);
			
			pathHolder = new Sprite;
			charaterHolder = new Sprite;
			view.addChild(pathHolder);
			view.addChild(charaterHolder);
			
			
			pool = facade.retrieveProxy(ModuleConst.HUMAN_POOL) as HumanPoolProxy;
			
			
//			facade.registerMediator(new MyCharaterControllerMediator(pathHolder,range));
			
			
			bgToucher.addEventListener(TouchEvent.TOUCH,myPlayerMoveHandle);
			bgToucher.x = range.x;
			bgToucher.y = range.y;
			
			
			
			var me:HumanMediator = pool.object;
			me.range = range;
			me.view.x = 300;
			me.view.y = 300;
			GlobalModule.charaterUtils.humanDressFun(me,"hair3,face_face1,clothes6,shoes1");
			charaterHolder.addChild(me.view);
			
			me.view.x = 100;
			me.view.y = 300;
			me.attackRate = 1;
			me.attackInterval = 0.1;
			me.attackRange = 1000;
			me.breakChance = 0.5;
			me.defense = 10;
			me.attack = 30;
			me.hpMax = 100;
			me.hp = 100;
			me.velocity = 5;
			me.dodge = 0.5;
			me.addSkill(new AttackSkill());
			me.weapon = new WeaponInfor(0,WeaponInfor.GUN);
			
			
//			sendNotification(WorldConst.ADD_MYCHARATER_CONTROL,me);
			sendNotification(WorldConst.UPDATE_PLAYER_CHARATER,me);
			
			myAI = new FighterControllerMediator("MyAI",me,1,AIGroup.PLAYER);
			myAI.decision = new SmartAI(true);
			playerAI = new ForceKillerAI(myAI.decision);
//			myAI.decision = playerAI = new ForceKillerAI();
			myAI.start();
			myAI.setTo(400,200);
			sendNotification(FightHelperMediator.JOIN_BATTLE,myAI);
			sendNotification(WorldConst.ADD_FIGHT_STATE,new FightStateVO(new FireState(5000,30,null,null,0),myAI));
			
			
//			callEnemy();
			/*callEnemy();
			callEnemy();*/
			
			npcs = new Vector.<FighterControllerMediator>;
			var npc:HumanMediator;
			var npcAI:FighterControllerMediator;
			
			npc = pool.object;
			npc.range = range;
			GlobalModule.charaterUtils.humanDressFun(npc,"hair3,face_face1,clothes6,shoes1");
			charaterHolder.addChild(npc.view);
			
			
			npc.view.x = 100;
			npc.view.y = 300;
			npc.attackRate = 1;
			npc.attackInterval = 1;
			npc.attackRange = 90;
			npc.breakChance = 0.5;
			npc.defense = 5;
			npc.attack = 20;
			npc.hpMax = 100;
			npc.hp = 100;
			npc.velocity = 4;
			npc.addSkill(new AttackSkill());
			npc.weapon = new WeaponInfor(0,WeaponInfor.SWORD);
			
			npcAI = new FighterControllerMediator("NPCAI1",npc,1,AIGroup.PLAYER);
			npcAI.setTo(200,200);
			npcAI.decision = new SmartAI();
			npcAI.start();
			sendNotification(FightHelperMediator.JOIN_BATTLE,npcAI);
			npcAI.fsm.changeState(AIState.DECISION);
			npcs.push(npcAI);
			
			npc = pool.object;
			npc.range = range;
			GlobalModule.charaterUtils.humanDressFun(npc,"hair3,face_face1,clothes6,shoes1");
			charaterHolder.addChild(npc.view);
			
			npc.view.x = 100;
			npc.view.y = 300;
			npc.attackRate = 0.5;
			npc.attackInterval = 1;
			npc.attackRange = 90;
			npc.breakChance = 0.5;
			npc.defense = 8;
			npc.attack = 20;
			npc.hpMax = 100;
			npc.hp = 100;
			npc.velocity = 2;
			npc.addSkill(new AttackSkill());
			npc.weapon = new WeaponInfor(0,WeaponInfor.SWORD);
			
			npcAI = new FighterControllerMediator("NPCAI2",npc,1,AIGroup.PLAYER);
			npcAI.setTo(200,200);
			npcAI.decision = new JuniorPirateAI();
			npcAI.start();
			sendNotification(FightHelperMediator.JOIN_BATTLE,npcAI);
			npcAI.fsm.changeState(AIState.DECISION);
			npcs.push(npcAI);
			
			npc = pool.object;
			npc.range = range;
			GlobalModule.charaterUtils.humanDressFun(npc,"hair3,face_face1,clothes6,shoes1");
			charaterHolder.addChild(npc.view);
			
			npc.view.x = 100;
			npc.view.y = 300;
			npc.attackRate = 1;
			npc.attackInterval = 1;
			npc.attackRange = 170;
			npc.breakChance = 0.5;
			npc.defense = 20;
			npc.attack = 10;
			npc.hpMax = 100;
			npc.hp = 100;
			npc.velocity = 1;
			npc.addSkill(new AttackSkill());
			npc.weapon = new WeaponInfor(0,WeaponInfor.GUN);
			
			npcAI = new FighterControllerMediator("NPCAI3",npc,1,AIGroup.PLAYER);
			npcAI.setTo(200,200);
			npcAI.decision = new JuniorPirateAI();
			npcAI.start();
			sendNotification(FightHelperMediator.JOIN_BATTLE,npcAI);
			npcAI.fsm.changeState(AIState.DECISION);
			npcs.push(npcAI);
			
			
			
			
			
			runEnterFrames = true;
			
		}
		
		private function myPlayerMoveHandle(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(view);
			if(touch){
				
				if(touch.phase ==TouchPhase.BEGAN){
					triggerMark = true;
					touch.getLocation(view,startPoint);
				}else if(touch.phase==TouchPhase.MOVED){
					touch.getLocation(view,point);
					
					if(point.x>startPoint.x+20||point.x<startPoint.x-20||point.y>startPoint.y+20||point.y<startPoint.y-20){
						triggerMark = false;
					}
					
				}else if(touch.phase==TouchPhase.ENDED){
					if(triggerMark){
						myAI.go(startPoint.x,startPoint.y);
						
						
					}
				}
			}
		}
		
		override public function onRemove():void
		{
			facade.removeProxy(ModuleConst.FIGHT_CHARATER_POOL);
			
			runEnterFrames = false;
			
			pool.object = myAI.charater;
			TweenLite.killTweensOf(myAI);
			myAI.dispose();
			
			for (var i:int = 0; i < npcs.length; i++) 
			{
				TweenLite.killTweensOf(npcs[i]);
				pool.object = npcs[i].charater;
				npcs[i].dispose();
				
			}
			
			
			facade.removeProxy(ModuleConst.FIGHT_CHARATER_POOL);
			facade.removeMediator(FightHelperMediator.NAME);
			facade.removeMediator(FightStateRunnerMediator.NAME);
		}
		
		
		private function callEnemy():void{
			var enemy:FighterControllerMediator = enemyPool.object;
//			CharaterUtils.configHumanFromPool(enemy.charater,"juniorPirate",range);
			enemy.fighter.range = range;
			GlobalModule.charaterUtils.humanDressFun(enemy.charater as HumanMediator,"hair3,face_face1,clothes6,shoes1");
			
			charaterHolder.addChild(enemy.charater.view);
			enemy.fighter.hpMax = enemy.fighter.hp = 100;
			enemy.fighter.attackRange = 50;
			enemy.fighter.attack = 10;
			enemy.fighter.velocity = Math.random()*2+1;
			enemy.fighter.attackRate = 1;
			enemy.fighter.defense = Math.random()*10;
			enemy.fighter.addSkill(new AttackSkill());
			enemy.fighter.weapon = new WeaponInfor(0,WeaponInfor.SWORD);
			if(Math.random()>0.5){
				enemy.decision = new JuniorPirateAI();
			}else{
				enemy.decision = new SmartAI();
				
			}
			enemy.setTo(range.width*Math.random(),range.height*Math.random());
			enemy.touchable = true;
			sendNotification(FightHelperMediator.JOIN_BATTLE,enemy);
			enemy.start();
			/*var txt:TextField = new TextField(200,40,enemy.getMediatorName());
			txt.fontSize = 12;
			enemy.charater.view.addChild(txt);*/
//			enemy.fsm.changeState(AIState.ESCAPE);
		}
		
		
		
		
		override public function handleNotification(notification:INotification):void
		{
			var item:FighterControllerMediator;
			switch(notification.getName())
			{
				case WorldConst.RECLAIM_CHARATER_FROM_BATTLE:{
					item = notification.getBody() as FighterControllerMediator;
					
					if(item.group==AIGroup.ENEMY){
						getLogger(BattleFieldMediator).debug(item.getMediatorName()+" RECLAIM");
						TweenLite.killTweensOf(item);
						enemyPool.object = item;
					}else{
						item.fighter.hp = 100;
						item.reset();
						item.setTo(range.width*Math.random(),range.height*Math.random());
						sendNotification(FightHelperMediator.JOIN_BATTLE,item);
					}
					
					break;
				}
				case BaseCharaterControllerMediator.CLICK_CHARATER:{
					item = notification.getBody() as FighterControllerMediator;
					myAI.resetState();
					
					if(myAI.decision!=playerAI){
						myAI.decision = playerAI;
					}
					
					myAI.target = item;
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
			return [WorldConst.RECLAIM_CHARATER_FROM_BATTLE,BaseCharaterControllerMediator.CLICK_CHARATER];
		}
		
		
		private function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		
	}
}