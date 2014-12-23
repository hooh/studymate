package com.studyMate.world.screens.wordcards
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.utils.BitmapFontUtils;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.component.vo.WordCardVO;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.FocusEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	
	import mx.utils.StringUtil;
	
	import feathers.data.ListCollection;
	
	import myLib.myTextBase.TextFieldHasKeyboard;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class RememberWordCardMediator extends ScreenBaseMediator
	{
		
		private const NAME:String = "RememberWordCardMediator";
		
		private const QRYWRONGWORD:String = "QryWrongWord";
		private const CHGWRONGWORDMARK:String = "ChgWrongWordMark";
		private const SEARCHWRONGWORD:String = "SearchWrongWord";
		
		private var RememberListVec:ListCollection;
		
		private var words:Vector.<WordCardVO>;
		private var nowWords:Vector.<WordCardVO>;
		
		private var searchVec:Vector.<WordCardVO>;
//		private var searchWord:Vector.<WordCardVO>;
		private var rememberCard:Vector.<RememberCard>;
		private var searchRememberCard:Vector.<RememberCard>;
		private var tempRememberCard:Vector.<RememberCard>

		
		private var pool:RememberCardPool
		
		private var bgVec:Vector.<flash.display.DisplayObject>
		private var showStr:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
		
		
		
		private var wordBackground:Sprite;
		
		private var _preBtn:starling.display.Button
		private var _nextBtn:starling.display.Button
		

		
		public function RememberWordCardMediator(viewComponent:Object = null)
		{
			super(NAME,viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		public function get view():Sprite
		{
			return getViewComponent()as Sprite;
		}
		
		
		private var tip:TextField;
		private var studyNum:TextField;
		private var quadWord:Quad;
		private var wordText:TextFieldHasKeyboard;
		private var clear:starling.display.Button;
		override public function onRegister():void
		{
			
			sendNotification(WorldConst.HIDE_MAIN_MENU);
			var quad:Quad = new Quad(Global.stageWidth,Global.stageHeight,0xedd597);
			view.addChild(quad);
			
			
			quadWord= new Quad(1200,550,0xedd597);
			
			bgVec = new Vector.<flash.display.DisplayObject>;
			
			var wordCardBmp1:Bitmap = new Bitmap(Assets.store["rememberCard"].bitmapData);
			wordCardBmp1.name = "bg";
			bgVec.push(wordCardBmp1);
			
			var wordCardBmp2:Bitmap = new Bitmap(Assets.store["rememberCard1"].bitmapData);
			wordCardBmp2.name ="green";
			bgVec.push(wordCardBmp2)
			
			BitmapFontUtils.init(showStr,bgVec,new TextFormat("HeiTi",36,0,false,false,null,null,null,"center"));
			
			
			rememberCard = new Vector.<RememberCard>();
			tempRememberCard = new Vector.<RememberCard>;
			searchRememberCard = new Vector.<RememberCard>;
			
			tip = new TextField(500,50,"我记住了                     个错词了！","HeiTi",20,0x5E3310,true);
			tip.x = 15;
			tip.y = 30;
			tip.vAlign = VAlign.TOP;
			tip.hAlign = HAlign.LEFT;
			view.addChild(tip);
			
			studyNum = new TextField(150,50,"","HeiTi",48,0x3F8F18,true);
			studyNum.x = 85;
			studyNum.y = 20;
			studyNum.vAlign = VAlign.CENTER;
			studyNum.hAlign = HAlign.CENTER;
			view.addChild(studyNum);
			
			words = new Vector.<WordCardVO>;
			nowWords = new Vector.<WordCardVO>;
//			preWords = new Vector.<WordCardVO>;
//			nextWords = new Vector.<WordCardVO>;
			searchVec = new Vector.<WordCardVO>;
			RememberListVec = new ListCollection();
			
			getWordList(_getwords);
			
/*			rememberScroller = new Scroller();
			rememberScroller.x = 25;
			rememberScroller.y = 90;
			rememberScroller.width = 1260;
			rememberScroller.height = 590;
			rememberScroller.snapToPages = true;
			rememberScroller.pageHeight = 620;
			rememberScroller.verticalScrollPolicy = "off";
			viewPort = new LayoutViewPort();
			view.addChild(rememberScroller);
			rememberScroller.viewPort = viewPort;
			viewPort.addChild(quadWord);*/
		
			
			wordBackground = new Sprite();
			wordBackground.x = 25;
			wordBackground.y = 90;
			wordBackground.width = 1260;
			wordBackground.height = 590;
			view.addChild(wordBackground);
			
/*			rememberList = new List();
			rememberList.x = 15;
			rememberList.y = 90;
			rememberList.width = 1260;
			rememberList.height = 550;
			rememberList.snapToPages = true;
			rememberList.pageHeight = 580;
//			rememberList.itemRendererType = RememberWordCardItemRender;
			viewPort = new LayoutViewPort();
//			view.addChild(rememberList);
//			viewPort.addChild(nowWordList);
//			viewPort.addChild(preWordList);
//			viewPort.addChild(nextWordList);
			rememberList.viewPort = viewPort;*/
//			rememberList.addEventListener(FeathersEventType.SCROLL_COMPLETE,testHandler);


			
/*			var _button:starling.display.Button = new starling.display.Button(Assets.getRememberWordCardAtlasTexture("more")); 
			_button.x = 614
			_button.y = 50
			_button.pivotX = 0.5*_button.width;
			_button.pivotY = 0.5*_button.height;
			_button.visible = false;
			view.addChild(_button);
			_button.addEventListener(Event.TRIGGERED,moreWordHandler);*/
			
			var _searchWord:Image = new Image(Assets.getRememberWordCardAtlasTexture("searchWord"));
			_searchWord.x = 800;
			_searchWord.y = 15;
			view.addChild(_searchWord);
				
			wordText = new TextFieldHasKeyboard();
			var _titleformat:TextFormat = new TextFormat("HeiTi",26,0x000000);
			wordText.x = 800;
			wordText.y = 25;
			wordText.width = 330;
			wordText.height = 45;
			wordText.restrict = "A-Z\a-z"
			wordText.maxChars = 20;
			wordText.defaultTextFormat = _titleformat;
			wordText.prompt = "搜索学会的单词";
			wordText.addEventListener(TextEvent.TEXT_INPUT,showClearBtnHandler);
			wordText.addEventListener(FocusEvent.FOCUS_OUT,hideClearBtnHandler);
			Starling.current.nativeOverlay.addChild(wordText);
			
			clear= new starling.display.Button(Assets.getRememberWordCardAtlasTexture("close"));
			clear.x = 1145;
			clear.y = 35;
			clear.visible= false;
			view.addChild(clear);
			clear.addEventListener(Event.TRIGGERED,clearHandler);
			
			var _searchBtn:starling.display.Button = new starling.display.Button(Assets.getRememberWordCardAtlasTexture("searchBtn"));
			_searchBtn.x = 1190;
			_searchBtn.y = 15;
			view.addChild(_searchBtn);
			_searchBtn.addEventListener(Event.TRIGGERED,searchHandler);
			
			pool = new RememberCardPool();
			
			_preBtn = new starling.display.Button(Assets.getRememberWordCardAtlasTexture("leftBtn"));
			_preBtn.x = 5;
			_preBtn.y = 350;
			_preBtn.visible = false;
			view.addChild(_preBtn);
			_preBtn.addEventListener(Event.TRIGGERED,preWordCardHandler);
			
			_nextBtn = new starling.display.Button(Assets.getRememberWordCardAtlasTexture("rightBtn"));
			_nextBtn.x = 1235;
			_nextBtn.y = 350;
			view.addChild(_nextBtn);
			_nextBtn.addEventListener(Event.TRIGGERED,nextWordCardHandler);
			
		}
		
		
		private var start:Number = 0;
		private function nextWordCardHandler():void
		{
			if(!Global.isLoading&&searchVec.length == 0){
				if((_getwords+20)>=int(studyNum.text)){
					sendNotification(CoreConst.TOAST,new ToastVO("这已经是最后一页了~"));
				}else{
					_preBtn.visible = true;
					start = _getwords;
					_getwords = _getwords+20;
					if(_getwords>=(int(studyNum.text)-20)){
						_nextBtn.visible = false;
					}else{
						_nextBtn.visible = true;
					}
					if(words.length <= _getwords){
						getWordList(_getwords);
					}else{
						wordBackground.removeChildren(0,-1,false);
						recylePool();
						nextPage();
					}
				}
				
			}
		}
		
		private function nextPage():void
		{
			var _rememberCard:RememberCard; 
			btnY = 0;
			wordPosX = 0;
			wordPosY = 0;
			if(_getwords+20<int(studyNum.text)){
				for(var j:int =(_getwords);j<(_getwords+20);j++){
					_rememberCard = pool.object ;
					if(wordPosY==4){
						wordPosX++;
						btnY = btnY+120;
						wordPosY=0;
					}
					_rememberCard.x = 30+wordPosY*295;
					_rememberCard.y = btnY;
					wordPosY++;
					_rememberCard.addWordField();
					_rememberCard.vo = words[j];
					_rememberCard.wordid = words[j].wordid;
					if(words[j].wordStatus == "Y"){
						_rememberCard.creatgeenWordCardBackground(BitmapFontUtils.getTexture("green_00000"));
					}else{
						_rememberCard.creatWordCardBackground(BitmapFontUtils.getTexture("bg_00000"));
					}
					_rememberCard.addEventListener(TouchEvent.TOUCH,changeStatusHandler);
					tempRememberCard.push(_rememberCard);
					wordBackground.addChild(_rememberCard);
				}	
			}else
			{
				for(var i:int =(_getwords);i<words.length;i++){
					_rememberCard = pool.object ;
					if(wordPosY==4){
						wordPosX++;
						btnY = btnY+120;
						wordPosY=0;
					}
					_rememberCard.x = 30+wordPosY*295;
					_rememberCard.y = btnY;
					wordPosY++;
					_rememberCard.addWordField();
					_rememberCard.vo = words[i];
					_rememberCard.wordid = words[i].wordid;
					if(words[i].wordStatus == "Y"){
						_rememberCard.creatgeenWordCardBackground(BitmapFontUtils.getTexture("green_00000"));
					}else{
						_rememberCard.creatWordCardBackground(BitmapFontUtils.getTexture("bg_00000"));
					}
					tempRememberCard.push(_rememberCard);
					_rememberCard.addEventListener(TouchEvent.TOUCH,changeStatusHandler);
					wordBackground.addChild(_rememberCard);
				}	
			}
		
		}
		
		private function preWordCardHandler():void
		{
			if(!Global.isLoading&&searchVec.length==0){
				if(_getwords>=20){
					_nextBtn.visible = true;
					start = _getwords;
					_getwords = _getwords-20;
					if(_getwords>=20){
						_preBtn.visible = true;
					}else{
						_preBtn.visible = false;
					}
					wordBackground.removeChildren(0,-1,false);
					recylePool();
					nextPage();
				}else{
					sendNotification(CoreConst.TOAST,new ToastVO("已经是第一页了~"));
				}
			}
		}
		
		private function recylePool():void
		{
			for(var i:int = 0;i<tempRememberCard.length;i++){
				pool.object = tempRememberCard[i];
			}
			tempRememberCard.length = 0;
			pool.purge();
		}		
		
		
		private function searchHandler():void
		{
			if(!Global.isLoading&&StringUtil.trim(wordText.text).length != 0){
				nowWords.length = 0;
				searchVec.length = 0;
				wordPosX = 0;
				wordPosY = 0;
				btnY = 0;
				_getwords = 0;
				_preBtn.visible = false;
				_nextBtn.visible = false;
				recylePool();
				wordBackground.removeChildren(0,-1,true);
				recyleSearchPool();
				PackData.app.CmdIStr[0] = CmdStr.SEARCHWRONGWORD;
				PackData.app.CmdIStr[1] = PackData.app.head.dwOperID;
				PackData.app.CmdIStr[2] = StringUtil.trim(wordText.text);
				PackData.app.CmdInCnt = 3;
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(SEARCHWRONGWORD));	
			}else{
				_getwords = 0;	
				searchVec.length = 0;
				wordBackground.removeChildren(0,-1,false);
				recylePool();
				_preBtn.visible = false;
				_nextBtn.visible = true;
				recyleSearchPool();
				_preBtn.removeEventListener(Event.TRIGGERED,preSearchWordHandler);	
				_nextBtn.removeEventListener(Event.TRIGGERED,nextSearchWordHandler);
				nextPage()
			}
		}
		
		private function recyleSearchPool():void
		{
			for(var i:int = 0;i<searchRememberCard.length;i++){
				pool.object = searchRememberCard[i];
			}
			searchRememberCard.length =0;
			pool.purge();
		}
		
		protected function hideClearBtnHandler(event:FocusEvent):void
		{
			if(wordText.text.length ==0){
				clear.visible= false;			
			}			
		}
		
		protected function showClearBtnHandler(event:TextEvent):void
		{
			if(wordText.text.length >0){
				clear.visible= true;			
			}
		}
		
		private function clearHandler():void
		{
			wordText.text = "";			
		}		
		
		private var _getwords:Number = 0;
		private function getWordList(_getwords:Number):void
		{
			if(!Global.isLoading){
				recylenowWordPool();
				nowWords.length = 0
				PackData.app.CmdIStr[0] = CmdStr.QRYWRONGWORD;
				PackData.app.CmdIStr[1] = PackData.app.head.dwOperID;
				PackData.app.CmdIStr[2] = _getwords;
				PackData.app.CmdIStr[3] = 20;
				PackData.app.CmdIStr[4] = "N";
				PackData.app.CmdInCnt = 5;
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(QRYWRONGWORD));	
			}
		}		
		
		private function recylenowWordPool():void
		{
			if(rememberCard.length == 0)return;
			for(var i:int = 0;i<rememberCard.length;i++){
				pool.object = rememberCard[i];
			}
			rememberCard.length = 0;
			pool.purge();
		}
		
		override public function listNotificationInterests():Array
		{
			return[QRYWRONGWORD,CHGWRONGWORDMARK,SEARCHWRONGWORD]
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var _result:DataResultVO = notification.getBody()as DataResultVO;
			var _wordData:WordCardVO = new WordCardVO();
			switch(notification.getName())
			{
				case QRYWRONGWORD:
				{
					if(!_result.isErr)
					{
						if(!_result.isEnd){
							_wordData.wordid = PackData.app.CmdOStr[1];
							_wordData.word = PackData.app.CmdOStr[2];
							_wordData.wordStatus = PackData.app.CmdOStr[3];
							_wordData.wordMean = PackData.app.CmdOStr[5];
							_wordData.wrongNum = PackData.app.CmdOStr[10];
							studyNum.text = PackData.app.CmdOStr[12];
							words.push(_wordData);
							nowWords.push(_wordData);
						}else{
							trace(words.length);
							trace(nowWords.length);
							wordBackground.removeChildren(0,-1,false);
							creatWordPage();
						}
					}
					break;
				}
				case CHGWRONGWORDMARK:
				{
					if(!_result.isErr){
						if(PackData.app.CmdOStr[0] == "000"){
							if(PackData.app.CmdOStr[1] =="Y"){
								tempRemember.creatgeenWordCardBackground(BitmapFontUtils.getTexture("green_00000"));
								for(var i:int = 0;i<words.length;i++){
									if(tempRemember.wordid == words[i].wordid){
										words[i].wordStatus = "Y";
									}
								}
								sendNotification(CoreConst.TOAST,new ToastVO("你已经单词标记为忘记~"));
							}else{
								tempRemember.creatgeenWordCardBackground(BitmapFontUtils.getTexture("bg_00000"));
								sendNotification(CoreConst.TOAST,new ToastVO("你已经把单词标记为记住~"));
								for(var j:int = 0;j<words.length;j++){
									if(tempRemember.wordid == words[j].wordid){
										words[j].wordStatus = "N";
									}
								}
							}
			
						}
					}
					break;
				}
				case SEARCHWRONGWORD:
				{
					if(!_result.isErr){
						if(!_result.isEnd){
							_wordData.wordid = PackData.app.CmdOStr[1];
							_wordData.word = PackData.app.CmdOStr[2];
							searchVec.push(_wordData);
						}else{
							if(searchVec.length == 0){
								wordBackground.removeChildren(0,-1,false);
								sendNotification(CoreConst.TOAST,new ToastVO("没有查到相关的单词~"));
							}else{
								creatSearchResult();
							}
						}
					}
				}
			}
		}
		
		private function creatWordPage():void
		{
			var _rememberCard:RememberCard; 
			btnY = 0;
			wordPosX = 0;
			wordPosY = 0;
			if(nowWords.length == 0){
				studyNum.text = "0";
				TweenLite.killDelayedCallsTo(showTipHandler);
				TweenLite.delayedCall(0.5,showTipHandler);
			}
			if(nowWords.length <20||studyNum.text == "20"){
				_nextBtn.visible = false;
			}
			for(var j:int =0;j<nowWords.length;j++){
				_rememberCard = pool.object ;
				_rememberCard.x = int(j%4)*295 + 30;
				_rememberCard.y = int(j/4)*120;
				_rememberCard.vo = nowWords[j];
				_rememberCard.wordid = nowWords[j].wordid;
				_rememberCard.addWordField();
				_rememberCard.wordField.text = nowWords[j].word;
				_rememberCard.text = nowWords[j].word;
				rememberCard.push(_rememberCard);
				_rememberCard.addEventListener(TouchEvent.TOUCH,changeStatusHandler);
				wordBackground.addChild(_rememberCard);
			}
		}
		
		
		private function showTipHandler():void
		{
			sendNotification(CoreConst.TOAST,new ToastVO("你还没有记住的错词哦，好好努力吧！"));
		}
		
		private var wordPosX:Number =0;
		private var wordPosY:Number = 0;
		private var btnY:Number = 0;
		
		private function creatSearchResult():void
		{
			wordPosX = 0;
			wordPosY = 0;
			btnY = 0;
			_getwords =0;
			var _temp:int = 0;
			tab = true;
			search = 0;
			var _rememberCard:RememberCard;
			if(searchVec.length>20){
				_temp = 20
			}else{
				_temp = searchVec.length;
			}
			for(var i:int = 0;i<_temp;i++){
				_rememberCard = pool.object ;
				_rememberCard.x = int(i%4)*295 + 30;
				_rememberCard.y = int(i/4)*120;
				_rememberCard.wordid = searchVec[i].wordid;
				_rememberCard.addWordField();
				_rememberCard.wordField.text = searchVec[i].word;
				_rememberCard.text = searchVec[i].word;
				_rememberCard.addEventListener(TouchEvent.TOUCH,changeStatusHandler);
				wordBackground.addChild(_rememberCard);
				searchRememberCard.push(_rememberCard);
				_rememberCard.addEventListener(TouchEvent.TOUCH,changeStatusHandler);
			}
			if(searchVec.length>20){
				_nextBtn.visible = true;
				_nextBtn.addEventListener(Event.TRIGGERED,nextSearchWordHandler);
			}
		}		
		
		private var search:int = 0;
		private function nextSearchWordHandler():void
		{	
			wordBackground.removeChildren(0,-1,false);
			recyleSearchPool();	
			var _rememberCard:RememberCard;
			if(tab){
				search = search + 20;
				tab = false;
			}
			if(search+20<searchVec.length){
				for(var i:int = search;i<search+20;i++){
					_rememberCard = pool.object ;
					_rememberCard.x = int(i%4)*295 + 30;
					_rememberCard.y = int((i-search)/4)*120;
					_rememberCard.vo = searchVec[i];
					_rememberCard.wordid = searchVec[i].wordid;
					_rememberCard.addWordField();
					_rememberCard.wordField.text = searchVec[i].word;
					_rememberCard.text = searchVec[i].word;
					searchRememberCard.push(_rememberCard);
					_rememberCard.addEventListener(TouchEvent.TOUCH,changeStatusHandler);
					wordBackground.addChild(_rememberCard);
				}
			}else{
				for(var j:int = search;j<searchVec.length;j++){
					_rememberCard = pool.object ;
					_rememberCard.x = int(j%4)*295 + 30;
					_rememberCard.y = int((j-search)/4)*120;
					_rememberCard.vo = searchVec[j];
					_rememberCard.wordid = searchVec[j].wordid;
					_rememberCard.addWordField();
					_rememberCard.wordField.text = searchVec[j].word;
					_rememberCard.text = searchVec[j].word;
					searchRememberCard.push(_rememberCard);
					_rememberCard.addEventListener(TouchEvent.TOUCH,changeStatusHandler);
					wordBackground.addChild(_rememberCard);
				}		
				_nextBtn.visible = false;
			}
			search = search + 20;
			if(searchVec.length>20){
				_preBtn.visible = true;
				_preBtn.addEventListener(Event.TRIGGERED,preSearchWordHandler);	
			}

		}
		
		private var tab:Boolean = true;
		private function preSearchWordHandler():void
		{
			if(search>=20){
				_nextBtn.visible = true;
				start = _getwords;
				if(!tab){
					search = search-40;
					tab = true;
				}else{
					search = search-20;
				}
				if(search>=20){
					_preBtn.visible = true;
				}else{
					_preBtn.visible = false;
				}
				wordBackground.removeChildren(0,-1,false);
				recyleSearchPool();
				var _rememberCard:RememberCard;
				var _temp:int = 0;
				if(search+20>searchVec.length){
					_temp = searchVec.length;
				}else{
					_temp = search + 20	
				}
				for(var i:int = search;i<_temp;i++){
					_rememberCard = pool.object ;
					_rememberCard.x = int(i%4)*295 + 30;
					_rememberCard.y = int((i-search)/4)*120;
					_rememberCard.vo = searchVec[i];
					_rememberCard.wordid = searchVec[i].wordid;
					_rememberCard.addWordField();
					_rememberCard.wordField.text = searchVec[i].word;
					_rememberCard.text = searchVec[i].word;
					searchRememberCard.push(_rememberCard);
					_rememberCard.addEventListener(TouchEvent.TOUCH,changeStatusHandler);
					wordBackground.addChild(_rememberCard);
				}
			}else{
				sendNotification(CoreConst.TOAST,new ToastVO("已经是第一页了~"));
			}	
		}
		
		private var tempRemember:RememberCard;
		private var startPoint:Point
		private function changeStatusHandler(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.currentTarget as starling.display.DisplayObject);
			if(touch != null){
				if(touch.phase == TouchPhase.BEGAN){
					startPoint = new Point(touch.globalX,touch.globalY);
				}else if(touch.phase == TouchPhase.ENDED){
					if((touch.globalY<startPoint.y+100)&&(touch.globalY>startPoint.y-100)&&!Global.isLoading){
						tempRemember = event.currentTarget as RememberCard;
						PackData.app.CmdIStr[0] = CmdStr.CHGWRONGWORDMARK
						PackData.app.CmdIStr[1] = PackData.app.head.dwOperID;
						PackData.app.CmdIStr[2] = (event.currentTarget as RememberCard).wordid;
						PackData.app.CmdInCnt = 3;
						Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(CHGWRONGWORDMARK));
					}
				}
			}
		}
		
		override public function onRemove():void{
			super.onRemove();
			BitmapFontUtils.dispose();
			wordText.removeEventListener(TextEvent.TEXT_INPUT,showClearBtnHandler);
			wordText.removeEventListener(FocusEvent.FOCUS_OUT,hideClearBtnHandler);
			Starling.current.nativeOverlay.removeChild(wordText);
			TweenLite.killDelayedCallsTo(showTipHandler);
			wordText = null;
		}
		
	}
}