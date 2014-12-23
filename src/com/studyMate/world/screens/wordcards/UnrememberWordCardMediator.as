package com.studyMate.world.screens.wordcards
{
	import com.byxb.extensions.starling.events.CameraUpdateEvent;
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.controller.HorizontalScrollerMediator;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.SoundVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.utils.BitmapFontUtils;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.model.WordCardPool;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.component.WordCard;
	import com.studyMate.world.screens.component.vo.WordCardVO;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.ColorMatrixFilter;
	
	import stateMachine.StateMachine;
	import stateMachine.StateMachineEvent;
	
	public class UnrememberWordCardMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "UnrememberWordCardMediator";
		
		private var cards:Vector.<WordCard>;
		private var discards:Vector.<WordCard>;
		
		private var hotY:int = 0;
		
		private var choosedCard:WordCard;
		
		private var choosePoint:Point;
		
		private var selectedCard:WordCard;
		
		private var _fsm:StateMachine;
		
		private const BLANK:String = "unChoose";
		private const CHOOSE:String = "choose"; 
		private const SELECTED:String = "selected";
		private const PLAY:String = "play";
		private const START:String = "start";
		private const DEAL:String = "deal";
		private const GATHER:String = "gather";
		private const SHUFFLE:String = "shuffle";
		private const FILTER:String = "filter";
		private const LEARN:String = "learn";
		private const MUTI_CHOOSE:String = "mutiChoose";
		private const RANDOM:String = "random";
		private const BACK:String = "back";
		private const CHANGE_SELECTED:String = "changeSelected";
		private const CHANGE_STATUS:String = "changeStatus";
		
		private const QRYWRONGWORD:String = "QryWrongWord";
		private const CHGWRONGWORDMARK:String = "ChgWrongWordMark";

		private var currentCard:WordCard;
		
		private var isSorting:Boolean;
		private var sortCount:int;
		private var gap:int;
		private var startPoint:Point;
		
		private var hasMove:Boolean;
		
		private var chooseCards:Vector.<WordCard>;
		
		private var remenberCards:Vector.<WordCard>;
		private var unRememberCards:Vector.<WordCard>;
		private var allCard:Vector.<WordCard>;
		
		private var isMuti:Boolean;

		
		private var pool:WordCardPool;
		private const viewGap:int = 65;
		
		private var words:Vector.<WordCardVO>;
		private var backupCards:Vector.<WordCard>;
		
		private var shuffleFun:Function;
		private var startTouchPoint:Point;
		private var filter:ColorMatrixFilter;
		
		public function UnrememberWordCardMediator(viewComponent:Object=null)
		{
			super(ModuleConst.WRONGWORD);
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class
		{
			return UnrememberWordCardMediatorView;
		}
		
		public function get view():UnrememberWordCardMediatorView{
			return getViewComponent() as UnrememberWordCardMediatorView;
		}
		      
		override public function onRegister():void
		{
			sendNotification(WorldConst.SHOW_MAIN_MENU);
			view.rivierBackground.show(new Rectangle(-Global.stageWidth*0.5,-Global.stageHeight*0.9,Global.stageWidth,Global.stageHeight));
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(HorizontalScrollerMediator,[0*viewGap,0,hotY],SwitchScreenType.SHOW,view)]);
			view.studyWordBtn.addEventListener(Event.TRIGGERED,studyWordHandler);
			view.studyWordResultBtn.addEventListener(Event.TRIGGERED,studyWordResultHandler);	
		}
		
		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.UPDATE_CAMERA,QRYWRONGWORD,CHGWRONGWORDMARK];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var _result:DataResultVO = notification.getBody()as DataResultVO;
			switch(notification.getName())
			{
				case WorldConst.UPDATE_CAMERA:
				{
					if(view.camera){
						view.camera.moveTo(-(notification.getBody() as int),-view.camera.world.y);
						if(!isSorting&&cards!=null){
							for (var i:int = 0; i < cards.length; i++) 
							{
								if(cards[i].x>view.camera.viewport.right||cards[i].x<view.camera.viewport.left){
									cards[i].visible = false;
								}else{
									cards[i].visible = true;
								}
							}
						}
					}
					break;
				}
				case QRYWRONGWORD:
				{
					if(!_result.isErr){
						if(!_result.isEnd){
							var _wordData:WordCardVO = new WordCardVO();
							_wordData.wordid = PackData.app.CmdOStr[1];
							_wordData.word = PackData.app.CmdOStr[2];
							_wordData.wordStatus = PackData.app.CmdOStr[3];
							_wordData.wordSymbol = MyUtils.toSpell(PackData.app.CmdOStr[4]);
							_wordData.wordMean = PackData.app.CmdOStr[5];
							_wordData.wordadd = PackData.app.CmdOStr[6];
							_wordData.wordVoice = PackData.app.CmdOStr[7];
							_wordData.wordStart = PackData.app.CmdOStr[8];
							_wordData.wordStop = PackData.app.CmdOStr[9];
							_wordData.wrongNum = PackData.app.CmdOStr[11]
							words.push(_wordData);
						}else{
							if(words.length==0){
								sendNotification(CoreConst.TOAST,new ToastVO("你还没有错词需要背~~"));
							}
							view.camera.y =0;
							creatStateMachine();
						}
					}
					break
				}
				case CHGWRONGWORDMARK:
				{
					if(!_result.isErr){
						if(PackData.app.CmdOStr[0] == "000"){
							if(PackData.app.CmdOStr[1] == "Y"){
								selectedCard.vo.wordStatus = "Y";
							}else if(PackData.app.CmdOStr[1] =="N"){
								selectedCard.vo.wordStatus = "N";
							}
							changeWordCardStatus();
						}
					}
					break;
				}
			}
		}
		
		private function creatStateMachine():void
		{
			pool = new WordCardPool();
			_fsm = new StateMachine;
				
			_fsm.addState(CHOOSE,{enter:enterChoose,exit:exitChoose,from:[BLANK,LEARN]});
			_fsm.addState(SELECTED,{enter:enterSelected,from:[BLANK,CHANGE_SELECTED,CHANGE_STATUS]});
			_fsm.addState(BLANK,{from:[CHOOSE,DEAL,MUTI_CHOOSE,LEARN,SELECTED,CHANGE_SELECTED,CHANGE_STATUS]});
			_fsm.addState(START,{enter:enterStart,exit:exitStart,from:["*"]});
			_fsm.addState(DEAL,{enter:enterDeal,from:[START]});
			_fsm.addState(GATHER,{enter:enterGather,from:[CHOOSE,SELECTED,BLANK,RANDOM,BACK]});
			_fsm.addState(MUTI_CHOOSE,{enter:enterMutiChoose,from:[BLANK]});
			_fsm.addState(FILTER,{enter:enterFilter,from:[MUTI_CHOOSE,BLANK]});
			_fsm.addState(LEARN,{enter:enterLearn,from:[SELECTED,CHOOSE,BLANK,FILTER,GATHER]});
			_fsm.addState(RANDOM,{enter:enterRandom,from:[BLANK,SELECTED,CHOOSE,LEARN]});
			_fsm.addState(BACK,{enter:enterBack,from:[BLANK,SELECTED,CHOOSE,LEARN]});
			_fsm.addState(CHANGE_SELECTED,{enter:enterChangeSelected,from:[SELECTED,CHOOSE,BLANK]});
			_fsm.addState(CHANGE_STATUS,{enter:enterChangeStatus,from:[SELECTED,BLANK]});
			_fsm.initialState = START;	
		}	
		
		
		
		private function enterChangeSelected(event:StateMachineEvent):void
		{
			if(selectedCard != null){
				exitSelected();		
			}
			_fsm.changeState(SELECTED);
		}
		
		private function exitSelected():void
		{
			if(selectedCard.isBack){
				selectedCard.isBack = false;
			}
			view.symbol.visible = false;
			view.voiceBtn.visible = false;
			view.turnBtn.visible = false;
			selectedCard.rest();
			TweenLite.to(selectedCard,0.4,{y:0,x:selectedCard.ox});
			sendNotification(WorldConst.SET_ROLL_SCREEN,true);
			TweenLite.killTweensOf(changeSelectMode);
		}
		
		private function enterChangeStatus(event:StateMachineEvent):void
		{
			changeStatus();
		}
		
		private function enterRandom(event:StateMachineEvent):void
		{
			view.randomBtn.visible = false;
			view.backBtn.visible = false;
			if(selectedCard != null){
				exitSelected();		
				selectedCard = null
			}
			_fsm.changeState(GATHER);
			sendNotification(WorldConst.SET_ROLL_TARGETX,-startPoint.x);
		}
		
		private function enterBack(event:StateMachineEvent):void
		{
			view.backBtn.visible = false;
			view.randomBtn.visible = false;
			if(selectedCard !=null){
				exitSelected();
				selectedCard=null;
			}
			_fsm.changeState(GATHER);
			sendNotification(WorldConst.SET_ROLL_TARGETX,-startPoint.x);
		}
		
		private function randomHandler():void
		{
			_fsm.changeState(RANDOM);
		}
		
		private function updataBackgroundHandler(e:CameraUpdateEvent):void
		{
			view.rivierBackground.show(e.viewport);
		}
		
		private function selectUnrememberHandler():void
		{
			if(chooseCards.length ==0){
				selectUnrememberCard();
				if(chooseCards.length != 0){
					view.startBtn.filter = null;
					view.startBtn.touchable = true;
				}
			}else{
				for(var j:int = 0;j<chooseCards.length;j++)
				{
					TweenLite.to(chooseCards[j],0.4,{y:0});
					chooseCards[j].isChoosed = false;
				}
				chooseCards.length = 0;
				view.startBtn.filter = filter;
				view.startBtn.touchable = false;
			}
		}
		
		private function selectAllCardsHandler():void
		{
			if(chooseCards.length ==0){
				selectRememberCard();
				if(chooseCards.length != 0){
					view.startBtn.filter = null;
					view.startBtn.touchable = true;
				}
			}else{
				for(var j:int = 0;j<cards.length;j++)
				{
					TweenLite.to(cards[j],0.4,{y:0});
					cards[j].isChoosed = false;
				}
				chooseCards.length = 0;
				view.startBtn.filter = filter;
				view.startBtn.touchable = false;
			}
		}
		
		private function selectRememberCard():void
		{
			for(var i:int = 0;i<cards.length;i++){
				if(cards[i].isRemember){
					choosedCard = cards[i];
					choosedCard.backvo = words[cards[i].id]
					cards[i].isChoosed = true;
					TweenLite.to(choosedCard,0.4,{y:-120});
					chooseCards.push(cards[i]);
				}
			}
		}
		
		private function selectUnrememberCard():void
		{
			for(var i:int = 0;i<cards.length;i++){
				if(!cards[i].isRemember){
					choosedCard = cards[i];
					choosedCard.backvo = words[cards[i].id]
					cards[i].isChoosed = true;
					chooseCards.push(cards[i]);
					TweenLite.to(choosedCard,0.4,{y:-120});
				}
			}
		}
		
		private function playWordVoiceHandler():void
		{
			if(selectedCard != null){
				var fileName:String = "edu/mp3/ESOUND_" + selectedCard.vo.wordVoice  + ".mp3";
				var wordSoundVO:SoundVO = new SoundVO(fileName,selectedCard.vo.wordStart,(selectedCard.vo.wordStop-selectedCard.vo.wordStart),0,null,0.8);	
				sendNotification(CoreConst.SOUND_PLAY,wordSoundVO);	
			}
		}		
		
		private function studyWordResultHandler():void
		{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(RememberWordCardMediator)]);
		}
		
		private function studyWordHandler():void
		{
			view.studyWordBtn.visible = false;
			words = new Vector.<WordCardVO>;
			backupCards = new Vector.<WordCard>();
			startPoint = new Point(200,-300);
			cards = new Vector.<WordCard>;
			remenberCards = new Vector.<WordCard>;
			unRememberCards = new Vector.<WordCard>;
			allCard = new Vector.<WordCard>;
			discards = new Vector.<WordCard>;
			gap = 4;
			choosePoint = new Point;
			startTouchPoint = new Point;
			
			var matrix:Vector.<Number>= Vector.<Number>([0.3086, 0.6094, 0.0820, 0, 0,  
				0.3086, 0.6094, 0.0820, 0, 0,  
				0.3086, 0.6094, 0.0820, 0, 0,  
				0,      0,      0,      1, 0]);  
			
			filter = new ColorMatrixFilter(matrix);
			
			view.startBtn.addEventListener(Event.TRIGGERED,startBtnHandle);
			view.backBtn.addEventListener(Event.TRIGGERED,backBtnHandle);
			view.randomBtn.addEventListener(Event.TRIGGERED,randomHandler);
			view.turnBtn.addEventListener(Event.TRIGGERED,turnBtnHandler);
			view.voiceBtn.addEventListener(Event.TRIGGERED,playWordVoiceHandler);
			view.rememberCardBtn.addEventListener(Event.TRIGGERED,selectAllCardsHandler);
			view.unrememberCardBtn.addEventListener(Event.TRIGGERED,selectUnrememberHandler);
			view.camera.addEventListener(CameraUpdateEvent.CAMERA_UPDATE,updataBackgroundHandler);
			getWordList();
			sendNotification(CoreConst.HIDE_STARUP_INFOR);	
		}
		
		private function getWordList():void
		{
			PackData.app.CmdIStr[0] = CmdStr.QRYWRONGWORD;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID;
			PackData.app.CmdIStr[2] = 0;
			PackData.app.CmdIStr[3] = 20;
			PackData.app.CmdIStr[4] = "Y";
			PackData.app.CmdInCnt = 5;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(QRYWRONGWORD));
		}		
		
		private function turnBtnHandler():void
		{
			if(selectedCard){
				selectedCard.isBack = !selectedCard.isBack;
				if(selectedCard.isBack){
					view.turnBtn.x = 20;
					view.turnBtn.y = 20;
					view.voiceBtn.visible = false;
					view.symbol.visible = false;
					view.remember.visible = false;
					view.wordMean.visible = true;
					view.wrongNum.visible = true;
					view.wordMean.text = selectedCard.backtext;
					view.wrongNum.text = selectedCard.num;
					selectedCard.backHolder.addChild(view.wordMean);
					selectedCard.backHolder.addChild(view.wrongNum);
				}else{
					view.turnBtn.x = 360;
					view.turnBtn.y = 20;
					view.voiceBtn.visible = true;
					view.symbol.visible = true;
					if(selectedCard.isRemember){
						view.remember.visible = true;
					}
					view.wordMean.visible = false;
					view.wrongNum.visible = false;
				}
			}
		}
		
		private function backBtnHandle():void
		{
			_fsm.changeState(BACK);
		}
		
		private function startBtnHandle():void
		{
			view.startBtn.visible = false;
			view.studyWordResultBtn.visible = false;
			if(!chooseCards.length){
				return;
			}
			_fsm.changeState(FILTER);
		}
		
		private function recyleAllCards():void{
			for (var i:int = 0; i < cards.length; i++) 
			{
				cards[i].removeFromParent();
				pool.object = cards[i];
			}
		}
		
		private function changeMulti():void{
			isMuti = true;
			_fsm.changeState(BLANK);
			view.stage.removeEventListener(TouchEvent.TOUCH,selectStageTouchHandle);
			view.stage.addEventListener(TouchEvent.TOUCH,mutiChooseStageTouchHandle);	
		}
		
		private function chageSingle():void{
			isMuti = false;
			_fsm.changeState(BLANK);
			view.stage.removeEventListener(TouchEvent.TOUCH,mutiChooseStageTouchHandle);
			view.stage.addEventListener(TouchEvent.TOUCH,selectStageTouchHandle);
		}
		
		private function enterLearn(event:StateMachineEvent):void{
			view.startBtn.visible = false;
			isSorting = false;
			view.backBtn.visible = true;
			view.touchable = true;
			view.randomBtn.visible = true;
			view.rememberCardBtn.visible = false;
			view.unrememberCardBtn.visible = false;
			layCards();
		}
		
		private function enterFilter(event:StateMachineEvent):void{
			isSorting = true;
			gap = 4;
			view.rememberCardBtn.visible = false;
			view.unrememberCardBtn.visible = false;
			view.touchable = false;
			for (var i:int = 0; i < chooseCards.length; i++) 
			{
				chooseCards[i].visible = true;
				view.cardHolder.addChildAt(chooseCards[i],0);
				TweenLite.to(chooseCards[i],1,{x:i*gap});
			}
			for (var j:int = 0; j < cards.length; j++) 
			{
				if(!cards[j].isChoosed){
					TweenLite.to(cards[j],1,{y:400,onComplete:hideUnchooseCardHandler,onCompleteParams:[cards[i]]});
				}
			}
			backupCards = cards;
			cards = chooseCards;
			sendNotification(WorldConst.SET_HSCROLL_RL,[cards.length*viewGap,0]);
			TweenLite.delayedCall(1.5,_fsm.changeState,[LEARN]);
			sendNotification(WorldConst.SET_ROLL_TARGETX,-startPoint.x);
		}
		
		private function hideUnchooseCardHandler(card:WordCard):void
		{
			card.visible = false;	
		}
		
		private function layCards():void{
			chageSingle();
			gap = viewGap;
			for (var i:int = 0; i < cards.length; i++) 
			{
				cards[i].visible = true;
				cards[i].isChoosed = false;
				cards[i].ox = i*gap;
				view.cardHolder.addChildAt(cards[i],0);
				TweenLite.to(cards[i],1,{x:i*gap,y:0});
			}
		}
		
		private function enterMutiChoose(event:StateMachineEvent):void{
			currentCard.isChoosed=!currentCard.isChoosed;
			if(currentCard.isChoosed){
				currentCard.backvo = words[currentCard.id]
				chooseCards.push(currentCard);
				TweenLite.to(currentCard,0.4,{y:-120});
			}else{
				chooseCards.splice(chooseCards.indexOf(currentCard),1);
				TweenLite.to(currentCard,0.4,{y:0});
			}
			if(chooseCards.length!=0){
				view.startBtn.filter = null;
				view.startBtn.touchable = true;
			}else{
				view.startBtn.filter = filter;
				view.startBtn.touchable = false;
			}
		} 	
		
		
		private function enterGather(event:StateMachineEvent):void{
			gap = 4;
			view.touchable = false;
			TweenLite.killDelayedCallsTo(getCards);
			TweenLite.killDelayedCallsTo(activesCards);
			TweenLite.killDelayedCallsTo(backStartPoint);
			TweenLite.delayedCall(0.3,getCards);
			TweenLite.delayedCall(1.5,activesCards);
			TweenLite.delayedCall(1.5,backStartPoint,[event.fromState]);	
		}
		
		private function getCards():void
		{
			for (var i:int = 0; i < cards.length; i++) 
			{
				cards[i].visible = true;
				cards[i].y = 0;
				TweenLite.to(cards[i],1,{x:i*gap});
			}
		}
		
		private function backStartPoint(prestatues:String):void{
			sortCount = 0;
			var i:int;
			for (i = 0; i < cards.length; i++) 
			{
				TweenLite.to(cards[i],0.8,{delay:0.5,x:startPoint.x,y:startPoint.y,onComplete:gatherCardsComplete,onCompleteParams:[cards[i],prestatues]});
			}
		}
		
		private function exitStart(event:StateMachineEvent):void{
			TweenLite.killDelayedCallsTo(changeBtnState);
			TweenLite.delayedCall(1.5,changeBtnState);			
		}
		
		private function changeBtnState():void
		{
			view.startBtn.visible = true;
			chooseCards.length = 0;
			view.startBtn.filter = filter;
			view.startBtn.touchable = false;
			view.backBtn.visible = false;
			view.rememberCardBtn.visible = true
			view.unrememberCardBtn.visible = true;
			view.touchable = true;
			if(view.rememberCardBtn.alpha<1){
				TweenLite.to(view.rememberCardBtn,2.5,{alpha:1});
				TweenLite.to(view.unrememberCardBtn,2.5,{alpha:1});
				TweenLite.to(view.startBtn,2.5,{alpha:1});
			}
		}
		
		private function enterStart(event:StateMachineEvent):void{
			isSorting = false;
			view.backBtn.visible = false;
			view.voiceBtn.visible = false;
			view.symbol.visible = false;
			view.turnBtn.visible = false;
			view.randomBtn.visible = false;
			view.studyWordResultBtn.visible = true;
			if(event.fromState==null){
				recyleAllCards();
				creatWordCard();
				view.camera.moveTo(0,-300,1,0,true);	
				sendNotification(WorldConst.SET_HSCROLL_RL,[cards.length*viewGap,0]);
			}
			_fsm.changeState(DEAL);
		}
		
		private function creatWordCard():void
		{
			var wordCard:WordCard;
			for (var i:int = 0; i < words.length; i++) 
			{
				wordCard = pool.object;
				wordCard.id = i;
				wordCard.wordId = words[i].wordid;
				wordCard.vo = words[i];
				wordCard.x = startPoint.x;
				wordCard.y = startPoint.y;
				wordCard.creatgeenWordCardBackground(BitmapFontUtils.getTexture("bg_00000"));
				wordCard.isRemember = false;
				cards.push(wordCard);
				view.cardHolder.addChildAt(wordCard,0);
			}
			chooseCards = new Vector.<WordCard>;
		}
		
		private function enterDeal(event:StateMachineEvent):void{
			deal();
		}
		
		private function activesCards():void{
			for (var i:int = 0; i < cards.length; i++) 
			{
				cards[i].rest();
			}
		}
		
		private function gatherCardsComplete(card:WordCard,prestatues:String):void{
			
			if(prestatues == RANDOM){
				cards = randomArr(cards);
				_fsm.changeState(LEARN);
			}else{
				cards = backupCards;
				for (var i:int = 0; i < cards.length; i++) 
				{
					cards[i].x = startPoint.x;
					cards[i].y = startPoint.y;
					cards[i].isChoosed = false;
					cards[i].rest();
					view.cardHolder.addChildAt(cards[i],0);
				}
				sendNotification(WorldConst.SET_HSCROLL_RL,[cards.length*viewGap,0]);
				_fsm.changeState(START);
			}
		}
		
		private function randomArr(arr:Vector.<WordCard>):Vector.<WordCard>
		{
			var outputArr:Vector.<WordCard> = arr.slice();
			var i:int = outputArr.length;
			while (i)
			{
				outputArr.push(outputArr.splice(int(Math.random() * i--), 1)[0]);
			}
			return outputArr;
		}
		
		private function startRestCards():void{
			gap = viewGap;
			for (var i:int = 0; i < cards.length; i++) 
			{
				TweenLite.to(cards[i],1,{x:i*gap});
				
			}
			TweenLite.delayedCall(1.5,restCards);
		}
		
		private function restCards():void{
			for (var i:int = 0; i < cards.length; i++) 
			{
				cards[i].rest();
			}
			changeMulti();
		}
		
		private function deal():void{
			for (var i:int = 0; i < cards.length; i++) 
			{
				var card:WordCard = cards[i];
				cards[i].rest();
				TweenLite.to(card,0.5,{delay:Math.random()*1,x:i*gap,y:0,onStart:onDealStart,onStartParams:[card]});
			}
			TweenLite.delayedCall(1.5,startRestCards);
		}
		
		private function onDealStart(card:WordCard):void{
			card.visible = true;
		}
		
		
		private function enterSelected(event:StateMachineEvent):void{
			selectedCard = currentCard;
			if(!selectedCard.isActive){
				selectedCard.activeScale();
				view.turnBtn.x = 360;
				view.turnBtn.y = 20;
				selectedCard.addChild(view.turnBtn);
				selectedCard.addChild(view.voiceBtn);
				selectedCard.addChild(view.symbol);
				view.symbol.text = selectedCard.symbolText
				view.voiceBtn.visible = true;
				view.symbol.visible = true;
				view.turnBtn.visible = true;
				view.remember.visible = false;
				if(selectedCard.isRemember){
					selectedCard.addChild(view.remember);
					view.remember.visible = true;
				}else{
					selectedCard.creatgeenWordCardBackground(BitmapFontUtils.getTexture("green_00000"));
					selectedCard.bg.alpha = 1;
				}
				TweenLite.to(selectedCard,0.5,{y:-350});
				sendNotification(WorldConst.SET_ROLL_TARGETX,-int(selectedCard.x));
				changeSelectMode();
				TweenLite.killDelayedCallsTo(playWordVoiceHandler);
				TweenLite.delayedCall(0.5,playWordVoiceHandler);
			}
		}
		
		private function detecDragAixHandle(event:TouchEvent):void{
			var touch:Touch = event.getTouch(event.currentTarget as starling.display.DisplayObject);
			if(!touch||!selectedCard){
				return;
			}
			if(touch.phase==TouchPhase.BEGAN){
				startTouchPoint.setTo(touch.globalX,touch.globalY);
			}else if(touch.phase==TouchPhase.MOVED){
				if(Math.abs(startTouchPoint.x - touch.globalX)>50){
					if(view.stage.hasEventListener(TouchEvent.TOUCH)){
						view.stage.removeEventListener(TouchEvent.TOUCH,detecDragAixHandle);
					}
					view.stage.addEventListener(TouchEvent.TOUCH,selectedCardXAixControlHandle);
				}else if(Math.abs(startTouchPoint.y - touch.globalY)>50){
					if(view.stage.hasEventListener(TouchEvent.TOUCH)){
						view.stage.removeEventListener(TouchEvent.TOUCH,detecDragAixHandle);
					}
					view.stage.addEventListener(TouchEvent.TOUCH,selectedCardYAixControlHandle);
				}
			}
		}
		
		private function changeSelectMode():void{
			sendNotification(WorldConst.SET_ROLL_SCREEN,false);
			view.stage.addEventListener(TouchEvent.TOUCH,detecDragAixHandle);
		}
		
		private function selectedCardXAixControlHandle(event:TouchEvent):void{
			var touch:Touch = event.getTouch(event.currentTarget as starling.display.DisplayObject);
			if(!touch||!selectedCard){
				return;
			}
			if(touch.phase==TouchPhase.BEGAN){
				
			}else if(touch.phase==TouchPhase.MOVED){
				touch.getMovement(view.cardHolder,choosePoint);
				if(choosePoint.x>0&&selectedCard.x<selectedCard.ox+100){
					selectedCard.x+=choosePoint.x;
				}else if(selectedCard.x>selectedCard.ox-100&&choosePoint.x<0){
					selectedCard.x+=choosePoint.x;
				}
				
				if(selectedCard.x>selectedCard.ox+100){
					selectedCard.x=selectedCard.ox+100;
				}else if(selectedCard.x<selectedCard.ox-100){
					selectedCard.x=selectedCard.ox-100;
				}
			}else if(touch.phase==TouchPhase.ENDED){
				var idx:int;
				if(selectedCard.x>selectedCard.ox+30){
					idx = cards.indexOf(selectedCard);
					
					idx++;
					if(idx>cards.length-1){
						idx = cards.length-1;
					}
					currentCard = cards[idx];
					
					_fsm.changeState(CHANGE_SELECTED);
				}else if(selectedCard.x<selectedCard.ox-30){
					idx = cards.indexOf(selectedCard);
					idx--;
					if(idx<0){
						idx = 0;
					}
					currentCard = cards[idx];
					
					_fsm.changeState(CHANGE_SELECTED);

				}else{
					TweenLite.to(selectedCard,0.3,{x:selectedCard.ox});
				}
				
				view.stage.removeEventListener(TouchEvent.TOUCH,selectedCardXAixControlHandle);
				view.stage.addEventListener(TouchEvent.TOUCH,detecDragAixHandle);
				
			}
		}
		
		private var turn:Boolean = true;
		private function selectedCardYAixControlHandle(event:TouchEvent):void{
			var touch:Touch = event.getTouch(event.currentTarget as starling.display.DisplayObject);
			if(!touch||!selectedCard){
				
				return;
			}
			if(touch.phase==TouchPhase.BEGAN){
				startTouchPoint.setTo(touch.globalX,touch.globalY);
			}else if(touch.phase==TouchPhase.MOVED){
				touch.getMovement(view.cardHolder,choosePoint);
				if(choosePoint.y>0){
					selectedCard.y+=choosePoint.y;
					if(selectedCard.y<-380&&turn){
						if(selectedCard.isRemember){
							if(Math.abs(selectedCard.y + 350)%10){
								selectedCard.geen.alpha += 0.07;
							}
						}else{
							if(Math.abs(selectedCard.y + 350)%10){
								selectedCard.bg.alpha += 0.07;
							}
						}
					}
				}else if(choosePoint.y<0){
					selectedCard.y+=choosePoint.y;
					if(selectedCard.y<-380&&turn){
						if(selectedCard.isRemember){
							if(Math.abs(selectedCard.y + 350)%10){
								selectedCard.geen.alpha -= 0.07;
							}
						}else{
							if(Math.abs(selectedCard.y + 350)%10){
								selectedCard.bg.alpha -= 0.07;
							}
						}
					}
				}
				 if(selectedCard.y<-480){
					selectedCard.y=-480;
				}
				if(!Global.isLoading&&selectedCard.y<-445){
					if(turn){
						turn = false;
						_fsm.changeState(CHANGE_STATUS);
					}
				}
				
			}else if(touch.phase==TouchPhase.ENDED){
				turn = true;
				if(selectedCard.isRemember){
					selectedCard.bg.alpha = 1;
					selectedCard.addChildAt(selectedCard.bg,0);
					selectedCard.geen.alpha = 1;
				}else{
					selectedCard.geen.alpha = 1;
					selectedCard.addChildAt(selectedCard.geen,0);
					selectedCard.bg.alpha = 1;
				}
				if(selectedCard.y>-200){
					view.voiceBtn.visible = false;
					view.symbol.visible = false;
					view.turnBtn.visible = false;
					_fsm.changeState(BLANK);
					_fsm.changeState(CHOOSE);
				}else {
					TweenLite.killTweensOf(selectedCard);
					TweenLite.to(selectedCard,0.3,{y:-350});
				}
				view.stage.removeEventListener(TouchEvent.TOUCH,selectedCardYAixControlHandle);
				view.stage.addEventListener(TouchEvent.TOUCH,detecDragAixHandle);
			}
		}
		
		private function changeStatus():void
		{
			PackData.app.CmdIStr[0] = CmdStr.CHGWRONGWORDMARK
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID;
			PackData.app.CmdIStr[2] = selectedCard.wordId;
			PackData.app.CmdInCnt = 3;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(CHGWRONGWORDMARK,null,"cn-gb",null,SendCommandVO.QUEUE|SendCommandVO.SCREEN));
		}
		
		private function changeWordCardStatus():void
		{
			if(selectedCard.isRemember){
				selectedCard.creatWordCardBackground(BitmapFontUtils.getTexture("bg_00000"));
				selectedCard.removeChild(view.remember);
				selectedCard.bg.alpha = 1;
				selectedCard.geen.alpha = 1;
				selectedCard.setChildIndex(selectedCard.geen,0);
				selectedCard.isRemember = false;
			}else{
				selectedCard.creatgeenWordCardBackground(BitmapFontUtils.getTexture("green_00000"));
				selectedCard.addChild(view.remember);
				selectedCard.geen.alpha = 1;
				selectedCard.bg.alpha = 1;
				selectedCard.setChildIndex(selectedCard.bg,0)
				if(selectedCard.isBack){
					view.remember.visible = false;
				}else{
					view.remember.visible = true;
				}
				selectedCard.isRemember = true;
			}
			_fsm.changeState(BLANK);
		}
		
		private function exitChoose(event:StateMachineEvent):void{
			TweenLite.to(choosedCard,0.4,{y:0});
			choosedCard.isChoosed = false;
			choosedCard = null;
			if(chooseCards.length == 0){
				view.startBtn.filter = filter;
			}
		}
		
		private function enterChoose(event:StateMachineEvent):void{
			choosedCard = currentCard;
			currentCard.isChoosed = true;
			TweenLite.to(choosedCard,0.4,{y:-120});
			if(!chooseCards.length == 0){
				view.startBtn.filter = null;
			}
			if((event.fromState==BLANK||event.fromState==CHOOSE)&&selectedCard != null){
				exitSelected();		
				selectedCard = null
			}
		}
		
		private function mutiChooseStageTouchHandle(event:TouchEvent):void{
			var touch:Touch = event.getTouch(view.cardHolder);
			if(touch&&touch.globalY>hotY){
				touch.getLocation(view.cardHolder,choosePoint);
				var item:starling.display.DisplayObject = view.cardHolder.hitTest(choosePoint);
				var touchCard:WordCard;
				if(item){
					touchCard = item.parent as WordCard;
				}
				if(!touchCard){
					return;
				}
				if(touch.phase==TouchPhase.BEGAN){
					hasMove = false;
					sendNotification(WorldConst.CHANGE_HSCROLL_DIRECTION,-1);
				}else if(touch.phase==TouchPhase.MOVED&&currentCard != touchCard){
					hasMove = true;
					currentCard = touchCard;
					_fsm.changeState(BLANK);
					_fsm.changeState(MUTI_CHOOSE);
				}else if(touch.phase==TouchPhase.ENDED&&!hasMove){
					currentCard = touchCard;
					_fsm.changeState(BLANK);
					_fsm.changeState(MUTI_CHOOSE);
					currentCard = null;
					sendNotification(WorldConst.CHANGE_HSCROLL_DIRECTION,1);
				}
			}else{
				sendNotification(WorldConst.CHANGE_HSCROLL_DIRECTION,1);
			}
		}
		
		private function selectStageTouchHandle(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(view.cardHolder);
			if(touch&&touch.globalY>hotY){
				touch.getLocation(view.cardHolder,choosePoint);
				var item:starling.display.DisplayObject = view.cardHolder.hitTest(choosePoint);
				var touchCard:WordCard;
				if(item){
					touchCard = item.parent as WordCard;
				}
				if(!touchCard||(selectedCard&&selectedCard==touchCard)){
					return;
				}
				if(touch.phase==TouchPhase.BEGAN){
					hasMove = false;
					sendNotification(WorldConst.CHANGE_HSCROLL_DIRECTION,-1);
				}else if(touch.phase==TouchPhase.MOVED&&currentCard != touchCard){
					hasMove = true;
					currentCard = touchCard;
					_fsm.changeState(BLANK);
					_fsm.changeState(CHOOSE);
				}else if(touch.phase==TouchPhase.ENDED&&!hasMove){
					currentCard = touchCard;
					_fsm.changeState(CHANGE_SELECTED);
					sendNotification(WorldConst.CHANGE_HSCROLL_DIRECTION,1);
				}
			}else{
				sendNotification(WorldConst.CHANGE_HSCROLL_DIRECTION,1);
			}
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			sendNotification(WorldConst.SHOW_MENU_BUTTON);
			BitmapFontUtils.dispose();
			view.removeChild(view.symbol,true);
			sendNotification(CoreConst.SOUND_STOP);
			if(_fsm != null){
				_fsm.canChangeStateTo(_fsm.state);
				TweenLite.killDelayedCallsTo(_fsm.changeState);
			}
			_fsm = null;
			if(cards != null){
				for (var a:int = 0; a < cards.length; a++) 
				{
					TweenLite.killTweensOf(cards[a]);
				}
				for (var i:int = 0; i < chooseCards.length; i++) 
				{
					TweenLite.killTweensOf(chooseCards[i]);
				}
			}
			Starling.current.stage.removeEventListener(TouchEvent.TOUCH,mutiChooseStageTouchHandle);
			Starling.current.stage.removeEventListener(TouchEvent.TOUCH,selectStageTouchHandle);
			Starling.current.stage.removeEventListener(TouchEvent.TOUCH,selectedCardYAixControlHandle);
			Starling.current.stage.removeEventListener(TouchEvent.TOUCH,detecDragAixHandle);
			TweenLite.killTweensOf(selectedCard);
			TweenLite.killTweensOf(choosedCard);
			TweenLite.killTweensOf(currentCard);
			TweenLite.killTweensOf(view.startBtn);
			TweenLite.killTweensOf(view.rememberCardBtn);
			TweenLite.killTweensOf(view.unrememberCardBtn);
			TweenLite.killDelayedCallsTo(startRestCards);
			TweenLite.killDelayedCallsTo(changeBtnState);
			TweenLite.killDelayedCallsTo(activesCards);
			TweenLite.killDelayedCallsTo(backStartPoint);
			TweenLite.killDelayedCallsTo(restCards);
			TweenLite.killDelayedCallsTo(getCards);
			TweenLite.killDelayedCallsTo(activesCards);
			TweenLite.killDelayedCallsTo(backStartPoint);
		}
	}
}