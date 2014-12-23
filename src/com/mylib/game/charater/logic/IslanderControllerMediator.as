package com.mylib.game.charater.logic
{
	import com.greensock.TweenLite;
	
	import flash.errors.IllegalOperationError;
	
	import stateMachine.StateMachineEvent;
	
	public class IslanderControllerMediator extends AimControllerMediator implements IIslander
	{
		
		public function get type():uint
		{
			return IslanderType.HUMAN;
		}
		
		public function IslanderControllerMediator(mediatorName:String=null, viewComponent:Object=null,totalMass:Number=1)
		{
			super(mediatorName, viewComponent,totalMass);
		}
		
		override protected function initFSM():void
		{
			super.initFSM();
			
			_fsm.addState(AIState.REST,{enter:enterRest,from:[AIState.DECISION,AIState.IDLE]});
			_fsm.addState(AIState.SIT,{enter:enterSit,from:[AIState.DECISION]});
			_fsm.addState(AIState.RANDOM_GO,{enter:enterRandomGo,from:[AIState.DECISION]});
			_fsm.addState(AIState.TALK,{enter:enterTalk,from:[AIState.DECISION,AIState.TARGETING,AIState.IDLE,AIState.REST,AIState.SIT]});
			_fsm.addState(AIState.FIND_TALK_PARTNER,{enter:enterFindTalkPartner,from:[AIState.DECISION]});
			_fsm.initialState = AIState.IDLE;
		}
		
		
		protected function enterFindTalkPartner(event:StateMachineEvent):void{
			islanderDecision.makeFindTalkPartner(this);
		}
		
		protected function enterRandomGo(event:StateMachineEvent):void{
			islanderDecision.makeRandomGODecision(this);
		}
		
		protected function enterRest(event:StateMachineEvent):void{
			islanderDecision.makeRestDecision(this);
		}
		
		protected function enterTalk(event:StateMachineEvent):void{
			islanderDecision.makeTalkDecision(this);
		}
		
		protected function enterSit(event:StateMachineEvent):void{
			islanderDecision.makeSitDecision(this);
		}
		
		
		
		override public function set decision(_d:IDecision):void
		{
			if(_d&&!(_d is IIslanderDecision)){
				throw new IllegalOperationError("must be IslanderAI");
			}
			
			super.decision = _d;
		}
		
		public function get islanderDecision():IIslanderDecision{
			return decision as IIslanderDecision;
		}
		
		
		
		
	}
}