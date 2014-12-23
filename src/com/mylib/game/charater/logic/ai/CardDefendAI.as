package com.mylib.game.charater.logic.ai
{
	import com.mylib.game.charater.logic.BaseCharaterControllerMediator;
	import com.mylib.game.charater.logic.FighterControllerMediator;
	import com.mylib.game.charater.logic.IFightDecision;
	
	public class CardDefendAI implements IFightDecision
	{
		public function CardDefendAI()
		{
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
		}
		
		public function makeTargetingDecision(ai:BaseCharaterControllerMediator):void
		{
		}
		
		public function makeArriveDecision(ai:BaseCharaterControllerMediator):void
		{
		}
	}
}