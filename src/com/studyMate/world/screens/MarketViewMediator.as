package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.charater.HumanMediator;
	import com.mylib.game.charater.ICharater;
	import com.mylib.game.charater.item.MarketItemSprite;
	import com.mylib.game.charater.item.MarketItemSpriteVO;
	import com.mylib.game.model.HumanPoolProxy;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.module.game.api.DressMarketConst;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.screens.ui.videoMarket.VideoHopeMediator;
	
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import feathers.controls.Scroller;
	import feathers.controls.TabBar;
	import feathers.controls.ToggleButton;
	import feathers.controls.supportClasses.LayoutViewPort;
	import feathers.data.ListCollection;
	
	import myLib.myTextBase.TextFieldHasKeyboard;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class MarketViewMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "MarketViewMediator";
		public static const SET_CPU_INPUT_VISIBLE:String = NAME + "SetPageInputVisible";	//设置跳转输入框
		private static const QUERY_MARK_FRAME:String = "QueryMarkframe";
		private static const GET_MONEY:String = "getMoney";
		private static const GET_STU_INFO:String = NAME + "getStuInfo";
		
		private var goldTF:TextField;
		private var goldNum:String;

		private var preBtn:Button;
		private var nextBtn:Button;
		private var gotoPageInput:TextFieldHasKeyboard;
		private var searchInput:TextFieldHasKeyboard;
		
		private var pageCount:int;
		private var selectType:String = "VIDEO";
		private var isFirstIn:Boolean = true;
		private var vo:SwitchScreenVO;
		
		private var myAge:int = 0;
		
		private var markItemSpVOList:Vector.<MarketItemSpriteVO>  = new Vector.<MarketItemSpriteVO>;

		public function MarketViewMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}
		override public function prepare(vo:SwitchScreenVO):void{
			this.vo = vo;
			
			getMoney();
		}
		
		override public function onRegister():void{
//			
			sendNotification(WorldConst.HIDE_MAIN_MENU);
			
			isFirstIn = false;
			
			init();
			
			doShowGoods();
			
			trace("@VIEW:MarketViewMediator:");
			
		}
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				case GET_MONEY:
					goldNum = PackData.app.CmdOStr[4];
					getStuInfo();
					
					break;
				case GET_STU_INFO:
					myAge = getAge(PackData.app.CmdOStr[13]);
					
					initMarkItemSpVOList("VIDEO",0);
					break;
				case QUERY_MARK_FRAME:
//					trace((PackData.app.CmdOStr[0] as String));
					if((PackData.app.CmdOStr[0] as String).charAt(0)=="!"){

						if(isFirstIn)
							Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
						else{
							//接收完毕
							if(markItemSpVOList.length == 0)
								pageIndex.text = "0/0";
							
							doShowGoods();
						}
					}else{
						//设定总页码
						pageCount = PackData.app.CmdOStr[1];
						if(PackData.app.CmdOStr[1] > 0){
							if(!isFirstIn)
								pageIndex.text = PackData.app.CmdOStr[2]+"/"+pageCount;
							
							//1:N 存储
							var markItemSpVO:MarketItemSpriteVO = new MarketItemSpriteVO();
							markItemSpVO.frameId = PackData.app.CmdOStr[3];
							markItemSpVO.frameName = PackData.app.CmdOStr[4].readMultiByte(PackData.app.CmdOStr[4].length,"cn-gb");
							markItemSpVO.goldCost = PackData.app.CmdOStr[8];
							markItemSpVO.wbidface = PackData.app.CmdOStr[9];
							markItemSpVO.txtBrief = PackData.app.CmdOStr[10].readMultiByte(PackData.app.CmdOStr[10].length,"cn-gb");
							markItemSpVO.wbidlean = PackData.app.CmdOStr[11];
							markItemSpVO.level = PackData.app.CmdOStr[7];
							
							markItemSpVOList.push(markItemSpVO);
							
							
						}
					}
					break;
				case WorldConst.UPDATE_MARKET_PER_INFO:
					goldTF.text = (notification.getBody()[0] as String);
					
					thirdTFtext = secTFtext;
					secTFtext = firTFtext;
					firTFtext = (notification.getBody()[1] as String);
					if(firTFtext.length > 6)	firTFtext = firTFtext.substr(0,4)+"..";
					
					if(firTFtext != "")	firTF.text = "1、"+firTFtext;
					if(secTFtext != "")	secTF.text = "2、"+secTFtext;
					if(thirdTFtext != "")	thirdTF.text = "3、"+thirdTFtext;
					
					

					charater.actor.playAnimation("idle",7,64,true);
					TweenLite.killTweensOf(delayFun);
					TweenLite.delayedCall(2.5,delayFun);
					break;
				case SET_CPU_INPUT_VISIBLE:
					var val:Boolean = notification.getBody() as Boolean;
					searchInput.visible = val;
					gotoPageInput.visible = val;
					
					break;
			}
		}
		
		override public function listNotificationInterests():Array{
			return [QUERY_MARK_FRAME,GET_MONEY,WorldConst.UPDATE_MARKET_PER_INFO,SET_CPU_INPUT_VISIBLE,GET_STU_INFO];
		}
		
		
		private function init():void{
			var bg:Image = new Image(Assets.getTexture("marketBg"));
			view.addChild(bg);
			
			/*var typeBtn:Button;
			for(var i:int=0;i<2;i++){
				switch(i){
					case 0:
						typeBtn = new Button(Assets.getMarketTexture("Frame/movieBtn"));
						typeBtn.name = "VIDEO";
						break;
					case 1:
						typeBtn = new Button(Assets.getMarketTexture("Frame/musicBtn"));
						typeBtn.name = "MUSIC";
						break;
				}
				typeBtn.x = 420+100*i;
				typeBtn.y = 25;
				typeBtn.addEventListener(Event.TRIGGERED,typeBtnHandle);
				view.addChild(typeBtn);
			}*/
			
			var wishBtn:Button = new Button(Assets.getMarketTexture("Frame/wishBtn"));
			wishBtn.x = 420;
			wishBtn.y = 40;
			view.addChild(wishBtn);
			wishBtn.addEventListener(Event.TRIGGERED,wishBtnHandle);
			
			createHuman();
			createFrameHolder();
			createResTableHolder();

			preBtn = new Button(Assets.getMarketTexture("Frame/pre_next_Btn"));
			preBtn.x = 647;
			preBtn.y = 690;
			preBtn.addEventListener(Event.TRIGGERED,preBtnHandle);
			view.addChild(preBtn);
			
			nextBtn = new Button(Assets.getMarketTexture("Frame/pre_next_Btn"));
			nextBtn.scaleX = -1;
			nextBtn.x = 840;
			nextBtn.y = 690;
			nextBtn.addEventListener(Event.TRIGGERED,nextBtnHandle);
			view.addChild(nextBtn);
			
			goldTF = new TextField(200,35,goldNum,"HuaKanT",23,0xa8410d);
			goldTF.hAlign = HAlign.CENTER;
			goldTF.vAlign = VAlign.CENTER;
			goldTF.x = 83;
			goldTF.y = 680;
			view.addChild(goldTF);
			
			gotoPageInput = new TextFieldHasKeyboard();
			gotoPageInput.defaultTextFormat = new TextFormat("HeiTi",18,0);
			gotoPageInput.maxChars = 2;
			gotoPageInput.width = 43;
			gotoPageInput.height = 23;
			gotoPageInput.x = 1010;
			gotoPageInput.y = 695;
			gotoPageInput.addEventListener(flash.events.Event.CHANGE,txtChangeHandle);
			gotoPageInput.addEventListener(KeyboardEvent.KEY_DOWN,gotoInputHandle);
			Starling.current.nativeOverlay.addChild(gotoPageInput);
			
			var gotopageBtn:Button = new Button(Assets.getMarketTexture("Frame/gotoPageBtn"));
			gotopageBtn.x = 1090;
			gotopageBtn.y = 687;
			gotopageBtn.addEventListener(Event.TRIGGERED,gotopageBtnHandle);
			view.addChild(gotopageBtn);

			
			searchInput = new TextFieldHasKeyboard();
			searchInput.defaultTextFormat = new TextFormat("HeiTi",18,0);
			searchInput.maxChars = 8;
			searchInput.width = 100;
			searchInput.height = 23;
			searchInput.x = 990;
			searchInput.y = 62;
			searchInput.addEventListener(KeyboardEvent.KEY_DOWN,searchInputHandle);
			Starling.current.nativeOverlay.addChild(searchInput);
			
			var searchBtn:Button = new Button(Assets.getMarketTexture("Frame/searchBtn"));
			searchBtn.x = 1100;
			searchBtn.y = 62;
			searchBtn.addEventListener(Event.TRIGGERED,searchBtnHandle);
			view.addChild(searchBtn);
			
			
			tabar = new TabBar();
			tabar.width = 260;
			tabar.x = 510;
			tabar.y = 76;
			tabar.dataProvider = new ListCollection(
				[				
					{ label: "" ,type:"filter" ,
						defaultIcon:new Image(Assets.getMarketTexture("Frame/filteBtn")) ,
						defaultSelectedIcon:new Image(Assets.getMarketTexture("Frame/filteBtn_down")),
						downIcon:new Image(Assets.getMarketTexture("Frame/filteBtn_down"))},
					{ label: "" ,type:"All" ,
						defaultIcon:new Image(Assets.getMarketTexture("Frame/allBtn")) ,
						defaultSelectedIcon:new Image(Assets.getMarketTexture("Frame/allBtn_down")),
						downIcon:new Image(Assets.getMarketTexture("Frame/allBtn_down"))},
				]);
			
			tabar.addEventListener(Event.CHANGE, tabBarHandle);
			view.addChild(tabar);
			tabar.direction = TabBar.DIRECTION_HORIZONTAL;
			tabar.selectedIndex = 0;
			
			
			tabar.customTabName = "btnTabBar";
			tabar.tabProperties.stateToSkinFunction = null;
			
			
		}
		private var tabar:TabBar;
		private function tabBarHandle(event:Event):void{
			trace(tabar.selectedItem.type);
			
			searchInput.text = "";
			currentIndex = 0;
			showArticleByType(selectType,0);
		}
		
		private function wishBtnHandle():void
		{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(VideoHopeMediator,null,SwitchScreenType.SHOW)]);

		}
		private function getMoney():void{
			PackData.app.CmdIStr[0] = CmdStr.GET_MONEY;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = "SYSTEM.SMONEY";
			PackData.app.CmdInCnt =3;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(GET_MONEY,null,'cn-gb',null,SendCommandVO.QUEUE|SendCommandVO.UNIQUE));
		}
		private function getStuInfo():void{
			PackData.app.CmdIStr[0] = CmdStr.GET_STUDENT_INFO;
			PackData.app.CmdIStr[1] = Global.user;
			PackData.app.CmdIStr[2] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 3;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(GET_STU_INFO));
			
		}
		private function getAge(_birth:String):int{
			return ((new Date).getFullYear() - (int(_birth.substr(0,4))));
			
		} 
		
		private var charater:ICharater;
		private var humanSC:Scroller;
		private var humanName:TextField;
		private var charaterSp:Sprite = new Sprite();
		private function createHuman():void{
			/*var suitsProxy:CharaterSuitsProxy = facade.retrieveProxy(CharaterSuitsProxy.NAME) as CharaterSuitsProxy;
			var profile:CharaterSuitsVO = suitsProxy.getCharaterSuit("npc5");*/
			charater = (facade.retrieveProxy(ModuleConst.HUMAN_POOL) as HumanPoolProxy).object;
			GlobalModule.charaterUtils.configHumanFromDressList(charater as HumanMediator,"face_face1,set4",new Rectangle());
			charater.view.x = 0;
			charater.view.y = 0;
			charaterSp.addChild(charater.view);
//			charaterSp.x = charater.view.width*3;
//			charaterSp.y = charater.view.height*8;
			charaterSp.x = 142;
			charaterSp.y = 352;
			charaterSp.scaleX = 4;
			charaterSp.scaleY = 4;
			var viewPort:LayoutViewPort = new LayoutViewPort();
			
			
			humanSC = new Scroller();
			humanSC.x = 38;
			humanSC.y = 285;
			humanSC.width = 260;
			humanSC.height = 278;
			humanSC.viewPort = viewPort;
			humanSC.isEnabled = false;
			viewPort.addChild(charaterSp);
			view.addChild(humanSC);
		}
		private function delayFun():void{
			charater.actor.playAnimation("idle",7,64,true);
		}
		
		
		private var goodsHolder:Sprite;
		private var pageIndex:TextField;
		private function createFrameHolder():void{

			goodsHolder = new Sprite();
			view.addChild(goodsHolder);

			pageIndex = new TextField(85,45,"1/"+pageCount,"HuaKanT",28);
			pageIndex.x = 700;
			pageIndex.y = 690;
			view.addChild(pageIndex);
		}
		private var firTF:TextField;
		private var secTF:TextField;
		private var thirdTF:TextField;
		private var firTFtext:String = "";
		private var secTFtext:String = "";
		private var thirdTFtext:String = "";
		private function createResTableHolder():void{
			firTF = new TextField(155,20,"","HuaKanT",18,0xcb5b00);
			firTF.hAlign = HAlign.LEFT;
			firTF.x = 100;
			firTF.y = 240;
			view.addChild(firTF);
			
			secTF = new TextField(155,20,"","HuaKanT",18,0xcb5b00);
			secTF.hAlign = HAlign.LEFT;
			secTF.x = 100;
			secTF.y = 270;
			view.addChild(secTF);
			
			thirdTF = new TextField(155,20,"","HuaKanT",18,0xcb5b00);
			thirdTF.hAlign = HAlign.LEFT;
			thirdTF.x = 100;
			thirdTF.y = 300;
			view.addChild(thirdTF);
			
			
			/*var gotoResBtn:Button = new Button(Assets.getMarketTexture("Frame/resTableBtn"));
			gotoResBtn.x = 190;
			gotoResBtn.y = 328;
			gotoResBtn.addEventListener(Event.TRIGGERED,gotoResBtnHandle);
			view.addChild(gotoResBtn);*/
		}
		
		private var currentIndex:int = 0;
		private function preBtnHandle(event:Event):void{
			if(currentIndex > 0){
				
				showArticleByType(selectType,currentIndex-1);
				currentIndex--;
				
				pageIndex.text = (currentIndex+1).toString()+"/"+pageCount;
			}
		}
		private function nextBtnHandle(event:Event):void{
			if(currentIndex < pageCount){
				
				showArticleByType(selectType,currentIndex+1);
				
				currentIndex++;
				
				pageIndex.text = (currentIndex+1).toString()+"/"+pageCount;
			}
		}
		private function typeBtnHandle(event:Event):void{
			if(selectType != (event.target as Button).name){
				selectType = (event.target as Button).name;
				
				currentIndex = 0;
				
				showArticleByType(selectType,0);
			}
		}
		private function initMarkItemSpVOList(_firstType:String,curPage:int,searchInfo:String="",isAll:Boolean=true):void{
			//发送命令字
			PackData.app.CmdIStr[0] = CmdStr.QUERY_MARK_FRAME;
			PackData.app.CmdIStr[1] = searchInfo;
			PackData.app.CmdIStr[2] = _firstType;
			PackData.app.CmdIStr[3] = "*";
			PackData.app.CmdIStr[4] = "*";
			PackData.app.CmdIStr[5] = "";
			PackData.app.CmdIStr[6] = "12";
			PackData.app.CmdIStr[7] = (curPage+1).toString();
//			if(!isAll){
			if(!tabar || tabar.selectedItem.type == "filter"){
				PackData.app.CmdIStr[8] =  PackData.app.head.dwOperID.toString();
			}else{
				PackData.app.CmdIStr[8] =  "";
			}
			PackData.app.CmdInCnt = 9;
			
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(QUERY_MARK_FRAME,null,"byte"));
		}
		private function showArticleByType(_firstType:String,curPage:int,searchInfo:String="",isAll:Boolean=true):void{
			
			markItemSpVOList.splice(0,markItemSpVOList.length);

			initMarkItemSpVOList(_firstType,curPage,searchInfo,isAll);
		}
		private function checkCanBuy(level:String):Boolean{
			
			if(level == "*" || level == "G"){
				return true;
			}
			if(level == "PG" && myAge >= 6){
				return true;
			}
			if(level == "PG-13" && myAge >= 13){
				return true;
			}
			return false;
			
		}
		private function doShowGoods():void{
			goodsHolder.removeChildren(0,-1,true);
			
			for(var i:int=markItemSpVOList.length-1;i>=0;i--){
				
				
				
				var marketItemSp:MarketItemSprite = new MarketItemSprite(markItemSpVOList[i], checkCanBuy(markItemSpVOList[i].level));

				
				marketItemSp.x = 374+206*(int(i%4));
				marketItemSp.y = 183+163*(int(i/4));

				goodsHolder.addChild(marketItemSp);
				
				
			}

			
			preBtn.enabled = false;
			nextBtn.enabled = false;
			if(currentIndex > 0)
				preBtn.enabled = true;
			if(currentIndex < pageCount-1)
				nextBtn.enabled = true;
		}
		
		private function gotoResBtnHandle(event:Event):void{
			sendNotification(WorldConst.POP_SCREEN_DATA);
			sendNotification(WorldConst.POP_SCREEN_DATA);
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ResTableMediator)]);
		}
		
		private function txtChangeHandle(event:flash.events.Event):void{
			//非数字
			if(isNaN(event.target.text)){
				event.target.text = "";
				sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.stage,
					640,381,null,"请输入合法数字"));
			}else if(Number(event.target.text)<1 && event.target.text != ""){
				event.target.text = "1";
			}else if(Number(event.target.text)>pageCount){
				event.target.text = pageCount;
			}
		}
		private function gotoInputHandle(event:KeyboardEvent):void{
			if(event.keyCode==13){
				gotopageBtnHandle(null);
			}
		}
		private function gotopageBtnHandle(event:Event):void{
			if(gotoPageInput.text != ""){
				if(Number(gotoPageInput.text)>0 && Number(gotoPageInput.text)<=pageCount){
					var gotoIndex:int = Number(gotoPageInput.text)-1;
					
					trace("跳转至： "+gotoIndex);
					if(currentIndex != gotoIndex){
						showArticleByType(selectType,gotoIndex);
						
						currentIndex = gotoIndex;
						pageIndex.text = (currentIndex+1).toString()+"/"+pageCount;
					}
					
				}else{
					sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.stage,
						640,381,null,"请输入范围内的页码。"));
				}
			}else{
				sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.stage,
					640,381,null,"请输入您要跳转的页码。"));
			}
		}
		
		private function searchInputHandle(event:KeyboardEvent):void{
			if(event.keyCode==13){
				searchBtnHandle(null);
			}
		}
		private function searchBtnHandle(event:Event):void{
//			if(searchInput.text != ""){
			if(searchInput.text != ""){
				sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.stage,
					640,381,null,"搜索："+searchInput.text));
			}
				
				currentIndex = 0;
//				selectType = "*";
				
				showArticleByType(selectType,0,searchInput.text);
//			}else{
//				sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.stage,
//					640,381,null,"请输入搜索关键字！"));
//			}
		}
		

		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class{
			return Sprite;
		}
		override public function onRemove():void{
			super.onRemove();
			TweenLite.killTweensOf(delayFun);
			
			view.removeChildren(0,-1,true);
			goodsHolder.removeChildren(0,-1,true);
			
			goodsHolder.dispose();
			
			(facade.retrieveProxy(ModuleConst.HUMAN_POOL) as HumanPoolProxy).object = charater;
			
			Starling.current.nativeOverlay.removeChild(gotoPageInput);
			Starling.current.nativeOverlay.removeChild(searchInput);
			
			sendNotification(WorldConst.SHOW_MAIN_MENU);
			
			
		}
	}
}