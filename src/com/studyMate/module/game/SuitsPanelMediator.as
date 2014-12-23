package com.studyMate.module.game
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.charater.ICharater;
	import com.mylib.game.charater.item.EquipmentItemButton;
	import com.mylib.game.model.CharaterSuitsProxy;
	import com.mylib.game.model.DressSuitsProxy;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.module.game.api.DressRoomConst;
	import com.studyMate.world.model.vo.DressSuitsVO;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import feathers.controls.Button;
	import feathers.controls.ScrollContainer;
	import feathers.controls.TabBar;
	import feathers.controls.ToggleButton;
	import feathers.data.ListCollection;
	import feathers.layout.TiledRowsLayout;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class SuitsPanelMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "SuitsPanelMediator";
		private const GET_USER_EQUIPENT:String = NAME + "getUserEquipment";
		private const GET_CUST_DATA_EXT:String = NAME + "getCuteDataExt";
		private var vo:SwitchScreenVO;
		
		
		private var mySuitList:Array = new Array;
		private var suitsProxy:CharaterSuitsProxy;
		private var dressSuitsProxy:DressSuitsProxy;
		private var dressTabBar:TabBar;
		
		private var charater:ICharater; 
		
		//读取装备信息文件 equipmentInfo2.xml 获取装备信息列表 dressSuitsVoList	
		private var dressSuitsVoList:Vector.<DressSuitsVO> = new Vector.<DressSuitsVO>;
		
		public function SuitsPanelMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}
		override public function prepare(vo:SwitchScreenVO):void{
			this.vo = vo;
			this.charater = vo.data[0];
			
			
			getStdInfo();
//			getMyEquipForServer();
		}
		

		override public function onRegister():void{
			
			
			initDressList();
			
			
			init();
			
			trace("@VIEW:DressRoomMediator:");
		}
		private function initDressList():void{
			suitsProxy = facade.retrieveProxy(CharaterSuitsProxy.NAME) as CharaterSuitsProxy;
			
			dressSuitsProxy = facade.retrieveProxy(DressSuitsProxy.NAME) as DressSuitsProxy;
			dressSuitsProxy.addCharaterDress(charater);
			
			
			var suitList:Vector.<DressSuitsVO> = new Vector.<DressSuitsVO>;
			if(dressSuitsProxy.dressSuitsVoList)
				suitList = dressSuitsProxy.dressSuitsVoList;
			if(mySuitList){
				for(var i:int=0;i<mySuitList.length;i++){
					
					var suitvo:DressSuitsVO = checkSuit(suitList,(mySuitList[i] as DressSuitsVO).name);
					//用户已购买的，并且本地存在，显示
					if(suitvo){
						suitvo.equipId = (mySuitList[i] as DressSuitsVO).equipId;
						
						dressSuitsVoList.push(suitvo);
					}
				}
			}
			
			//测试用，跳过取个人装备列表过程
//			dressSuitsVoList = suitList;
		}
		private function checkSuit(_suitList:Vector.<DressSuitsVO>,_name:String):DressSuitsVO{
			if(_suitList){
				for(var i:int=0;i<_suitList.length;i++){
					//png有该装备
					if(_suitList[i].name == _name)
						return _suitList[i];
				}
			}
			return null;
		}
		
		
		
		
		private function tabButtonFactory():feathers.controls.Button{
			var tab:ToggleButton = new ToggleButton();
			tab.defaultSkin = new Image(Assets.getDressSeriesTexture("DressRoom/itemUnSelect"));
			tab.defaultSelectedSkin = new Image(Assets.getDressSeriesTexture("DressRoom/itemSelect"));
			tab.downSkin = new Image(Assets.getDressSeriesTexture("DressRoom/itemSelect"));
			return tab;
		}
		
		
		private function init():void{
			
			var bg:Image = new Image(Assets.getDressSeriesTexture("DressRoom/suitsPanelBg"));
			bg.y = 50;
			view.addChild(bg);
			
			
			layout = new TiledRowsLayout();
			layout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			layout.gap = 2;
			layout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			layout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
			layout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
			layout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_MIDDLE;
			
			createDressHolder();
			
			
			
			dressTabBar = new TabBar();
			dressTabBar.x = 25;
			dressTabBar.y = 22;
			dressTabBar.dataProvider = new ListCollection(
				[				
					{ label: "" ,type:"head" ,defaultIcon:new Image(Assets.getDressSeriesTexture("DressRoom/headIcon"))},				
					{ label: "" ,type:"body" ,defaultIcon:new Image(Assets.getDressSeriesTexture("DressRoom/clothIcon"))},	
					{ label: "" ,type:"hand" ,defaultIcon:new Image(Assets.getDressSeriesTexture("DressRoom/handIcon"))},	
					{ label: "" ,type:"foot" ,defaultIcon:new Image(Assets.getDressSeriesTexture("DressRoom/footIcon"))},		
					{ label: "" ,type:"set" ,defaultIcon:new Image(Assets.getDressSeriesTexture("DressRoom/setIcon"))},		
				]);
			
//			dressTabBar.width = 70*dressTabBar.dataProvider.length;
			dressTabBar.addEventListener(Event.CHANGE, dressTabBarChangeHandler);
			view.addChild(dressTabBar);
			dressTabBar.customTabName = "dressTabBar";
			dressTabBar.tabFactory = tabButtonFactory;
			dressTabBar.tabProperties.stateToSkinFunction = null;
			
			
			
			showEquipmentByType("head",charater.sex);
		}
		
		private var dressHolder:Sprite;
		private var layout:TiledRowsLayout;
		private var _equipItemcontainer:ScrollContainer;
		private function createDressHolder():void{
			_equipItemcontainer = new ScrollContainer();
			_equipItemcontainer.x = 25;
			_equipItemcontainer.y = 93;
			_equipItemcontainer.width = 1230;
			_equipItemcontainer.height = 210;
			_equipItemcontainer.layout = layout;
			_equipItemcontainer.snapToPages = TiledRowsLayout.PAGING_VERTICAL;
			_equipItemcontainer.snapScrollPositionsToPixels = true;
			
			
			dressHolder = new Sprite();
			dressHolder.addChild(_equipItemcontainer);
			view.addChild(dressHolder);
		}
		
		
		private function dressTabBarChangeHandler(event:Event):void{
//			trace("选择卡： "+dressTabBar.selectedItem.label+dressTabBar.selectedItem.type);
			showEquipmentByType(dressTabBar.selectedItem.type,charater.sex);
			
		}
		
		
		

		
		public function showEquipmentByType(_suitType:String,_sex:String):void{
			
			
			while(_equipItemcontainer.numChildren > 0)
				_equipItemcontainer.removeChildAt(_equipItemcontainer.numChildren-1);
			
			var itemBtn:EquipmentItemButton;
			var len:int = dressSuitsVoList.length;
			for(var i:int=0;i<len;i++){
				if((dressSuitsVoList[i].suitType == _suitType 
					&& _sex == "A" && (dressSuitsVoList[i].level == "0" || dressSuitsVoList[i].level == "1"))
					|| (dressSuitsVoList[i].suitType == _suitType 
					&& (dressSuitsVoList[i].sex == _sex || dressSuitsVoList[i].sex == "B") 
					&& (dressSuitsVoList[i].level == "0" || dressSuitsVoList[i].level == "1"))){
					var len2:int = dressSuitsVoList[i].equipments.length;

					itemBtn = new EquipmentItemButton(Assets.getDressSeriesTexture("DressRoom/suitSpanelItem"));
					
					
					var img:DisplayObject = GlobalModule.charaterUtils.getNormalEquipImg(dressSuitsVoList[i],2);
					img.x = (itemBtn.width>>1)-(img.width>>1);
					img.y = (itemBtn.height>>1)-(img.height>>1);
					itemBtn.addChild(img);
					

					itemBtn.dressSuitsVo = dressSuitsVoList[i];
					itemBtn.addEventListener(TouchEvent.TOUCH,itemBtnHandle);
					
					_equipItemcontainer.addChild(itemBtn);
				}
			}
		}
		private var beginX:Number;
		private var endX:Number;
		private function itemBtnHandle(event:TouchEvent):void{
			var btn:EquipmentItemButton = event.currentTarget as EquipmentItemButton;
			var touchPoint:Touch = event.getTouch(btn);
			
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					beginX = touchPoint.globalX;
				}else if(touchPoint.phase==TouchPhase.ENDED){
					endX = touchPoint.globalX;
					if(Math.abs(endX-beginX) < 10){
//						dressSuitsProxy.dressUp(charater,btn.dressSuitsVo);
						
						//检查身上是否穿该件衣服
						var dresslist:String = GlobalModule.charaterUtils.getHumanDressList(charater);
						var had:Boolean = dresslist.indexOf(btn.dressSuitsVo.name) != -1;
						
						if(btn.parent){
							sendNotification(WorldConst.SWITCH_SCREEN,new SwitchScreenVO(ItemControlMediator,[btn,had],SwitchScreenType.SHOW));
							
						}
						
					}
				}
			}
			
		}
		
		private function delEquip(_vo:DressSuitsVO):void{
			//本地删除
			for (var i:int = 0; i < dressSuitsVoList.length; i++) 
			{
				if(_vo.name == dressSuitsVoList[i].name)
				{
					dressSuitsVoList.splice(i,1);
					break;
				}
				
			}
		}
		
		//取性别
		private function getStdInfo():void{
			PackData.app.CmdIStr[0] = CmdStr.GET_CUST_DATA_EXT;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 2;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(GET_CUST_DATA_EXT,null,'cn-gb',null,SendCommandVO.QUEUE));
		}
		
		//取后台个人已购买装备列表
		private function getMyEquipForServer():void{
			PackData.app.CmdIStr[0] = CmdStr.QRY_USER_EQUIP;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 2;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(GET_USER_EQUIPENT,null,'cn-gb',null,SendCommandVO.QUEUE));
		}
		
		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case GET_CUST_DATA_EXT:
					var _str:String = "defaultset";
					if(!result.isErr){
						//女
						if( PackData.app.CmdOStr[2] == 0 ){
							_str = "defaultset2";
						}
						
					}
					//将默认装备加入个人列表，但不能出售
					if(mySuitList){
						var defVo:DressSuitsVO = new DressSuitsVO;
						defVo.equipId = "-1";
						defVo.name = _str;
						mySuitList.push(defVo);
						
					}
					
					getMyEquipForServer();
					
					break;
				case GET_USER_EQUIPENT:
					//取用户所有装备
					if(!result.isEnd){
						var tmpvo:DressSuitsVO = new DressSuitsVO;
						tmpvo.equipId = PackData.app.CmdOStr[1];
						tmpvo.name = PackData.app.CmdOStr[2]
						
						mySuitList.push(tmpvo);
						
					}else{
						/*Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.GET_SERVER_EQUIPMENT,[GET_EQUIP_PRICE]);*/
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
						
					}
					
					break;
				case DressRoomConst.HUMAN_DRESS:
					
					var btn:EquipmentItemButton = notification.getBody() as EquipmentItemButton;
					dressSuitsProxy.dressUp(charater,btn.dressSuitsVo);
					
					
					
					break;
				case DressRoomConst.SELL_DRESS_COMPLETE:
					btn = notification.getBody() as EquipmentItemButton;
					delEquip(btn.dressSuitsVo);
					btn.removeFromParent(true);
					
					
					break;
			}
		}
		override public function listNotificationInterests():Array{
			return [GET_USER_EQUIPENT,DressRoomConst.HUMAN_DRESS,DressRoomConst.SELL_DRESS_COMPLETE,GET_CUST_DATA_EXT];
		}
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class{
			return Sprite;
		}
		override public function onRemove():void{
			super.onRemove();
			_equipItemcontainer.removeChildren(0,-1,true);
			
		}
	}
}