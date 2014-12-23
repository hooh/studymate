package com.mylib.game.charater.logic
{
	import flash.errors.IllegalOperationError;
	
	import stateMachine.StateMachineEvent;

	public class PetDogControllerMediator extends AimControllerMediator implements IIslander
	{
		public function PetDogControllerMediator(mediatorName:String=null, viewComponent:Object=null, totalMass:Number=1)
		{
			super(mediatorName, viewComponent, totalMass);
		}
		
		override protected function initFSM():void
		{
			super.initFSM();
			
			_fsm.addState(AIState.REST,{enter:enterRest,from:[AIState.DECISION,AIState.IDLE]});
			_fsm.addState(AIState.RANDOM_GO,{enter:enterRandomGo,from:[AIState.DECISION]});
			
		}
		
		
		protected function enterRest(event:StateMachineEvent):void{
			petDogDecision.makeRestDecision(this);
		}
		
		protected function enterRandomGo(event:StateMachineEvent):void{
			petDogDecision.makeRandomGODecision(this);
		}
		
		override public function set decision(_d:IDecision):void
		{
			if(_d&&!(_d is IPetDogDecision)){
				throw new IllegalOperationError("must be IpetDogDecision");
				return;
			}
			
			
			super.decision = _d;
		}
		
		public function get petDogDecision():IPetDogDecision{
			return decision as IPetDogDecision;
		}
		
		public function get type():uint
		{
			return IslanderType.PET;
		}
	}
}