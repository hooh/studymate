package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.component.AndroidGame.AndroidGameVO;
	import com.studyMate.world.component.AndroidGame.GameMarket.GameMarketItem;
	import com.studyMate.world.component.AndroidGame.GameMarket.GameMarketScroller;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	
	import mx.utils.StringUtil;
	
	import feathers.controls.Button;
	import feathers.controls.TabBar;
	import feathers.controls.ToggleButton;
	import feathers.data.ListCollection;
	
	import myLib.myTextBase.TextFieldHasKeyboard;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;

	public class AndroidGameMarketMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "AndroidGameMarketMediator";
		
		private static const GET_MONEY:String = NAME + "GetMoney";
		private static const QUERY_GAME_INFO:String = NAME + "Query_Game_Info";
		private static const HOPE_GAME:String = NAME + "HopeGame";
		private static const OPEN_GAME_INFO:String = NAME + "OpenGameInfo";
		private static const APK_FACE_DOWNLOAD_COMPLETE:String = NAME + "ApkFaceDownloadComplete";
		
		private var vo:SwitchScreenVO;
		
		private var goldNum:int = 0;
		private var moneyTxt:TextField;//剩余的钱
		private var tabs:TabBar;//列表，最新、全部..
		

		public function AndroidGameMarketMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function prepare(vo:SwitchScreenVO):void
		{
			this.vo = vo;
			
			myGameList = vo.data as Vector.<AndroidGameVO>;
			
			
			getGMoney();
		}
		override public function onRegister():void
		{
			sendNotification(WorldConst.HIDE_LEFT_MENU);
			
			
			var image:Image = new Image(Assets.getTexture("gameMarketbg"));
			image.blendMode = BlendMode.NONE;
			image.touchable = false;
			view.addChild(image);	
			
			tabs = new TabBar();
			tabs.dataProvider = new ListCollection(
				[
					/*{label: "New"},*/
					{label: "全部"}
				]);			
			tabs.x = 55; tabs.y = 2;
			view.addChild(tabs);			
			setStyle(tabs);			
			
			//搜索Btn
			var searchBtn:starling.display.Button = new starling.display.Button(Assets.getAndroidGameTexture("searchBtn"));
			searchBtn.x = 1076;
			searchBtn.y = 4;
			searchBtn.enabled = false;
			view.addChild(searchBtn);
			
			//许愿Btn
			var wishBtn:starling.display.Button = new starling.display.Button(Assets.getAndroidGameTexture("wishBtn"));
			wishBtn.x = 1161;
			wishBtn.y = 4;
			view.addChild(wishBtn);
			
			//金币文本
			moneyTxt = new TextField(130,40,goldNum.toString(),'HeiTi',20,0xFFF3C4,true);
			moneyTxt.x = 937;
			moneyTxt.y = 46;
			moneyTxt.touchable = false;
			view.addChild(moneyTxt);
			
			tabs.addEventListener( starling.events.Event.CHANGE, tabs_changeHandler );
			searchBtn.addEventListener(Event.TRIGGERED,searchHandler);
			wishBtn.addEventListener(Event.TRIGGERED,wishHandler);

			
			
			flitMarketList();
			
			
			
			view.addChild(itemHolder);
			itemHolder.clipRect = new Rectangle(42,92,1196,635);
			
			
			initControlSp();
			
			itemHolder.addChild(scrollSp);
			
			
			var itemBg:Image = new Image(Assets.getTexture("gameMarketItemBg"));
			itemBg.x = 36;
			itemBg.y = 92;
			scrollSp.addChild(itemBg);
			
			
			marketGameScroll = new GameMarketScroller(marketShowList,view);
			scrollSp.addChild(marketGameScroll);
			
			
			
			scrollSp.addEventListener(TouchEvent.TOUCH,scrollSpHandle);

			this.backHandle = quitHandler;
			
			trace("@VIEW:AndroidGameMarketMediator:");
		}
		private function quitHandler():void{//先停止消息后，再退出
			if(!Global.isLoading){
				sendNotification(WorldConst.POP_SCREEN);
			}
		}
		
		
		private var itemHolder:Sprite = new Sprite;;
		private var controlSp:Sprite;
		private function initControlSp():void{
			controlSp = new Sprite;
			controlSp.x = 200;
			controlSp.y = 126;
			
			var bg:Image = new Image(Assets.getAndroidGameTexture("controlBg"));
			controlSp.addChild(bg);
			
			var wishBtn:starling.display.Button = new starling.display.Button(Assets.getAndroidGameTexture("control_WishBtn"));
			wishBtn.x = 820;
			wishBtn.y = 5;
			wishBtn.visible = false;
			controlSp.addChild(wishBtn);
			wishBtn.addEventListener(Event.TRIGGERED,controlBtnHandle);
			
			var searchBtn:starling.display.Button = new starling.display.Button(Assets.getAndroidGameTexture("control_SearchBtn"));
			searchBtn.x = 820;
			searchBtn.y = 5;
			searchBtn.visible = false;
			controlSp.addChild(searchBtn);
			searchBtn.addEventListener(Event.TRIGGERED,controlBtnHandle);
			
			controlSp.visible = false;
			
			itemHolder.addChild(controlSp);
			
			
			textInput = new TextFieldHasKeyboard();
			textInput.defaultTextFormat = new TextFormat("HeiTi",34);
			textInput.restrict = "^`\/";
			textInput.embedFonts = true;
			textInput.antiAliasType = AntiAliasType.ADVANCED;
			textInput.width = 750;
			textInput.height = 40;
			textInput.x = 220;
			textInput.y = 138;
			textInput.maxChars = 18;
			textInput.visible = false;
			textInput.addEventListener(KeyboardEvent.KEY_DOWN,textInputHandler);
			
			Starling.current.nativeOverlay.addChild(textInput);
			
		}
		private function controlBtnHandle():void{
			
			var infoStr:String = StringUtil.trim(textInput.text);
			if(infoStr !=""){
				if(btnState == "W")
					sendWish(infoStr);
				else if(btnState == "S")
					sendSearch(infoStr);
			}else{
				if(btnState == "W")
					sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,640,381,null,"请输入你想购买的游戏名称。"));
				else if(btnState == "S")
					sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,640,381,null,"请输入你想搜索的游戏。"));
				
			}
		}
		protected function textInputHandler(e:KeyboardEvent):void
		{
			if(e.keyCode == 13) {//回车
				e.preventDefault();
				e.stopImmediatePropagation();
				
				controlBtnHandle();
			}
		}
		private function sendWish(infoStr:String):void{
			/*PackData.app.CmdIStr[0] = CmdStr.Send_FAQ_Info;
			PackData.app.CmdIStr[1] = "150";
			PackData.app.CmdIStr[2] = '游戏许愿';//菜单名称
			PackData.app.CmdIStr[3] = infoStr+"(id:"+PackData.app.head.dwOperID.toString()+")";
			PackData.app.CmdInCnt = 4;	*/
			PackData.app.CmdIStr[0] = CmdStr.SEND_FAQ_TRANSLATION;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] =  '游戏许愿';//菜单名称
			PackData.app.CmdIStr[3] = '0';
			PackData.app.CmdIStr[4] = 'H';
			PackData.app.CmdIStr[5] = infoStr;
			PackData.app.CmdInCnt = 6;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(HOPE_GAME));	//派发调用绘本列表参数，调用后台
		}
		private function sendSearch(infoStr:String):void{
			
			
		}
		
		private var textInput:TextFieldHasKeyboard;
		
		
		private function flitMarketList():void{
			for(var i:int=0;i<marketGameList.length;i++){
				
				var isHad:Boolean = false;
				
				for(var j:int=0;j<myGameList.length;j++){
					//已购买
					if(marketGameList[i].gid == myGameList[j].gid){
						isHad = true;
						
						break;
					}
				}
				
				if(!isHad)
					marketShowList.push(marketGameList[i]);
			}
			
		}
		
		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case GET_MONEY:
					
					goldNum = PackData.app.CmdOStr[4];
					
					getMarketGameInfo();
					break;
				case QUERY_GAME_INFO:
					if(!result.isEnd){
						
						var gamevo:AndroidGameVO = new AndroidGameVO;
						gamevo.gid = PackData.app.CmdOStr[1];
						gamevo.gameName = PackData.app.CmdOStr[2];
						gamevo.faceId = PackData.app.CmdOStr[3];
						gamevo.faceName = PackData.app.CmdOStr[4];
						gamevo.apkId = PackData.app.CmdOStr[5];
						gamevo.apkName = PackData.app.CmdOStr[6];
						gamevo.gold = PackData.app.CmdOStr[7];
						gamevo.perPoint = PackData.app.CmdOStr[8];
						gamevo.level = PackData.app.CmdOStr[9];
						gamevo.isOpen = PackData.app.CmdOStr[10];
						gamevo.type = PackData.app.CmdOStr[12];
						
						marketGameList.push(gamevo);
						
						
					}else{
						
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.DOWNLOAD_APK_FACE,[marketGameList,APK_FACE_DOWNLOAD_COMPLETE]);
						
					}
					break;
				case APK_FACE_DOWNLOAD_COMPLETE:
					
					
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
					
					
					break;
				case HOPE_GAME:
					if(PackData.app.CmdOStr[0] == "000")
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,640,381,null,"您的许愿我们已经收到，会尽快帮您实现。"));
					else
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,640,381,null,"许愿失败，请重新尝试。"));
					if(textInput){
						textInput.text = "";
					}
					break;
				case GameMarketItem.BUY_CLICK:
					var _gamevo:AndroidGameVO = notification.getBody() as AndroidGameVO;
					
					sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,640,381,doBuy,"确定花费 ￥"+_gamevo.gold + " 购买 \""+_gamevo.gameName + "\" ？",null,_gamevo));
					
					
					break;
				case OPEN_GAME_INFO:
					
					
					if((PackData.app.CmdOStr[0] as String)=="000"){
						moneyTxt.text = PackData.app.CmdOStr[1];	//返回剩余金币
						
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,640,381,null,"游戏购买成功，返回上一界面下载、安装。"));	
					}else if((PackData.app.CmdOStr[0] as String)=="M00"){
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,640,381,null,"游戏已购买，不要浪费钱了哦。"));
					}else{
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,640,381,null,"购买失败"));	
					}
					
					break;
				
			}
		}
		override public function listNotificationInterests():Array
		{
			return [GET_MONEY,QUERY_GAME_INFO,APK_FACE_DOWNLOAD_COMPLETE,HOPE_GAME,GameMarketItem.BUY_CLICK,OPEN_GAME_INFO];
		}
		
		private function doBuy(_gamevo:AndroidGameVO):void{
			PackData.app.CmdIStr[0] = CmdStr.Open_Game_Info;
			PackData.app.CmdIStr[1] = _gamevo.gid;
			PackData.app.CmdIStr[2] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 3;	
			sendNotification(CoreConst.SEND_11,new SendCommandVO(OPEN_GAME_INFO));	//开启游戏
			
		}
		
		private var myGameList:Vector.<AndroidGameVO> = new Vector.<AndroidGameVO>;
		private var marketGameScroll:GameMarketScroller;
		private var marketGameList:Vector.<AndroidGameVO> = new Vector.<AndroidGameVO>;
		private var marketShowList:Vector.<AndroidGameVO> = new Vector.<AndroidGameVO>;
		
		
		
		private function tabs_changeHandler( event:Event ):void{
			switch(tabs.selectedIndex){
				case 0://获取最新游戏列表
					
					break;
				
				case 1://获取全部游戏列表
					
					
					
					break;
			}
		}
		
		
		private var btnState:String = "";
		//许愿
		private function wishHandler():void{
			textInput.text = "";
			
			if(btnState == "" || btnState == "S"){
				
				setItemScroll("down");
				
				
				displayWish();
				
				
				btnState = "W";
			}else if(btnState == "W"){
				
				setItemScroll("up");
				
				displayWish(false);
				
				btnState = "";
			}
		}
		
		//搜索
		private function searchHandler():void{
			textInput.text = "";
			
			if(btnState == "" || btnState == "W"){
				
				setItemScroll("down");

				displaySearch();
				
				btnState = "S";
			}else if(btnState == "S"){
				
				setItemScroll("up");
				
				displaySearch(false);
				
				btnState = "";
			}
		}
		
		private function displayWish(_isshow:Boolean=true):void{
			TweenLite.killTweensOf(delayHideControl);
			if(_isshow){
				controlSp.visible = _isshow;
				//许愿
				controlSp.getChildAt(1).visible = _isshow;
				controlSp.getChildAt(2).visible = false;
			}else{
				
				TweenLite.delayedCall(0.5,delayHideControl);
			}
		}
		private function displaySearch(_isshow:Boolean=true):void{
			TweenLite.killTweensOf(delayHideControl);
			if(_isshow){
				controlSp.visible = _isshow;
				//查找
				controlSp.getChildAt(2).visible = _isshow;
				controlSp.getChildAt(1).visible = false;
			}else{
				
				TweenLite.delayedCall(0.5,delayHideControl);
			}
			
		}
		private function delayHideControl():void{
			controlSp.visible = false;
			controlSp.getChildAt(1).visible = false;
			controlSp.getChildAt(2).visible = false;
			
		}
		
		
		private var scrollSp:Sprite = new Sprite;
		private function setItemScroll(_state:String):void{
			TweenLite.killTweensOf(scrollSp);
			
			if(_state == "up"){
				
//				Starling.current.nativeOverlay.removeChild(textInput);
				textInput.visible = false;
				
				TweenLite.to(scrollSp,0.5,{y:0});
				
				
			}else if(_state == "down"){
				
//				Starling.current.nativeOverlay.addChild(textInput);
				textInput.visible = true;
				
				TweenLite.to(scrollSp,0.5,{y:127});
			}
			
			
		}
		private var curentY:Number;
		private function scrollSpHandle(event:TouchEvent):void{
			var touch:Touch = event.getTouch(event.target as DisplayObject);
			if(touch){
				
				if(touch.phase ==TouchPhase.BEGAN){
					curentY = touch.globalY;
					
				}else if(touch.phase==TouchPhase.ENDED){
					//向下
					if((touch.globalY - curentY) >= 100){
						textInput.text = "";
						
						if(btnState == "" || btnState == "S"){
							
							setItemScroll("down");
							displayWish();
							btnState = "W";
						}
						
					}else if((touch.globalY - curentY) <= -50){
						//向上
						setItemScroll("up");
						
						TweenLite.delayedCall(0.5,delayHideControl);
						
						btnState = "";
					}
				}
			}
		}
		
		
		
		private function setStyle(tabs:TabBar):void{
			tabs.direction = TabBar.DIRECTION_HORIZONTAL;
			tabs.gap = 22;
			tabs.customTabName = "androidMarketTabBar";
			tabs.tabFactory = tabButtonFactory;
			tabs.tabProperties.stateToSkinFunction = null;			
//			tabs.tabProperties.@defaultLabelProperties.textFormat = new TextFormat("HuaKanT", 22, 0xFFFFFF,true);
//			tabs.tabProperties.@defaultLabelProperties.embedFonts = true;			
//			tabs.tabProperties.@defaultSelectedLabelProperties.textFormat = new TextFormat("HuaKanT", 22, 0xFEF2D3,true);
//			tabs.tabProperties.@defaultSelectedLabelProperties.embedFonts = true;
			
			var boldFontDescription:FontDescription = new FontDescription("HuaKanT",FontWeight.BOLD,FontPosture.NORMAL,FontLookup.EMBEDDED_CFF);
			tabs.tabProperties.@defaultLabelProperties.elementFormat = new ElementFormat(boldFontDescription, 22, 0xFFFFFF);
			tabs.tabProperties.@defaultSelectedLabelProperties.elementFormat =  new ElementFormat(boldFontDescription, 22, 0xFEF2D3);

		}
		private function tabButtonFactory():feathers.controls.Button{
			var tab:ToggleButton = new ToggleButton();
			tab.defaultSkin = new Image(Assets.getAndroidGameTexture("tabarUpIcon"));
			tab.defaultSelectedSkin = new Image(Assets.getAndroidGameTexture("tabarDownIcon"));
			tab.downSkin = new Image(Assets.getAndroidGameTexture("tabarDownIcon"));
			return tab;
		}
		
		
		
		
		
		private function getGMoney():void{
			PackData.app.CmdIStr[0] = CmdStr.GET_MONEY;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = "SYSTEM.GMONEY";
			PackData.app.CmdInCnt =3;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(GET_MONEY));
		}
		private function getMarketGameInfo():void{
			
			PackData.app.CmdIStr[0] = CmdStr.Query_Game_Info;
			PackData.app.CmdIStr[1] = "*";
			PackData.app.CmdIStr[2] = "*";
			PackData.app.CmdIStr[3] = "*";
			PackData.app.CmdIStr[4] = "*";
			PackData.app.CmdIStr[5] = "00000000";
			PackData.app.CmdIStr[6] = "YYYYMMDD";
			PackData.app.CmdInCnt = 7;	
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(QUERY_GAME_INFO));	
			
			
		}
		
		
		
		
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		override public function onRemove():void{
			super.onRemove();
			
			TweenLite.killTweensOf(scrollSp);
			TweenLite.killTweensOf(delayHideControl);
			
			sendNotification(WorldConst.SHOW_LEFT_MENU);
			
			scrollSp.removeEventListener(TouchEvent.TOUCH,scrollSpHandle);
			
			if(textInput){
				textInput.removeEventListener(KeyboardEvent.KEY_DOWN,textInputHandler);
				
				
				Starling.current.nativeOverlay.removeChild(textInput);
			}
			
			view.removeChildren(0,-1,true);
		}
	}
}