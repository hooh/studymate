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

	public class JuniorPirateAI implements IFightDecision
	{
		private var fightHelper:FightHelperMediator;
		private var _guardRange:int;
		public function JuniorPirateAI(__guardRange:int=1000)
		{
			fightHelper = Facade.getInstance(CoreConst.CORE).retrieveMediator(FightHelperMediator.NAME) as FightHelperMediator;
			_guardRange = __guardRange;
		}
		
		
		public function makeDecision(ai:BaseCharaterControllerMediator):void
		{
			var fightController:FighterControllerMediator = ai as FighterControllerMediator;
			fightController.target = fightHelper.getClosestEnemy(ai.position,fightController.group,_guardRange) as FighterControllerMediator;
			if(fightController.target){
				fightController.fightDistance = fightController.fighter.attackRange;
				ai.fsm.changeState(AIState.TARGETING);
			}
		}
		
		public function makeFightDecision(ai:FighterControllerMediator):void
		{
			if(!ai.canTouchTarget){
				ai.fsm.changeState(AIState.IDLE);
			}else{
				Facade.getInstance(CoreConst.CORE).sendNotification(FightHelperMediator.LAUNCH_SKILL,new AttackCharaterVO(ai,ai.target,SkillType.SIMPLE_ATTACK));
				
			}
			
		}
		
		public function makeHurtDecision(attacker:FighterControllerMediator, me:FighterControllerMediator):void
		{
			// TODO Auto Generated method stub
			
		}
		
		
		public function makeTargetingDecision(ai:BaseCharaterControllerMediator):void
		{
			var fightController:FighterControllerMediator = ai as FighterControllerMediator;
			fightController.target = fightHelper.getClosestEnemy(ai.position,fightController.group,_guardRange) as FighterControllerMediator;
			if(fightController.isAwayTarget){
				if(fightController.target&&fightController.target.alive){
					ai.steering.seek(fightController.target.position);
				}else{
					ai.fsm.changeState(AIState.IDLE);
				}
			}else{
				ai.fsm.changeState(AIState.FIGHTING);
			}
			
		}
		
		
		public function makeEscapeDecision(ai:FighterControllerMediator):void
		{
		}
		
		
		public function makeArriveDecision(ai:BaseCharaterControllerMediator):void
		{
			ai.fsm.changeState(AIState.IDLE);
		}
		
		
		public function get guardRange():int
		{
			return _guardRange;
		}
		
		public function set guardRange(_int:int):void
		{
			_guardRange = _int;
		}
		
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			
		}
		
	}
}