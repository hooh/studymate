package com.mylib.game.charater.logic.ai
{
	import com.mylib.game.charater.logic.AIState;
	import com.mylib.game.charater.logic.BaseCharaterControllerMediator;
	import com.mylib.game.charater.logic.FighterControllerMediator;
	import com.mylib.game.charater.logic.IFightDecision;
	
	import flash.geom.Point;
	
	import starling.events.EventDispatcher;
	
	
	public class HeroGoAI extends EventDispatcher implements IFightDecision
	{
		
		
		private var hasArrived:Boolean;
		
		private var location:Point;
		private var target:Point;
		
		public function HeroGoAI(location:Point,target:Point)
		{
			this.location = location;
			this.target = target;
			
			
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
			if(!hasArrived){
				ai.charater.velocity = 3;
				ai.go(location.x,location.y);
			}
			
			
			
		}
		
		public function makeTargetingDecision(ai:BaseCharaterControllerMediator):void
		{
		}
		
		public function makeArriveDecision(ai:BaseCharaterControllerMediator):void
		{
			hasArrived = true;
			
			if(target){
				if(target.x>=location.x){
					ai.charater.dirX = 1;
				}else{
					ai.charater.dirX = -1;
				}
				
			}
			
			ai.fsm.changeState(AIState.IDLE);
			
			this.dispatchEventWith(EnterFightEvent.READY);
			
			
		}
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			
		}
		
	}
}