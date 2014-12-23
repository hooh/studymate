package com.mylib.game.charater.logic
{
	import com.greensock.TweenLite;
	
	import flash.geom.Vector3D;
	
	import stateMachine.StateMachineEvent;

	public class AimControllerMediator extends BaseCharaterControllerMediator
	{
		protected var _thinkFun:Function;
		public function AimControllerMediator(mediatorName:String=null, viewComponent:Object=null, totalMass:Number=1)
		{
			super(mediatorName, viewComponent, totalMass);
		}
		
		override protected function initFSM():void
		{
			_fsm.addState(AIState.SEEKING,{enter:enterSeek,exit:removeThinkFun,from:["*"]});
			_fsm.addState(AIState.IDLE,{enter:enterIdle,from:["*"]});
			_fsm.addState(AIState.DECISION,{enter:enterDecision,exit:removeThinkFun,from:[AIState.IDLE,AIState.DECISION,null]});
			_fsm.addState(AIState.TARGETING,{enter:enterTargeting,exit:exitTargeting,from:["*"]});
		}
		
		protected function enterSeek(event:StateMachineEvent):void{
			var distance:Number = Vector3D.distance(position, destination);
			thinkFun = enterSeek;
			if(distance>5){
				charater.run();
				steering.seek(destination,0);
			}else{
				velocity.setTo(0,0,0);
				steering.reset();
				decision.makeArriveDecision(this);
			}
		}
		
		protected function enterIdle(event:StateMachineEvent):void{
			velocity.setTo(0,0,0);
			steering.reset();
			thinkFun = null;
			TweenLite.killTweensOf(this);
			if(charater){
				charater.idle();
			}
		}
		
		protected function enterDecision(event:StateMachineEvent):void{
			decision.makeDecision(this);
		}
		
		protected function enterTargeting(event:StateMachineEvent):void{
			
			decision.makeTargetingDecision(this);
			
			if(fsm.state==AIState.TARGETING){
				charater.run();
				thinkFun = enterTargeting;
			}
			
		}
		
		
		
		protected function exitTargeting(event:StateMachineEvent):void{
			velocity.setTo(0,0,0);
			steering.reset();
			removeThinkFun(event);
			charater.idle();
		}
		
		protected function removeThinkFun(event:StateMachineEvent):void{
			thinkFun = null;
		}
		
		override public function think():void
		{
			if(_fsm.state==AIState.IDLE){
				_fsm.changeState(AIState.DECISION);
			}else if(_fsm.state==AIState.DECISION){
				thinkFun = enterDecision;
			}
			
			if(thinkFun!=null){
				thinkFun(null);
			}
		}
		
		override public function resetState():void
		{
			fsm.changeState(AIState.IDLE);
		}
		
		public function get thinkFun():Function
		{
			return _thinkFun;
		}
		
		
		public function set thinkFun(value:Function):void
		{
			_thinkFun = value;
		}
		
		override public function go(_x:int,_y:int):void{
			
			destination.setTo(_x,_y,0);
			if(fsm.state!=AIState.SEEKING){
				velocity.setTo(0,0,0);
				steering.reset();
				TweenLite.killTweensOf(this);
				if(charater){
					charater.idle();
					
				}
				
				
				fsm.changeState(AIState.SEEKING);
			}
		}
		
	}
}