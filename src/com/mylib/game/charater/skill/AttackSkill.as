package com.mylib.game.charater.skill
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.effect.FightEffectProxy;
	import com.mylib.game.charater.logic.AIState;
	import com.mylib.game.fight.FightHelperMediator;
	import com.studyMate.world.controller.vo.AttackCharaterVO;
	import com.studyMate.world.screens.WorldConst;
	
	import org.as3commons.logging.api.getLogger;
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	public class AttackSkill extends BaseSkill
	{
		public function AttackSkill()
		{
			super();
			type = SkillType.SIMPLE_ATTACK;
		}
		
		override public function launch(acvo:AttackCharaterVO):void
		{
			super.launch(acvo);
			
			TweenLite.killTweensOf(acvo.attacker);
			attack(acvo);
			
			
		}
		
		private function attack(acvo:AttackCharaterVO):void{
//			acvo.attacker.charater.attackAction(acvo.attacker.charater.attackRate);
			
			(Facade.getInstance(CoreConst.CORE).retrieveProxy(FightEffectProxy.NAME) as FightEffectProxy).fight(acvo);
			
			
//			acvo.attacker.charater.actor.playAnimation("shoot",8,acvo.attacker.charater.attackRate*20,false);
			
			if(acvo.attacker.charater.view.x>acvo.target.charater.view.x){
				acvo.attacker.charater.dirX = -1;
			}else{
				acvo.attacker.charater.dirX = 1;
			}
			
			
			getLogger(FightHelperMediator).debug(acvo.attacker.getMediatorName()+" attack "+acvo.target.getMediatorName());
			TweenLite.to(acvo.attacker,acvo.attacker.fighter.attackRate*20,{onComplete:attackComplete,onCompleteParams:[acvo],useFrames:true});
			
		}
		
		private function simpleAttack(acvo:AttackCharaterVO):void{
			
			var attack:int = acvo.attacker.fighter.attack+acvo.attacker.fighter.level*Math.ceil(Math.random()*2);
			var hurt:int = (1/(1+0.06*acvo.target.fighter.defense))*attack;
			acvo.target.fighter.hp-=hurt;
			
			
		}
		
		private function attackComplete(acvo:AttackCharaterVO):void{
			getLogger(FightHelperMediator).debug(acvo.attacker.getMediatorName()+" attackComplete "+acvo.target.getMediatorName());
			TweenLite.killTweensOf(acvo.attacker);
			if(!acvo.target.alive){
				acvo.attacker.fsm.changeState(AIState.IDLE);
				return;
			}
			
			
			if(acvo.target.fighter.dodge>Math.random()){
				Facade.getInstance(CoreConst.CORE).sendNotification(FightHelperMediator.ATTACK_CHARATER_COMPLETE,acvo);
			}else{
				getLogger(FightHelperMediator).debug(acvo.attacker.getMediatorName()+" hit"+acvo.target.getMediatorName());
				simpleAttack(acvo);
				if(doBreak(acvo)){
					getLogger(FightHelperMediator).debug(acvo.attacker.getMediatorName()+" break"+acvo.target.getMediatorName());
					
					acvo.target.fighter.hitAction();
					TweenLite.killTweensOf(acvo.target);
					acvo.target.fsm.changeState(AIState.FREEZE);
					TweenLite.to(acvo.target,0.5,{onComplete:hitComplete,onCompleteParams:[acvo]});
				}
				Facade.getInstance(CoreConst.CORE).sendNotification(FightHelperMediator.ATTACK_CHARATER_COMPLETE,acvo);
			}
			
			
			
			
			
		}
		
		private function doBreak(acvo:AttackCharaterVO):Boolean{
			
			if(Math.random()>1-acvo.attacker.fighter.breakChance){
				return true;
			}
			
			return false;
		}
		
		
		
		private function hitComplete(acvo:AttackCharaterVO):void{
			acvo.target.fsm.changeState(AIState.IDLE);
			getLogger(FightHelperMediator).debug(acvo.attacker.getMediatorName()+" break complete"+acvo.target.getMediatorName());
			
		}
		
	}
}