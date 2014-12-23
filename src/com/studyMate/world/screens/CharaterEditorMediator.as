package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.charater.CharaterUtils;
	import com.mylib.game.charater.HumanMediator;
	import com.mylib.game.charater.ICharater;
	import com.mylib.game.charater.item.EquipmentItemButton;
	import com.mylib.game.model.CharaterSuitsInfoProxy;
	import com.mylib.game.model.CharaterSuitsProxy;
	import com.mylib.game.model.DressSuitsProxy;
	import com.mylib.game.model.HumanPoolProxy;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.controller.CreateCharaterCommand;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.model.vo.CharaterSuitsVO;
	import com.studyMate.world.model.vo.DressEquipmentVO;
	import com.studyMate.world.model.vo.DressSuitsVO;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import de.polygonal.ds.HashMap;
	
	import feathers.controls.Button;
	import feathers.controls.PageIndicator;
	import feathers.controls.Radio;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.controls.Slider;
	import feathers.controls.TextInput;
	import feathers.controls.supportClasses.LayoutViewPort;
	import feathers.core.ToggleGroup;
	import feathers.events.FeathersEventType;
	import feathers.layout.TiledRowsLayout;
	
	import org.as3commons.logging.api.Logger;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;

	public class CharaterEditorMediator extends ScreenBaseMediator implements IMediator
	{
		public static const NAME:String = "CharaterEditorMediator";
		private static const GET_EQUIPLIST_FROM_SERVER:String = "GetEquipListFromServer";
		private static const INSERT_EQUIP_TO_SERVER:String = "InsertEquipToServer";
		private static const DEL_EQUIP_FROM_SERVER:String = "DelEquipFromServer";
		
		private var dressSuitsProxy:DressSuitsProxy;
		
		private var characterHolder:Sprite;
		private var controlCharaterHolder:Sprite;
		private var dressHolder:Sprite;
		private var synHolder:Sprite;
		
		private var charater:ICharater;
		private var profile:CharaterSuitsVO;
		private var suitsProxy:CharaterSuitsProxy;
		private var charaterModel:ICharater;
		private var npcsuitProxy:CharaterSuitsInfoProxy;
		
		private var acterState:String = "idle"; //人物状态
		
		private var charaterNameTextField:TextField;
		private var pageIndicator:PageIndicator;
		private var toFramesSlider:Slider;
		private var listFramesSlider:Slider;
		private var toFramesSliderValue:TextField;
		private var listFramesSliderValue:TextField;
		
		private var toFramesValue:Number = 7; //toFrames值，全局变量
		private var isLoop:Boolean = true; //是否重复播放，默认为true
		private var loopBtn:Button;
		
		private var _equipItemcontainer:ScrollContainer; //显示装备的容器
		private var _charaterContainer:ScrollContainer; //显示人物的容器
		private var layout:TiledRowsLayout;
		private var equipTG:ToggleGroup; //装备分类
		
		private var charaterList:Vector.<ICharater>; //人物列表
		private var currentIndex:int = 0; //当前人物序号
		
		private var newCharaterInput:TextInput;
		private var sexTG:ToggleGroup; //性别选择		
		private var texture:Texture;
		
		public function CharaterEditorMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}

		override public function onRegister():void
		{
			sendNotification(WorldConst.HIDE_MAIN_MENU);
			sendNotification(WorldConst.HIDE_LEFT_MENU);
			
			dressSuitsProxy = facade.retrieveProxy(DressSuitsProxy.NAME) as DressSuitsProxy;
			dressSuitsProxy.init(getNewEquipmentInfo());
			
			charaterList = new Vector.<ICharater>;
			
			init();
			initBoneData();

			
			
		}
		private function init():void{
			texture = Texture.fromBitmap(Assets.store["task_bg"],false);
			var bg:Image = new Image(texture);
			view.addChild(bg);
			
			layout = new TiledRowsLayout();
			layout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			layout.gap = 2;
			layout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			layout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
			layout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
			layout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_MIDDLE;
			
			
			controlCharaterHolder = new Sprite();
			controlCharaterHolder.x = 70;
			controlCharaterHolder.y = 30;
			view.addChild(controlCharaterHolder);
			
			dressHolder = new Sprite();
			dressHolder.x = 630;
			dressHolder.y = 180;
			view.addChild(dressHolder);
			
			characterHolder = new Sprite();
			view.addChild(characterHolder);
			showCharater();
			
			synHolder = new Sprite();
			synHolder.x = 900;
			synHolder.y = 30;
			view.addChild(synHolder);
			
			
			
//			createCharaterModel();
			
			createControlHolder();
			createDressHolder();
			
			createSynHolder();
			
		}
		
		//创建人物，添加到容器中
		private function createCharater(_charaterName:String,addCharater:Boolean=false):void{
			var charater:ICharater;
			var charaterSp:Sprite = new Sprite();

			
			charater = (facade.retrieveProxy(ModuleConst.HUMAN_POOL) as HumanPoolProxy).object;
			
			var dress:String;
			if(!addCharater){
				//创建主角
				if(_charaterName == "captain")
					dress = Global.myDressList;
				else
					//创建NPC
					dress = npcsuitProxy.getDress(_charaterName);
				
			}else
				//创建新人
				dress = "face_face1";
			charater.charaterName = _charaterName;
			GlobalModule.charaterUtils.configHumanFromDressList(charater as HumanMediator,dress,new Rectangle());
			
			charaterList.push(charater);
			//人物添加进换装管理
			dressSuitsProxy.addCharaterDress(charater);
			
			charater.view.x = 150;
			charater.view.y = 262;
//			var charaterBg:Image = CreateCharaterCommand.getTextureDisplay(Assets.charaterTexture,"charaterBg");
//			charaterSp.addChild(charaterBg);
			charaterSp.addChild(new Quad(300,280,0xf8df9d));
			charaterSp.addChild(charater.view);
			charater.scale = 3;
//			charaterSp.addEventListener(TouchEvent.TOUCH,actorTouchHandle);

			_charaterContainer.addChild(charaterSp);
		}
		
		private function showAllNPC():void{
			npcsuitProxy = new CharaterSuitsInfoProxy();
			facade.registerProxy(npcsuitProxy);
			

			
			var npclist:Array = npcsuitProxy.getNpcList().concat();
			
			for(var i:int=0;i<npclist.length;i++)
				createCharater(npclist[i]);
			
		}
		private function showCharater():void{
			_charaterContainer = new ScrollContainer();
			_charaterContainer.x = 150;
			_charaterContainer.y = 180;
			_charaterContainer.width = 304;
			_charaterContainer.height = 300;
			_charaterContainer.layout = layout;
			_charaterContainer.snapToPages = TiledRowsLayout.PAGING_VERTICAL;
			_charaterContainer.snapScrollPositionsToPixels = true;
			
			suitsProxy = facade.retrieveProxy(CharaterSuitsProxy.NAME) as CharaterSuitsProxy;
			createCharater("captain");
			showAllNPC();
			
			//显示默认人物——主角
			charater = charaterList[0];
			
			characterHolder.addChild(_charaterContainer);
			_charaterContainer.addEventListener(FeathersEventType.SCROLL_COMPLETE,charaterContainerHandle);
			
			//显示角色名称
			charaterNameTextField = new TextField(75,30,"captain","Verdana",18);
			charaterNameTextField.x = 470;
			charaterNameTextField.y = 330;
			charaterNameTextField.hAlign = HAlign.LEFT;
			characterHolder.addChild(charaterNameTextField);
			
			//显示指示器Indicator
			pageIndicator = new PageIndicator();
			pageIndicator.width = 304;
			pageIndicator.x = 150;
			pageIndicator.y = 480;
			pageIndicator.direction = PageIndicator.DIRECTION_HORIZONTAL;
			pageIndicator.gap = 3;
			pageIndicator.pageCount = charaterList.length;
			pageIndicator.touchable = false;
			characterHolder.addChild(pageIndicator);
		}
		//创建人物控制按钮
		private function createControlHolder():void{
			var viewPort:LayoutViewPort = new LayoutViewPort();
			var btnSC:Scroller = new Scroller();
			btnSC.width = 800;
			btnSC.height = 45;
			btnSC.viewPort = viewPort;
			controlCharaterHolder.addChild(btnSC);

			//动作系列按钮
			var btnList:Vector.<String> = getActionList();
			var len:int = btnList.length;
			var actorBtn:Button;
			var preBtn:Button = new Button();; //记录上一个btn的宽度
			for(var i:int=0;i<len;i++){
				actorBtn = new Button();
				actorBtn.name = btnList[i]+"Btn";
				actorBtn.label = btnList[i];
//				controlCharaterHolder.addChild(actorBtn);
				viewPort.addChild(actorBtn);
				actorBtn.validate();
				
				actorBtn.x = preBtn.x + preBtn.width + 5;
				preBtn = actorBtn;
				
				actorBtn.addEventListener(Event.TRIGGERED,actionBtnHandle);
			}
			
			viewPort = new LayoutViewPort();
			btnSC = new Scroller();
			btnSC.y = 70;
			btnSC.width = 800;
			btnSC.height = 45;
			btnSC.viewPort = viewPort;
			controlCharaterHolder.addChild(btnSC);
			
			//表情系列按钮
			var faceBtnList:Array = GlobalModule.charaterUtils.getHumanFaceList("face_face1");
			len = faceBtnList.length;
			var faceBtn:Button;
			preBtn = new Button();
			for(i=0;i<len;i++){
				faceBtn = new Button();
				faceBtn.name = faceBtnList[i]+"Btn";
				faceBtn.label = faceBtnList[i];
				viewPort.addChild(faceBtn);
				faceBtn.validate();
				
				faceBtn.x = preBtn.x + preBtn.width + 5;
				preBtn = faceBtn;

				faceBtn.addEventListener(Event.TRIGGERED,faceBtnHandle);
			}
			
			//放大、缩小
			var zoomBtn:Button;
			for(i=0;i<3;i++){
				zoomBtn = new Button();
				zoomBtn.name = "Btn"+i;
				zoomBtn.label = "X"+(i+1);
				zoomBtn.y = 220+70*i;

				zoomBtn.addEventListener(Event.TRIGGERED,zoomBtnHandle);
				controlCharaterHolder.addChild(zoomBtn);
			}
			
			//是否重复播放
			loopBtn = new Button();
			loopBtn.label = "Loop";
			loopBtn.y = 430;
			loopBtn.addEventListener(Event.TRIGGERED,loopBtnHandle);
			controlCharaterHolder.addChild(loopBtn);
			
			//frame操作栏
			var titleText:TextField = new TextField(75,30,"toFrames：","Verdana");
			titleText.y = 500;
			titleText.hAlign = HAlign.LEFT;
			controlCharaterHolder.addChild(titleText);
			
			titleText = new TextField(75,30,"listFrames：","Verdana");
			titleText.y = 570;
			titleText.hAlign = HAlign.LEFT;
			controlCharaterHolder.addChild(titleText);
			
			toFramesSlider = new Slider();		
			toFramesSlider.maximum = 50;			
			toFramesSlider.value = 7; //toFrames默认值为 7
			toFramesSlider.step = 1;
			toFramesSlider.direction = Slider.DIRECTION_HORIZONTAL;			
			toFramesSlider.liveDragging = true;			
			toFramesSlider.validate();
			toFramesSlider.x = 75;
			toFramesSlider.y = 500;
			toFramesSlider.width = 300;
			toFramesSlider.addEventListener(TouchEvent.TOUCH, toFramesSliderHandler);
			controlCharaterHolder.addChild(toFramesSlider);

			listFramesSlider = new Slider();		
			listFramesSlider.maximum = 200;			
			listFramesSlider.value = 64;
			listFramesSlider.step = 1;	
			listFramesSlider.direction = Slider.DIRECTION_HORIZONTAL;			
			listFramesSlider.liveDragging = true;
			listFramesSlider.validate();
			listFramesSlider.x = 75;
			listFramesSlider.y = 570;
			listFramesSlider.width = 300;
			listFramesSlider.addEventListener(TouchEvent.TOUCH, listFramesSliderHandler);
			controlCharaterHolder.addChild(listFramesSlider);
			
			toFramesSliderValue = new TextField(50,30,toFramesSlider.value.toString(),"Verdana");
			toFramesSliderValue.x = 385;
			toFramesSliderValue.y = 500;
			toFramesSliderValue.hAlign = HAlign.LEFT;
			controlCharaterHolder.addChild(toFramesSliderValue);
			
			listFramesSliderValue = new TextField(50,30,listFramesSlider.value.toString(),"Verdana");
			listFramesSliderValue.x = 385;
			listFramesSliderValue.y = 570;
			listFramesSliderValue.hAlign = HAlign.LEFT;
			controlCharaterHolder.addChild(listFramesSliderValue);
		}
		private function createSynHolder():void{
			var addBtn:Button = new Button();
			addBtn.label = "addToServer";
			synHolder.addChild(addBtn);
			addBtn.validate();
			addBtn.addEventListener(Event.TRIGGERED,addBtnHandle);
			
			var delBtn:Button = new Button();
			delBtn.label = "delFromServer";
			delBtn.x = addBtn.width + 5;
			synHolder.addChild(delBtn);
			delBtn.addEventListener(Event.TRIGGERED,delBtnHandle);
			
		}
		private function createDressHolder():void{
			equipTG = new ToggleGroup();
			var radio:Radio;
			var titleText:TextField;

			for(var i:int=0;i<5;i++){
				radio = new Radio();
				radio.toggleGroup = equipTG;
				radio.y = 50*i;
				switch(i){
					case 0:
						radio.name = "Head";
						titleText = new TextField(75,30,"Head","Verdana",18);
						break;
					case 1:
						radio.name = "Body";
						titleText = new TextField(75,30,"Body","Verdana",18);
						break;
					case 2:
						radio.name = "Hand";
						titleText = new TextField(75,30,"Hand","Verdana",18);
						break;
					case 3:
						radio.name = "Foot";
						titleText = new TextField(75,30,"Foot","Verdana",18);
						break;
					case 4:
						radio.name = "Set";
						titleText = new TextField(75,30,"Set","Verdana",18);
						break;
				}
				titleText.x = 30;
				titleText.y = 50*i;
				titleText.hAlign = HAlign.LEFT;
				
				dressHolder.addChild(radio);
				dressHolder.addChild(titleText);
			}
//			equipTG.onChange.add(toggleGroupHandle);
			equipTG.addEventListener(Event.CHANGE,toggleGroupHandle);
			
			_equipItemcontainer = new ScrollContainer();
			_equipItemcontainer.x = 90;
			_equipItemcontainer.width = 400;
			_equipItemcontainer.height = 300;
			_equipItemcontainer.layout = layout;
			_equipItemcontainer.snapToPages = TiledRowsLayout.PAGING_VERTICAL;
			_equipItemcontainer.snapScrollPositionsToPixels = true;
			dressHolder.addChild(_equipItemcontainer);
			
			//显示该类型的装备
			showEquipmentByType("head",charater.sex);
			
			newCharaterInput = new TextInput();
			newCharaterInput.width = 180;
			newCharaterInput.height = 40;
			newCharaterInput.x = 150;
			newCharaterInput.y = 300;
			newCharaterInput.addEventListener(FeathersEventType.ENTER,newCharaterInputHandle);
			dressHolder.addChild(newCharaterInput);
			
			var saveCharaterBtn:Button = new Button();
			saveCharaterBtn.y = 350;
//			saveCharaterBtn.scaleX = 2;
//			saveCharaterBtn.scaleY = 2;
			saveCharaterBtn.label = "Save charater";
			saveCharaterBtn.addEventListener(Event.TRIGGERED,saveCharaterBtnHandle);
			dressHolder.addChild(saveCharaterBtn);
			
			var addCharaterBtn:Button = new Button();
			addCharaterBtn.x = 150;
			addCharaterBtn.y = 350;
//			addCharaterBtn.scaleX = 2;
//			addCharaterBtn.scaleY = 2;
			addCharaterBtn.label = "Add charater";
			addCharaterBtn.addEventListener(Event.TRIGGERED,addCharaterBtnHandle);
			dressHolder.addChild(addCharaterBtn);
			
			var delCharaterBtn:Button = new Button();
			delCharaterBtn.x = 300;
			delCharaterBtn.y = 350;
//			delCharaterBtn.scaleX = 2;
//			delCharaterBtn.scaleY = 2;
			delCharaterBtn.label = "Del charater";
			delCharaterBtn.addEventListener(Event.TRIGGERED,delCharaterBtnHandle);
			dressHolder.addChild(delCharaterBtn);
			
			sexTG = new ToggleGroup();
			for(i=0;i<2;i++){
				radio = new Radio();
				radio.toggleGroup = sexTG;
				radio.x = 70*i;
				radio.y = 320;
				switch(i){
					case 0:
						radio.name = "M";
						titleText = new TextField(75,30,"M","Verdana",18);
						break;
					case 1:
						radio.name = "F";
						titleText = new TextField(75,30,"F","Verdana",18);
						break;
				}
				titleText.x = 30+70*i;
				titleText.y = 320;
				titleText.hAlign = HAlign.LEFT;
				
				dressHolder.addChild(radio);
				dressHolder.addChild(titleText);
			}
			sexTG.addEventListener(Event.CHANGE,sexTGHandle);
			
			var gotoOldViewBtn:Button = new Button();
			gotoOldViewBtn.x = 500;
			gotoOldViewBtn.y = 470;
//			gotoOldViewBtn.scaleX = 2;
//			gotoOldViewBtn.scaleY = 2;
			gotoOldViewBtn.label = "Goto Old";
			gotoOldViewBtn.addEventListener(Event.TRIGGERED,gotoOldViewBtnHandle);
			dressHolder.addChild(gotoOldViewBtn);
			
			var gotoIslandBtn:Button = new Button();
			gotoIslandBtn.x = 350;
			gotoIslandBtn.y = 470;
			gotoIslandBtn.label = "Goto Island";
			gotoIslandBtn.addEventListener(Event.TRIGGERED,gotoIslandBtnHandle);
			dressHolder.addChild(gotoIslandBtn);
			
		}
		
		
/**一系列监听函数，用于监听所有操作*****************************************************************************************************/
		private var isEquipTap:Boolean = false;
		private var beginX:Number;
		private var endX:Number;
		private var equipX:Number;
		private var equipY:Number;
		private var differX:Number;
		private var differY:Number;
		//点击人物监听
		private function actorTouchHandle(event:TouchEvent):void{
			var touchPoint:Touch = event.getTouch(event.target as DisplayObject);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					if(touchPoint.target.name.indexOf("|")>-1){
						beginX = touchPoint.globalX;
						trace("点击X："+beginX);
						
						equipX = touchPoint.target.x;
						equipY = touchPoint.target.y;
						
						differX = beginX-equipX;
						differY = touchPoint.globalY-equipY;
						
						isEquipTap = true;
					}
				}else if(touchPoint.phase==TouchPhase.MOVED){
					if(isEquipTap){
						touchPoint.target.x = touchPoint.globalX-differX;
						touchPoint.target.y = touchPoint.globalY-differY;
					}
				}else if(touchPoint.phase==TouchPhase.ENDED){
					if(isEquipTap){
						endX = touchPoint.globalX;
						if(Math.abs(endX-beginX) < 50){
							TweenLite.to(touchPoint.target,1.5,{x:equipX,y:equipY});
						}
					}
				}
			}
		}
		//人物动作按钮
		private function actionBtnHandle(event:Event):void{
			acterState = (event.target as Button).label;
			listFramesSlider.value = 64;
			listFramesSliderValue.text = "64";
			
			charater.actor.playAnimation(acterState,toFramesValue,64,isLoop);
		}
		//人物表情按钮
		private function faceBtnHandle(event:Event):void{
			var btnLabe:String = (event.target as Button).label;
			
			charater.actor.switchCostume("head","face",btnLabe);
		}
		//放大、缩小按钮
		private function zoomBtnHandle(event:Event):void{
			if((event.target as Button).name == "Btn0"){
				charater.view.scaleX = 1;
				charater.view.scaleY = 1;
			}else if((event.target as Button).name == "Btn1"){
				charater.scale = 2;
			}else{
				charater.scale = 3;
			}
		}
		//是否重复播放
		private function loopBtnHandle(event:Event):void{
			if(isLoop){
				isLoop = false;
				loopBtn.label = "UnLoop";
			}else{
				isLoop = true;
				loopBtn.label = "Loop";
			}
		}
		//toFrame设置
		private function toFramesSliderHandler(event:TouchEvent):void{
			var touch:Touch = event.getTouch(event.target as DisplayObject);
			if(touch){
				if(touch.phase == TouchPhase.MOVED){
					toFramesValue = toFramesSlider.value;
					toFramesSliderValue.text = toFramesSlider.value.toString();
					charater.actor.playAnimation(acterState,toFramesValue,listFramesSlider.value,isLoop);
				}
			}
		}
		//listFrames设置
		private function listFramesSliderHandler(event:TouchEvent):void{
			var touch:Touch = event.getTouch(event.target as DisplayObject);
			if(touch){
				if(touch.phase == TouchPhase.MOVED){
					listFramesSliderValue.text = listFramesSlider.value.toString();
					charater.actor.playAnimation(acterState,toFramesValue,listFramesSlider.value,isLoop);
				}
			}
		}
		//装备类别切换监听
		private function toggleGroupHandle(event:Event):void{
			var selectItem:String = ((event.target as ToggleGroup).selectedItem as Radio).name;
			switch(selectItem){
				case "Head":showEquipmentByType("head",charater.sex);break;
				case "Body":showEquipmentByType("body",charater.sex);break;
				case "Hand":showEquipmentByType("hand",charater.sex);break;
				case "Foot":showEquipmentByType("foot",charater.sex);break;
				case "Set":showEquipmentByType("set",charater.sex);break;
			}
		}
		//角色性别
		private function sexTGHandle(event:Event):void{
			equipTG.selectedIndex=0;
			var selectItem:String = ((event.target as ToggleGroup).selectedItem as Radio).name;
			switch(selectItem){
				case "M":showEquipmentByType("head","M");break;
				case "F":showEquipmentByType("head","F");break;
			}
		}
		//角色名输入框监听
		private function newCharaterInputHandle():void{
			addCharaterBtnHandle(null);
			
		}
		//保存人物修改监听
		private function saveCharaterBtnHandle(event:Event):void{
			//临时保存个人服装
			if(charater.charaterName == "captain")
				Global.myDressList = GlobalModule.charaterUtils.getHumanDressList(charater);
			else
				npcsuitProxy.saveNPC(charater.charaterName,GlobalModule.charaterUtils.getHumanDressList(charater));
			
			sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,640,381,null,"角色 "+charater.charaterName+" 已保存"));
		}
		//创建新的NPC
		private function addCharaterBtnHandle(event:Event):void{
			if(newCharaterInput.text == ""){
				sendNotification(WorldConst.DIALOGBOX_SHOW,
					new DialogBoxShowCommandVO(newCharaterInput,0,-100,null,"请输入新角色的名称，如：npc1."));
			}else if(hasCharater(newCharaterInput.text)){
				sendNotification(WorldConst.DIALOGBOX_SHOW,
					new DialogBoxShowCommandVO(newCharaterInput,0,-100,null,"角色： "+newCharaterInput.text+" 已存在，请重新输入新的角色名！"));
				newCharaterInput.text = "";
			}else{
				//创建新人物
				createCharater(newCharaterInput.text.toLocaleLowerCase(),true);
				
				TweenLite.delayedCall(0.2,function scroll():void{
					_charaterContainer.scrollToPageIndex(charaterList.length-1,0,1);
				});
				
				newCharaterInput.text = "";
				pageIndicator.pageCount++;
			}
		}
		//滚动人物容器
		private function charaterContainerHandle():void{
			var preChareter:ICharater = charater;
			currentIndex = _charaterContainer.horizontalScrollPosition/_charaterContainer.width;
			if(currentIndex<0)
				currentIndex = 0;
			charater = charaterList[currentIndex];
//			charaterNameTextField.text = charater.charaterName;
			if(currentIndex == 0)
				charaterNameTextField.text = "captain";
			else
				charaterNameTextField.text = charater.charaterName;
			
			pageIndicator.selectedIndex = currentIndex;
			
			var preSex:String = preChareter.sex;
			var nowSex:String = charater.sex;
			//性别不同时操作
			if(preSex != nowSex){
				//切换人物，刷新装备显示列表
				showEquipmentByType("head",nowSex);
				//切换性别显示
				switch(nowSex){
					case "M":sexTG.selectedIndex=0;break;
					case "F":sexTG.selectedIndex=1;break;
				}
			}
		}
		//删除人物
		private function delCharaterBtnHandle(event:Event):void{
			if(currentIndex == 0)
				sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,640,381,null,"主角不能删除！"));
			else
				sendNotification(WorldConst.DIALOGBOX_SHOW,
					new DialogBoxShowCommandVO(view,640,381,doDel,"确定要删除角色： "+charaterList[currentIndex].charaterName+" ？"));
		}
		//确认删除
		private function doDel():void{
			
			npcsuitProxy.delNPC(charaterList[currentIndex].charaterName);
			
			pageIndicator.pageCount--;
			
			dressSuitsProxy.delCharaterDress(charaterList[currentIndex]);
			(facade.retrieveProxy(ModuleConst.HUMAN_POOL) as HumanPoolProxy).object = charater;
			charaterList.splice(currentIndex,1);
			_charaterContainer.removeChildAt(currentIndex);
		}
		//判断创建的角色是否存在
		private function hasCharater(_charaterName:String):Boolean{
			var len:int = charaterList.length;
			for(var i:int=0;i<len;i++){
				if(_charaterName.toLocaleLowerCase() == charaterList[i].charaterName)
					return true;
			}
			return false;
		}
		//进入旧编辑界面
		private function gotoOldViewBtnHandle(event:Event):void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(CharacterEditorMediator)]);
		}
		private function gotoIslandBtnHandle():void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(HappyIslandMediator)]);
		}


		
/**新数据结构************************************************************************************************************/
		/**
		 * 读取装备信息文件 equipmentInfo2.xml 获取装备信息列表 dressSuitsVoList
		 */		
		private var dressSuitsVoList:Vector.<DressSuitsVO> = new Vector.<DressSuitsVO>;
		
		
		public function getNewEquipmentInfo():Vector.<DressSuitsVO>{
			var dressSuitsVo:DressSuitsVO;
			var dressEquipmentVo:DressEquipmentVO;
			
			var suitName:String;
			var suitType:String;
			var sex:String;
			var level:String;
			
			var equipXml:XML = getFile("textures/equipmentInfo2.xml");
			for each (var i:XML in equipXml.children()){
				
				suitName = i.@name;
				suitType = i.@suitType;
				sex = i.@sex;
				level = i.@level;
				
				dressSuitsVo = new DressSuitsVO();
				dressSuitsVo.name = suitName;
				dressSuitsVo.suitType = suitType;
				dressSuitsVo.sex = sex;
				dressSuitsVo.level = level;

				var equipList:XMLList = i.equipment;

				if(equipList.length()){
					for each(var j:XML in equipList){
						
						dressEquipmentVo = new DressEquipmentVO();
						dressEquipmentVo.name = j.@name;
						dressEquipmentVo.x = j.@x;
						dressEquipmentVo.y = j.@y;
						dressEquipmentVo.order = j.@order;
						dressEquipmentVo.type = j.@type;
						dressEquipmentVo.data = j.@data;
						dressEquipmentVo.bone = j.@bone;
						dressEquipmentVo.equipmentType = j.@equipmentType;
						
						dressSuitsVo.equipments.push(dressEquipmentVo);
						
					}
					
				}
				dressSuitsVoList.push(dressSuitsVo);
				
			}
			return dressSuitsVoList;
		}
		//根据类别显示装备
		private function showEquipmentByType(_suitType:String,_sex:String):void{
//			while(_equipItemcontainer.numChildren > 0)
//				_equipItemcontainer.removeChildAt(_equipItemcontainer.numChildren-1);
			_equipItemcontainer.removeChildren();
			var itemBg:Image;
			var itemBtn:EquipmentItemButton;

			var len:int = dressSuitsVoList.length;
			for(var i:int=0;i<len;i++){
				/*if(dressSuitsVoList[i].suitType == _suitType && (dressSuitsVoList[i].sex == _sex || dressSuitsVoList[i].sex == "B")){*/
				if(dressSuitsVoList[i].suitType == _suitType){
					var len2:int = dressSuitsVoList[i].equipments.length;
					itemBg = CreateCharaterCommand.getTextureDisplay(Assets.charaterTexture,"equipItemBg");
//					itemBg = createItemBg(false) as Image;
					itemBtn = new EquipmentItemButton(itemBg.texture);

					var img:DisplayObject = getNormalEquipImg(dressSuitsVoList[i]);
					img.x = (itemBtn.width>>1)-(img.width>>1);
					img.y = (itemBtn.height>>1)-(img.height>>1);
					itemBtn.addChild(img);
					
					itemBtn.dressSuitsVo = dressSuitsVoList[i];
					itemBtn.scaleX = 2; 
					itemBtn.scaleY = 2;
					itemBtn.addEventListener(TouchEvent.TOUCH,itemBtnHandle);

					_equipItemcontainer.addChild(itemBtn);
				}
			}
		}
		
		private var isTap:Boolean = false;
		private function itemBtnHandle(event:TouchEvent):void{
			var btn:EquipmentItemButton = event.currentTarget as EquipmentItemButton;
			var touchPoint:Touch = event.getTouch(btn);
			
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					isTap = true;
				}else if(touchPoint.phase==TouchPhase.MOVED){
					isTap = false;
				}else if(touchPoint.phase==TouchPhase.ENDED){
					if(isTap){
						dressSuitsProxy.dressUp(charater,btn.dressSuitsVo);
					}
					isTap = false;
				}
			}
			
		}
		
/**一系列get函数，用于获取相关所需数据*****************************************************************************************************/		
		//读文件	
		private function getFile(fileName:String):XML{
			var file:File = Global.document.resolvePath(Global.localPath+"/media/"+fileName);
			var fstream:FileStream = new FileStream();
			fstream.open(file,FileMode.READ);
			
			var xml:XML = XML(fstream.readMultiByte(fstream.bytesAvailable,PackData.BUFF_ENCODE));
			fstream.close();
			
			return xml;
		}
		//修改文件
		private function modifyXMLFile(fileName:String,xml:String):void{
			var file:File = Global.document.resolvePath(Global.localPath+"/media/"+fileName);
			var fs:FileStream = new FileStream();			
			fs.open(file,FileMode.WRITE);
			fs.writeMultiByte(xml,PackData.BUFF_ENCODE);
			fs.close();
		}
		//获取所有动作 	
		private function getActionList():Vector.<String>{
			var actionList:Vector.<String> =  new Vector.<String>;
			var actionXml:XML;
			var boneName:String = "";
			
			actionXml = getFile("textures/MHumanSK.sk");
			for each (var i:XML in actionXml.animation) 
			{
				actionList.push(i.@name);
			}
			return actionList;
		}

		private var boneDateMap:HashMap;
		//获取骨骼数据
		private function initBoneData():void{
			boneDateMap = new HashMap();
			
			var actionXml:XML;
			var actionName:String = "";
			var p:Point = new Point();
			
			actionXml = getFile("textures/MHumanSK.sk");
			for each (var i:XML in actionXml.animation) 
			{
				actionName = i.@name;
				if(i.@name == "idle"){
					boneDateMap.insert("head",new Point(i.head[0].@x,i.head[0].@y));
					boneDateMap.insert("body",new Point(i.body[0].@x,i.body[0].@y));
//					boneDateMap.insert("trouser",new Point(i.trouser[0].@x,i.trouser[0].@y));
//					boneDateMap.insert("hand1_1",new Point(i.hand1_1[0].@x,i.hand1_1[0].@y));
					boneDateMap.insert("hand1_2",new Point(i.hand1_2[0].@x,i.hand1_2[0].@y));
//					boneDateMap.insert("hand2_1",new Point(i.hand2_1[0].@x,i.hand2_1[0].@y));
					boneDateMap.insert("hand2_2",new Point(i.hand2_2[0].@x,i.hand2_2[0].@y));
//					boneDateMap.insert("leg1_1",new Point(i.leg1_1[0].@x,i.leg1_1[0].@y));
					boneDateMap.insert("leg1_2",new Point(i.leg1_2[0].@x,i.leg1_2[0].@y));
//					boneDateMap.insert("leg2_1",new Point(i.leg2_1[0].@x,i.leg2_1[0].@y));
					boneDateMap.insert("leg2_2",new Point(i.leg2_2[0].@x,i.leg2_2[0].@y));
					break;
				}
			}
		}
		//获取整理过后的装备贴图
		private function getNormalEquipImg(_dressSuitsVO:DressSuitsVO):DisplayObject{
			var img:Image;
			
			var sp:Sprite = new Sprite();
			
			var len:int = _dressSuitsVO.equipments.length;
			
			if(len >1){
				var minX:Number = 100;
				var minY:Number = 100;
				var _minX:Number;
				var _minY:Number;
				for(var j:int=0;j<len;j++){
					_minX = _dressSuitsVO.equipments[j].x + (boneDateMap.find(_dressSuitsVO.equipments[j].bone) as Point).x;
					_minY = _dressSuitsVO.equipments[j].y + (boneDateMap.find(_dressSuitsVO.equipments[j].bone) as Point).y;
					if(_minX < minX){
						minX = _minX;
					}
					if(_minY < minY){
						minY = _minY;
					}
					
				}
				
				for(var i:int=0;i<len;i++){
					img = CreateCharaterCommand.getTextureDisplay(Assets.charaterTexture,_dressSuitsVO.equipments[i].data) as Image;
					
					img.x = _dressSuitsVO.equipments[i].x + (boneDateMap.find(_dressSuitsVO.equipments[i].bone) as Point).x;
					img.y = _dressSuitsVO.equipments[i].y + (boneDateMap.find(_dressSuitsVO.equipments[i].bone) as Point).y;
					
					if(_dressSuitsVO.suitType == "foot" ||_dressSuitsVO.suitType == "body" ||_dressSuitsVO.suitType == "set"){
						
						img.x -= minX;
						img.y -= minY;
						
					}
					
					sp.addChild(img);
				}
				
				if(_dressSuitsVO.suitType == "set"){
					sp.scaleX = 0.5;
					sp.scaleY = 0.5;
				}
				return sp;
			}else{
				img = CreateCharaterCommand.getTextureDisplay(Assets.charaterTexture,_dressSuitsVO.equipments[0].data) as Image;
				
				return img;
			}
			
		}
		
		private var equipList:Vector.<String> = new Vector.<String>;
		private var firstLogin:Boolean = true;
		//获取服务器装备列表
		private function getEquipListFromServer():void{
			PackData.app.CmdIStr[0] = CmdStr.QUERY_EQUIPMENT;
			PackData.app.CmdIStr[1] = "*";
			PackData.app.CmdIStr[2] = "*";
			PackData.app.CmdInCnt = 3;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(GET_EQUIPLIST_FROM_SERVER));
			
			
		}
		
		//添加装备到服务器
		private var addNum:int;
		private function addBtnHandle(event:Event):void{
			sendNotification(WorldConst.DIALOGBOX_SHOW,
				new DialogBoxShowCommandVO(view,640,381,null,"正在向服务器更新装备列表，请稍后..."));
			
			sendNotification(WorldConst.SET_MODAL,true);
			
			addNum = 0;
			doAdd();
		}
		private function doAdd():void{
			if(addNum < dressSuitsVoList.length){
				//不存在，则插入到后台数据库
				if(equipList.indexOf(dressSuitsVoList[addNum].name) == -1){
					insertEquipToServer(dressSuitsVoList[addNum].name);
				}else{
					addNum++;
					doAdd();
				}
			}else{
				sendNotification(WorldConst.SET_MODAL,false);
				
				sendNotification(WorldConst.DIALOGBOX_SHOW,
					new DialogBoxShowCommandVO(view,640,381,null,"更新完毕！~O(∩_∩)O~"));
				
				equipList.splice(0,equipList.length);
				getEquipListFromServer();
			}
		}
		private function insertEquipToServer(equipcode:String):void{
			PackData.app.CmdIStr[0] = CmdStr.INTUPD_EQUIPMENT;
			PackData.app.CmdIStr[1] = "0";
			PackData.app.CmdIStr[2] = equipcode;
			PackData.app.CmdIStr[3] = "";
			PackData.app.CmdIStr[4] = "";
			PackData.app.CmdIStr[5] = "20110101-000001";
			PackData.app.CmdIStr[6] = "20991231-235959";
			PackData.app.CmdInCnt = 7;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(INSERT_EQUIP_TO_SERVER));
		}
		
		private var delNum:int;
		//从服务器删除装备
		private function delBtnHandle(event:Event):void{
			sendNotification(WorldConst.DIALOGBOX_SHOW,
				new DialogBoxShowCommandVO(view,640,381,null,"正在在服务器删除装备列表，请稍后..."));
			
			sendNotification(WorldConst.SET_MODAL,true);
			

			delNum = 0;
			doDelEquip();
		}
		
		private function doDelEquip():void{
//			if(delNum < equipList.length && delNum >= 0 ){
//				//本地不存在，则从数据库删除
//				if(dressSuitsVoList.indexOf(equipList[delNum]) == -1){
//					delEquipFromServer(equipList[delNum]);
//				}else{
//					delNum--;
//					doDelEquip();
//				}
//			}else{
//				sendNotification(WorldConst.SET_MODAL,false);
//				
//				sendNotification(WorldConst.DIALOGBOX_SHOW,
//					new DialogBoxShowCommandVO(view,640,381,null,"删除完毕！~O(∩_∩)O~"));
//				
//				equipList.splice(0,equipList.length);
//				getEquipListFromServer();
//			}
		}
		private function delEquipFromServer(equipcode:String):void{
			PackData.app.CmdIStr[0] = CmdStr.DEL_EQUIPMENT;
			PackData.app.CmdIStr[1] = "0";
			PackData.app.CmdIStr[2] = equipcode;
			PackData.app.CmdInCnt = 3;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(DEL_EQUIP_FROM_SERVER));
		}
		
		
		

		
		
		
/**************************************************************************************************************/
		

		
		override public function handleNotification(notification:INotification):void{
			var name:String = notification.getName();
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(name){
				case GET_EQUIPLIST_FROM_SERVER:
					if(!result.isEnd){
						equipList.push(PackData.app.CmdOStr[2]);
					}else{
						trace("服务器装备个数："+equipList.length);
						if(firstLogin){
							firstLogin = false;
							Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
						}
					}
					break;
				case INSERT_EQUIP_TO_SERVER:
					addNum++;
					doAdd();
					break;
				case DEL_EQUIP_FROM_SERVER:	
					delNum--;
					doDelEquip();
					break;
			}
		}
		override public function listNotificationInterests():Array
		{
			return [GET_EQUIPLIST_FROM_SERVER,INSERT_EQUIP_TO_SERVER,DEL_EQUIP_FROM_SERVER];
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		override public function onRemove():void
		{
			Assets.disposeTexture("task/bg");
			
			var len:int = charaterList.length;
			for(var i:int=0;i<len;i++)
				(facade.retrieveProxy(ModuleConst.HUMAN_POOL) as HumanPoolProxy).object = charaterList[i];
			
			
			facade.removeProxy(CharaterSuitsInfoProxy.NAME);
			
			texture.dispose();
			
			sendNotification(WorldConst.SHOW_MAIN_MENU);
			sendNotification(WorldConst.SHOW_LEFT_MENU);
			sendNotification(WorldConst.STOP_RANDOM_ACTION);
		}

		private var vo:SwitchScreenVO;
		override public function prepare(vo:SwitchScreenVO):void
		{
			this.vo = vo;
			getEquipListFromServer();
			
		}
	}
}