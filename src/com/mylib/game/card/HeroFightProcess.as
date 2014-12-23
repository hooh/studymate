package com.mylib.game.card
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.JobTypes;
	import com.mylib.game.charater.logic.ai.EnterFightEvent;
	import com.mylib.game.charater.logic.ai.HeroFightAI;
	import com.mylib.game.charater.logic.ai.HeroGoAI;
	import com.mylib.game.charater.logic.ai.MonsterEnterFightAI;
	import com.mylib.game.controller.vo.HeroFightVO;
	import com.mylib.game.model.FightCharaterPoolProxy;
	import com.mylib.game.ui.MonsterHPBar;
	import com.studyMate.module.ModuleConst;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.events.Event;
	
	import stateMachine.StateMachine;
	import stateMachine.StateMachineEvent;

	public class HeroFightProcess implements IAnimatable
	{
		private var fsm:StateMachine;
		
		private static const ATTENTION:String = "attention";
		private static const INIT:String = "init";
		private static const FIGHT:String = "fight";
		private static const FIGHT_END:String = "fightEnd";
		private static const END:String = "end";
		private static const BACK:String = "back";
		private static const IMM_FIGHT:String = "immFight";
		
		private var hfvo:HeroFightVO;
		
		private var lastUpdateTime:uint;
		
		
		public function HeroFightProcess(hfvo:HeroFightVO)
		{
			
			this.hfvo = hfvo;
			
			fsm = new StateMachine();
			fsm.addState(ATTENTION,{enter:enterAttention,from:[INIT]});
			fsm.addState(INIT,{enter:enterInit,from:["*"]});
			fsm.addState(FIGHT,{enter:enterFight,from:[ATTENTION]});
			fsm.addState(FIGHT_END,{enter:enterFightEnd,from:["*"]});
			fsm.addState(END,{enter:enterEnd,from:["*"]});
			fsm.addState(BACK,{enter:enterBack,from:["*"]});
			
			fsm.initialState = INIT;
		}
		
		
		
		
		private function enterEnd(event:StateMachineEvent):void{
			dispose();
			Facade.getInstance(CoreConst.CORE).sendNotification(HeroFightManager.FIGHT_END,hfvo);
			
		}
		
		
		private function enterBack(event:StateMachineEvent):void{
			hfvo.readyCount = 0;
			for (var i:int = 0; i < hfvo.heros.length; i++) 
			{
				var ai:HeroGoAI = new HeroGoAI(new Point(-100,hfvo.monster.fighter.charater.range.y),null);
				ai.addEventListener(EnterFightEvent.READY,leaveHandle);
				hfvo.heros[i].fighter.decision.dispose();
				hfvo.heros[i].fighter.decision = ai;
				hfvo.heros[i].fighter.resetState();
			}
			
			
		}
		
		
		private function enterFightEnd(event:StateMachineEvent):void{
			
			stop();
			
			hfvo.monster.fighter.decision = null;
			hfvo.monster.fighter.pause();
			hfvo.monster.fighter.charater.action("die",false);
			
			fsm.changeState(BACK);
			
			
		}
		
		
		public function start():void{
			
			if(hfvo.monster.data.hp>0){
				fsm.changeState(ATTENTION);
			}else{
				fsm.changeState(END);
			}
			
			
		}
		
		
		private function enterFight(event:StateMachineEvent):void{
			Starling.juggler.add(this);
			lastUpdateTime = getTimer();
		}
		
		
		public function stop():void{
			if(Starling.juggler.contains(this)){
				Starling.juggler.remove(this);
			}
		}
		
		public function dispose():void{
			
			for (var i:int = 0; i < hfvo.heros.length; i++) 
			{
				if(!hfvo.heros[i].fighter){
					continue;
				}
				
				if(hfvo.heros[i].fighter.charater){
					hfvo.heros[i].fighter.charater.view.visible = true;
				}
				
				
				if(hfvo.heros[i].fighter.decision)
					hfvo.heros[i].fighter.decision.dispose();
				
				TweenLite.killTweensOf(hfvo.heros[i].fighter);
				(Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.FIGHT_CHARATER_POOL) as FightCharaterPoolProxy).object = hfvo.heros[i].fighter;
				hfvo.heros[i].fighter = null;
			}
			
		}
		
		
		private function attention():void{
			
			var i:int;
			var hasWarrior:Boolean;
			
			for (i = 0; i < hfvo.heros.length; i++) 
			{
				if(hfvo.heros[i].data.job==JobTypes.warrior){
					hasWarrior = true;
					break;
				}
			}
			
			if(!hasWarrior){
				hfvo.heros[0].data.job=JobTypes.warrior;
			}
			
			
			
			for (i = 0; i < hfvo.heros.length; i++) 
			{
				var target:Point = new Point(hfvo.monster.fighter.charater.range.x,hfvo.monster.fighter.charater.range.y+i+1);
				var dirX:int;
				var locationX:int = 50;
				if(i%2>0){
					dirX = 1;
				}else{
					dirX = -1;
				}
				
				if(hfvo.heros[i].data.job!=JobTypes.warrior){
					locationX+=50;
				}
				
				locationX+=i*10;
				locationX*=dirX;
				locationX+=target.x;
				
				
				if(hfvo.monster.data.hp<hfvo.monster.data.fullHP){
					hfvo.heros[i].fighter.decision = new HeroFightAI(hfvo,hfvo.heros[i]);
					hfvo.heros[i].heroAtt = hfvo.heroAttribute;
					hfvo.heros[i].fighter.start();
					hfvo.heros[i].fighter.charater.actor.start();
					hfvo.heros[i].fighter.charater.view.visible = true;
					
					
					hfvo.heros[i].fighter.setTo(locationX,target.y);
					
					if(target.x>=locationX){
						hfvo.heros[i].fighter.charater.dirX = 1;
					}else{
						hfvo.heros[i].fighter.charater.dirX = -1;
					}
					
				}else{
					var ai:HeroGoAI = new HeroGoAI(new Point(locationX,target.y),target);
					ai.addEventListener(EnterFightEvent.READY,readyHandle);
					
					hfvo.heros[i].heroAtt = hfvo.heroAttribute;
					
					hfvo.heros[i].fighter.decision = ai;
					
					hfvo.heros[i].fighter.start();
					hfvo.heros[i].fighter.charater.actor.start();
					hfvo.heros[i].fighter.charater.view.visible = true;
				}
					
				
				
				
			}
			
			var monsterAI:MonsterEnterFightAI = new MonsterEnterFightAI();
			hfvo.monster.fighter.decision = monsterAI;
			monsterAI.addEventListener(EnterFightEvent.READY,monsterReadyHandle);
			if(hfvo.monster.data.hp<hfvo.monster.data.fullHP){
				
				fsm.changeState(FIGHT);
				
				
				
			}else{
			}
			
			
			
			
			
			
		}
		
		private function monsterReadyHandle(event:Event):void
		{
			if(event){
				(event.target as MonsterEnterFightAI).removeEventListeners();
			}
			
			var bar:MonsterHPBar = new MonsterHPBar(hfvo);
			hfvo.monster.fighter.charater.view.addChild(bar);
			hfvo.monster.fighter.decision = null;
			hfvo.monster.fighter.pause();
			bar.update();
			Facade.getInstance(CoreConst.CORE).sendNotification(HeroFightManager.REGIST_UPDATE_VALUE,[hfvo,bar]);
			
		}
		
		private function readyHandle(event:Event):void{
			
			(event.target as HeroGoAI).removeEventListeners();
			
			
			hfvo.readyCount++;
			
			if(hfvo.readyCount==hfvo.heros.length){
				changeFightState();
			}
		}
		
		private function changeFightState():void{
			
			for (var i:int = 0; i < hfvo.heros.length; i++) 
			{
				
				hfvo.heros[i].fighter.decision = new HeroFightAI(hfvo,hfvo.heros[i]);
			}
			
			
			
			fsm.changeState(FIGHT);
			
			
		}
		
		
		
		private function leaveHandle(event:Event):void{
			(event.target as HeroGoAI).removeEventListeners();
			
			
			hfvo.readyCount++;
			
			if(hfvo.readyCount==hfvo.heros.length){
				
				fsm.changeState(END);
				
				
				
			}
		}
		
		private function enterAttention(event:StateMachineEvent):void{
			attention();
		}
		
		private function enterInit(event:StateMachineEvent):void{
			hfvo.update();
		}
		
		
		
		public function advanceTime(time:Number):void
		{
			
			if(getTimer()>1000+lastUpdateTime){
				var sec:uint = (getTimer() - lastUpdateTime)*0.001;
				hfvo.cacheHP+=hfvo.averageDamage*sec;
			}
			
			if(hfvo.remainHP<=0){
				fsm.changeState(FIGHT_END);
			}
			
			
			
		}
		
	}
}