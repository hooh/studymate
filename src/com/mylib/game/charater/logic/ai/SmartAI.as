package com.mylib.game.charater.logic.ai
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.logic.AIState;
	import com.mylib.game.charater.logic.BaseCharaterControllerMediator;
	import com.mylib.game.charater.logic.FighterControllerMediator;
	import com.mylib.game.charater.logic.IFightDecision;
	import com.mylib.game.charater.skill.SkillType;
	import com.mylib.game.fight.FightHelperMediator;
	import com.studyMate.world.controller.vo.AttackCharaterVO;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	public class SmartAI implements IFightDecision
	{
		private var fightHelper:FightHelperMediator;
		private var _obstinate:Boolean;
		private var escapeRange:int;
		
		public function SmartAI(obstinate:Boolean=false)
		{
			fightHelper = Facade.getInstance(CoreConst.CORE).retrieveMediator(FightHelperMediator.NAME) as FightHelperMediator;
			_obstinate = obstinate;
		}
		
		
		public function makeDecision(ai:BaseCharaterControllerMediator):void
		{
			var fightController:FighterControllerMediator = ai as FighterControllerMediator;
			
			if(fightController.fighter.hp/fightController.fighter.hpMax<0.2){
				escapeRange = 50;
				ai.fsm.changeState(AIState.ESCAPE);
			}else{
				fightController.target = fightHelper.getMinHPEnemy(fightController.group) as FighterControllerMediator;
				
				if(fightController.target){
					fightController.fightDistance = fightController.fighter.attackRange;
					ai.fsm.changeState(AIState.TARGETING);
				}
				
			}
			
			
		}
		
		public function makeFightDecision(ai:FighterControllerMediator):void
		{
			var fightController:FighterControllerMediator = ai as FighterControllerMediator;
			if(fightController.fighter.hp/fightController.fighter.hpMax<0.2){
				escapeRange = 50;
				ai.fsm.changeState(AIState.ESCAPE);
			}else if(!ai.canTouchTarget){
				ai.fsm.changeState(AIState.IDLE);
			}else{
				Facade.getInstance(CoreConst.CORE).sendNotification(FightHelperMediator.LAUNCH_SKILL,new AttackCharaterVO(ai,ai.target,SkillType.SIMPLE_ATTACK));
				
			}
			
			
			
		}
		
		
		public function makeTargetingDecision(ai:BaseCharaterControllerMediator):void
		{
			var fightController:FighterControllerMediator = ai as FighterControllerMediator;
			if(fightController.isAwayTarget){
				fightController.target = fightHelper.getMinHPEnemy(fightController.group) as FighterControllerMediator;
				
				if(fightController.target&&fightController.target.alive){
					ai.steering.seek(fightController.target.position);
				}else{
					fightController.reset();
				}
			}else{
				ai.fsm.changeState(AIState.FIGHTING);
			}
			
		}
		
		public function makeEscapeDecision(ai:FighterControllerMediator):void
		{
			var fightController:FighterControllerMediator = ai as FighterControllerMediator;
			
			if(!ai.charater.range.contains(ai.position.x,ai.position.y)){
				ai.go(Math.random()*ai.charater.range.width+ai.charater.range.x,Math.random()*ai.charater.range.height+ai.charater.range.y);
				return;
			}
			
			var target:FighterControllerMediator = fightHelper.getClosestEnemy(ai.position,ai.group,escapeRange) as FighterControllerMediator;
			if(target){
				ai.steering.evade(target);
			}else{
				
				if(fightController.fighter.hp/fightController.fighter.hpMax<0.2){
					ai.steering.wander();
				}else{
					ai.reset();
				}
				
			}
			
		}
		
		public function get obstinate():Boolean
		{
			return _obstinate;
		}
		
		public function set obstinate(value:Boolean):void
		{
			_obstinate = value;
		}
		
		
		public function makeHurtDecision(attacker:FighterControllerMediator, me:FighterControllerMediator):void
		{
			escapeRange = me.fighter.attackRange;
			me.fsm.changeState(AIState.ESCAPE);
		}
		
		
		public function makeArriveDecision(ai:BaseCharaterControllerMediator):void
		{
			ai.reset();
		}
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			
		}
		
	}
}