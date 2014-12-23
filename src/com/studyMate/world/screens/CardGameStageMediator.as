package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.card.CValue;
	import com.mylib.game.card.CardDisplay;
	import com.mylib.game.card.CardGameState;
	import com.mylib.game.card.CardGroup;
	import com.mylib.game.card.CardPlayerDisplay;
	import com.mylib.game.card.GameCharaterData;
	import com.mylib.game.card.HeroAttribute;
	import com.mylib.game.card.PlayerInTurnDisplay;
	import com.mylib.game.charater.logic.FighterControllerMediator;
	import com.mylib.game.charater.logic.ai.AIConst;
	import com.mylib.game.charater.logic.ai.GoAndWaitAI;
	import com.mylib.game.charater.logic.ai.RandomFightAI;
	import com.mylib.game.controller.CardFightHelperMediator;
	import com.mylib.game.controller.vo.CardFightAnimationVO;
	import com.mylib.game.model.FightCharaterPoolProxy;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.model.vo.NPCRawDataVO;
	
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import feathers.controls.Button;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import stateMachine.StateMachine;
	import stateMachine.StateMachineEvent;

	public class CardGameStageMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "CardGameMediator";
		private var player1:PlayerInTurnDisplay;
		private var player2:PlayerInTurnDisplay;
		private var state:StateMachine;
		private var ruleMap:Dictionary;
//		private var checkBtn:Button;
//		private var rollBtn:Button;
		
		
		private var pool:FightCharaterPoolProxy;
		private var winSide:uint;
		private var lastWinSide:uint;
		public static const SIDE1:uint = 1;
		public static const SIDE2:uint = 2;
		
		public var group1:CardGroup;
		public var group2:CardGroup;
		
		private var addBtn:Button;
		
		private var readyCount:int;
		private var winCount:int;
		private var sideCount:int;
		
		
		private var playersInTurn:Vector.<PlayerInTurnDisplay>;
		
		private var roundEnd:Boolean;
		
		private var column:Array;
		private var charaterHolder:Sprite;
		
		private var fightHelper:CardFightHelperMediator;
		
		public var range:Rectangle;
		
		public function CardGameStageMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			column = [1,2,3,4,5,6,7,8];
		}
		
		override public function onRegister():void
		{
			if(!facade.hasProxy(ModuleConst.FIGHT_CHARATER_POOL)){
				pool = new FightCharaterPoolProxy(true);
				facade.registerProxy(pool);
				pool.init();
			}else{
				pool = facade.retrieveProxy(ModuleConst.FIGHT_CHARATER_POOL) as FightCharaterPoolProxy;
			}
			
			
			
			
			
			fightHelper = new CardFightHelperMediator(NAME+"helper");
			facade.registerMediator(fightHelper);
			
			range = new Rectangle(0,0,WorldConst.stageWidth,200);
			
			winSide = 0;
			lastWinSide = 0;
			player1 = new PlayerInTurnDisplay(null,1);
			player2 = new PlayerInTurnDisplay(null,-1);
			player1.x = 100;
			player2.x = 700;
			
			playersInTurn = Vector.<PlayerInTurnDisplay>([player1,player2]);
			
			
			group1 = new CardGroup;
			group2 = new CardGroup;
			
			group1.hp = group2.hp = 0;
			
			group1.range = new Rectangle(0,0,500,200);
			group2.range = new Rectangle(0,0,700,200);
			group1.dirX = -1;
			group2.dirX = 1;
			
			group1.groupData = new Vector.<GameCharaterData>;
			group2.groupData = new Vector.<GameCharaterData>;
			
			
			
			group1.displays = new Vector.<CardPlayerDisplay>;
			
			group2.displays = new Vector.<CardPlayerDisplay>;
			
			
			
			view.addChild(player1);
			view.addChild(player2);
			
			charaterHolder = new Sprite;
			view.addChild(charaterHolder);
			
			state = new StateMachine();
			state.addState(CardGameState.PLAYER_TURN,{enter:enterPlayerTurn,from:[CardGameState.CHECK,CardGameState.NEXT_TURN,CardGameState.START,CardGameState.WAIT]});
			state.addState(CardGameState.CHECK,{enter:enterCheck,exit:exitCheck,from:[CardGameState.ROLL]});
			state.addState(CardGameState.START,{enter:enterStart,from:["*"]});
			state.addState(CardGameState.END,{enter:enterEnd,from:[CardGameState.JUDGE]});
			state.addState(CardGameState.ROLL,{enter:enterRoll,exit:exitRoll,from:[CardGameState.PLAYER_TURN,CardGameState.NEXT_TURN]});
			state.addState(CardGameState.NEXT_TURN,{enter:enterNextTurn,from:[CardGameState.JUDGE]});
			state.addState(CardGameState.JUDGE,{enter:enterJudge,from:[CardGameState.CHECK]});
			state.addState(CardGameState.WAIT,{from:["*"]});
			
			ruleMap = new Dictionary();
			ruleMap[HeroAttribute.EARTH] = [HeroAttribute.WATER,HeroAttribute.GOLD];
			ruleMap[HeroAttribute.WATER] = [HeroAttribute.FIRE,HeroAttribute.WOOD];
			ruleMap[HeroAttribute.WOOD] = [HeroAttribute.EARTH,HeroAttribute.FIRE];
			ruleMap[HeroAttribute.FIRE] = [HeroAttribute.GOLD,HeroAttribute.EARTH];
			ruleMap[HeroAttribute.GOLD] = [HeroAttribute.WOOD,HeroAttribute.WATER];
			
			state.initialState = CardGameState.WAIT;
			
			runEnterFrames = true;
		}
		
		override public function advanceTime(time:Number):void
		{
			// TODO Auto Generated method stub
			super.advanceTime(time);
			sendNotification(WorldConst.SORT_CONTAINER,charaterHolder);
		}
		
		
		
		
		public function startGame():void{
			state.changeState(CardGameState.START);
		}
		
		public function reset():void{
			
			group1.displays.forEach(disposeCardPlayerDisplayItem);
			group2.displays.forEach(disposeCardPlayerDisplayItem);
			winSide = 0;
			readyCount = 0;
			sideCount = 0;
			group1.reset();
			group2.reset();
			
			fightHelper.reset();
			TweenLite.killTweensOf(state.changeState);
		}
		
		
		
		private function rollHandle(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.target as DisplayObject,TouchPhase.ENDED);
			if(touch){
				var i:int;
				player1.roller.roll();
				player2.roller.roll();
				
				state.changeState(CardGameState.CHECK);
			}
		}
		
		private function enterRoll(event:StateMachineEvent):void{
			
			var attGroup:CardGroup = playersInTurn[sideCount%playersInTurn.length].data;
			var deffGroup:CardGroup = playersInTurn[(sideCount+1)%playersInTurn.length].data;
			
			playersInTurn[sideCount%playersInTurn.length].roller.roll();
			TweenLite.delayedCall(3.5,state.changeState,[CardGameState.CHECK]);
			
		}
		
		private function exitRoll(event:StateMachineEvent):void{
			
//			rollBtn.isEnabled = false;
			
		}
		
		private function exitCheck(event:StateMachineEvent):void{
			
//			checkBtn.isEnabled = false;
			
			
			
		}
		
		private function enterNextTurn(event:StateMachineEvent):void{
			
//			player1.unHoldCard(player1.catchingCard);
//			player2.unHoldCard(player2.catchingCard);
			
//			drawCard(player1);
//			drawCard(player2);
			
			if(roundEnd){
				state.changeState(CardGameState.PLAYER_TURN);
			}else{
				sideCount++;
				state.changeState(CardGameState.ROLL);
			}
			
		}
		
		private function enterEnd(event:StateMachineEvent):void{
			state.changeState(CardGameState.WAIT);
		}
		
		
		protected function enterJudge(event:StateMachineEvent):void{
			
			if(group1.hp<=0||group2.hp<=0){
				state.changeState(CardGameState.END);
			}else{
				TweenLite.delayedCall(3,state.changeState,[CardGameState.NEXT_TURN]);
			}
		}
		
		
		
		
		protected function groupAttack(attackGroup:CardGroup,defGroup:CardGroup,remainHp:int):void{
			var idx1:int=attackGroup.idx%attackGroup.groupData.length;
			var idx2:int=defGroup.idx%defGroup.groupData.length;
			attackGroup.idx = idx1;
			defGroup.idx = idx2;
			
			var item1:CardPlayerDisplay = attackGroup.displays[idx1];
			var item2:CardPlayerDisplay = defGroup.displays[idx2];
			item2.refresh();
//			item1.islander.charater.action("fight",8,item1.islander.fighter.attackRate*24,false);
//			TweenLite.to(item1,item1.islander.fighter.attackRate*24/60,{onComplete:attackComplete,onCompleteParams:[item1]});
//			item2.islander.charater.action("hit",8,30,true);
//			TweenLite.to(item2,0.5,{onComplete:attackComplete,onCompleteParams:[item2]});
			if(remainHp<=0){
				TweenLite.killTweensOf(item2);
				item2.islander.charater.action("die",8,30,false);
				TweenLite.delayedCall(3,item2.dispose);
				defGroup.displays.splice(idx2,1);
				defGroup.groupData.splice(idx2,1);
				roundEnd = true;
				
			}else{
				
				defGroup.idx=idx2;
//				defGroup.idx++;
				roundEnd = false;
			}
		}
		
		
		protected function attackComplete(item:CardPlayerDisplay):void{
			TweenLite.killTweensOf(item);
			item.islander.fighter.idle();
		}
		
		
		protected function setPlayerHp(player):void{
			
		}
		
		protected function enterStart(event:StateMachineEvent):void{
//			genPlayerCard();
			
			if(!group1.groupData.length||!group2.groupData.length){
				state.changeState(CardGameState.WAIT);
				return;
			}
			
			state.changeState(CardGameState.PLAYER_TURN);
		}
		
		
		
		protected function randomSortItems(cards:Vector.<CardDisplay>):void{
			var r:int;
			var len:int= cards.length;
			var t:*;
			for (var i:int = 0; i < len; ++i) 
			{
				r = int(Math.random() * len);
				t = cards[r];
				cards[r] = cards[i];
				cards[i] = t;
			}
		}
		
		
		
		
		protected function enterCheck(event:StateMachineEvent):void{
			
			var attacker:PlayerInTurnDisplay = playersInTurn[sideCount%playersInTurn.length];
			var defender:PlayerInTurnDisplay = playersInTurn[(sideCount+1)%playersInTurn.length];
			var attackValues:Vector.<CValue> = attacker.roller.getResult();
			
			var hurt:int = calculateHurt(attackValues,defender.data.values);
			
			defender.hp-=hurt;
//			groupAttack(getPlayerGroup(attacker.data.data),getPlayerGroup(defender.data.data),defender.hp);
			
			state.changeState(CardGameState.JUDGE);
		}
		
		private function getPlayerGroup(player:GameCharaterData):CardGroup{
			
			if(group1.groupData.indexOf(player)>=0){
				return group1;
			}else{
				return group2;
			}
			
			
		}
		
		
		
		private function calculateHurt(attackCards:Vector.<CValue>,defenderCards:Vector.<CValue>):int{
			
			var dtype:uint;
			var dvalue:int;
			var hurt:Number = 0;
			for (var i:int = 0; i < attackCards.length; i++) 
			{
				dtype = getRestrictionType(attackCards[i].type);
				
				dvalue = getTypeValue(defenderCards,dtype);
				
				hurt+=(1/(1+0.06*dvalue))*attackCards[i].value;
				
			}
			
			return hurt;
		}
		
		private function getTypeValue(cards:Vector.<CValue>,type:uint):int{
			
			for (var i:int = 0; i < cards.length; i++) 
			{
				if(cards[i].type==type){
					return cards[i].value
				}
			}
			
			return 0;
			
		}
		
		private function getRestrictionType(type:int):uint{
			var result:int;
			for (var i:* in ruleMap) 
			{
				
				if(ruleMap[i][0]==type){
					result = i;
					break;
				}
			}
			
			return result;
			
			
		}
		
		
		
		protected function checkResult(card1:CValue,card2:CValue,addValue1:int,addValue2:int):int{
			
			var v1:int;
			var v2:int;
			var card1Value:int = card1.value+addValue1;
			var card2Value:int = card2.value+addValue2;
			
			if(card1Value<0){
				card1Value=0;
			}
			
			if(card2Value<0){
				card2Value=0;
			}
			
			//1克2
			if(ruleMap[card1.type][0]==card2.type){
				v1 =card1Value*2;
				v2 = card2Value;
			}else if(ruleMap[card2.type][0]==card1.type){
				v1 = card1Value;
				v2 = card2Value*2;
			}else if(ruleMap[card1.type][1]==card2.type){
				v1 = card1Value;
				v2 = card2Value*2;
			}else if(ruleMap[card2.type][1]==card1.type){
				v1 = card1Value*2;
				v2 = card2Value;
			}else if(card2.type==card1.type){
				v1 = card1Value;
				v2 = card2Value;
			}
			
			return v1 - v2;
			
			
			
		}
		
		
		protected function enterPlayerTurn(event:StateMachineEvent):void{
			player1.data = group1;
			player2.data = group2;
			player1.addValue = 0;
			player2.addValue = 0;
			
			
			group1.refreshValue();
			group2.refreshValue();
			
			player1.refresh();
			player2.refresh();
			
			sideCount = 0;
			roundEnd = false;
			
			state.changeState(CardGameState.ROLL);
			
			
		}
		
		
		protected function sortGroupDisplay(group:CardGroup):void{
			
			var item:CardPlayerDisplay;
			var idx:int;
			
			var record:Array = [0,0,0,0,0,0];
			
			for (var i:int = 0; i < group.displays.length; i++) 
			{
				idx = (group.idx+i)%group.displays.length;
				item = group.displays[idx] as CardPlayerDisplay;
				item.refresh();
				var xx:int; 
				var oy:int;
				
				var ci:int=0;
				for (var j:int = 0; j < record.length; j++) 
				{
					if(record[j]<column[j]){
						ci = j;
						oy = -record[j]*30+group.range.height+group.range.y;
						record[j]++;
						break;
					}
				}
				
				
				xx = group.dirX*ci*60+group.range.width;
				
				item.islander.go(xx,oy);
			}
			
			
			
			
		}
		
		private function disposeCardPlayerDisplayItem(item:CardPlayerDisplay, index:int, array:Vector.<CardPlayerDisplay>):void {
			item.dispose();
			TweenLite.killTweensOf(item);
			TweenLite.killTweensOf(item.islander);
		}
		
		
		public function setGroupData(group:CardGroup,_g:Vector.<GameCharaterData>,dir:int):void{
			group.groupData.length = 0;
			group.idx = 0;
			group.hp = 0;
			group.displays.forEach(disposeCardPlayerDisplayItem);
			group.displays.length = 0;
			
			
			for (var i:int = 0; i < _g.length; i++) 
			{
				addGroupMember(group,_g[i],dir);
			}
			
		}
		
		
		private function genPlayerCard():void{
			group1.groupData.length = 0;
			group1.idx = 0;
			
			group1.displays.forEach(disposeCardPlayerDisplayItem);
			group2.displays.forEach(disposeCardPlayerDisplayItem);
			group1.displays.length = 0;
			group2.displays.length = 0;
			
			var cp:GameCharaterData;
			var cardPlayerDisay:CardPlayerDisplay;
			for (var i:int = 0; i < 3; i++) 
			{
				cp = new GameCharaterData();
				cp.values = Vector.<CValue>([
					new CValue(HeroAttribute.GOLD,Math.random()*0),
					new CValue(HeroAttribute.WOOD,Math.random()*0),
					new CValue(HeroAttribute.WATER,Math.random()*0),
					new CValue(HeroAttribute.FIRE,Math.random()*0),
					new CValue(HeroAttribute.EARTH,Math.random()*0)
				]);
				
				addGroupMember(group1,cp,1);
			}
			
			
			group2.groupData.length = 0;
			group2.idx = 0;
			
			for (i = 0; i < 3; i++) 
			{
				cp = new GameCharaterData();
				cp.values = Vector.<CValue>([
					new CValue(HeroAttribute.GOLD,Math.random()*11),
					new CValue(HeroAttribute.WOOD,Math.random()*11),
					new CValue(HeroAttribute.WATER,Math.random()*11),
					new CValue(HeroAttribute.FIRE,Math.random()*11),
					new CValue(HeroAttribute.EARTH,Math.random()*11)
				]);
				addGroupMember(group2,cp,-1);
			}
			
		}
		
		public function addLeftGroup(cardPlayer:GameCharaterData):void{
			addGroupMember(group1,cardPlayer,1);
//			sortGroupDisplay(group1);
		}
		
		public function addRightGroup(cardPlayer:GameCharaterData):void{
			addGroupMember(group2,cardPlayer,-1);
//			sortGroupDisplay(group2);
		}
		
		
		private function addGroupMember(group:CardGroup,cardPlayer:GameCharaterData,dir:int):void{
			var cardPlayerDisay:CardPlayerDisplay = new CardPlayerDisplay();
			cardPlayerDisay.data = cardPlayer;
			
			cardPlayerDisay.islander.decision = new RandomFightAI(fightHelper);
			cardPlayerDisay.islander.charater.range = range;
			cardPlayerDisay.islander.fighter.attackRange = 60;
			cardPlayerDisay.islander.start();
			charaterHolder.addChild(cardPlayerDisay.islander.charater.view);
			
			
			if(dir>0){
				cardPlayerDisay.islander.group = 1;
				cardPlayerDisay.islander.setTo(0,200);
			}else{
				cardPlayerDisay.islander.group = 2;
				cardPlayerDisay.islander.setTo(1280,200);
			}
			sendNotification(CardFightHelperMediator.REGISTER,cardPlayerDisay.islander);
			
			group.hp+=cardPlayer.fullHP;
			group.isUpdateValue = false;
			
			
			group.groupData.push(cardPlayer);
			group.displays.push(cardPlayerDisay);
			
		}
		
		
		public static function genPlayerData(raw:Vector.<NPCRawDataVO>):Vector.<GameCharaterData>{
			
			var result:Vector.<GameCharaterData> = new Vector.<GameCharaterData>(raw.length);
			
			for (var i:int = 0; i < raw.length; i++) 
			{
				var cp:GameCharaterData = new GameCharaterData();
				var cardRaw:Array = raw[i].property.split("|");
				cp.values = new Vector.<CValue>(cardRaw.length);
				cp.equiment = raw[i].equiments;
				cp.name = raw[i].name;
				cp.state = raw[i].state;
				cp.charaterClass = raw[i].roleClass;
				cp.fullHP = parseInt(raw[i].hp);
				cp.hp = cp.fullHP;
				cp.id = raw[i].id;
				cp.skeleton = raw[i].skeleton;
				cp.job = parseInt(raw[i].ai);
				cp.scale = parseFloat(raw[i].scale);
				for (var j:int = 0; j < cardRaw.length; j++) 
				{
					if(cardRaw[j]!=""){
						var cardValue:Array = (cardRaw[j] as String).split("_");
						var card:CValue = new CValue(cardValue[0],cardValue[1]);
						cp.values[j] = card;
					}
				}
				result[i] = cp;
			}
			
			return result;
		}
		
		public static function getCardPlayerPropertyStr(_cardPlayer:GameCharaterData):String{
			
			var str:String = "";
			
			for (var i:int = 0; i < _cardPlayer.values.length; i++) 
			{
				str += _cardPlayer.values[i].type+"_"+_cardPlayer.values[i].value;
				if(i!=_cardPlayer.values.length-1){
					str+="|";
				}
			}
			return str;
		}
		
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case CardDisplay.CLICK:
				{
					
					
					
					break;
				}
				case AIConst.AI_ARRIVED:{
					var vo:FighterControllerMediator = notification.getBody() as FighterControllerMediator;
					/*if(state.state!=CardGameState.WAIT&&(vo==player1.data.islander||vo==player2.data.islander)&&readyCount<2){
						readyCount++;
						startFight();
					}*/
					
					
					
					break;
				}
					
				default:
				{
					break;
				}
			}
		}
		
		private function startFight():void{
			if(readyCount==2){
				state.changeState(CardGameState.ROLL);
			}
			
		}
		
		override public function listNotificationInterests():Array
		{
			return [CardDisplay.CLICK,AIConst.AI_ARRIVED];
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			facade.removeMediator(fightHelper.getMediatorName());
			
			reset();
			
		}
		
		
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
	}
}