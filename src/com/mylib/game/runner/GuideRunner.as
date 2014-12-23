package com.mylib.game.runner
{
	import com.mylib.game.charater.logic.AIState;
	import com.mylib.game.model.IslanderPoolProxy;
	
	import stateMachine.StateMachine;
	import stateMachine.StateMachineEvent;

	public class GuideRunner extends PlayerRunner
	{
		public function GuideRunner(name:String)
		{
			super(name);
		}
		
		override protected function updateFrame():void
		{
			position += _velocity.x;
		}
		
		
		
		override protected function enterRun(event:StateMachineEvent):void
		{
			frameFun = runFun;
			charater.charater.actor.stop();
		}
		
		
	}
}