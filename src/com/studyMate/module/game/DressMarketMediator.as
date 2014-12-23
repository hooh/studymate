package com.studyMate.module.game
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.charater.HumanMediator;
	import com.mylib.game.charater.ICharater;
	import com.mylib.game.charater.item.DressMarketItem;
	import com.mylib.game.charater.item.EquipmentItemButton;
	import com.mylib.game.fightGame.CircleChart;
	import com.mylib.game.fightGame.RollerUtils;
	import com.mylib.game.model.DressSuitsProxy;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.module.game.api.DressMarketConst;
	import com.studyMate.utils.BitmapFontUtils;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.model.vo.DressSeriesItemVO;
	import com.studyMate.world.model.vo.DressSuitsVO;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import de.polygonal.core.ObjectPool;
	
	import feathers.controls.ScrollContainer;
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	import feathers.layout.TiledRowsLayout;
	
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
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class DressMarketMediator extends ScreenBaseMediator
	{
		private static const EQUIP_CONFIG_FLAG:String = "NEW_EQUIP_ID";
		
		private var tree:Image;
		
		private var vo:SwitchScreenVO;
		
		private var charater:ICharater;
		private var stuSex:String;
		
		private var gameGoldNum:String = "";
		private var gameGoldTF:TextField;
		private var goldNum:String = "";
		private var goldTF:TextField;
		private var saveBtn:starling.display.Button;
		private var cancleBtn:starling.display.Button;
		
		private var layout:TiledRowsLayout;
		private var container:ScrollContainer;
		
		public var scroll:DressMarketScroller;
		private var previewCircle:CircleChart;
		
		
		private var dressSuitsProxy:DressSuitsProxy;
		private var dressSuitsVoList:Vector.<DressSuitsVO>;
		private var serverSuitList:Vector.<DressSuitsVO> = new Vector.<DressSuitsVO>;
		private var marketSuitList:Vector.<DressSuitsVO> = new Vector.<DressSuitsVO>;
		private var mySuitNameList:Array = new Array;
		
		private var newList:Array = [];
		
		public function DressMarketMediator(viewComponent:Object=null){
			super(ModuleConst.DRESS_MARKET, viewComponent);
		}
		override public function prepare(vo:SwitchScreenVO):void{
			this.vo = vo;
			
			getStdInfo();
		}
		

		override public function onRegister():void{
			sendNotification(WorldConst.SET_ROLL_SCREEN,false);
			sendNotification(WorldConst.HIDE_MAIN_MENU);

			var bg:Image = new Image(Assets.getTexture("dressMarketBg"));
			view.addChild(bg);

		
			serverSuitList = Global.dressDatalist;
			
			createHuman();
			createFrontPanel();
			createSortBtn();
			initDressList();
			initBitmapFont();
			
			scroll = new DressMarketScroller(marketSuitList);
			scroll.x = 360;
			scroll.y = 96;
			view.addChild(scroll);
			btnTabBarChangeHandler(null);
			
			trace("@VIEW:DressMarketMediator:");
		}
		//初始化位图字体
		private function initBitmapFont():void{
			BitmapFontUtils.dispose();
			
			var priceStr:String = ".-0123456789";
			var assets:Vector.<flash.display.DisplayObject> = new Vector.<flash.display.DisplayObject>;
			var bmp:Bitmap;
			
			for (var i:int = 1; i < 6; i++){
				bmp = Assets.getTextureAtlasBMP(Assets.store["DressSeriesTexture"],Assets.store["DressSeriesXML"],"DressMarket/itemBg_lvl"+i);
				bmp.name = "DressMarket/itemBg_lvl"+i;
				assets.push(bmp);}
			for (i = 1; i < 6; i++){
				bmp = Assets.getTextureAtlasBMP(Assets.store["DressSeriesTexture"],Assets.store["DressSeriesXML"],"DressMarket/lvlIconMax"+i+"_M");
				bmp.name = "DressMarket/lvlIconMax"+i+"_M";
				assets.push(bmp);}
			for (i = 1; i < 6; i++){
				for (var j:int = 1; j < 6; j++){
					bmp = Assets.getTextureAtlasBMP(Assets.store["DressSeriesTexture"],Assets.store["DressSeriesXML"],"DressMarket/lvlIconMax"+i+"_"+j);
					bmp.name = "DressMarket/lvlIconMax"+i+"_"+j;
					assets.push(bmp);}}
			bmp = Assets.getTextureAtlasBMP(Assets.store["DressSeriesTexture"],Assets.store["DressSeriesXML"],"DressMarket/itemUpdateBtn");
			bmp.name = "DressMarket/itemUpdateBtn";
			assets.push(bmp);
			bmp = Assets.getTextureAtlasBMP(Assets.store["DressSeriesTexture"],Assets.store["DressSeriesXML"],"DressMarket/itemUpdateDisBtn");
			bmp.name = "DressMarket/itemUpdateDisBtn";
			assets.push(bmp);
			bmp = Assets.getTextureAtlasBMP(Assets.store["DressSeriesTexture"],Assets.store["DressSeriesXML"],"DressMarket/itemBuyBtn");
			bmp.name = "DressMarket/itemBuyBtn";
			assets.push(bmp);
			bmp = Assets.getTextureAtlasBMP(Assets.store["DressSeriesTexture"],Assets.store["DressSeriesXML"],"DressMarket/itemInfoBtn");
			bmp.name = "DressMarket/itemInfoBtn";
			assets.push(bmp);
			
			bmp = Assets.getTextureAtlasBMP(Assets.store["DressSeriesTexture"],Assets.store["DressSeriesXML"],"DressMarket/itemGoldIcon1");
			bmp.name = "DressMarket/itemGoldIcon1";
			assets.push(bmp);
			bmp = Assets.getTextureAtlasBMP(Assets.store["DressSeriesTexture"],Assets.store["DressSeriesXML"],"DressMarket/itemGoldIcon2");
			bmp.name = "DressMarket/itemGoldIcon2";
			assets.push(bmp);
			
			bmp = Assets.getTextureAtlasBMP(Assets.store["DressSeriesTexture"],Assets.store["DressSeriesXML"],"DressMarket/newTips");
			bmp.name = "DressMarket/newTips";
			assets.push(bmp);
			
			var tf:TextFormat = new TextFormat('HeiTi',13,0xffffff);
			tf.letterSpacing = -3;
			
			BitmapFontUtils.init(priceStr,assets,tf,[new GlowFilter(0,1,2,2,5)]);
			
			
		}

/****   准备等级处理              ********************************************************************************************************/
		private var serItemsList:Vector.<DressSeriesItemVO> = new Vector.<DressSeriesItemVO>;
		private function initDressList():void{
			dressSuitsProxy = facade.retrieveProxy(DressSuitsProxy.NAME) as DressSuitsProxy;
			dressSuitsProxy.addCharaterDress(charater);
			
			if(dressSuitsProxy.dressSuitsVoList)
				dressSuitsVoList = dressSuitsProxy.dressSuitsVoList;
			else
				dressSuitsVoList = new Vector.<DressSuitsVO>;
			if(serverSuitList){
				for(var i:int=0;i<serverSuitList.length;i++){
					
					//本地图片库存在装备，并且用户未购买,显示
					var suit:DressSuitsVO = getSuit(serverSuitList[i]);
					if(suit){
						
						suit.equipId = serverSuitList[i].equipId;
						suit.price = serverSuitList[i].price;
						suit.goldprice = serverSuitList[i].goldprice;
						suit.property = serverSuitList[i].property;
						
						//判断是否新品
						if(newList && newList.indexOf(suit.equipId) != -1)
						{
							suit.isNew = true;
							marketSuitList.unshift(suit);
							continue;
						}
						
						marketSuitList.push(suit);
					}
				}
			}
		}
		private function getSuit(_drssVo:DressSuitsVO):DressSuitsVO{
			if(dressSuitsVoList){
				for(var i:int=0;i<dressSuitsVoList.length;i++){
					//png有该图片
					if(dressSuitsVoList[i].name == _drssVo.name){
						var dressVo:DressSuitsVO = dressSuitsVoList[i];
						var itemVo:DressSeriesItemVO =  GlobalModule.charaterUtils.getEquipItemInfo(_drssVo.name);
						//已经购买
						if(mySuitNameList.indexOf(_drssVo.name) != -1){
							dressVo.hasBuy = true;
							dressVo.isShow = checkUpdate(itemVo);
						}else{
							dressVo.hasBuy = false;
							//是一级，则显示---购买
							if(!itemVo)	dressVo.isShow = true;
							else	if(itemVo.level == "1"){ serItemsList.push(itemVo); dressVo.isShow = true; }
							else	dressVo.isShow = false;
						}
						return dressVo;
					}
				}
			}
			return null;
		}
		private function checkUpdate(_itemVo:DressSeriesItemVO):Boolean{
			//没有该装备等级信息，直接显示
			if(!_itemVo)	return true;
			
			for (var i:int = 0; i < serItemsList.length; i++) 
			{
				//如果是同一系列
				if(serItemsList[i].seriesName == _itemVo.seriesName){

					//新装备更高级，则替换原来的
					if((int(_itemVo.level)) > (int(serItemsList[i].level))){
						setDressHide(serItemsList[i].name);
						
						serItemsList.splice(i,1);
						serItemsList.push(_itemVo);
						return true;
					}else
						return false;
				}
				
			}
			//没有这个系列,加入列表，并且显示
			serItemsList.push(_itemVo);
			return true;
		}
		private function setDressHide(_dressName:String):void{
			for (var i:int = 0; i < marketSuitList.length; i++) 
			{
				if(marketSuitList[i].name == _dressName){
					marketSuitList[i].isShow = false;
					return;
				}
			}
		}
		
		
		private function createHuman():void{
			charater = (facade.retrieveProxy(ModuleConst.HUMAN_POOL) as ObjectPool).object;
			
			GlobalModule.charaterUtils.configHumanFromDressList(charater as HumanMediator,Global.myDressList,new Rectangle());
			
			charater.view.x = 168;
			charater.view.y = 524;
			charater.view.scaleX = 1;
			charater.view.scaleY = 1;
			charater.view.alpha = 1;
			view.addChild(charater.view);
			
			
			if(stuSex == "0"){
				charater.actor.getProfile().sex = "F";
				charater.sex = "F";
			}else{
				charater.actor.getProfile().sex = "M";
				charater.sex = "M";
			}
			
			/*charater.view.addEventListener(TouchEvent.TOUCH,charaterHandle);*/
		}
		private function createFrontPanel():void{
			gameGoldTF = new TextField(200,38,gameGoldNum,"HeiTi",28,0xffffff);
			gameGoldTF.hAlign = HAlign.LEFT;
			gameGoldTF.vAlign = VAlign.TOP;
			gameGoldTF.x = 165;
			gameGoldTF.y = 77;
			gameGoldTF.nativeFilters = [new GlowFilter(0,1,5,5,20)]
			view.addChild(gameGoldTF);
			
			goldTF = new TextField(200,38,goldNum,"HeiTi",28,0xffffff);
			goldTF.hAlign = HAlign.LEFT;
			goldTF.vAlign = VAlign.TOP;
			goldTF.x = 163;
			goldTF.y = 195;
			goldTF.nativeFilters = [new GlowFilter(0,1,5,5,20)]
			view.addChild(goldTF);
			
			saveBtn = new starling.display.Button(Assets.getDressSeriesTexture("DressMarket/saveBtn"));
			saveBtn.x = 46;
			saveBtn.y = 630;
			view.addChild(saveBtn);
			saveBtn.addEventListener(Event.TRIGGERED,saveBtnHandle);
			
			cancleBtn = new starling.display.Button(Assets.getDressSeriesTexture("DressMarket/cancleBtn"));
			cancleBtn.x = 256;
			cancleBtn.y = 630;
			view.addChild(cancleBtn);
			cancleBtn.addEventListener(Event.TRIGGERED,cancleBtnHandle);
			
			//预览圈
			previewCircle = new CircleChart;
			previewCircle.x = 180;
			previewCircle.y = 325;
			view.addChild(previewCircle);
			
			
			
			
		}
		private var btnTabBar:TabBar;
		private function createSortBtn():void{
			btnTabBar = new TabBar();
			btnTabBar.gap = -10;
			btnTabBar.x = 1187;
			btnTabBar.y = 75;
			btnTabBar.dataProvider = new ListCollection(
				[				
					{ type:"head" ,
						defaultIcon:new Image(Assets.getDressSeriesTexture("DressMarket/tabtn_head_up")) ,
						defaultSelectedIcon:new Image(Assets.getDressSeriesTexture("DressMarket/tabtn_head_down")),
						downIcon:new Image(Assets.getDressSeriesTexture("DressMarket/tabtn_head_down"))},
					{ type:"body" ,
						defaultIcon:new Image(Assets.getDressSeriesTexture("DressMarket/tabtn_cloth_up")) ,
						defaultSelectedIcon:new Image(Assets.getDressSeriesTexture("DressMarket/tabtn_cloth_down")),
						downIcon:new Image(Assets.getDressSeriesTexture("DressMarket/tabtn_cloth_down"))},
					{ type:"hand" ,
						defaultIcon:new Image(Assets.getDressSeriesTexture("DressMarket/tabtn_hand_up")) ,
						defaultSelectedIcon:new Image(Assets.getDressSeriesTexture("DressMarket/tabtn_hand_down")),
						downIcon:new Image(Assets.getDressSeriesTexture("DressMarket/tabtn_hand_down"))},
					{ type:"foot" ,
						defaultIcon:new Image(Assets.getDressSeriesTexture("DressMarket/tabtn_foot_up")) ,
						defaultSelectedIcon:new Image(Assets.getDressSeriesTexture("DressMarket/tabtn_foot_down")),
						downIcon:new Image(Assets.getDressSeriesTexture("DressMarket/tabtn_foot_down"))},
					{ type:"set" ,
						defaultIcon:new Image(Assets.getDressSeriesTexture("DressMarket/tabtn_set_up")) ,
						defaultSelectedIcon:new Image(Assets.getDressSeriesTexture("DressMarket/tabtn_set_down")),
						downIcon:new Image(Assets.getDressSeriesTexture("DressMarket/tabtn_set_down"))},
				]);
			
			btnTabBar.addEventListener(Event.CHANGE, btnTabBarChangeHandler);
			view.addChild(btnTabBar);
			btnTabBar.direction = TabBar.DIRECTION_VERTICAL;
			
			btnTabBar.customTabName = "btnTabBar";
			btnTabBar.tabProperties.stateToSkinFunction = null;
		}
		private function btnTabBarChangeHandler(event:Event):void{
			scroll.showItemByType(btnTabBar.selectedItem.type,charater.sex);
		}
		
		//点击人物
		private function charaterHandle(e:TouchEvent):void{
			var touch:Touch = e.getTouch((e.target as starling.display.DisplayObject),TouchPhase.ENDED);
			
			if(touch){
				
				var pro:String = GlobalModule.charaterUtils.getEquipProperty(GlobalModule.charaterUtils.getHumanDressList(charater));
				if(pro != ""){
					
					RollerUtils.setChartByProperty(previewCircle,pro);
					previewCircle.refresh();
				}
			}
		}
		//设置圈圈
		private function setCricle(_vo:DressSuitsVO):void{
			if(!previewCircle)
				return;
			
			previewCircle.clear();
			
			if(_vo.property && _vo.property != ""){
				RollerUtils.setChartByProperty(previewCircle,_vo.property);
				previewCircle.refresh();
				
				trace("这里："+_vo.property);
				return;
			}
			
			
			var pro:String = GlobalModule.charaterUtils.getEquipProperty(_vo.name);
			if(pro != ""){
				
				RollerUtils.setChartByProperty(previewCircle,pro);
				previewCircle.refresh();
			}
		}
		
		
		
		private function checkSave(_dressList:String):Boolean{
			var dressList:Array = _dressList.split(",");
			
			for(var i:int=0;i<dressList.length;i++){
				//过滤面部，默认脚
				if(dressList[i].indexOf("face") != -1 || dressList[i] == "shoes1")
					continue;
				
				
				//有未购买，返回false
				if(mySuitNameList.indexOf(dressList[i]) == -1){
					return false;
				}
			}
			return true;
			
		}
		private function saveBtnHandle(event:Event):void{
			var _dressList:String = GlobalModule.charaterUtils.getHumanDressList(charater);
			//没有未购买，可以上传身上的装备
			if(checkSave(_dressList))
				updateEquipToServer(_dressList);
			else
				sendNotification(WorldConst.DIALOGBOX_SHOW,
					new DialogBoxShowCommandVO(view,640,381,null,"您身上穿有未购买的衣服，请购买后再点击 \"保存形象\" "));
			
		}
		private function cancleBtnHandle(event:Event):void{
			
			GlobalModule.charaterUtils.configHumanFromDressList(charater,Global.myDressList,new Rectangle());
			
		}
		
		private function updateEquipToServer(dressList:String):void{
			PackData.app.CmdIStr[0] = CmdStr.UPDATE_CHARATER_EQUIPMENT;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = dressList;
			PackData.app.CmdInCnt = 3;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(WorldConst.UPDATE_CHARATER_EQUIPMENT_COMPLETE));

		}

		
		private function getStdInfo():void{
			PackData.app.CmdIStr[0] = CmdStr.GET_STUDENT_INFO;
			PackData.app.CmdIStr[1] = Global.user;
			PackData.app.CmdIStr[2] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 3;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(DressMarketConst.GET_STUDENT_INFO));
		}
		private function getMoney():void{
			PackData.app.CmdIStr[0] = CmdStr.GET_MONEY;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = "SYSTEM.SMONEY";
			PackData.app.CmdInCnt = 3;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(DressMarketConst.GET_MONEY));
		}
		private function getGameMeney():void{
			PackData.app.CmdIStr[0] = CmdStr.GET_GAME_MONEY;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = "SYSTEM.GAMEGOLD";
			PackData.app.CmdInCnt = 3;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(DressMarketConst.GET_GAME_MONEY));
			
		}
		
		//取后台个人已购买装备列表
		private function getMyEquipForServer():void{
			PackData.app.CmdIStr[0] = CmdStr.QRY_USER_EQUIP;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 2;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(DressMarketConst.QRY_USER_EQUIP));
		}
		
		private function getNewEquiplist():void{
			PackData.app.CmdIStr[0] = CmdStr.QRY_EQ_CONFIG;
			PackData.app.CmdIStr[1] = EQUIP_CONFIG_FLAG;
			PackData.app.CmdInCnt = 2;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(DressMarketConst.QRY_NEW_EQUIP_LIST));
			
		}
		
		private var buyClickItem:DressMarketItem;
		private var buyDressSuitVo:DressSuitsVO;
		//购买装备
		private function buyEquipment(_dressSuitVo:DressSuitsVO):void{
//			buyClickItem = _clickItem;
			buyDressSuitVo = _dressSuitVo;
			
			PackData.app.CmdIStr[0] = CmdStr.BUY_EQUIPMENT;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = _dressSuitVo.equipId; //equipId
			PackData.app.CmdInCnt = 3;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(DressMarketConst.BUY_EQUIPMENT));
		}
		
		
		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case DressMarketConst.GET_STUDENT_INFO:
					if(!result.isErr){
						stuSex = PackData.app.CmdOStr[21];
						
						getMoney();
					}
					break;
				case DressMarketConst.GET_MONEY:
					if(!result.isErr){
						goldNum = PackData.app.CmdOStr[4];
						getGameMeney();
					}
					break;
				case DressMarketConst.GET_GAME_MONEY:
					if(!result.isErr){
						gameGoldNum = PackData.app.CmdOStr[3];
						
						
						if(Global.dressDatalist && Global.dressDatalist.length == 0){
							//取商城所有装备
							Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.GET_SERVER_EQUIPMENT,[DressMarketConst.QRY_EQUIPMENT]);
						}else{
							//检查是否进入娱乐岛
							getMyEquipForServer();
						}
						
						
					}
					
					break;
				case DressMarketConst.QRY_EQUIPMENT:
					//取商城所有装备
					if(!result.isEnd){
						
						var dressSuitVo:DressSuitsVO = new DressSuitsVO();
						dressSuitVo.equipId = PackData.app.CmdOStr[1];
						dressSuitVo.name = PackData.app.CmdOStr[2];
						dressSuitVo.price = PackData.app.CmdOStr[3];
						dressSuitVo.property = PackData.app.CmdOStr[6];
						dressSuitVo.goldprice = PackData.app.CmdOStr[8];
						
						serverSuitList.push(dressSuitVo);
						
					}else{
						//更新Global数据
						Global.dressDatalist = serverSuitList;
						
						getMyEquipForServer();
						
					}
					break;
				case DressMarketConst.QRY_USER_EQUIP:
					//取用户所有装备
					if(!result.isEnd){
						
						mySuitNameList.push(PackData.app.CmdOStr[2]);
						
					}else{
						
						/*Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);*/
						
						getNewEquiplist();
						
					}
					break;
				case DressMarketConst.QRY_NEW_EQUIP_LIST:
					if(!result.isEnd){
						if(PackData.app.CmdOStr[1] == EQUIP_CONFIG_FLAG)
						{
							var newEQStr:String = PackData.app.CmdOStr[5];
							newList = newEQStr.split(",");
							trace("新装备==============================="+newEQStr);
						}
						
					}else{
						
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
						
					}
					
					break;
				case DressMarketConst.BUY_EQUIPMENT:
					//购买成功
					if((PackData.app.CmdOStr[0] as String)=="000"){
						//加入本地个人装备表
						mySuitNameList.push(PackData.app.CmdOStr[2]);
						buyDressSuitVo.hasBuy = true;
						buyClickItem.freshItem(buyDressSuitVo);
						
						//更新界面金币数
						gameGoldTF.text = PackData.app.CmdOStr[3];
						goldTF.text = PackData.app.CmdOStr[4];
						
						sendNotification(WorldConst.DIALOGBOX_SHOW,
							new DialogBoxShowCommandVO(view,640,381,null,"恭喜您，该装备已收进您的个人空间"));
						
					}else if((PackData.app.CmdOStr[0] as String)=="M00"){
						//金币不够
						sendNotification(WorldConst.DIALOGBOX_SHOW,
							new DialogBoxShowCommandVO(view,640,381,null,"十分抱歉，您的金币不足，购买失败"));
						
					}else{
						sendNotification(WorldConst.DIALOGBOX_SHOW,
							new DialogBoxShowCommandVO(view,640,381,null,"莫名错误导致购买失败，请与客服联系"));
						
					}
					
					
					
					break;
				case WorldConst.UPDATE_CHARATER_EQUIPMENT_COMPLETE:
					Global.myDressList = GlobalModule.charaterUtils.getHumanDressList(charater);
					
					sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,640,381,null,"温馨提醒：您的衣服换好了哦！"));
					
					
					
					break;
				case DressMarketItem.ITEM_CLICK:
					
					var suitvo:DressSuitsVO = notification.getBody() as DressSuitsVO;
					
					dressSuitsProxy.dressUp(charater,suitvo);
					
					break;
				case DressMarketItem.BUY_CLICK:
					buyClickItem = notification.getBody()[0] as DressMarketItem;
					var _suitvo:DressSuitsVO = notification.getBody()[1] as DressSuitsVO;
					
					sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,
						640,381,buyEquipment,"确定要花费 "+_suitvo.price+"钻石 和 "+_suitvo.goldprice+"金币 购买 这件装备 吗？",null,_suitvo));
					
					
//					buyEquipment(notification.getBody() as String);
					
					
					break;
				case DressMarketConst.UPDATE_MONEY:
					//更新界面金币数
					gameGoldTF.text = notification.getBody()[0] as String;
					goldTF.text = notification.getBody()[1] as String;
					
					break;
				case DressUpgradeMediator.UPDATE_EQUIP_SUCCESS:
					//加入本地个人装备表
					mySuitNameList.push(notification.getBody() as String);
					
					break;
				
			}
		}
		override public function listNotificationInterests():Array{
			return [DressMarketConst.GET_STUDENT_INFO,DressMarketConst.GET_MONEY,DressMarketConst.GET_GAME_MONEY,
				DressMarketItem.ITEM_CLICK,DressMarketItem.BUY_CLICK,DressMarketConst.UPDATE_MONEY,
				DressMarketConst.QRY_USER_EQUIP,DressMarketConst.QRY_EQUIPMENT,
				DressMarketConst.BUY_EQUIPMENT,WorldConst.UPDATE_CHARATER_EQUIPMENT_COMPLETE,
				DressUpgradeMediator.UPDATE_EQUIP_SUCCESS,DressMarketConst.QRY_NEW_EQUIP_LIST];
		}
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class{
			return Sprite;
		}
		override public function onRemove():void{
			super.onRemove();
			BitmapFontUtils.dispose();
			(facade.retrieveProxy(ModuleConst.HUMAN_POOL) as ObjectPool).object = charater;
			sendNotification(WorldConst.SET_ROLL_SCREEN,true);
			sendNotification(WorldConst.SHOW_MAIN_MENU);
			
			if(charater && charater.view)
				charater.view.removeEventListener(TouchEvent.TOUCH,charaterHandle);

			view.removeChildren(0,-1,true);
		}
	}
}