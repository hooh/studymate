package com.mylib.game.charater.logic.ai
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.logic.AIState;
	import com.mylib.game.charater.logic.BaseCharaterControllerMediator;
	import com.mylib.game.charater.logic.IIslander;
	import com.mylib.game.charater.logic.IIslanderDecision;
	import com.mylib.game.charater.logic.IslanderControllerMediator;
	import com.mylib.game.charater.logic.IslandersManagerMediator;
	
	import flash.geom.Vector3D;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class IslanderAI implements IIslanderDecision
	{
		protected var randomStates:Vector.<String>;
		protected var manager:IslandersManagerMediator;
		protected var _target:IslanderControllerMediator;
		
		public function IslanderAI()
		{
			manager = Facade.getInstance(CoreConst.CORE).retrieveMediator(IslandersManagerMediator.NAME) as IslandersManagerMediator;
			randomStates = Vector.<String>([
				AIState.SIT,
				AIState.REST,
				AIState.FIND_TALK_PARTNER,
				AIState.RANDOM_GO
			]);
			
		}
		
		public function makeFindTalkPartner(controller:IslanderControllerMediator):void
		{
			target = manager.findFreeIslander(controller);
			
			if(target){
				TweenLite.killTweensOf(target);
//				target.reset();
				target.fsm.changeState(AIState.TALK);
				controller.fsm.changeState(AIState.TARGETING);
				
				
				
			}else{
				controller.fsm.changeState(AIState.IDLE);
			}
		}
		
		
		public function makeDecision(ai:BaseCharaterControllerMediator):void
		{
			
			
//			trace(ai.getMediatorName(),"makeDecision");
			var randomIdx:int = Math.random()*randomStates.length;
			
			
			ai.fsm.changeState(randomStates[randomIdx]);
			
			
			
		}
		
		public function makeTargetingDecision(controller:BaseCharaterControllerMediator):void
		{
			
			if(manager.islanders.indexOf(target)<0){
				target = null;
				controller.fsm.changeState(AIState.IDLE);
				return;
			}
			
			if(isAwayTarget(controller)){
				controller.steering.seek(target.position);
			}else{
				Facade.getInstance(CoreConst.CORE).sendNotification(IslandersManagerMediator.DIALOG,controller);
			}
		}
		
		
		public function isAwayTarget(controller:BaseCharaterControllerMediator):Boolean{
			
			
			var distance:Number = Vector3D.distance(controller.position, target.position);
			
			if(distance>60){
				return true;
			}
			
			return false;
		}
		
		
		public function makeArriveDecision(ai:BaseCharaterControllerMediator):void
		{
			ai.reset();
		}
		
		public function makeRestDecision(controller:IslanderControllerMediator):void
		{
			
			controller.charater.idle();
			timeFly(controller);
			
		}
		
		public function makeRandomGODecision(controller:IslanderControllerMediator):void
		{
			
			controller.go(Math.random()*controller.charater.range.width+controller.charater.range.x,Math.random()*controller.charater.range.height+controller.charater.range.y);
			
		}
		
		
		public function makeSitDecision(controller:IslanderControllerMediator):void
		{
			timeFly(controller);
			controller.charater.action("sit",20,100,false);
		}
		
		public function makeTalkDecision(controller:IslanderControllerMediator):void
		{
			
				
		}
		
		private function timeFly(controller:IslanderControllerMediator):void{
			TweenLite.killTweensOf(controller);
			TweenLite.to(controller,Math.random()*3+2,{onComplete:controller.reset});
		}

		public function get target():IslanderControllerMediator
		{
			return _target;
		}

		public function set target(value:IslanderControllerMediator):void
		{
			_target = value;
		}
		
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			
		}
		
	}
}