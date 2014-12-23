package com.mylib.game.charater.logic.ai
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.logic.BaseCharaterControllerMediator;
	import com.mylib.game.charater.logic.IIslanderDecision;
	import com.mylib.game.charater.logic.IslanderControllerMediator;
	import com.studyMate.model.vo.SendCommandVO;
	
	import flash.geom.Vector3D;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class CharaterControlAI implements IIslanderDecision
	{
		protected var _target:IslanderControllerMediator;
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			
		}
		
		
		public function CharaterControlAI()
		{
			
			
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
		
		
		public function makeArriveDecision(ai:BaseCharaterControllerMediator):void
		{
			ai.reset();
			
			Facade.getInstance(CoreConst.CORE).sendNotification("AiArrived");	
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
			return _target;
		}

		public function set target(value:IslanderControllerMediator):void
		{
			_target = value;
		}
		
		
	}
}