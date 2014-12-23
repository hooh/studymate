package com.studyMate.module.game.gameEditor
{
	import com.byxb.utils.centerPivot;
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.house.HouseInfoVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.module.game.api.HouseEditorConst;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.screens.HappyIslandBackground;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.geom.Rectangle;
	import flash.globalization.DateTimeFormatter;
	
	import feathers.controls.Button;
	import feathers.controls.PageIndicator;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Slider;
	import feathers.controls.TextInput;
	import feathers.controls.ToggleSwitch;
	import feathers.events.FeathersEventType;
	import feathers.layout.TiledRowsLayout;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class HouseEditorMediator extends ScreenBaseMediator implements IMediator
	{
		private var vo:SwitchScreenVO;
		private var isFirstIn:Boolean = true;
		
		private var houseSp:Sprite;
		private var frontSp:Sprite;
		private var dataSp:Sprite;
		private var controlSp:Sprite;
		private var preViewSp:Sprite;
		private var _background:HappyIslandBackground;
		
		private var serverHouseList:Vector.<HouseInfoVO> = new Vector.<HouseInfoVO>;
		private var localHouseList:Vector.<HouseInfoVO> = new Vector.<HouseInfoVO>;
		
		
		private var houseName:TextInput;
		private var houseDfata:TextInput;
		private var houseType:TextInput;
		private var houseWidth:TextInput;
		private var houseOffsetY:TextInput;
		private var houseMaxNum:TextInput;
		private var housePrice:TextInput;
		private var houseDealOperID:TextInput;
		private var houseDealTime:TextInput;
		private var isSell:ToggleSwitch;
		private var buildTime:TextInput;
		
		
		private var isPreView:Boolean = false;
		private var preViewBtn:Button;
		private var nowStateTF:TextField;
		private var preViewHouseY:TextField;
		
		private var isServerHad:TextField;
		private var isModify:TextField;
		private var saveBtn:Button;
		private var delBtn:Button;
		private var bgTexture:Texture;
		
		public function HouseEditorMediator(viewComponent:Object=null)
		{
			super(ModuleConst.HOUSE_EDITOR, viewComponent);
		}
		override public function prepare(vo:SwitchScreenVO):void
		{
			this.vo = vo;
			
			getServerHouseList();
			
//			Facade.getInstance(ApplicationFacade.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		override public function onRegister():void
		{
			sendNotification(WorldConst.HIDE_MAIN_MENU);
			bgTexture = Texture.fromBitmap(Assets.store["task_bg"],false);
			var bg:Image = new Image(bgTexture);
			view.addChild(bg);
			
			_background = new HappyIslandBackground;
			_background.touchable = false;
			_background.y = 381;
			view.addChild(_background);
			_background.show(new Rectangle(-Global.stageWidth*0.5,-Global.stageHeight*0.5,Global.stageWidth,Global.stageHeight));
			_background.alpha = 0;
			
			houseSp = new Sprite();
			view.addChild(houseSp);
			
			frontSp = new Sprite();
			view.addChild(frontSp);
			
			dataSp = new Sprite();
			view.addChild(dataSp);
			
			controlSp = new Sprite();
			view.addChild(controlSp);
			
			preViewSp = new Sprite();
			view.addChild(preViewSp);
			
			
			getHouseList();
			
			
			
			createPageHolder();
			createFrontHolder();
			
			
			
			createPreViewHolder();
			createControlHolder();
			
			createDataHolder();
			
		}
		
		
		
		
		
/**界面初始化***********************************************************************/			
		
		private var layout:TiledRowsLayout;
		private var pageContainer:ScrollContainer;
		private var pageIndicator:PageIndicator;
		private function createPageHolder():void{
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
			pageContainer.y = 50;
			pageContainer.width = 340;
			pageContainer.height = 400;
			pageContainer.layout = layout;
			pageContainer.snapToPages = TiledRowsLayout.PAGING_VERTICAL;
			pageContainer.snapScrollPositionsToPixels = true;
			houseSp.addChild(pageContainer);
			pageContainer.addEventListener(FeathersEventType.SCROLL_COMPLETE,pageContainerHandle);
			pageContainer.addEventListener(TouchEvent.TOUCH,pageContainerClick);
			
			
			pageContainer.clipContent = false;
			
			var len:int = localHouseList.length;
			
			for(var i:int=0;i<len;i++){
				pageContainer.addChild(localHouseList[i].houseImg);
			}
		}
		private function createFrontHolder():void{
			pageIndicator = new PageIndicator();
			frontSp.addChild(pageIndicator);
			pageIndicator.width = 100;
			centerPivot(pageIndicator);
			pageIndicator.x = 640;
			pageIndicator.y = 500;
			pageIndicator.direction = PageIndicator.DIRECTION_HORIZONTAL;
			pageIndicator.gap = 3;
			pageIndicator.pageCount = pageContainer.numChildren;
			pageIndicator.touchable = false;
			
			TweenLite.delayedCall(0.5,function():void{
				localHouseList[0].houseImg.scaleX = 1.3;
				localHouseList[0].houseImg.scaleY = 1.3;
				
			});
			
			
			nowStateTF = new TextField(150,70,"编辑状态","HeiTi",30,0x330000,true);
			nowStateTF.vAlign = VAlign.CENTER;
			view.addChild(nowStateTF);
			nowStateTF.x = 640-(nowStateTF.width/2);
			nowStateTF.y = 5;
			
			isServerHad = new TextField(150,70,"已存在","HeiTi",25,0x330000,true);
			isServerHad.vAlign = VAlign.CENTER;
			view.addChild(isServerHad);
			isServerHad.x = 730;
			isServerHad.y = 5;
			
			isModify = new TextField(150,70,"","HeiTi",25,0x330000,true);
			isModify.vAlign = VAlign.CENTER;
			view.addChild(isModify);
			isModify.x = 900;
			isModify.y = 5;
			
			
			
			
			
		}
		private function createDataHolder():void{
			var titleTF:TextField;
			for(var i:int=0;i<11;i++){
				titleTF = new TextField(150,70,"","HeiTi",20,0x330000,true);
				titleTF.x = (int(i/3))*320;
				titleTF.y = (i%3)*70+530;
				titleTF.hAlign = HAlign.RIGHT;
				titleTF.vAlign = VAlign.TOP;
				dataSp.addChild(titleTF);
				switch(i){
					case 0:  titleTF.text = "房子名称(roomName)";  break;
					case 1:  titleTF.text = "素材数据(wbidface)";  break;
					case 2:  titleTF.text = "房子类型(type)";  break;
					case 3:  titleTF.text = "房子宽度(weight)";  break;
					case 4:  titleTF.text = "房子Y值(offset_y)";  break;
					case 5:  titleTF.text = "NPC容量(maxstonum)";  break;
					case 6:  titleTF.text = "单价(price)";  break;
					case 7:  titleTF.text = "操作员ID(dealoperid)";  break;
					case 8:  titleTF.text = "修改时间(dealtime)";  break;
					case 9:  titleTF.text = "是否上架(isSell)";  break;
					case 10:  titleTF.text = "修建时间(buildTime)";  break;
				}
				
			}
			
			houseName = new TextInput();
			houseName.name = "houseName";
			houseName.width = 160;
			houseName.height = 50;
			houseName.x = 155;
			houseName.y = 530;
			dataSp.addChild(houseName);
			houseName.addEventListener(FeathersEventType.FOCUS_IN,inputClick);
			
			houseDfata = new TextInput();
			houseDfata.name = "houseDfata";
			houseDfata.width = 160;
			houseDfata.height = 50;
			houseDfata.x = 155;
			houseDfata.y = 600;
			houseDfata.isEnabled = false;
			dataSp.addChild(houseDfata);
			
			houseType = new TextInput();
			houseType.name = "houseType";
			houseType.width = 160;
			houseType.height = 50;
			houseType.x = 155;
			houseType.y = 670;
			dataSp.addChild(houseType);
			houseType.addEventListener(FeathersEventType.FOCUS_IN,inputClick);
			
			houseWidth = new TextInput();
			houseWidth.name = "houseWidth";
			houseWidth.width = 160;
			houseWidth.height = 50;
			houseWidth.x = 475;
			houseWidth.y = 530;
			dataSp.addChild(houseWidth);
			houseWidth.addEventListener(FeathersEventType.FOCUS_IN,inputClick);
			
			houseOffsetY = new TextInput();
			houseOffsetY.name = "houseOffsetY";
			houseOffsetY.width = 160;
			houseOffsetY.height = 50;
			houseOffsetY.x = 475;
			houseOffsetY.y = 600;
			houseOffsetY.isEnabled = false;
			dataSp.addChild(houseOffsetY);
			
			houseMaxNum = new TextInput();
			houseMaxNum.name = "houseMaxNum";
			houseMaxNum.width = 160;
			houseMaxNum.height = 50;
			houseMaxNum.x = 475;
			houseMaxNum.y = 670;
			dataSp.addChild(houseMaxNum);
			houseMaxNum.addEventListener(FeathersEventType.FOCUS_IN,inputClick);
			
			housePrice = new TextInput();
			housePrice.name = "housePrice";
			housePrice.width = 160;
			housePrice.height = 50;
			housePrice.x = 795;
			housePrice.y = 530;
			dataSp.addChild(housePrice);
			housePrice.addEventListener(FeathersEventType.FOCUS_IN,inputClick);
			
			houseDealOperID = new TextInput();
			houseDealOperID.name = "houseDealOperID";
			houseDealOperID.width = 160;
			houseDealOperID.height = 50;
			houseDealOperID.x = 795;
			houseDealOperID.y = 600;
			houseDealOperID.isEnabled = false;
			dataSp.addChild(houseDealOperID);
			
			houseDealTime = new TextInput();
			houseDealTime.name = "houseDealTime";
			houseDealTime.width = 160;
			houseDealTime.height = 50;
			houseDealTime.x = 795;
			houseDealTime.y = 670;
			houseDealTime.isEnabled = false;
			dataSp.addChild(houseDealTime);
			
			isSell = new ToggleSwitch();
			isSell.name = "isSell";
			isSell.x = 1115;
			isSell.y = 530;
			isSell.onText = "是";
			isSell.offText = "否";
			dataSp.addChild(isSell);
//			isSell.addEventListener(FeathersEventType.FOCUS_IN,inputClick);
			isSell.addEventListener(TouchEvent.TOUCH,toggleClick);
			
			buildTime = new TextInput();
			buildTime.name = "buildTime";
			buildTime.width = 160;
			buildTime.height = 50;
			buildTime.x = 1115;
			buildTime.y = 600;
			dataSp.addChild(buildTime);
			buildTime.addEventListener(FeathersEventType.FOCUS_IN,inputClick);
			

			showHouseData(0);
			
		}
		
		private var ySlider:Slider;
		private function createPreViewHolder():void{
			preViewSp.alpha = 0;
			
			ySlider = new Slider();
			ySlider.minimum = -100;
			ySlider.maximum = 300;			
			ySlider.value = 130;
			ySlider.step = 1;
			ySlider.direction = Slider.DIRECTION_VERTICAL;			
			ySlider.liveDragging = true;			
			ySlider.validate();
			ySlider.x = 850;
			ySlider.y = 150;
			ySlider.width = 35;
			ySlider.height = 350;
			ySlider.addEventListener(TouchEvent.TOUCH, ySliderHandler);
			preViewSp.addChild(ySlider);
			
			
			
			
			var titleTF:TextField;
			titleTF = new TextField(150,70,"","HeiTi",20,0x330000,true);
			titleTF.x = 320;
			titleTF.y = 600;
			titleTF.hAlign = HAlign.RIGHT;
			titleTF.vAlign = VAlign.TOP;
			titleTF.text = "房子Y值(offset_y)";
			preViewSp.addChild(titleTF);
			
			
			
			preViewHouseY = new TextField(160,50,"","HeiTi",15);
			preViewHouseY.x = 475;
			preViewHouseY.y = 600;
			titleTF.hAlign = HAlign.LEFT;
			titleTF.vAlign = VAlign.TOP;
			preViewHouseY.touchable = false;
			preViewSp.addChild(preViewHouseY);
		}
		
		private function createControlHolder():void{
			preViewBtn = new Button();
			preViewBtn.label = "预览";
			preViewBtn.width = 100;
			preViewBtn.height = 50;
			preViewBtn.x = 100;
			preViewBtn.y = 20;
			controlSp.addChild(preViewBtn);
			preViewBtn.addEventListener(Event.TRIGGERED,preViewBtnHandle);
			
			
			saveBtn = new Button();
			saveBtn.label = "上传服务器";
			saveBtn.width = 100;
			saveBtn.height = 50;
			saveBtn.x = 210;
			saveBtn.y = 20;
			saveBtn.isEnabled = false;
			controlSp.addChild(saveBtn);
			saveBtn.addEventListener(Event.TRIGGERED,saveBtnHandle);
			
			delBtn = new Button();
			delBtn.label = "删除房子";
			delBtn.width = 100;
			delBtn.height = 50;
			delBtn.x = 320;
			delBtn.y = 20;
			delBtn.isEnabled = false;
			controlSp.addChild(delBtn);
			delBtn.addEventListener(Event.TRIGGERED,delBtnHandle);
			
		}
		
		
		
		
		
		
		
		
		
		
		
/**监听函数***********************************************************************/		
		private function pageContainerHandle():void{
			pageIndicator.selectedIndex = pageContainer.horizontalScrollPosition/pageContainer.width;
			
			setHouseScale();

			localHouseList[pageIndicator.selectedIndex].houseImg.scaleX = 1.3;
			localHouseList[pageIndicator.selectedIndex].houseImg.scaleY = 1.3;
			
			showHouseData(pageIndicator.selectedIndex);
		}
		private var preViewHouse:Image;
		private function preViewBtnHandle(event:Event):void{
			//预览状态
			if(isPreView){
				if(preViewHouse){
					preViewHouse.removeFromParent(true);
					preViewHouse = null;
				}
				nowStateTF.text = "编辑状态";
				preViewBtn.label = "预览";
				
				overEffect(_background,false);
				overEffect(preViewSp,false);
				overEffect(dataSp,true);
				overEffect(houseSp,true);
				overEffect(frontSp,true);
				
				localHouseList[pageIndicator.selectedIndex].y = ySlider.value;
				setInput(localHouseList[pageIndicator.selectedIndex]);
				
				isPreView = false;
			}else{
				nowStateTF.text = "预览状态";
				preViewBtn.label = "退出预览";
				
				overEffect(_background,true);
				overEffect(preViewSp,true);
				overEffect(dataSp,false);
				overEffect(houseSp,false);
				overEffect(frontSp,false);
				
				if(!preViewHouse){
					preViewHouse = new Image(Assets.getHapIslandHouseTexture(localHouseList[pageIndicator.selectedIndex].data));
					preViewHouse.pivotX = preViewHouse.width/2;
					preViewHouse.pivotY = preViewHouse.height;
					preViewHouse.x = 640;
					/*preViewHouse.y = 381+130;*/
					preViewHouse.y = 381+localHouseList[pageIndicator.selectedIndex].y;
					view.addChild(preViewHouse);
					
					TweenLite.from(preViewHouse,0.5,{scaleX:1.3,scaleY:1.3,y:(100+381)});
				}
				preViewHouseY.text = localHouseList[pageIndicator.selectedIndex].y.toString();
				ySlider.value = localHouseList[pageIndicator.selectedIndex].y;
				
				isPreView = true;
			}
			
		}
		//过度效果
		private function overEffect(target:DisplayObject,_endVisible:Boolean):void{
			TweenLite.killTweensOf(target);
			
			if(_endVisible){
				target.alpha = 1;
				TweenLite.from(target,0.5,{alpha:0});
			}else{
				target.alpha = 0;
				TweenLite.from(target,0.5,{alpha:1});
			}
		}
		private function ySliderHandler(event:TouchEvent):void{
			var touch:Touch = event.getTouch(event.target as DisplayObject);
			if(touch){
				if(touch.phase == TouchPhase.MOVED){
					trace(ySlider.value);
					if(preViewHouse){
						preViewHouse.y = 381+ySlider.value;
						
						preViewHouseY.text = ySlider.value.toString();
						
						saveBtn.isEnabled = true;
						isModify.text = "已修改";
						
						localHouseList[pageIndicator.selectedIndex].isModify = true;
					}
					
				}
			}
		}
		private function inputClick(event:Event):void{
			trace("d ");
			houseName.addEventListener(Event.CHANGE,updModifyState);
			houseType.addEventListener(Event.CHANGE,updModifyState);
			houseWidth.addEventListener(Event.CHANGE,updModifyState);
			houseMaxNum.addEventListener(Event.CHANGE,updModifyState);
			housePrice.addEventListener(Event.CHANGE,updModifyState);
			buildTime.addEventListener(Event.CHANGE,updModifyState);
			
		}
		private function pageContainerClick(event:TouchEvent):void{
			var touch:Touch = event.getTouch(event.target as DisplayObject,TouchPhase.BEGAN);
			if(touch){
				houseName.removeEventListener(Event.CHANGE,updModifyState);
				houseType.removeEventListener(Event.CHANGE,updModifyState);
				houseWidth.removeEventListener(Event.CHANGE,updModifyState);
				houseMaxNum.removeEventListener(Event.CHANGE,updModifyState);
				housePrice.removeEventListener(Event.CHANGE,updModifyState);
				isSell.removeEventListener(Event.CHANGE,updModifyState);
				buildTime.removeEventListener(Event.CHANGE,updModifyState);
			}
		}
		private function updModifyState(event:Event):void{
			var inputName:String = (event.target as DisplayObject).name;
			switch(inputName){
				case "houseName":
					localHouseList[pageIndicator.selectedIndex].name = houseName.text;
					break;
				case "houseType":
					localHouseList[pageIndicator.selectedIndex].type = houseType.text;
					break;
				case "houseWidth":
					localHouseList[pageIndicator.selectedIndex].width = Number(houseWidth.text);
					break;
				case "houseMaxNum":
					localHouseList[pageIndicator.selectedIndex].maxNumber = Number(houseMaxNum.text);
					break;
				case "housePrice":
					localHouseList[pageIndicator.selectedIndex].price = Number(housePrice.text);
					break;
				case "isSell":
					if(isSell.isSelected)
						localHouseList[pageIndicator.selectedIndex].status = "y";
					else
						localHouseList[pageIndicator.selectedIndex].status = "n";
					break;
				case "buildTime":
					localHouseList[pageIndicator.selectedIndex].buildTime = Number(buildTime.text);
					break;
				
				
			}
			
			saveBtn.isEnabled = true;
			isModify.text = "已修改";
			
			localHouseList[pageIndicator.selectedIndex].isModify = true;
			
			
		}
		
		private function toggleClick(event:TouchEvent):void{
			var inputName:String = (event.currentTarget as ToggleSwitch).name;
			var touch:Touch = event.getTouch(event.target as DisplayObject,TouchPhase.BEGAN);
			if(touch){
				switch(inputName){
					case "isSell":
						isSell.addEventListener(Event.CHANGE,updModifyState);
						break;
					case "":
						
						break;
				}
				
			}
			
			
		}
		
		
		
		
		//保存
		private function saveBtnHandle(event:Event):void{
			
			
			PackData.app.CmdIStr[0] = CmdStr.INTUPD_PER_ROOM;
			PackData.app.CmdIStr[1] = localHouseList[pageIndicator.selectedIndex].data;
			PackData.app.CmdIStr[2] = localHouseList[pageIndicator.selectedIndex].name;
			PackData.app.CmdIStr[3] = localHouseList[pageIndicator.selectedIndex].type;
			PackData.app.CmdIStr[4] = localHouseList[pageIndicator.selectedIndex].width.toString();
			PackData.app.CmdIStr[5] = localHouseList[pageIndicator.selectedIndex].y.toString();
			PackData.app.CmdIStr[6] = localHouseList[pageIndicator.selectedIndex].maxNumber.toString();
			PackData.app.CmdIStr[7] = localHouseList[pageIndicator.selectedIndex].price.toString();
			PackData.app.CmdIStr[8] = localHouseList[pageIndicator.selectedIndex].status;
			PackData.app.CmdIStr[9] = localHouseList[pageIndicator.selectedIndex].buildTime.toString();
			PackData.app.CmdIStr[10] = localHouseList[pageIndicator.selectedIndex].dealOperId;
			PackData.app.CmdInCnt = 11;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(HouseEditorConst.INTUPD_PER_ROOM));
			
		}
		//删除
		private function delBtnHandle(event:Event):void{
			PackData.app.CmdIStr[0] = CmdStr.DEL_PER_ROOM;
			PackData.app.CmdIStr[1] = localHouseList[pageIndicator.selectedIndex].data;
			PackData.app.CmdIStr[2] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 3;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(HouseEditorConst.DEL_PER_ROOM));
			
			
		}
		
		
	
		
/**数据操作、处理***********************************************************************/			
		
		private function getTimeFormat():String {
			var dateFormatter:DateTimeFormatter = new DateTimeFormatter("en-US");			
			dateFormatter.setDateTimePattern("yyyy-MM-dd");
			return dateFormatter.format(Global.nowDate);
		}
		private function getHouseList():void{
			var houseXml:XML = MyUtils.getXmlFile("textures/HapIslandHouse.xml");
			
			var houseVo:HouseInfoVO;
			
			for each (var i:XML in houseXml.children()){
				houseVo = new HouseInfoVO();
				
				houseVo.name = i.@name;
				houseVo.data = i.@name;
				houseVo.width = i.@width;
				houseVo.height = i.@height;
				
				houseVo.houseImg = new Image(Assets.getHapIslandHouseTexture(houseVo.data));
				
				localHouseList.push(houseVo);
			}
		}
		
		private function setHouseScale():void{
			var len:int = pageIndicator.pageCount;
			for(var i:int=0;i<len;i++){
				localHouseList[i].houseImg.scaleX = 1;
				localHouseList[i].houseImg.scaleY = 1;
				
			}
		}
		
		
		private function showHouseData(index:int):void{
			var len:int = serverHouseList.length;
			var isHad:Boolean = false;
			
			//添加已修改判断
			if(localHouseList[index].isModify){
				if(localHouseList[index].isServerHad){
					isServerHad.text = "已存在";
					delBtn.isEnabled = true;
				}else{
					isServerHad.text = "不存在";
					delBtn.isEnabled = false;
				}
				
				saveBtn.isEnabled = true;
				isModify.text = "已修改";
				setInput(localHouseList[index]);
				
				return;
				
			}
			if(localHouseList[index].isServerHad){
				saveBtn.isEnabled = false;
				isServerHad.text = "已存在";
				delBtn.isEnabled = true;
				setInput(localHouseList[index]);
				
				return;
			}

			
			
			for(var i:int=0;i<len;i++){
				
				if(localHouseList[index].data == serverHouseList[i].data){
					isHad = true;
					localHouseList[index].id = serverHouseList[i].id;
					localHouseList[index].name = serverHouseList[i].name;
					localHouseList[index].type = serverHouseList[i].type;
					localHouseList[index].y = serverHouseList[i].y;
					localHouseList[index].width = serverHouseList[i].width;
					localHouseList[index].maxNumber = serverHouseList[i].maxNumber;
					localHouseList[index].price = serverHouseList[i].price;
					localHouseList[index].dealOperId = serverHouseList[i].dealOperId;
					localHouseList[index].dealTime = serverHouseList[i].dealTime;
					localHouseList[index].status = serverHouseList[i].status;
					localHouseList[index].buildTime = serverHouseList[i].buildTime;
					
					localHouseList[index].isServerHad = true;

					break;
				}
			}
			if(!isHad){
				localHouseList[index].y = 130;
				localHouseList[index].dealOperId = PackData.app.head.dwOperID.toString();
				localHouseList[index].dealTime = getTimeFormat();
				localHouseList[index].isServerHad = false;
			}
			
			if(localHouseList[index].isServerHad){
				isServerHad.text = "已存在";
				delBtn.isEnabled = true;
			}else{
				isServerHad.text = "不存在";
				delBtn.isEnabled = false;
			}
			saveBtn.isEnabled = false;
			isModify.text = "未修改";
			setInput(localHouseList[index]);
		}
		private function setInput(_houseVo:HouseInfoVO):void{
			houseName.text = _houseVo.name;
			houseDfata.text = _houseVo.data;
			houseType.text = _houseVo.type;
			houseWidth.text = _houseVo.width.toString();
			houseOffsetY.text = _houseVo.y.toString();
			houseMaxNum.text = _houseVo.maxNumber.toString();
			housePrice.text = _houseVo.price.toString();
			houseDealOperID.text = _houseVo.dealOperId;
			houseDealTime.text = _houseVo.dealTime;
			if(_houseVo.status == "y")
				isSell.isSelected = true;
			else
				isSell.isSelected = false;
			
			buildTime.text = _houseVo.buildTime.toString();
		}
		
		
		private function getServerHouseList():void{
			
			
			PackData.app.CmdIStr[0] = CmdStr.QRY_PER_ROOM;
			PackData.app.CmdIStr[1] = "*";
			PackData.app.CmdIStr[2] = "";
			PackData.app.CmdInCnt = 3;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(WorldConst.QRY_PER_ROOM_COMPLETE));
			
		}

/**消息处理***********************************************************************/	
		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			var name:String = notification.getName();
			switch(name){
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
						houseVo.dealOperId = PackData.app.CmdOStr[11];
						houseVo.dealTime = PackData.app.CmdOStr[12];
						serverHouseList.push(houseVo);
						
						
						
					}else{
						if(isFirstIn){
							isFirstIn = false;
							Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
						}else{
							
						}
					}
					
					break;
				case HouseEditorConst.INTUPD_PER_ROOM:
					if(!result.isErr){
						localHouseList[pageIndicator.selectedIndex].isServerHad = true;
						localHouseList[pageIndicator.selectedIndex].isModify = false;
						saveBtn.isEnabled = false;
						isModify.text = "未修改";
						isServerHad.text = "已存在";
						
						sendNotification(WorldConst.DIALOGBOX_SHOW,
							new DialogBoxShowCommandVO(view,640,381,null,"成功添加房子",null));
					}
					break;
				case HouseEditorConst.DEL_PER_ROOM:
					if(!result.isErr){
						var len:int = serverHouseList.length;
						
						//删除serverHouseList中的该房子
						for(var i:int=0;i<len;i++){
							if(localHouseList[pageIndicator.selectedIndex].data == serverHouseList[i].data){
								serverHouseList.splice(i,1);
								
								break;
								
							}
						}
						localHouseList[pageIndicator.selectedIndex].id = "";
						localHouseList[pageIndicator.selectedIndex].type = "";
						localHouseList[pageIndicator.selectedIndex].y = 0;
						localHouseList[pageIndicator.selectedIndex].maxNumber = 0;
						localHouseList[pageIndicator.selectedIndex].price = 0;
						localHouseList[pageIndicator.selectedIndex].dealOperId = "";
						localHouseList[pageIndicator.selectedIndex].dealTime = "";
						localHouseList[pageIndicator.selectedIndex].status = "";
						localHouseList[pageIndicator.selectedIndex].isModify = false;
						localHouseList[pageIndicator.selectedIndex].isServerHad = false;
						localHouseList[pageIndicator.selectedIndex].buildTime = 0;
						
						showHouseData(pageIndicator.selectedIndex);
						
						sendNotification(WorldConst.DIALOGBOX_SHOW,
							new DialogBoxShowCommandVO(view,640,381,null,"成功删除",null));
						
					}
					break;
				
			}
		}
		override public function listNotificationInterests():Array{
			return [WorldConst.QRY_PER_ROOM_COMPLETE,HouseEditorConst.INTUPD_PER_ROOM,HouseEditorConst.DEL_PER_ROOM];
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class{
			return Sprite;
		}
		override public function onRemove():void{
			if(bgTexture)
				bgTexture.dispose();
//			Assets.disposeTexture("task/bg");
	
			TweenLite.killTweensOf(preViewHouse);
			sendNotification(WorldConst.SHOW_MAIN_MENU);
		}

	}
}