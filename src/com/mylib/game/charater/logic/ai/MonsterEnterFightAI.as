package com.mylib.game.charater.logic.ai
{
	import com.mylib.game.charater.logic.AIState;
	import com.mylib.game.charater.logic.BaseCharaterControllerMediator;
	import com.mylib.game.charater.logic.FighterControllerMediator;
	import com.mylib.game.charater.logic.IFightDecision;
	
	import starling.events.EventDispatcher;
	
	public class MonsterEnterFightAI extends EventDispatcher implements IFightDecision
	{
		private var hasArrive:Boolean;
		
		public function MonsterEnterFightAI()
		{
		}
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			
		}
		
		
		public function makeFightDecision(ai:FighterControllerMediator):void
		{
		}
		
		public function makeEscapeDecision(ai:FighterControllerMediator):void
		{
		}
		
		public function makeHurtDecision(attacker:FighterControllerMediator, me:FighterControllerMediator):void
		{
		}
		
		public function makeDecision(ai:BaseCharaterControllerMediator):void
		{
			if(!hasArrive){
				ai.go(ai.charater.range.x,ai.charater.range.y);
			}
		}
		
		public function makeTargetingDecision(ai:BaseCharaterControllerMediator):void
		{
		}
		
		public function makeArriveDecision(ai:BaseCharaterControllerMediator):void
		{
			if(Math.abs(ai.charater.range.x-ai.charater.view.x)>10){
				ai.go(ai.charater.range.x,ai.charater.range.y);
				return;
			}
			
			this.dispatchEventWith(EnterFightEvent.READY);
			hasArrive = true;
			ai.charater.dirX = -1;
			ai.fsm.changeState(AIState.IDLE);
		}
	}
}