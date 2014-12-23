package com.mylib.game.charater.logic.ai
{
	import com.mylib.game.charater.logic.AIState;
	import com.mylib.game.charater.logic.BaseCharaterControllerMediator;
	import com.mylib.game.charater.logic.FighterControllerMediator;
	import com.mylib.game.charater.logic.IFightDecision;
	
	public class CollectionIdleAI implements IFightDecision
	{
		public function CollectionIdleAI()
		{
		}
		
		public function makeArriveDecision(ai:BaseCharaterControllerMediator):void
		{
		}
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			
		}
		
		
		public function makeDecision(ai:BaseCharaterControllerMediator):void
		{
			ai.setTo(ai.charater.range.x,ai.charater.range.y);
			
			ai.charater.dirX = -1;
			ai.fsm.changeState(AIState.IDLE);
		}
		
		public function makeTargetingDecision(ai:BaseCharaterControllerMediator):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function makeEscapeDecision(ai:FighterControllerMediator):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function makeFightDecision(ai:FighterControllerMediator):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function makeHurtDecision(attacker:FighterControllerMediator, me:FighterControllerMediator):void
		{
			// TODO Auto Generated method stub
			
		}
		
		
	}
}