package com.mylib.game.charater.logic.ai
{
	import com.mylib.framework.CoreConst;
	import com.mylib.game.card.FightEffectFactoryProxy;
	import com.mylib.game.card.FightEffectVO;
	import com.mylib.game.charater.IHuman;
	import com.mylib.game.charater.JobTypes;
	import com.mylib.game.charater.logic.AIState;
	import com.mylib.game.charater.logic.BaseCharaterControllerMediator;
	import com.mylib.game.charater.logic.FighterControllerMediator;
	import com.mylib.game.charater.logic.IFightDecision;
	
	import flash.geom.Point;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.events.EventDispatcher;
	
	public class RollFightAI extends EventDispatcher implements IFightDecision
	{
		private var hasArrived:Boolean;
		private var location:Point;
		private var target:Point;
		
		public function RollFightAI(location:Point,target:Point)
		{
			this.location = location;
			this.target = target;
		}
		
		public function makeFightDecision(ai:FighterControllerMediator):void
		{
			var effect:FightEffectVO = (Facade.getInstance(CoreConst.CORE).retrieveProxy(FightEffectFactoryProxy.NAME) as FightEffectFactoryProxy).getEffect(JobTypes.yuzhou);
			effect.start(0,-120,-100,-120,-100,ai.charater.view);
		}
		
		public function makeEscapeDecision(ai:FighterControllerMediator):void
		{
		}
		
		public function makeHurtDecision(attacker:FighterControllerMediator, me:FighterControllerMediator):void
		{
			(me.charater as IHuman).beatHead();
			(Facade.getInstance(CoreConst.CORE).retrieveProxy(FightEffectFactoryProxy.NAME) as FightEffectFactoryProxy).getEffect(JobTypes.hurt).start(0,-50,-60,-50,-60,me.charater.view);
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
		}
	}
}