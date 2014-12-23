package com.mylib.game.charater.logic.ai
{
	import com.greensock.TweenLite;
	import com.mylib.game.charater.PetDogMediator;
	import com.mylib.game.charater.logic.AIState;
	import com.mylib.game.charater.logic.BaseCharaterControllerMediator;
	import com.mylib.game.charater.logic.IDecision;
	import com.mylib.game.charater.logic.IPetDogDecision;
	import com.mylib.game.charater.logic.IslanderControllerMediator;
	import com.mylib.game.charater.logic.PetDogControllerMediator;
	
	public class PetDogFreeAI implements IPetDogDecision
	{
		protected var randomStates:Vector.<String>;
		protected var randomActions:Vector.<Function>;
		
		
		public function PetDogFreeAI()
		{
			
			randomStates = Vector.<String>([
				AIState.RANDOM_GO,
				AIState.REST
			]);
			
		}
		
		public function makeDecision(ai:BaseCharaterControllerMediator):void
		{
//			trace(ai.getMediatorName(),"makeDecision");
			
			if(Math.random()>0.8){
				ai.fsm.changeState(randomStates[0]);
			}else{
				ai.fsm.changeState(randomStates[1]);
			}
			
			
			
		}
		
		public function makeTargetingDecision(ai:BaseCharaterControllerMediator):void
		{
		}
		
		public function makeArriveDecision(ai:BaseCharaterControllerMediator):void
		{
			ai.reset();
		}
		
		public function makeRandomGODecision(controller:PetDogControllerMediator):void
		{
			controller.go(Math.random()*controller.charater.range.width+controller.charater.range.x,Math.random()*controller.charater.range.height+controller.charater.range.y);
		}
		
		public function makeRestDecision(controller:PetDogControllerMediator):void
		{
			randomActions ||=Vector.<Function>([
				(controller.charater as PetDogMediator).rest,
				(controller.charater as PetDogMediator).shout,
				(controller.charater as PetDogMediator).lieDown,
				(controller.charater as PetDogMediator).sit
			]);
			
			var randomIdx:int = Math.random()*randomActions.length;
			
			
			randomActions[randomIdx].call();
			
			
			timeFly(controller);
		}
		
		private function timeFly(controller:PetDogControllerMediator):void{
			TweenLite.killTweensOf(controller);
			TweenLite.to(controller,Math.random()*3+2,{onComplete:controller.reset});
		}
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			
		}
		
	}
}