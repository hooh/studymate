package com.mylib.game.charater.logic
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.game.fight.FightHelperMediator;
	

	public class NormalDisposition implements IFightDecision
	{
		private var fightHelper:FightHelperMediator;
		private var _obstinate:Boolean;
		
		public function NormalDisposition(obstinate:Boolean=false)
		{
			fightHelper = Facade.getInstance(CoreConst.CORE).retrieveMediator(FightHelperMediator.NAME) as FightHelperMediator;
			_obstinate = obstinate;
		}
		
		public function makeDecision(ai:FighterControllerMediator):void
		{
			if(ai.charater.hp<90){
				ai.fsm.changeState(AIState.ESCAPE);
			}else if(!ai.target||!ai.target.alive){
				ai.target = fightHelper.getClosestEnemy(ai.position,ai.group,1000) as FighterControllerMediator;
				
				if(ai.target){
					ai.fightDistance = ai.charater.attackRange;
					ai.fsm.changeState(AIState.TARGETING);
				}
				
			}
			
			
		}
		
		public function makeFightDecision(ai:FighterControllerMediator):void
		{
			if(ai.charater.hp<90){
				ai.fsm.changeState(AIState.ESCAPE);
			}else if(!ai.canTouchTarget){
				TweenLite.killTweensOf(ai);
				
				if(obstinate){
					ai.fightDistance = 30;
					ai.fsm.changeState(AIState.PURSU);
				}else{
					ai.fsm.changeState(AIState.MISS);
				}
				
			}
			
			
			
		}
		
		public function makePursuDecision(ai:FighterControllerMediator):void
		{
			if(ai.isAwayTarget){
				ai.steering.pursuit(ai.target);
			}else{
				ai.fsm.changeState(AIState.FIGHTING);
			}
			
			
		}
		
		
		public function makeTargetingDecision(ai:FighterControllerMediator):void
		{
			if(ai.isAwayTarget){
				ai.target = fightHelper.getClosestEnemy(ai.position,ai.group,1000) as FighterControllerMediator;
				
				if(ai.target&&ai.target.alive){
					ai.steering.seek(ai.target.position);
				}else{
					ai.fsm.changeState(AIState.IDLE);
				}
			}else{
				ai.fsm.changeState(AIState.FIGHTING);
			}
			
		}
		
		public function makeEscapeDecision(ai:FighterControllerMediator):void
		{
			if(!ai.charater.state.range.contains(ai.position.x,ai.position.y)){
				ai.go(Math.random()*ai.charater.state.range.width+ai.charater.state.range.x,Math.random()*ai.charater.state.range.height+ai.charater.state.range.y);
				return;
			}
			
			var target:FighterControllerMediator = fightHelper.getDangerEnemy(ai.position,ai.group) as FighterControllerMediator;
			if(target){
				ai.steering.evade(target);
			}else{
				ai.steering.wander();
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
		
		
	}
}