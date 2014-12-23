package com.studyMate.world.screens
{
	import com.byxb.extensions.starling.display.CameraSprite;
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.controller.HorizontalScrollerMediator;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.utils.BitmapFontUtils;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.model.WordCardPool;
	import com.studyMate.world.screens.component.WordCard;
	import com.studyMate.world.screens.component.vo.WordCardVO;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	import feathers.display.TiledImage;
	import feathers.text.BitmapFontTextFormat;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.ColorMatrixFilter;
	
	import stateMachine.StateMachine;
	import stateMachine.StateMachineEvent;
	
	public class WordCardScreen extends ScreenBaseMediator
	{
		public static const NAME:String = "WordCardScreen";
		
		private var cardHolder:starling.display.Sprite;
		private var cards:Vector.<WordCard>;
		private var discards:Vector.<WordCard>;
		
		private var hotY:int = 0;
		
		private var choosedCard:WordCard;
		
		private var choosePoint:Point;
		
		private var selectedCard:WordCard;
		
		
		private var _fsm:StateMachine;
		
		private static const BLANK:String = "unChoose";
		private static const CHOOSE:String = "choose"; 
		private static const SELECTED:String = "selected";
		private static const PLAY:String = "play";
		private static const START:String = "start";
		private static const DEAL:String = "deal";
		private static const GATHER:String = "gather";
		private static const  SHUFFLE:String = "shuffle";
		private static const FILTER:String = "filter";
		private static const LEARN:String = "learn";
		private static const MUTI_CHOOSE:String = "mutiChoose";
		
		
		
		private const QRYWRONGWORD:String = "QryWrongWord";
		private const CHGWRONGWORDMARK:String = "ChgWrongWordMark";
		
		
		private var currentCard:WordCard;
		private var preSelectedCard:WordCard;
		
		private var discardHolder:starling.display.Sprite;
		
		private var isSorting:Boolean;
		private var sortCount:int;
		private var gap:int;
		private var startPoint:Point;
		
		private var camera:CameraSprite;
		private var hasMove:Boolean;
		
		private var chooseCards:Vector.<WordCard>;
		private var unChooseCards:Vector.<WordCard>;
		
		private var remenberCards:Vector.<WordCard>;
		private var unRememberCards:Vector.<WordCard>;
		private var allCard:Vector.<WordCard>;
		
		private var isMuti:Boolean;
		
		private var bg:TiledImage;
		
		private var cloud:Image;
		
		private var pool:WordCardPool;
		private const viewGap:int = 65;
		
		
		private var words:Vector.<WordCardVO> = new Vector.<WordCardVO>;
		
		private var shuffleFun:Function;
		
		private var backupCards:Vector.<WordCard>;
		
		private var startTouchPoint:Point;
		
		private var filter:ColorMatrixFilter;

		private var explainTaBtn:TabBar;
		private var selectTaBtn:TabBar;
		
		private var turnBtn:starling.display.Button;
		
		private var voiceBtn:starling.display.Button;
		private var symbol:Label;
		
		private var remember:Image
		
		private var showStr:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890[]:'-"
		
		public function WordCardScreen(viewComponent:Object=null)
		{
			super(NAME);
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class
		{
			return starling.display.Sprite;
		}
		
		public function get view():starling.display.Sprite{
			return getViewComponent() as starling.display.Sprite;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			
			var _result:DataResultVO = notification.getBody()as DataResultVO;
			switch(notification.getName())
			{
				case WorldConst.UPDATE_CAMERA:
				{
					if(camera){
						camera.moveTo(-(notification.getBody() as int),-camera.world.y);
						if(!isSorting){
							
							for (var i:int = 0; i < cards.length; i++) 
							{
								if(cards[i].x>camera.viewport.right||cards[i].x<camera.viewport.left){
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
							showStr += _wordData.wordMean;
							showStr += _wordData.wordSymbol;
							words.push(_wordData);
						}else{
							BitmapFontUtils.init(showStr,bgVec,new TextFormat("HeiTi",60));
							symbol.textRendererProperties.textFormat =  new BitmapFontTextFormat("dHei",30,0x000000);
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
								for(var j:int = 0;j<words.length;j++){
									if(selectedCard.wordId == words[j].wordid){
										words[j].wordStatus = "Y";
									}
								}
								changeWordCardStatus(true);
							}else if(PackData.app.CmdOStr[1] =="N"){
								for(var k:int = 0;k<words.length;k++){
									if(selectedCard.wordId == words[k].wordid){
										words[k].wordStatus = "N";
									}
								}
								changeWordCardStatus(false);
							}
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
			
			_fsm.addState(CHOOSE,{enter:enterChoose,exit:exitChoose,from:[BLANK,SELECTED,LEARN]});
			_fsm.addState(SELECTED,{enter:enterSelected,exit:exitSelected,from:[CHOOSE,BLANK]});
			_fsm.addState(BLANK,{from:[CHOOSE,DEAL,MUTI_CHOOSE,LEARN,SELECTED]});
			_fsm.addState(PLAY,{enter:enterPlay,from:[SELECTED]});
			_fsm.addState(START,{enter:enterStart,exit:exitStart,from:["*"]});
			_fsm.addState(DEAL,{enter:enterDeal,from:[START]});
			_fsm.addState(GATHER,{enter:enterGather,from:[CHOOSE,SELECTED,MUTI_CHOOSE,BLANK,DEAL]});
			_fsm.addState(SHUFFLE,{enter:enterShuffle,from:[GATHER]});
			_fsm.addState(MUTI_CHOOSE,{enter:enterMutiChoose,from:[BLANK]});
			_fsm.addState(FILTER,{enter:enterFilter,from:[MUTI_CHOOSE,DEAL]});
			_fsm.addState(LEARN,{enter:enterLearn,from:[FILTER]});
			_fsm.initialState = START;
			camera.moveTo(0,-300,1,0,true);	
			
			chooseCards = new Vector.<WordCard>;
			unChooseCards = new Vector.<WordCard>;
		}		
		
		private var bgVec:Vector.<flash.display.DisplayObject> 
		private function initWordCard():void
		{
			startPoint = new Point(200,-300);
			
			cardHolder = new starling.display.Sprite;
			
			cards = new Vector.<WordCard>;
			
			remenberCards = new Vector.<WordCard>;
			unRememberCards = new Vector.<WordCard>;
			allCard = new Vector.<WordCard>;
			
			discards = new Vector.<WordCard>;
			gap = 4;
			
			
			bgVec = new Vector.<flash.display.DisplayObject>;

			var wordCardBmp1:Bitmap = new Bitmap(Assets.store["wordCard"].bitmapData);
			wordCardBmp1.name = "bg";
			bgVec.push(wordCardBmp1);
			
			var wordCardBmp2:Bitmap = new Bitmap(Assets.store["wordCarded"].bitmapData);
			wordCardBmp2.name ="green";
			bgVec.push(wordCardBmp2)
				
			BitmapFontUtils.init(showStr,bgVec,new TextFormat("HeiTi",60));

			
			camera = new CameraSprite(new Rectangle(0,0, WorldConst.stageWidth, WorldConst.stageHeight), null, .3, .1, .01);
			view.addChild(camera);
			
			
			camera.addChild(cardHolder);
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(HorizontalScrollerMediator,[cards.length*viewGap,0,hotY],SwitchScreenType.SHOW,view)]);
			
			
			discardHolder = new starling.display.Sprite;
			view.addChild(discardHolder);
			
			
			choosePoint = new Point;
			startTouchPoint = new Point;
			
			var matrix:Vector.<Number>= Vector.<Number>([0.3086, 0.6094, 0.0820, 0, 0,  
				0.3086, 0.6094, 0.0820, 0, 0,  
				0.3086, 0.6094, 0.0820, 0, 0,  
				0,      0,      0,      1, 0]);  
			
			filter = new ColorMatrixFilter(matrix);
			
			
			startBtn = new starling.display.Button(Assets.getWordCardAtlasTexture("startBtn"));
			startBtn.x = 560;
			startBtn.y = 200;
			startBtn.filter = filter;
			startBtn.touchable = false;
			startBtn.addEventListener(Event.TRIGGERED,startBtnHandle);
			view.addChild(startBtn);
			
			selectTaBtn = new TabBar();
			selectTaBtn.x = 500;
			selectTaBtn.y = 350;
			selectTaBtn.gap = 20;
			selectTaBtn.dataProvider = new ListCollection([ {label:"全选"},
															{label:"未学会"},
															{label:"已学会"}
														]);
			selectTaBtn.customTabName = "selectWordCard";
//			selectTaBtn.tabFactory = selectTaBtnFactory;
//			selectTaBtn.tabProperties.stateToSkinFunction = null;	
			var boldFontDescription1:FontDescription = new FontDescription("dHei");
			selectTaBtn.tabProperties.@defaultLabelProperties.elementFormat = new ElementFormat(boldFontDescription1,24, 0x26746F);
			selectTaBtn.tabProperties.@defaultSelectedLabelProperties.elementFormat =  new ElementFormat(boldFontDescription1, 24,0x26746F)
			selectTaBtn.selectedIndex = 0;
			view.addChild(selectTaBtn);
			selectTaBtn.addEventListener(Event.CHANGE,selectWordCardHandler);
			
			
			backBtn = new starling.display.Button(Assets.getWordCardAtlasTexture("backBtn"));
			backBtn.x = 10;
			backBtn.y = 10;
			backBtn.addEventListener(Event.TRIGGERED,backBtnHandle);
			view.addChild(backBtn);
			
			
			explainTaBtn = new TabBar();
			explainTaBtn.x = -35;
			explainTaBtn.y = -160;
			explainTaBtn.width =350;
			explainTaBtn.gap = -1
			explainTaBtn.dataProvider = new ListCollection([   { label: "基本学习"},
															   { label: "例句"},
															   { label: "记忆方法"}
															]);
			explainTaBtn.customTabName = "WordCardTabBar";
			explainTaBtn.tabFactory = explainTaBtnFactory;
			explainTaBtn.tabProperties.stateToSkinFunction = null;	
			var boldFontDescription:FontDescription = new FontDescription("dHei");
			explainTaBtn.tabProperties.@defaultLabelProperties.elementFormat = new ElementFormat(boldFontDescription,24, 0xffffff);
			explainTaBtn.tabProperties.@defaultSelectedLabelProperties.elementFormat =  new ElementFormat(boldFontDescription, 24,0xAE7C29)
			explainTaBtn.selectedIndex = 0;
			explainTaBtn.addEventListener( Event.CHANGE, changeExplainHandler );
			
			remember = new Image(Assets.getWordCardAtlasTexture("getWord"))
			remember.x = 25;
			remember.y = 100;
			remember.scaleX = 0.8;
			remember.scaleY = 0.8;
			
			
			turnBtn = new starling.display.Button(Assets.getWordCardAtlasTexture("warningBtn"));
			turnBtn.x = 340;
			turnBtn.y = 20;
			turnBtn.scaleX = 1.3;
			turnBtn.scaleY = 1.3;
			turnBtn.addEventListener(Event.TRIGGERED,turnBtnHandler);
			
			voiceBtn = new starling.display.Button(Assets.getWordCardAtlasTexture("playBtn"));
			voiceBtn.x = 80;
			voiceBtn.y = 250;
			
			
			symbol = BitmapFontUtils.getLabel();
			symbol.x = 130;
			symbol.y = 250;
			symbol.textRendererProperties.textFormat =  new BitmapFontTextFormat("dHei",30,0x000000);
			symbol.textRendererProperties.embedFonts  = true;
			
		}
		
		
		private var select:String
		private function selectWordCardHandler(event:Event):void
		{
			view.touchable = false;
			switch(selectTaBtn.selectedItem.label)
			{
				case "全选":
				{
					select= "";
					recylePool();
					recyleUnremenberPool();
					recyleRemenberPool();
					shuffleFun = reSelect;
					sendNotification(WorldConst.SET_ROLL_TARGETX,-startPoint.x);
					_fsm.changeState(GATHER);
					break;
				}
				case "未学会":
				{
					select = "N";
					recylePool();
					recyleUnremenberPool();
					recyleRemenberPool();
					shuffleFun = reSelect;
					sendNotification(WorldConst.SET_ROLL_TARGETX,-startPoint.x);
					_fsm.changeState(GATHER);
					break;
				}
				case "已学会":
				{
					select = "Y";
					recylePool();
					recyleUnremenberPool();
					recyleRemenberPool();
					shuffleFun = reSelect;
					sendNotification(WorldConst.SET_ROLL_TARGETX,-startPoint.x);
					_fsm.changeState(GATHER);
					break;
				}
			}
		}
		
		private function recyleRemenberPool():void
		{
			for(var i:int = 0;i<remenberCards.length;i++){
				pool.object = remenberCards[i];
			}
		}
		
		private function recyleUnremenberPool():void
		{
			for(var i:int = 0;i<unRememberCards.length;i++){
				pool.object = unRememberCards[i];
			}
		}
		
		
		private function recylePool():void
		{
			for (var i:int = 0; i < allCard.length; i++) 
			{
				pool.object = allCard[i];
			}		
		}
		
		private function selectTaBtnFactory():feathers.controls.Button
		{
			var tab:feathers.controls.Button = new feathers.controls.Button();
			return tab;
		}
		
		private var num:int = 0;
		private function explainTaBtnFactory():feathers.controls.Button{
			var tab:feathers.controls.Button = new feathers.controls.Button();
			tab.defaultSkin = new Image(Assets.getWordCardAtlasTexture("study"));
			tab.defaultSelectedSkin = new Image(Assets.getWordCardAtlasTexture("example"));
			tab.downSkin = new Image(Assets.getWordCardAtlasTexture("memory"));
			return tab;
		}	
		
		private function changeExplainHandler(event:Event):void
		{
			switch(explainTaBtn.selectedItem.label)
			{
				case "基本学习":
				{
					selectedCard.backField.text = words[selectedCard.id].wordMean
					break;
				}
				case "例句":
				{
					selectedCard.backField.text = "asfdasdf";
					break;
				}
				case "记忆方法":
				{
					selectedCard.backField.text	= "124324353";
					break;
				}
			}
		}
		
		private var wordCardBmp:Bitmap;
		override public function listNotificationInterests():Array
		{
			return [WorldConst.UPDATE_CAMERA,QRYWRONGWORD,CHGWRONGWORDMARK];
		}
		
		
		override public function onRegister():void
		{
			var background:Image;
			background = new Image(Assets.getTexture("wordBackground"));
			view.addChild(background);
			
			getWordList("");
			sendNotification(CoreConst.HIDE_STARUP_INFOR);
			initWordCard();
			
		}
		
	
		
		private function getWordList(status:String):void
		{
			words.length = 0;
			if(cards != null){
				cards.length = 0;
			}
			PackData.app.CmdIStr[0] = CmdStr.QRYWRONGWORD;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID;
			PackData.app.CmdIStr[2] = 0;
			PackData.app.CmdIStr[3] = 50;
			PackData.app.CmdIStr[4] = status;
			PackData.app.CmdInCnt = 5;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(QRYWRONGWORD));
		}		
		
		
		private function turnBtnHandler():void
		{
			if(selectedCard){
				selectedCard.isBack = !selectedCard.isBack;
				if(selectedCard.isBack){
					turnBtn.x = 20;
					turnBtn.y = 20;
					voiceBtn.visible = false;
					symbol.visible = false;
					remember.visible = false;
				}else{
					turnBtn.x = 340;
					turnBtn.y = 20;
					voiceBtn.visible = true;
					symbol.visible = true;
					remember.visible = true;
				}
			}
			
		}
		
		
		private var startBtn:starling.display.Button
		private var backBtn:starling.display.Button
		
		
		private function backBtnHandle():void
		{
			shuffleFun = recover;
			sendNotification(WorldConst.SET_ROLL_TARGETX,-startPoint.x);
			_fsm.changeState(GATHER);
		}
		
		
		private function recover():void{
			cards.length = 0;
			cards = backupCards;
			
			for (var i:int = 0; i < cards.length; i++) 
			{
				cards[i].x = startPoint.x;
				cards[i].y = startPoint.y;
				cards[i].isChoosed = false;
				cards[i].rest();
				cardHolder.addChildAt(cards[i],0);
				
			}
			changeMulti();
			sendNotification(WorldConst.SET_HSCROLL_RL,[cards.length*viewGap,0]);
			
		}
		
		private function reSelect():void
		{
			recyleAllCards();
			creatCard();
			
			
			cards.length = 0;
			if(select == "Y"){
				cards = remenberCards;
			}else if(select == "N"){
				cards = unRememberCards;
			}else if(select == ""){
				cards = allCard;
			}
			for (var i:int = 0; i < cards.length; i++) 
			{
				cards[i].x = startPoint.x;
				cards[i].y = startPoint.y;
				cards[i].isChoosed = false;
				cards[i].rest();
				cardHolder.addChildAt(cards[i],0);
				
			}
			changeMulti();
			sendNotification(WorldConst.SET_HSCROLL_RL,[cards.length*viewGap,0]);
		}
		
		
		private function creatCard():void
		{
			var wordCard:WordCard
			remenberCards.length = 0
			unRememberCards.length = 0;
			allCard.length = 0;
			for (var i:int = 0; i < words.length; i++) 
			{
				wordCard = pool.object;
				wordCard.id = i;
				wordCard.wordId = words[i].wordid;
				wordCard.vo = words[i];
				wordCard.x = startPoint.x;
				wordCard.y = startPoint.y;
				if(words[i].wordStatus == "Y"){
					wordCard.creatgeenWordCardBackground(BitmapFontUtils.getTexture("green_00000"));
					wordCard.isRemember = true;
					remenberCards.push(wordCard);
				}else if(words[i].wordStatus == "N"){
					wordCard.creatgeenWordCardBackground(BitmapFontUtils.getTexture("bg_00000"));
					wordCard.isRemember = false;
					unRememberCards.push(wordCard);
				}
				cards.push(wordCard);
				allCard.push(wordCard);
			}
		}
		
		private function startBtnHandle():void
		{
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
		
		
		private function unselectAllBtnHandle():void
		{
			for (var i:int = 0; i < cards.length; i++) 
			{
				if(cards[i].isChoosed){
					cards[i].isChoosed = false;
					TweenLite.to(cards[i],0.4,{y:0});
				}
			}
			
			chooseCards.length=0;
			TweenLite.to(cloud,1,{y:0});
		}
		
		private function selectAllBtnHandle():void
		{
			for (var i:int = 0; i < cards.length; i++) 
			{
				if(!cards[i].isChoosed){
					cards[i].isChoosed = true;
					cards[i].backvo = words[i];
					chooseCards.push(cards[i]);
					TweenLite.to(cards[i],0.4,{y:-120});
				}
			}
			
			TweenLite.to(cloud,1,{y:-200});
		}
		
		
		
		private var mutiBtn:feathers.controls.Button;
		private function mutiBtnHandle():void
		{
			if(isMuti){
				mutiBtn.label = "muti";
				chageSingle();
				unselectAllBtnHandle();
			}else{
				mutiBtn.label = "single";
				changeMulti();
				
			}
			
		}
		
		private function changeMulti():void{
			isMuti = true;
			_fsm.changeState(BLANK);
/*			TweenLite.killDelayedCallsTo(addEventHandler);
			TweenLite.delayedCall(3,addEventHandler);*/
			addEventHandler();
	
		}
		
		private function addEventHandler():void
		{
			view.stage.removeEventListener(TouchEvent.TOUCH,selectStageTouchHandle);
			view.stage.addEventListener(TouchEvent.TOUCH,mutiChooseStageTouchHandle);			
		}
		
		private function chageSingle():void{
			isMuti = false;
			_fsm.changeState(BLANK);
		/*	TweenLite.killDelayedCallsTo(removeEvent);
			TweenLite.delayedCall(4,removeEvent);*/
			removeEvent();
		}
		
		private function removeEvent():void
		{
			view.stage.removeEventListener(TouchEvent.TOUCH,mutiChooseStageTouchHandle);
			view.stage.addEventListener(TouchEvent.TOUCH,selectStageTouchHandle);
		}
		
		private function enterLearn(event:StateMachineEvent):void{
			startBtn.visible = false;
			selectTaBtn.visible = false
			isSorting = false;
			backBtn.visible = true;
			cleanUnChooseCards();
			layCards();
			
		}
		
		private function enterFilter(event:StateMachineEvent):void{
			
			unChooseCards.length = 0;
			isSorting = true;
			gap = 4;
			for (var i:int = 0; i < chooseCards.length; i++) 
			{
				chooseCards[i].visible = true;
				cardHolder.addChildAt(chooseCards[i],0);
				TweenLite.to(chooseCards[i],1,{x:i*gap});
			}
			
			
			for (var j:int = 0; j < cards.length; j++) 
			{
				if(!cards[j].isChoosed){
					unChooseCards.push(cards[j]);
					TweenLite.to(cards[j],1,{y:400});
				}
				
			}
			
			backupCards = cards;
			cards = chooseCards;
			sendNotification(WorldConst.SET_HSCROLL_RL,[cards.length*viewGap,0]);
			TweenLite.delayedCall(1.5,_fsm.changeState,[LEARN]);
			
			sendNotification(WorldConst.SET_ROLL_TARGETX,-startPoint.x);
		}
		
		private function cleanUnChooseCards():void{
			
			for (var i:int = 0; i < unChooseCards.length; i++) 
			{
				unChooseCards[i].removeFromParent();
			}
			
		}
		
		
		
		private function layCards():void{
			chageSingle();
			gap = viewGap;
			for (var i:int = 0; i < cards.length; i++) 
			{
				cards[i].visible = true;
				cards[i].isChoosed = false;
				cards[i].ox = i*gap;
				cardHolder.addChildAt(cards[i],0);
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
				startBtn.filter = null;
				startBtn.touchable = true;
				selectTaBtn.visible = false;
			}else{
				startBtn.filter = filter;
				startBtn.touchable = false;
				selectTaBtn.visible = true;
			}
	
		}
		
		
		private function enterShuffle(event:StateMachineEvent):void{
			shuffleFun.apply();
		}
		
		
		private function shuffle():void{
			cards = randomArr(cards);
			
			for (var i:int = 0; i < cards.length; i++) 
			{
				cardHolder.setChildIndex(cards[i],0);
			}
			
		}
		
		
		private function enterGather(event:StateMachineEvent):void{
			isSorting = true;
			gap = 4;
			for (var i:int = 0; i < cards.length; i++) 
			{
				cards[i].visible = true;
				cards[i].y = 0;
				TweenLite.to(cards[i],1,{x:i*gap});
			}
			view.touchable = false;
			TweenLite.delayedCall(1.5,activesCards);
			TweenLite.delayedCall(1.5,backStartPoint);
			
			
			
		}
		
		private function backStartPoint():void{
			sortCount = 0;
			var i:int;
			for (i = 0; i < cards.length; i++) 
			{
				TweenLite.to(cards[i],Math.random()*0.5+0.3,{delay:Math.random()*1,x:startPoint.x,y:startPoint.y,onComplete:gatherCardsComplete,onCompleteParams:[cards[i]]});
			}
		}
		
		private function exitStart(event:StateMachineEvent):void{
		}
		
		
		
		private function enterStart(event:StateMachineEvent):void{
			isSorting = false;
			var wordCard:WordCard;
			if(event.fromState==null){
				recyleAllCards();
				creatWordCard("");
				sendNotification(WorldConst.SET_HSCROLL_RL,[cards.length*viewGap,0]);
			}
			
			_fsm.changeState(DEAL);
			
			
		}
		private function creatWordCard(select:String):void
		{
			var wordCard:WordCard;
			cards.length = 0;
			if(select == ""){
				for (var i:int = 0; i < words.length; i++) 
				{
					wordCard = pool.object;
					wordCard.id = i;
					wordCard.wordId = words[i].wordid;
					wordCard.vo = words[i];
					wordCard.x = startPoint.x;
					wordCard.y = startPoint.y;
					if(words[i].wordStatus == "Y"){
						wordCard.creatgeenWordCardBackground(BitmapFontUtils.getTexture("green_00000"));
						wordCard.isRemember = true;
					}else if(words[i].wordStatus == "N"){
						wordCard.creatgeenWordCardBackground(BitmapFontUtils.getTexture("bg_00000"));
						wordCard.isRemember = false;
					}
					cards.push(wordCard);
					cardHolder.addChildAt(wordCard,0);
				}
			}
		}
		
		private function enterDeal(event:StateMachineEvent):void{
			deal();
		}
		
		private function sortBtnHandle():void{
			shuffleFun = shuffle;
			sendNotification(WorldConst.SET_ROLL_TARGETX,-startPoint.x);
			_fsm.changeState(GATHER);
		}
		
		private function activesCards():void{
			
			for (var i:int = 0; i < cards.length; i++) 
			{
				cards[i].rest();
			}
			
		}
		
		private function randomCards():void{
			
			sortCount = 0;
			for (var i:int = 0; i < cards.length; i++) 
			{
				TweenLite.to(cards[i],Math.random()*0.5+0.3,{delay:Math.random()*1,x:startPoint.x,y:startPoint.y,onComplete:gatherCardsComplete,onCompleteParams:[cards[i]]});
			}
			
		}
		
		
		private function gatherCardsComplete(card:WordCard):void{
			sortCount++;
			if(sortCount!=cards.length){
				card.visible = false;
			}else{
				_fsm.changeState(SHUFFLE);
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
			
			startBtn.visible = true;
			if(chooseCards.length == 0){
				startBtn.filter = filter;
				startBtn.touchable = false;
				selectTaBtn.visible = true;
			}
			backBtn.visible = false;
			gap = viewGap;
			
			for (var i:int = 0; i < cards.length; i++) 
			{
				TweenLite.to(cards[i],1,{x:i*gap});
				
			}
			selectTaBtn.touchable = true;
			view.touchable = true;
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
		
		
		
		
		private function tweenCard(card:WordCard):void{
			card.active();
			card.visible = true;
			TweenLite.to(card,0.3+Math.random()*0.5,{x:400,y:300,onComplete:tweenCardHandle,onCompleteParams:[card]});
			
		}
		
		private function tweenCardHandle(card:WordCard):void{
			sortCount++;
			if(sortCount!=discardHolder.numChildren){
				card.visible = false;
			}
		}
		
		
		private function playBtnHandle():void
		{
			_fsm.changeState(PLAY);
		}
		
		private function sortCards(beginIdx:int=0):void{
			
			for (var i:int = beginIdx; i < cards.length; i++) 
			{
				
				if(cards[i].visible){
					TweenLite.to(cards[i],0.2,{x:cards[i].x-gap});
				}else{
					cards[i].x = gap*i;
				}
			}
			
		}
		
		private function enterPlay(event:StateMachineEvent):void{
			
			discardHolder.addChild(selectedCard);
			
			var p:Point = new Point(selectedCard.x,selectedCard.y);
			var result:Point = new Point;
			cardHolder.localToGlobal(p,result);
			selectedCard.x = result.x;
			selectedCard.y = result.y;
			
			TweenLite.to(selectedCard,1,{x:1200,y:140});
			discards.push(selectedCard);
			
			
		}
		
		
		private function exitSelected(event:StateMachineEvent):void{
			if(selectedCard.isBack){
				selectedCard.isBack = false;
			}
			selectedCard.rest();
			TweenLite.to(selectedCard,0.4,{y:0,x:selectedCard.ox});
			preSelectedCard = selectedCard;
			selectedCard = null;
			sendNotification(WorldConst.SET_ROLL_SCREEN,true);
			TweenLite.killTweensOf(changeSelectMode);
			view.stage.removeEventListener(TouchEvent.TOUCH,detecDragAixHandle);
			
		}
		
		
		private function enterSelected(event:StateMachineEvent):void{
			
			
			selectedCard = currentCard;
			
			if(!selectedCard.isActive){
				selectedCard.activeScale();
				selectedCard.backHolder.addChild(explainTaBtn);
				turnBtn.x = 340;
				turnBtn.y = 20;
				selectedCard.addChild(turnBtn);
				selectedCard.addChild(voiceBtn);
				selectedCard.addChild(symbol);
				selectedCard.bg.alpha = 1;
				selectedCard.geen.alpha = 1;
				explainTaBtn.selectedIndex = 0;
				symbol.text = selectedCard.symbolText
				voiceBtn.visible = true;
				symbol.visible = true;
				if(selectedCard.isRemember){
					selectedCard.addChild(remember);
					remember.visible = true;
					selectedCard.addChildAt(selectedCard.bg,0);
				}else{
					selectedCard.addChildAt(selectedCard.geen,0);
				}
				TweenLite.to(selectedCard,0.5,{y:-350});
				sendNotification(WorldConst.SET_ROLL_TARGETX,-int(selectedCard.x));
				changeSelectMode();
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
				
				//				touch.getLocation(cardHolder,choosePoint);
				touch.getMovement(cardHolder,choosePoint);
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
				if(selectedCard.x>selectedCard.ox+50){
					idx = cards.indexOf(selectedCard);
					
					idx++;
					if(idx>cards.length-1){
						idx = cards.length-1;
					}
					currentCard = cards[idx];
					
					_fsm.changeState(BLANK);
					_fsm.changeState(SELECTED);
				}else if(selectedCard.x<selectedCard.ox-50){
					idx = cards.indexOf(selectedCard);
					
					idx--;
					if(idx<0){
						idx = 0;
					}
					currentCard = cards[idx];
					
					_fsm.changeState(BLANK);
					_fsm.changeState(SELECTED);
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
				touch.getMovement(cardHolder,choosePoint);
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
				if(!Global.isLoading&&selectedCard.y<-445){
					if(turn){
						turn = false;
						changeStatus();
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
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(CHGWRONGWORDMARK));
		}
		
		private function changeWordCardStatus(select:Boolean):void
		{
			
			if(selectedCard.isRemember){
				selectedCard.creatWordCardBackground(BitmapFontUtils.getTexture("bg_00000"));
				selectedCard.removeChild(remember);
				selectedCard.bg.alpha = 1;
				selectedCard.geen.alpha = 0;
				selectedCard.isRemember = false;

			}else{
				selectedCard.creatgeenWordCardBackground(BitmapFontUtils.getTexture("green_00000"));
				selectedCard.addChild(remember);
				selectedCard.geen.alpha = 1;
				selectedCard.bg.alpha = 0;
				if(selectedCard.isBack){
					remember.visible = false;
				}else{
					remember.visible = true;
				}
				selectedCard.isRemember = true;
			}
		}
		
		private function exitChoose(event:StateMachineEvent):void{
			TweenLite.to(choosedCard,0.4,{y:0});
			choosedCard.isChoosed = false;
			choosedCard = null;
		}
		
		
		
		private function enterChoose(event:StateMachineEvent):void{
			choosedCard = currentCard;
			currentCard.isChoosed = true;
			TweenLite.to(choosedCard,0.4,{y:-120});
		}
		
		
		
		private function mutiChooseStageTouchHandle(event:TouchEvent):void{
			
			var touch:Touch = event.getTouch(cardHolder);
			trace("touch");
			if(touch&&touch.globalY>hotY){
				
				touch.getLocation(cardHolder,choosePoint);
				var item:starling.display.DisplayObject = cardHolder.hitTest(choosePoint);
				var touchCard:WordCard;
				if(item){
					touchCard = item.parent as WordCard;
				}
				
				
				if(!touchCard){
					return;
				}
				
				if(touch.phase==TouchPhase.BEGAN){
					hasMove = false;
					trace("began");
					sendNotification(WorldConst.CHANGE_HSCROLL_DIRECTION,-1);
				}else if(touch.phase==TouchPhase.MOVED&&currentCard != touchCard){
					hasMove = true;
					
					currentCard = touchCard;
					
					_fsm.changeState(BLANK);
					_fsm.changeState(MUTI_CHOOSE);
					trace("move");
					
					
				}else if(touch.phase==TouchPhase.ENDED&&!hasMove){
					currentCard = touchCard;
					_fsm.changeState(BLANK);
					_fsm.changeState(MUTI_CHOOSE);
					currentCard = null;
					sendNotification(WorldConst.CHANGE_HSCROLL_DIRECTION,1);
					trace("end1");
				}
				
				
			}else{
				trace("else");
				sendNotification(WorldConst.CHANGE_HSCROLL_DIRECTION,1);
			}
			
			
		}
		
		
		
		private function selectStageTouchHandle(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(cardHolder);
			
			
			if(touch&&touch.globalY>hotY){
				
				touch.getLocation(cardHolder,choosePoint);
				var item:starling.display.DisplayObject = cardHolder.hitTest(choosePoint);
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
					_fsm.changeState(BLANK);
					_fsm.changeState(SELECTED);
					sendNotification(WorldConst.CHANGE_HSCROLL_DIRECTION,1);
				}
				
				
			}else{
				sendNotification(WorldConst.CHANGE_HSCROLL_DIRECTION,1);
			}
			
			
		}
		
		
	override public function onRemove():void
	{
		view.removeChild(symbol,true);
		_fsm.canChangeStateTo(_fsm.state);
		removeTweenLite();
		removeEventHandler();
/*		TweenLite.killTweensOf(selectedCard);
		TweenLite.killTweensOf(cloud);
		TweenLite.killTweensOf(choosedCard);
		TweenLite.killTweensOf(currentCard);
		TweenLite.killDelayedCallsTo(startRestCards);
		TweenLite.killDelayedCallsTo(activesCards);
		TweenLite.killDelayedCallsTo(backStartPoint);
		TweenLite.killDelayedCallsTo(restCards);
		TweenLite.killDelayedCallsTo(_fsm.changeState);*/
/*		view.stage.removeEventListener(TouchEvent.TOUCH,mutiChooseStageTouchHandle);
		view.stage.removeEventListener(TouchEvent.TOUCH,selectStageTouchHandle);
		view.stage.removeEventListener(TouchEvent.TOUCH,selectedCardYAixControlHandle);
		view.stage.removeEventListener(TouchEvent.TOUCH,detecDragAixHandle);*/
/*		for (var a:int = 0; a < cards.length; a++) 
		{
			TweenLite.killTweensOf(cards[a]);
		}
		for (var i:int = 0; i < chooseCards.length; i++) 
		{
			TweenLite.killTweensOf(chooseCards[i]);
		}*/
		super.onRemove();
		
	}
	
	private function removeEventHandler():void
	{
		view.stage.removeEventListener(TouchEvent.TOUCH,mutiChooseStageTouchHandle);
		view.stage.removeEventListener(TouchEvent.TOUCH,selectStageTouchHandle);
		view.stage.removeEventListener(TouchEvent.TOUCH,selectedCardYAixControlHandle);
		view.stage.removeEventListener(TouchEvent.TOUCH,detecDragAixHandle);
	}
	
	private function removeTweenLite():void
	{
		TweenLite.killTweensOf(selectedCard);
		TweenLite.killTweensOf(cloud);
		TweenLite.killTweensOf(choosedCard);
		TweenLite.killTweensOf(currentCard);
		TweenLite.killDelayedCallsTo(startRestCards);
		TweenLite.killDelayedCallsTo(activesCards);
		TweenLite.killDelayedCallsTo(backStartPoint);
		TweenLite.killDelayedCallsTo(restCards);
		TweenLite.killDelayedCallsTo(_fsm.changeState);
//		TweenLite.killDelayedCallsTo(touchSelectHandler);
		for (var a:int = 0; a < cards.length; a++) 
		{
			TweenLite.killTweensOf(cards[a]);
		}
		for (var i:int = 0; i < chooseCards.length; i++) 
		{
			TweenLite.killTweensOf(chooseCards[i]);
		}
	}
		
	}
}