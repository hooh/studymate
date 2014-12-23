package com.mylib.game.charater.logic
{
	import com.greensock.TweenLite;
	import com.mylib.game.charater.ICharater;
	import com.mylib.game.charater.IFighter;
	
	import flash.errors.IllegalOperationError;
	import flash.geom.Vector3D;
	
	import stateMachine.StateMachineEvent;
	

	public class FighterControllerMediator extends BaseCharaterControllerMediator
	{
		protected var _target:FighterControllerMediator;
		
		protected var _group:uint;
		
		
		protected var _fightDistance:int;
		
		protected var _thinkFun:Function;
		
		
		public function FighterControllerMediator(mediatorName:String=null, viewComponent:Object=null,totalMass:Number=1,__group:uint=0)
		{
			super(mediatorName, viewComponent,totalMass);
			
			group = __group;
			
			
		}
		
		
		override protected function initFSM():void{
			_fsm.addState(AIState.SEEKING,{enter:enterSeek,exit:removeThinkFun,from:[AIState.ESCAPE,AIState.FIGHTING,AIState.SEEKING,AIState.IDLE,AIState.TARGETING,AIState.DECISION]});
			_fsm.addState(AIState.FIGHTING,{enter:enterFighting,exit:exitFighting,from:[AIState.TARGETING,AIState.DECISION]});
			_fsm.addState(AIState.IDLE,{enter:enterIdle,from:["*"]});
			_fsm.addState(AIState.DECISION,{enter:enterDecision,exit:removeThinkFun,from:[AIState.IDLE,AIState.DECISION,null]});
			_fsm.addState(AIState.TARGETING,{enter:enterTargeting,exit:removeThinkFun,from:[AIState.FIGHTING,AIState.TARGETING,AIState.DECISION]});
			_fsm.addState(AIState.FREEZE,{enter:enterFreeze,from:["*"]});
			_fsm.addState(AIState.DEAD,{enter:enterDead,from:["*"]});
			_fsm.addState(AIState.HIT,{enter:enterHit,from:["*"]});
			_fsm.addState(AIState.ESCAPE,{enter:enterEscape,exit:removeThinkFun,from:["*"]});
//			_fsm.initialState = AIState.DECISION;
		}
		
		
		protected function exitFighting(event:StateMachineEvent):void{
			TweenLite.killTweensOf(this);
			removeThinkFun(null);
		}
		
		protected function enterEscape(event:StateMachineEvent):void{
			target = null;
			thinkFun = enterEscape;
			TweenLite.killTweensOf(this);
			charater.run();
			fightDecision.makeEscapeDecision(this);
		}
		
		
		override public function set charater(_c:ICharater):void{
			
			if(_c is IFighter || !_c){
				setViewComponent(_c);
			}else{
				throw new IllegalOperationError("the charater must be fighter");
			}
			
		}
		
		public function get fighter():IFighter{
			return getViewComponent() as IFighter;
		}
		
		public function set target(_t:FighterControllerMediator):void{
			_target = _t;
			
		}
		
		public function get target():FighterControllerMediator{
			return _target;
		}
		
		
		
		override public function go(_x:int,_y:int):void{
			
			if(!alive){
				return;
			}
			destination.setTo(_x,_y,0);
			if(fsm.state!=AIState.SEEKING){
				target = null;
				velocity.setTo(0,0,0);
				steering.reset();
				TweenLite.killTweensOf(this);
				charater.idle();
				
				
				fsm.changeState(AIState.SEEKING);
			}
		}
		
		
		
		override public function think() :void {
			
			
			if(_fsm.state==AIState.IDLE){
				_fsm.changeState(AIState.DECISION);
			}else if(_fsm.state==AIState.DECISION){
				thinkFun = enterDecision;
			}
			
			if(thinkFun!=null){
				thinkFun(null);
			}
			
			
		}
		
		override public function reset() :void {
			target = null;
			resetState();
		}
		
		
		public function get group():uint
		{
			return _group;
		}
		
		public function set group(_uint:uint):void
		{
			_group = _uint;
		}
		
		public function get alive():Boolean
		{
			return fsm.state!=AIState.DEAD?true:false;
		}
		
		
		protected function removeThinkFun(event:StateMachineEvent):void{
			thinkFun = null;
		}
		
		protected function enterHit(event:StateMachineEvent):void{
			
		}
		
		public function get thinkFun():Function
		{
			return _thinkFun;
		}
		
		public function set thinkFun(value:Function):void
		{
			_thinkFun = value;
		}
		
		
		protected function enterFreeze(event:StateMachineEvent):void{
			velocity.setTo(0,0,0);
			target = null;
			steering.reset();
		}
		
		protected function enterDead(event:StateMachineEvent):void{
			TweenLite.killTweensOf(this);
			velocity.setTo(0,0,0);
			target = null;
			steering.reset();
			fighter.die();
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
		
		
		protected function enterIdle(event:StateMachineEvent):void{
			
			velocity.setTo(0,0,0);
			steering.reset();
			thinkFun = null;
			TweenLite.killTweensOf(this);
			charater.idle();
		}
		
		protected function enterFighting(event:StateMachineEvent):void{
			velocity.setTo(0,0,0);
			steering.reset();
			fightDecision.makeFightDecision(this);
//			thinkFun = detectFighting;
			
		}
		
		protected function detectFighting(nullParamter:*=null):void{
			
			
			
			
			
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
				if(decision)
					decision.makeArriveDecision(this);
			}
		}
		
		public function get isAwayTarget():Boolean{
			
			if(!target||!target.alive){
				return true;
			}
			
			var distance:Number = Vector3D.distance(position, target.position);
			
			if(distance>_fightDistance){
				return true;
			}
			
			return false;
		}
		
		public function get canTouchTarget():Boolean{
			
			if(!target||!target.alive){
				return false;
			}
			
			var distance:Number = Vector3D.distance(position, target.position);
			
			if(distance>fighter.attackRange){
				return false;
			}
			
			return true;
		}
		
		
		override public function resetState():void{
			_fsm.changeState(AIState.IDLE);
		}
		

		public function get fightDistance():int
		{
			return _fightDistance;
		}
		
		public function set fightDistance(_int:int):void
		{
			_fightDistance = _int;
		}
		
		
		
		override public function set decision(_d:IDecision):void
		{
			if(_d&&!(_d is IFightDecision)){
				throw new IllegalOperationError("the decision must be IFightDecision");
			}
			
			
			super.decision = _d;
		}
		
		public function get fightDecision():IFightDecision{
			return _decision as IFightDecision;
		}
		
		
	}
}