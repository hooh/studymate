package com.studyMate.world.screens
{
	import com.byxb.utils.centerPivot;
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.house.HouseInfoVO;
	import com.mylib.game.house.HouseItemSprite;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	
	import flash.geom.Rectangle;
	
	import feathers.controls.PageIndicator;
	import feathers.controls.ScrollContainer;
	import feathers.events.FeathersEventType;
	import feathers.layout.TiledRowsLayout;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.VAlign;
	import com.studyMate.utils.MyUtils;

	public class HouseStoreMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "HouseStoreMediator";
		private static const BUY_STD_PER_ROOM_COMPLETE:String = "BuyStdPerroomComplete";

		private var vo:SwitchScreenVO;
		private var ownHouseHolder:Sprite;
		
		private var layout:TiledRowsLayout;
		private var pageContainer:ScrollContainer;
		private var pageIndicator:PageIndicator;
		
		private var houseNameTF:TextField;
		private var houseBuildTimeTF:TextField;
		private var houseMaxNumTF:TextField;
		
		private var buyBtn:feathers.controls.Button;
		
		public function HouseStoreMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void{
			this.vo = vo;
			this.ownHouseHolder = vo.data as Sprite;
			
			getHouseList();
			getStoreHouseList();
			
			/*Facade.getInstance(ApplicationFacade.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);*/
		}

		
		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case WorldConst.QRY_PER_ROOM_COMPLETE:
					var houseVo:HouseInfoVO;
					if(!result.isEnd){
						houseVo = new HouseInfoVO();
						houseVo.id = PackData.app.CmdOStr[1];
						houseVo.name = PackData.app.CmdOStr[2];
						houseVo.data = PackData.app.CmdOStr[3];
						houseVo.type = PackData.app.CmdOStr[4];
						houseVo.width = Number(PackData.app.CmdOStr[5]);
						houseVo.y = Number(PackData.app.CmdOStr[6]);
						houseVo.maxNumber = int(PackData.app.CmdOStr[7]);
						houseVo.price = Number(PackData.app.CmdOStr[8]);
						houseVo.status = PackData.app.CmdOStr[9];
						houseVo.buildTime = PackData.app.CmdOStr[10];
						
						//本地存在素材的房子才展示
						if(localHouseImgList.indexOf(houseVo.data) != -1){
							storeHouseList.push(houseVo);
						}
						
						
					}else{
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
					}
					
					break;
				case BUY_STD_PER_ROOM_COMPLETE:
					if(!result.isErr){
						trace(PackData.app.CmdOStr[0]);
						if(PackData.app.CmdOStr[0] == "0M1")
							sendNotification(WorldConst.DIALOGBOX_SHOW,
								new DialogBoxShowCommandVO(view,640,381,null,"十分抱歉，您的金币不足以购买该楼盘！"));
						else{
							sendNotification(WorldConst.ADD_ISLAND_HOUSE,newHouseVo(storeHouseList[pageIndicator.selectedIndex]));
						}
					}
					break;
				
				
			}
		}
		private function newHouseVo(_houseVo:HouseInfoVO):HouseInfoVO{
			var houseVo:HouseInfoVO = new HouseInfoVO();
			houseVo.id = _houseVo.id;
			houseVo.name = _houseVo.name;
			houseVo.data = _houseVo.data;
			houseVo.type = _houseVo.type;
			houseVo.width = _houseVo.width;
			houseVo.y = _houseVo.y;
			houseVo.maxNumber = _houseVo.maxNumber;
			houseVo.price = _houseVo.price;
			houseVo.status = _houseVo.status;
			houseVo.buildTime = _houseVo.buildTime;
			return houseVo;
		}
		
		override public function listNotificationInterests():Array{
			return [WorldConst.QRY_PER_ROOM_COMPLETE,BUY_STD_PER_ROOM_COMPLETE];
		}
		
		override public function onRegister():void {
			sendNotification(WorldConst.SET_ROLL_SCREEN,false);
			sendNotification(WorldConst.HIDE_TALKINGBOX);
			
			var img:Image = new Image(Assets.getTexture("MessagePaper"));
			centerPivot(img);
			view.addChild(img);
			img.x = 640; img.y = 381;

			var texture:Texture = Assets.getAtlasTexture("huInfo_closeBtn");
			var closeBtn:starling.display.Button = new starling.display.Button(texture);
			closeBtn.x = 1180; closeBtn.y = 10;
			closeBtn.addEventListener(TouchEvent.TOUCH, onCloseBtnHandler);
			view.addChild(closeBtn);
			
			
			showAllHouse();
			
			createHouseInfHolder();
			
			if(storeHouseList.length > 0)
				setHouseInf(storeHouseList[0]);
			
		}
		
		
		
		private function showAllHouse():void{
			layout = new TiledRowsLayout();
			layout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			layout.gap = 2;
			layout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			layout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
			layout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
			layout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_MIDDLE;
			layout.useSquareTiles = false;
			
			pageContainer = new ScrollContainer();
			pageContainer.x = 470;
			pageContainer.y = 150;
			pageContainer.width = 340;
			pageContainer.height = 400;
			pageContainer.layout = layout;
			pageContainer.snapToPages = TiledRowsLayout.PAGING_VERTICAL;
			pageContainer.snapScrollPositionsToPixels = true;
			view.addChild(pageContainer);
			pageContainer.addEventListener(FeathersEventType.SCROLL_COMPLETE,pageContainerHandle);
			pageContainer.clipContent = false;
			pageContainer.clipRect = new Rectangle(-310,0,940,400);
			
			var len:int = storeHouseList.length;
			var houseItemSp:HouseItemSprite;
			for(var i:int=0;i<len;i++){
				houseItemSp = new HouseItemSprite(storeHouseList[i]);
				
				pageContainer.addChild(houseItemSp);
			}
			
			
			pageIndicator = new PageIndicator();
			view.addChild(pageIndicator);
			pageIndicator.width = 100;
			centerPivot(pageIndicator);
			pageIndicator.x = 640;
			pageIndicator.y = 550;
			pageIndicator.direction = PageIndicator.DIRECTION_HORIZONTAL;
			pageIndicator.gap = 3;
			pageIndicator.pageCount = pageContainer.numChildren;
			pageIndicator.touchable = false;
			
			TweenLite.delayedCall(0.5,function():void{
				if(storeHouseList.length > 0){
					storeHouseList[0].houseImg.scaleX = 1.3;
					storeHouseList[0].houseImg.scaleY = 1.3;
				}
			});
			
		}
		private function createHouseInfHolder():void{
			var titleTF:TextField = new TextField(300,70,"慢科地产","HuaKanT",45,0x330000,true);
			titleTF.vAlign = VAlign.CENTER;
			view.addChild(titleTF);
			titleTF.x = 640-(titleTF.width/2);
			titleTF.y = 25;
			
			houseNameTF = new TextField(500,70,"","HuaKanT",30,0x0066FF,true);
			houseNameTF.vAlign = VAlign.CENTER;
			view.addChild(houseNameTF);
			houseNameTF.x = 640-(houseNameTF.width/2);
			houseNameTF.y = 80;
			
			houseBuildTimeTF = new TextField(350,70,"","HuaKanT",30,0xFFB200,true);
			houseBuildTimeTF.vAlign = VAlign.CENTER;
			view.addChild(houseBuildTimeTF);
			houseBuildTimeTF.x = 640-houseBuildTimeTF.width;
			houseBuildTimeTF.y = 130;
			
			houseMaxNumTF = new TextField(350,70,"","HuaKanT",30,0xFFB200,true);
			houseMaxNumTF.vAlign = VAlign.CENTER;
			view.addChild(houseMaxNumTF);
			houseMaxNumTF.x = 640;
			houseMaxNumTF.y = 130;
			
			buyBtn = new feathers.controls.Button();
			buyBtn.label = "购买";
			buyBtn.width = 100;
			buyBtn.height = 50;
			view.addChild(buyBtn);
			buyBtn.x = 640-(buyBtn.width>>1);
			buyBtn.y = 575;
			buyBtn.addEventListener(Event.TRIGGERED,buyBtnHandle);
			if(storeHouseList.length == 0)
				buyBtn.isEnabled = false;
		}
		
		
		
		private var localHouseImgList:Array = new Array();
		private var storeHouseList:Vector.<HouseInfoVO> = new Vector.<HouseInfoVO>;
		private function getHouseList():void{
			var houseXml:XML = MyUtils.getXmlFile("textures/HapIslandHouse.xml");
			
			var name:String;
			for each (var i:XML in houseXml.children()){
				name = i.@name;
				localHouseImgList.push(name);
			}
			
		}
		private function getStoreHouseList():void{
			
			
			PackData.app.CmdIStr[0] = CmdStr.QRY_PER_ROOM;
			PackData.app.CmdIStr[1] = "*";
			PackData.app.CmdIStr[2] = "";
			PackData.app.CmdInCnt = 3;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(WorldConst.QRY_PER_ROOM_COMPLETE));
			
		}
		private function setHouseInf(_houseVo:HouseInfoVO):void{
			houseNameTF.text = "楼盘名称："+_houseVo.name;
			houseBuildTimeTF.text = "建筑耗时："+_houseVo.buildTime.toString()+"个月";
			houseMaxNumTF.text = "房子容量："+_houseVo.maxNumber.toString();
		}
		private function setHouseScale():void{
			var len:int = pageIndicator.pageCount;
			for(var i:int=0;i<len;i++){
				storeHouseList[i].houseImg.scaleX = 1;
				storeHouseList[i].houseImg.scaleY = 1;
			}
		}
		
		
		private function onCloseBtnHandler(e:TouchEvent):void{
			var touch:Touch = e.touches[0];
			if(touch.phase == TouchPhase.ENDED){
				vo.type = SwitchScreenType.HIDE;
				sendNotification(WorldConst.SWITCH_SCREEN,[vo]);
			}
		}
		private function pageContainerHandle():void{
			pageIndicator.selectedIndex = pageContainer.horizontalScrollPosition/pageContainer.width;
			
			setHouseScale();
			
			storeHouseList[pageIndicator.selectedIndex].houseImg.scaleX = 1.3;
			storeHouseList[pageIndicator.selectedIndex].houseImg.scaleY = 1.3;
			
			setHouseInf(storeHouseList[pageIndicator.selectedIndex]);
		}
		private function buyBtnHandle(event:Event):void{
			sendNotification(WorldConst.DIALOGBOX_SHOW,
				new DialogBoxShowCommandVO(view,640,381,dobuy,"是否花费 "+
					storeHouseList[pageIndicator.selectedIndex].price+" 万购买这套房?!",null,storeHouseList[pageIndicator.selectedIndex]));
		}
		private function dobuy(_houseVo:HouseInfoVO):void{
			
			PackData.app.CmdIStr[0] = CmdStr.BUY_STD_PER_ROOM;
			PackData.app.CmdIStr[1] = _houseVo.data;
			PackData.app.CmdIStr[2] = PackData.app.head.dwOperID.toString();
			/*PackData.app.CmdIStr[3] = (160+ownHouseHolder.numChildren*320).toString();*/
			PackData.app.CmdIStr[3] = (ownHouseHolder.numChildren*320).toString();
			trace("商店X："+ownHouseHolder.numChildren*320);
			PackData.app.CmdInCnt = 4;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(BUY_STD_PER_ROOM_COMPLETE));
			
		}
		
		
		
		override public function onRemove():void{
			super.onRemove();
			
			sendNotification(WorldConst.SET_ROLL_SCREEN,true);
			sendNotification(WorldConst.REMOVE_POPUP_SCREEN,this);
		}
		override public function get viewClass():Class{
			return Sprite;
		}
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
	}
}