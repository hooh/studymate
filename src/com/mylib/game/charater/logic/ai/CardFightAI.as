package com.mylib.game.charater.logic.ai
{
	import com.greensock.TweenLite;
	import com.mylib.game.charater.logic.AIState;
	import com.mylib.game.charater.logic.BaseCharaterControllerMediator;
	import com.mylib.game.charater.logic.FighterControllerMediator;
	import com.mylib.game.charater.logic.IDecision;
	import com.mylib.game.charater.logic.IFightDecision;
	import com.mylib.game.fight.FightHelperMediator;
	
	import org.as3commons.logging.api.getLogger;
	
	public class CardFightAI implements IFightDecision
	{
		public var recoverAI:IDecision;
		private var ox:int;
		private var oy:int;
		private var odirX:int;
		
		public function CardFightAI(recoverAI:IDecision,ox:int,oy:int,odirX:int)
		{
			this.recoverAI = recoverAI;
			this.ox = ox;
			this.oy = oy;
			this.odirX = odirX;
		}
		
		public function makeFightDecision(ai:FighterControllerMediator):void
		{
			ai.charater.action("fight",8,ai.fighter.attackRate*20,false);
			
			ai.target.charater.action("hit",8,30,true);
			TweenLite.to(ai.target,0.5,{onComplete:actionComplete,onCompleteParams:[ai.target]});
			
			
			if(ai.charater.view.x>ai.target.charater.view.x){
				ai.charater.dirX = -1;
			}else{
				ai.charater.dirX = 1;
			}
			
			TweenLite.to(ai,ai.fighter.attackRate,{onComplete:attackComplete,onCompleteParams:[ai]});
		}
		
		private function actionComplete(ai:FighterControllerMediator):void{
			ai.charater.idle();
		}
		
		
		private function attackComplete(ai:FighterControllerMediator):void{
			
			
			ai.go(ox,oy);
			
			
			
			
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
			
			if(fightController.target){
				fightController.fightDistance = fightController.fighter.attackRange;
				ai.fsm.changeState(AIState.TARGETING);
			}else{
				makeArriveDecision(ai);
			}
			
			
			
		}
		
		public function makeTargetingDecision(ai:BaseCharaterControllerMediator):void
		{
			var fightController:FighterControllerMediator = ai as FighterControllerMediator;
			if(fightController.isAwayTarget){
				
				//跳，跑，或者闪动。
				if(fightController.target){
					ai.steering.seek(fightController.target.position);
				}else{
					makeArriveDecision(ai);
				}
			}else{
				ai.fsm.changeState(AIState.FIGHTING);
			}
			
		}
		
		public function makeArriveDecision(ai:BaseCharaterControllerMediator):void
		{
			
			if(recoverAI){
				ai.decision = recoverAI;
				ai.charater.dirX = odirX;
			}else{
				ai.fsm.changeState(AIState.IDLE);
			}
			
			
		}
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			
		}
		
	}
}