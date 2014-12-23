package com.mylib.game.charater.logic.ai
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.logic.AIState;
	import com.mylib.game.charater.logic.BaseCharaterControllerMediator;
	import com.mylib.game.charater.logic.IIslanderDecision;
	import com.mylib.game.charater.logic.IslanderControllerMediator;
	import com.mylib.game.controller.MutiCharaterControllerMediator;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class MutiOLExitAI implements IIslanderDecision
	{
		private var id:String;
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			
		}
		
		
		public function MutiOLExitAI(id:String)
		{
			this.id = id;
		}
		
		public function makeFindTalkPartner(controller:IslanderControllerMediator):void
		{
			
		}
		public function makeDecision(ai:BaseCharaterControllerMediator):void
		{
			
		}
		
		public function makeTargetingDecision(controller:BaseCharaterControllerMediator):void
		{
			
		}
		
		
		public function makeRestDecision(controller:IslanderControllerMediator):void
		{
			
		}
		
		public function makeRandomGODecision(controller:IslanderControllerMediator):void
		{
			
		}
		
		
		public function makeSitDecision(controller:IslanderControllerMediator):void
		{
			
		}
		
		public function makeTalkDecision(controller:IslanderControllerMediator):void
		{
			
				
		}
		public function get target():IslanderControllerMediator
		{
			return null;
		}

		public function set target(value:IslanderControllerMediator):void
		{
		}
		
		
		
		public function makeArriveDecision(controller:BaseCharaterControllerMediator):void
		{
			controller.fsm.changeState(AIState.IDLE);
			TweenLite.to(controller.charater.view,1,{alpha:0,onComplete:recycle,onCompleteParams:[id]});
		}
		private function recycle(id:String):void{
			/*if(Facade.getInstance(CoreConst.CORE).hasMediator(MutiOnlineControllerMediator.NAME))
				(Facade.getInstance(CoreConst.CORE).retrieveMediator(MutiOnlineControllerMediator.NAME) 
					as MutiOnlineControllerMediator).recyle(id);*/
			if(Facade.getInstance(CoreConst.CORE).hasMediator(MutiCharaterControllerMediator.NAME))
				(Facade.getInstance(CoreConst.CORE).retrieveMediator(MutiCharaterControllerMediator.NAME) 
					as MutiCharaterControllerMediator).recyle(id);
		}
		
	}
}