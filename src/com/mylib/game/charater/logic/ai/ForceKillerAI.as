package com.mylib.game.charater.logic.ai
{
	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.logic.AIState;
	import com.mylib.game.charater.logic.BaseCharaterControllerMediator;
	import com.mylib.game.charater.logic.FighterControllerMediator;
	import com.mylib.game.charater.logic.IDecision;
	import com.mylib.game.charater.logic.IFightDecision;
	import com.mylib.game.charater.skill.SkillType;
	import com.mylib.game.fight.FightHelperMediator;
	import com.studyMate.world.controller.vo.AttackCharaterVO;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class ForceKillerAI implements IFightDecision
	{
		public var recoverAI:IDecision;
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			
		}
		
		
		public function ForceKillerAI(recoverAI:IDecision=null)
		{
			this.recoverAI = recoverAI;
		}
		
		public function makeDecision(ai:BaseCharaterControllerMediator):void
		{
			var fightController:FighterControllerMediator = ai as FighterControllerMediator;
			
			if(fightController.target&&fightController.target.alive){
				fightController.fightDistance = fightController.fighter.attackRange;
				ai.fsm.changeState(AIState.TARGETING);
			}else{
				makeArriveDecision(ai);
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
		
		public function makeTargetingDecision(ai:BaseCharaterControllerMediator):void
		{
			var fightController:FighterControllerMediator = ai as FighterControllerMediator;
			if(fightController.isAwayTarget){
				if(fightController.target&&fightController.target.alive){
					ai.steering.seek(fightController.target.position);
				}else{
					makeArriveDecision(ai);
				}
			}else{
				ai.fsm.changeState(AIState.FIGHTING);
			}
			
		}
		
		public function makeEscapeDecision(ai:FighterControllerMediator):void
		{
		}
		
		
		public function makeHurtDecision(attacker:FighterControllerMediator, me:FighterControllerMediator):void
		{
		}
		
		public function makeReadyAttacked(attacker:FighterControllerMediator, me:FighterControllerMediator):void
		{
		}
		
		
		public function makeArriveDecision(ai:BaseCharaterControllerMediator):void
		{
			if(recoverAI){
				ai.decision = recoverAI;
			}else{
				ai.fsm.changeState(AIState.IDLE);
			}
		}
		
	}
}