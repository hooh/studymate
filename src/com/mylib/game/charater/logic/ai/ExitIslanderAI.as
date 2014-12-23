package com.mylib.game.charater.logic.ai
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.logic.AIState;
	import com.mylib.game.charater.logic.BaseCharaterControllerMediator;
	import com.mylib.game.charater.logic.IIslanderDecision;
	import com.mylib.game.charater.logic.IslanderControllerMediator;
	import com.mylib.game.charater.logic.IslandersManagerMediator;
	import com.mylib.game.model.IslanderPoolProxy;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class ExitIslanderAI implements IIslanderDecision
	{
		private var preAI:IIslanderDecision;
		private var exitX:int;
		private var exitY:int;
		private var islanderPool:IslanderPoolProxy;
		
		
		public function ExitIslanderAI(exitX:int,exitY:int,preAI:IIslanderDecision)
		{
			this.exitX = exitX;
			this.exitY = exitY;
			this.preAI = preAI;
			islanderPool = Facade.getInstance(CoreConst.CORE).retrieveProxy(IslanderPoolProxy.NAME) as IslanderPoolProxy;
		}
		
		public function makeRestDecision(controller:IslanderControllerMediator):void
		{
		}
		
		public function makeSitDecision(controller:IslanderControllerMediator):void
		{
		}
		
		public function makeTalkDecision(controller:IslanderControllerMediator):void
		{
		}
		
		public function makeRandomGODecision(controller:IslanderControllerMediator):void
		{
		}
		
		public function makeFindTalkPartner(controller:IslanderControllerMediator):void
		{
		}
		
		public function get target():IslanderControllerMediator
		{
			return null;
		}
		
		public function set target(value:IslanderControllerMediator):void
		{
		}
		
		public function makeDecision(ai:BaseCharaterControllerMediator):void
		{
		}
		
		public function makeTargetingDecision(ai:BaseCharaterControllerMediator):void
		{
		}
		
		public function makeArriveDecision(controller:BaseCharaterControllerMediator):void
		{
			controller.fsm.changeState(AIState.IDLE);
			TweenLite.to(controller.charater.view,1,{alpha:0,onComplete:recycle,onCompleteParams:[controller]});
		}
		
		private function recycle(controller:BaseCharaterControllerMediator):void{
			
			islanderPool.object = controller;
			Facade.getInstance(CoreConst.CORE).sendNotification(IslandersManagerMediator.LEAVE_ISLAND,controller);
		}
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			
		}
		
	}
}