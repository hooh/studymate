package com.mylib.game.charater.logic.ai
{
	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.TalkingProxy;
	import com.mylib.game.charater.logic.AIState;
	import com.mylib.game.charater.logic.BaseCharaterControllerMediator;
	import com.mylib.game.charater.logic.IIslanderDecision;
	import com.mylib.game.charater.logic.IslanderControllerMediator;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class SantaAI implements IIslanderDecision
	{
		private var dialogs:Vector.<String>;
		private var idx:int;
		
		public function SantaAI()
		{
			dialogs = Vector.<String>([
				"Oh, jingle bells, jingle bells",
				"Jingle all the way",
				"Oh, what fun it is to ride",
				"In a one horse open sleigh",
				"Jingle bells, jingle bells",
				"Jingle all the way",
				"Oh, what fun it is to ride",
				"In a one horse open sleigh",
				"A day or two ago",
				"I thought I'd take a ride",
				"And soon Miss Fanny Bright",
				"Was seated by my side",
				"The horse was lean and lank",
				"Misfortune seemed his lot",
				"We got into a drifted bank",
				"And then we got upsot",
				"Oh, jingle bells, jingle bells",
				"Jingle all the way",
				"Oh, what fun it is to ride",
				"In a one horse open sleigh",
				"Jingle bells, jingle bells",
				"Jingle all the way",
				"Oh, what fun it is to ride",
				"In a one horse open sleigh yeah",
				"Jingle bells, jingle bells",
				"Jingle all the way",
				"Oh, what fun it is to ride",
				"In a one horse open sleigh",
				"Jingle bells, jingle bells",
				"Jingle all the way",
				"Oh, what fun it is to ride",
				"In a one horse open sleigh "
			]);
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
			var talkProxy:TalkingProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(TalkingProxy.NAME) as TalkingProxy;
			var str:String = dialogs[idx];
			talkProxy.playerSay(controller.charater,str);
			controller.go(Math.random()*controller.charater.range.width+controller.charater.range.x,Math.random()*controller.charater.range.height+controller.charater.range.y);
			idx++;
			if(idx>dialogs.length-1){
				idx = 0;
			}
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
			ai.fsm.changeState(AIState.RANDOM_GO);
		}
		
		public function makeTargetingDecision(ai:BaseCharaterControllerMediator):void
		{
		}
		
		public function makeArriveDecision(ai:BaseCharaterControllerMediator):void
		{
			ai.fsm.changeState(AIState.IDLE);
		}
		
		public function dispose():void
		{
		}
	}
}