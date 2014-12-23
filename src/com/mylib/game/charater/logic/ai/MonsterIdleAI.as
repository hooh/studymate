package com.mylib.game.charater.logic.ai
{
	import com.mylib.game.charater.logic.AIState;
	import com.mylib.game.charater.logic.BaseCharaterControllerMediator;
	import com.mylib.game.charater.logic.FighterControllerMediator;
	import com.mylib.game.charater.logic.IFightDecision;
	
	public class MonsterIdleAI implements IFightDecision
	{
		public function MonsterIdleAI()
		{
		}
		
		public function makeArriveDecision(ai:BaseCharaterControllerMediator):void
		{
			
			if(ai.charater.view.x >ai.charater.range.x+ai.charater.range.width*0.5){
				ai.go(ai.charater.range.x,ai.charater.range.y);
			}else{
				ai.go(ai.charater.range.x+ai.charater.range.width,ai.charater.range.y);
			}
			
		}
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			
		}
		
		
		public function makeDecision(ai:BaseCharaterControllerMediator):void
		{
			ai.go(ai.charater.range.x+ai.charater.range.width,ai.charater.range.y);
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