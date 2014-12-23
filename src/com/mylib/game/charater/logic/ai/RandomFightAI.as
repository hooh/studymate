package com.mylib.game.charater.logic.ai
{
	import com.greensock.TweenLite;
	import com.mylib.game.charater.logic.AIState;
	import com.mylib.game.charater.logic.BaseCharaterControllerMediator;
	import com.mylib.game.charater.logic.FighterControllerMediator;
	import com.mylib.game.charater.logic.IFightDecision;
	import com.mylib.game.controller.CardFightHelperMediator;
	
	public class RandomFightAI implements IFightDecision
	{
		private var fightHelper:CardFightHelperMediator;
		private var currentAction:String;
		
		public function RandomFightAI(_fightHelper:CardFightHelperMediator)
		{
			fightHelper = _fightHelper;
		}
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			
		}
		
		
		public function makeFightDecision(ai:FighterControllerMediator):void
		{
			
			
			
			if(!ai.canTouchTarget){
				currentAction="";
				reset(ai);
			}else{
				if(currentAction!="fight"){
					currentAction="fight";
					ai.charater.action("fight",8,ai.fighter.attackRate*20,false);
					
					if(ai.charater.view.x>ai.target.charater.view.x){
						ai.charater.dirX = -1;
					}else{
						ai.charater.dirX = 1;
					}
					
					TweenLite.to(ai,ai.fighter.attackRate,{onComplete:reset,onCompleteParams:[ai]});
				}
				
			}
			
			
			
			
			
		}
		
		private function reset(ai:FighterControllerMediator):void{
			currentAction = "";
			ai.reset();
			
		}
		
		public function makeEscapeDecision(ai:FighterControllerMediator):void
		{
		}
		
		public function makeHurtDecision(attacker:FighterControllerMediator, me:FighterControllerMediator):void
		{
		}
		
		public function makeDecision(ai:BaseCharaterControllerMediator):void
		{
			var fightController:FighterControllerMediator = ai as FighterControllerMediator;
			
			fightController.target = fightHelper.getRandomEnemy(fightController.group) as FighterControllerMediator;
			
			if(fightController.target){
				fightController.fightDistance = fightController.fighter.attackRange;
				ai.fsm.changeState(AIState.TARGETING);
			}else{
				fightController.go(fightController.charater.range.x+Math.random()*fightController.charater.range.width,
					fightController.charater.range.y+Math.random()*fightController.charater.range.height
				);
			}
			
			
			
		}
		
		public function makeTargetingDecision(ai:BaseCharaterControllerMediator):void
		{
			
			var fightController:FighterControllerMediator = ai as FighterControllerMediator;
			if(fightController.isAwayTarget){
				if(fightController.target){
					ai.steering.seek(fightController.target.position);
				}else{
					fightController.reset();
				}
			}else{
				ai.fsm.changeState(AIState.FIGHTING);
			}
			
			
		}
		
		public function makeArriveDecision(ai:BaseCharaterControllerMediator):void
		{
			ai.reset();
		}
	}
}