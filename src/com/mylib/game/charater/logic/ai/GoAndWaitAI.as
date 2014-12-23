package com.mylib.game.charater.logic.ai
{
	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.logic.BaseCharaterControllerMediator;
	import com.mylib.game.charater.logic.FighterControllerMediator;
	import com.mylib.game.charater.logic.IFightDecision;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class GoAndWaitAI implements IFightDecision
	{
		public var dir:int;
		
		public function GoAndWaitAI(dir:int)
		{
			this.dir = dir;
		}
		
		public function makeEscapeDecision(ai:FighterControllerMediator):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function makeFightDecision(ai:FighterControllerMediator):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function makeDecision(ai:BaseCharaterControllerMediator):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function makeTargetingDecision(ai:BaseCharaterControllerMediator):void
		{
			// TODO Auto Generated method stub
			
		}
		
		
		public function makeHurtDecision(attacker:FighterControllerMediator, me:FighterControllerMediator):void
		{
			// TODO Auto Generated method stub
			
		}
		
		
		
		public function makeArriveDecision(ai:BaseCharaterControllerMediator):void
		{
			ai.charater.dirX = dir;
			ai.reset();
			
			Facade.getInstance(CoreConst.CORE).sendNotification(AIConst.AI_ARRIVED,ai);
			
		}
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			
		}
		
	}
}