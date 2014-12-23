package com.mylib.game.charater.logic
{
	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.IHuman;
	import com.mylib.game.charater.TalkPair;
	import com.mylib.game.charater.logic.ai.IslanderAI;
	import com.mylib.game.charater.logic.vo.JoinIslandVO;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import org.as3commons.logging.api.getLogger;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class IslandersManagerMediator extends Mediator
	{
		public static const NAME:String = "IslandersManager";
		
		public var islanders:Vector.<IIslander>;
		
		public static const JOIN_ISLAND:String = NAME+"jointIsland";
		public static const LEAVE_ISLAND:String = NAME + "leaveIsland";
		public static const DIALOG:String = NAME + "dialog";
		
		private var pairMap:Dictionary;
		private var homeMap:Dictionary;
		
		protected var talkingNum:int;
		
		public function IslandersManagerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			
			islanders = new Vector.<IIslander>;
			pairMap = new Dictionary(true);
			homeMap = new Dictionary(true);
			talkingNum = 0;
			
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case JOIN_ISLAND:
				{
					islanders.push((notification.getBody() as JoinIslandVO).islander);
					homeMap[(notification.getBody() as JoinIslandVO).islander] = (notification.getBody() as JoinIslandVO).home;
					
					break;
				}
				case DIALOG:{
					
					var islander:IslanderControllerMediator = notification.getBody() as IslanderControllerMediator;
					if(!canTalk()){
						freeIslander(islander);
						return;
					}
					
					
					islander.fsm.changeState(AIState.TALK);
					islander.islanderDecision.target.fsm.changeState(AIState.TALK);
					
					
					var talkPair:TalkPair = new TalkPair("HuaKanT");
					talkPair.player1 = islander.charater as IHuman;
					talkPair.player2 = islander.islanderDecision.target.charater as IHuman;
					pairMap[talkPair] = islander;
					var talkProxy:HumanTalkShowProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(HumanTalkShowProxy.NPC) as HumanTalkShowProxy;
					talkPair.dialogue = talkProxy.findTopic();
					
					if(islander.position.x<islander.islanderDecision.target.position.x){
						talkPair.player1.dirX = 1;
						talkPair.player2.dirX = -1;
						islander.position.x = islander.islanderDecision.target.position.x-60;
					}else{
						talkPair.player1.dirX = -1;
						talkPair.player2.dirX = 1;
						islander.position.x = islander.islanderDecision.target.position.x+60;
					}
					
					
					(facade.retrieveProxy(HumanTalkShowProxy.NPC) as HumanTalkShowProxy).processDialogue(talkPair);
					talkPair.addEventListener(TalkPair.END_DIALOGUE_EVENT,endDialog);
					talkingNum++;
					
					break;
				}
				case LEAVE_ISLAND:{
					var ide:int = islanders.indexOf(notification.getBody() as IslanderControllerMediator);
					if(ide>=0){
//						getLogger(IslanderControllerMediator).debug(islanders[ide].getMediatorName()+" LEAVE_ISLAND");
						delete homeMap[notification.getBody()];
						islanders.splice(ide,1);
					}
					
					break;
				}
				default:
				{
					break;
				}
			}
		}
		
		protected function endDialog(event:Event):void
		{
			var pair:TalkPair = event.target as TalkPair;
			pair.removeEventListener(TalkPair.END_DIALOGUE_EVENT,endDialog);
			var islander:IslanderControllerMediator = pairMap[pair];
			if(islander){
				talkingNum--;
				delete pairMap[pair];
				
				freeIslander(islander);
				if(islander.islanderDecision.target)
				freeIslander(islander.islanderDecision.target);
			}
		}
		
		private function freeIslander(islander:IslanderControllerMediator):void{
			islander.fsm.changeState(AIState.IDLE);
			islander.islanderDecision.target.fsm.changeState(AIState.IDLE);
			islander.islanderDecision.target = null;
		}
		
		override public function listNotificationInterests():Array
		{
			return [JOIN_ISLAND,DIALOG,LEAVE_ISLAND];
		}
		
		public function findFreeIslander(me:IIslander):IslanderControllerMediator{
			randomSortItems();
			for (var i:int = 0; i < islanders.length; i++) 
			{
				if(me!=islanders[i]&&islanders[i].type==IslanderType.HUMAN&&isFreeIslander(islanders[i])&&(islanders[i] as IslanderControllerMediator).decision is IslanderAI){
					return islanders[i] as IslanderControllerMediator;
				}
			}
			
			return null;
		}
		
		protected function randomSortItems():void{
			var r:int;
			var len:int= islanders.length;
			var t:IIslander;
			for (var i:int = 0; i < len; ++i) 
			{
				r = int(Math.random() * len);
				t = islanders[r];
				islanders[r] = islanders[i];
				islanders[i] = t;
			}
		}
		
		
		public function getIslanderHome(islander:IslanderControllerMediator):Point{
			return homeMap[islander];
		}
		
		
		public function isFreeIslander(controller:IIslander):Boolean{
			
			if(controller.fsm.state==AIState.IDLE||
				controller.fsm.state==AIState.REST||
				controller.fsm.state==AIState.SIT){
				return true;
			}else{
				return false;
			}
			
		}
		
		public function canTalk():Boolean{
			if(talkingNum>1){
				return false;
			}
			return true;
		}
		
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
			
			
			
			islanders.length = 0;
			
			
		}
		
	}
}