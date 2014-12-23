package com.studyMate.world.screens
{
	import com.mylib.api.ICharaterUtils;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.charater.HumanMediator;
	import com.mylib.game.charater.ICharater;
	import com.mylib.game.charater.item.BoneImage;
	import com.mylib.game.model.CharaterSuitsProxy;
	import com.mylib.game.model.HumanPoolProxy;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.controller.CreateCharaterCommand;
	import com.studyMate.world.model.vo.CharaterSuitsVO;
	import com.studyMate.world.model.vo.SuitEquipmentVO;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	
	import feathers.controls.Button;
	import feathers.controls.Radio;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Slider;
	import feathers.core.ToggleGroup;
	import feathers.layout.TiledRowsLayout;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
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

	public class CharacterEditorMediator extends ScreenBaseMediator implements IMediator
	{
		public static const NAME:String = "CharacterEditorMediator";

		private var btnHolder:Sprite;
		private var characterHolder:Sprite;

		private var XSlider:Slider;
		private var YSlider:Slider;
		private var XSliderValue:TextField;
		private var YSliderValue:TextField;
		
		private var charater:ICharater;
		private var profile2:CharaterSuitsVO;
		private var profile:CharaterSuitsVO;
		private var suitsProxy:CharaterSuitsProxy;
		private var charaterSp:Sprite;
		
		private var boneTG:ToggleGroup;
		private var equipInfo:TextField;
		
		private var _container:ScrollContainer = new ScrollContainer();
		private var texture:Texture;

		public function CharacterEditorMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}

		override public function onRegister():void
		{
			init();
			getAllEquipment();
			getEquipmentList("head");
			
			sendNotification(WorldConst.HIDE_LEFT_MENU);
			sendNotification(WorldConst.HIDE_MAIN_MENU);

			
		}
		private function init():void{
			texture = Texture.fromBitmap(Assets.store["task_bg"],false);
			var bg:Image = new Image(texture);
			view.addChild(bg);
			
			characterHolder = new Sprite();
			characterHolder.touchable = false;
			view.addChild(characterHolder);
			
			btnHolder = new Sprite();
			btnHolder.touchable = true;
			btnHolder.x = 600;
			view.addChild(btnHolder);

			var saveEditBtn:Button = new Button();
			saveEditBtn.addEventListener(Event.TRIGGERED,saveEditBtnHandle);
			saveEditBtn.x = 85;
			saveEditBtn.y = 30;
//			saveEditBtn.scaleX = 2;
//			saveEditBtn.scaleY = 2;
			saveEditBtn.label = "Save equipment";
			view.addChild(saveEditBtn);
			
			var exportAllEquipBtn:Button = new Button();
			exportAllEquipBtn.addEventListener(Event.TRIGGERED,exportAllEquipBtnHandle);
			exportAllEquipBtn.x =250;
			exportAllEquipBtn.y = 30;
//			exportAllEquipBtn.scaleX = 2;
//			exportAllEquipBtn.scaleY = 2;
			exportAllEquipBtn.label = "Export \"equipmentInfo.xml\"";
			view.addChild(exportAllEquipBtn);
			
			var zoomBtn:Button;
			for(var i:int=0;i<3;i++){
				zoomBtn = new Button();
				zoomBtn.addEventListener(Event.TRIGGERED,zoomBtnHandle);
				zoomBtn.x = 85;
				zoomBtn.y = 250+70*i;
//				zoomBtn.scaleX = 2;
//				zoomBtn.scaleY = 2;
				
				zoomBtn.name = "Btn"+i;
				zoomBtn.label = "X"+Math.pow(2,i);
				
				view.addChild(zoomBtn);
			}

			var titleText:TextField = new TextField(75,30,"X：","Verdana");
			titleText.x = 155;
			titleText.y = 530;
			titleText.autoScale = true;
			titleText.hAlign = HAlign.LEFT;
			btnHolder.addChild(titleText);
			
			titleText = new TextField(75,30,"Y：","Verdana");
			titleText.x = 155;
			titleText.y = 600;
			titleText.autoScale = true;
			titleText.hAlign = HAlign.LEFT;
			btnHolder.addChild(titleText);
			
			XSlider = new Slider();		
			XSlider.minimum = -30;			
			XSlider.maximum = 30;			
			XSlider.value = 0;
			XSlider.step = 1;	
			XSlider.direction = Slider.DIRECTION_HORIZONTAL;			
			XSlider.liveDragging = true;			
			XSlider.addEventListener(TouchEvent.TOUCH, XSliderHandler);			
			btnHolder.addChild(XSlider);
			XSlider.validate();
			XSlider.x = 190;
			XSlider.y = 530;
			XSlider.width = 300;

			YSlider = new Slider();	
			YSlider.minimum = -30;			
			YSlider.maximum = 30;			
			YSlider.value = 0;
			YSlider.step = 1;		
			YSlider.direction = Slider.DIRECTION_HORIZONTAL;			
			YSlider.liveDragging = true;			
			YSlider.addEventListener(TouchEvent.TOUCH, YSliderHandler);			
			btnHolder.addChild(YSlider);
			YSlider.validate();
			YSlider.x = 190;
			YSlider.y = 600;
			YSlider.width = 300;
			
			XSliderValue = new TextField(50,30,XSlider.value.toString(),"Verdana");
			XSliderValue.x = 500;
			XSliderValue.y = 530;
			XSliderValue.autoScale = true;
			XSliderValue.hAlign = HAlign.LEFT;
			btnHolder.addChild(XSliderValue);
			
			YSliderValue = new TextField(50,30,YSlider.value.toString(),"Verdana");
			YSliderValue.x = 500;
			YSliderValue.y = 600;
			YSliderValue.autoScale = true;
			YSliderValue.hAlign = HAlign.LEFT;
			btnHolder.addChild(YSliderValue);

			showAllActor();
		}
		private function showAllActor():void{
			charaterSp = new Sprite();
			
			var range:Rectangle = new Rectangle();
			suitsProxy = facade.retrieveProxy(CharaterSuitsProxy.NAME) as CharaterSuitsProxy;
			profile = suitsProxy.getCharaterSuit("templet2");
			
//			profile2 = profile.clone();
			
			charater = (facade.retrieveProxy(ModuleConst.HUMAN_POOL) as HumanPoolProxy).object;
			charaterSp.addChild(charater.view);
			charater.view.x = 0;
			charater.view.y = 0;
			charater.actor.playAnimation("idle",64,64,true);
			(Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CHARATER_UTILS) as ICharaterUtils).configHumanFromDressList(charater as HumanMediator,"face_face1",new Rectangle());
			
			profile2 = charater.actor.getProfile();
			
			charaterSp.name = "captain";
			charaterSp.x = 320;
			charaterSp.y = 470;
			charaterSp.scaleX = 3;
			charaterSp.scaleY = 3;
			characterHolder.addChild(charaterSp);
			
			showBoneList(charaterSp.name);
		}

		private function showBoneList(charaterSuit:String):void{
			boneTG = new ToggleGroup();
			var radio:Radio;
			var titleText:TextField;
			
			for(var i:int=0;i<6;i++){
				radio = new Radio();
				radio.toggleGroup = boneTG;
				radio.y = 50*i+50;
				switch(i){
					case 0:
						radio.name = "Head";
						titleText = new TextField(85,30,"Head","Verdana",18);
						break;
					case 1:
						radio.name = "Hand1_2";
						titleText = new TextField(85,30,"Hand1_2","Verdana",18);
						break;
					case 2:
						radio.name = "Hand2_2";
						titleText = new TextField(85,30,"Hand2_2","Verdana",18);
						break;
					case 3:
						radio.name = "Body";
						titleText = new TextField(85,30,"Body","Verdana",18);
						break;
					case 4:
						radio.name = "Leg1_2";
						titleText = new TextField(85,30,"Leg1_2","Verdana",18);
						break;
					case 5:
						radio.name = "Leg2_2";
						titleText = new TextField(85,30,"Leg2_2","Verdana",18);
						break;
				}
				titleText.x = 30;
				titleText.y = 50*i+50;
				titleText.hAlign = HAlign.LEFT;
				
				btnHolder.addChild(radio);
				btnHolder.addChild(titleText);
			}
			boneTG.addEventListener(Event.CHANGE,toggleGroupHandle);

			var layout:TiledRowsLayout = new TiledRowsLayout();
			layout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			layout.gap = 2;
			layout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			layout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
			layout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
			layout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_MIDDLE;
			
			_container.x = 180;
			_container.y = 80;
			_container.width = 400;
			_container.height = 300;
			_container.layout = layout;
			_container.snapToPages = TiledRowsLayout.PAGING_VERTICAL;
			_container.snapScrollPositionsToPixels = true;
			btnHolder.addChild(_container);

			equipInfo = new TextField(400,100,"","Verdana",15);
			setEquipInfo(equipment,true);
			equipInfo.x = 180;equipInfo.autoScale = true;
			equipInfo.y = 350;
			equipInfo.hAlign = HAlign.LEFT;
			btnHolder.addChild(equipInfo);
			
			var equipCopyBtn:Button = new Button();
			equipCopyBtn.label = "Copy";
			equipCopyBtn.x = 190;
			equipCopyBtn.y = 455;
//			equipCopyBtn.scaleX = 2;
//			equipCopyBtn.scaleY = 2;
			equipCopyBtn.addEventListener(Event.TRIGGERED,equipCopyHandle);
			btnHolder.addChild(equipCopyBtn);
		}
		
		private function toggleGroupHandle(event:Event):void{
			var selectItem:String = ((event.target as ToggleGroup).selectedItem as Radio).name;
			getEquipmentList(selectItem.toLocaleLowerCase());
		}
		
		private function equipCopyHandle(event:Event):void{
			Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT,equipInfo.text);
		}

		
		//获取骨骼的装备列表，从equipment。xml
		private function getEquipmentList(_boneName:String):void{
			//while(_container.numChildren > 0)
			//	_container.removeChildAt(_container.numChildren-1);
			_container.removeChildren(0,-1,true);
			var equipDisplay:BoneImage;
			
			//当前骨骼名称
			currentBoneName = _boneName;
			var len:int = suitVOList.length;
			if(len>0){
				for(var j:int=0;j<len;j++){
					if(suitVOList[j].bone==_boneName){
						equipDisplay = CreateCharaterCommand.getTextureDisplay(Assets.charaterTexture,suitVOList[j].data) as BoneImage;
						equipDisplay.name = suitVOList[j].name;
						equipDisplay.id = suitVOList[j].data;
						equipDisplay.boneName = _boneName;
						
						equipDisplay.localX = suitVOList[j].x;
						equipDisplay.localY = suitVOList[j].y;
						equipDisplay.order = suitVOList[j].order;
						
						equipDisplay.scaleX = 2;
						equipDisplay.scaleY = 2;
						_container.addChild(equipDisplay);
						
						equipDisplay.addEventListener(TouchEvent.TOUCH,dressEquipment);
					}
				}
			}
		}
		private var currentBoneName:String;
		private var equipment:BoneImage;
		private var beginX:Number;
		private var endX:Number;
		private function dressEquipment(event:TouchEvent):void{
			var _equipment:BoneImage = event.currentTarget as BoneImage;

			var touchPoint:Touch = event.getTouch(event.target as DisplayObject);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					beginX = touchPoint.globalX;
				}else if(touchPoint.phase==TouchPhase.ENDED){
					endX = touchPoint.globalX;
					if(Math.abs(endX-beginX) < 10){
						if(hasEquipment(_equipment.name)){
							charater.actor.removeBoneDisplayItem(_equipment.boneName,_equipment.name);
							XSlider.value = 0;
							YSlider.value = 0;
							setEquipInfo(equipment,true);
						}else{
							equipment = CreateCharaterCommand.getTextureDisplay(
								Assets.charaterTexture,_equipment.id) as BoneImage;
							equipment.boneName = _equipment.boneName;
							equipment.name = _equipment.name;
							equipment.x = _equipment.localX;
							equipment.y = _equipment.localY;
							equipment.date = _equipment.id;
							
							charater.actor.addBoneDisplay(_equipment.boneName,equipment,_equipment.id,_equipment.order);
			
							XSlider.value = equipment.x;
							YSlider.value = equipment.y;
							
							setEquipInfo(equipment);
						}
						XSliderValue.text = XSlider.value.toString();
						YSliderValue.text = YSlider.value.toString();
					}
				}
			}
		}
		private function hasEquipment(equipName:String):Boolean{
			var len:int = profile2.equipments.length;
			for(var i:int=0;i<len;i++){
				if(profile2.equipments[i].name == equipName)
					return true;
			}
			return false;
		}

/**************************************************************************************************************/
		private var suitVOList:Vector.<SuitEquipmentVO>;
		//获取骨骼的装备列表，从equipment。xml
		private function getAllEquipment():void{
			suitVOList = new Vector.<SuitEquipmentVO>();
			var suitVO:SuitEquipmentVO;
			var equipXml:XML;
			var equipName:String = "";
			var boneName:String = "";
			
			//将equipmentInfo.xml的装备添加到suitVOList列表
			equipXml = _getFile("textures/equipmentInfo.xml");
			for each (var i:XML in equipXml.children()) {
				boneName = i.@bone;
				
				var equipList:XMLList = i.equipment;
				if(equipList.length()){
					for each(var j:XML in equipList){
						if(j.@name == "face")
							continue;
						
						suitVO = new SuitEquipmentVO();
						suitVO.bone = boneName;
						suitVO.name = j.@name;
						suitVO.data = j.@data;
						suitVO.x = j.@x;
						suitVO.y = j.@y;
						suitVO.type = j.@type;
						suitVO.order = j.@order;
						
						suitVOList.push(suitVO);
					}
				}
			}

			//排除equipmentInfo.xml，将myCharater.xml的装备添加到suitVOList列表
			equipXml = _getFile("textures/myCharater.xml");
			for each (var k:XML in equipXml.children()) {
				var str:String = k.@name;
				var _str:String = str.substring(0,str.indexOf("_"));
				if(_str == "MHuman" ||_str == "face" ||_str == "equipItemBg" ||_str == "charaterBg")
					continue;
				
				boneName = str.substring(0,str.lastIndexOf("_"));
				equipName = str.substring(str.lastIndexOf("_")+1);

				
				if(!hasSuitVO(str)){
					suitVO = new SuitEquipmentVO();
					
					suitVO.bone = boneName;
					suitVO.name = equipName;
					suitVO.data = str;
					suitVO.x = 0;
					suitVO.y = 0;
					suitVO.type = "s";
					suitVO.order = 0;
					
					suitVOList.push(suitVO);
				}
			}
		}
		private function hasSuitVO(suitName:String):Boolean{
			var len:int = suitVOList.length;
			for(var i:int=0;i<len;i++){
				if(suitVOList[i].data == suitName)
					return true;
			}
			return false;
		}
/**************************************************************************************************************/

		private function _getFile(fileName:String):XML{
			var file:File = Global.document.resolvePath(Global.localPath+"/media/"+fileName);
			if(file.exists){
				var fstream:FileStream = new FileStream();
				fstream.open(file,FileMode.READ);
				
				var xml:XML = XML(fstream.readMultiByte(fstream.bytesAvailable,PackData.BUFF_ENCODE));
				fstream.close();
				
				return xml;
			}else
				return XML("");
			
		}
		private function saveEditBtnHandle(event:Event):void{
			var len:int = suitVOList.length;
			if(len>0 && equipment){
				for(var j:int=0;j<len;j++){
					if(suitVOList[j].name == equipment.name){
						suitVOList[j].x = XSlider.value;
						suitVOList[j].y = YSlider.value;
						
						getEquipmentList(currentBoneName);
						break;
					}
				}
			}
		}
		private function exportAllEquipBtnHandle(event:Event):void{
			var equipXml:XML;
			var equipName:String = "";
			var boneName:String = "";
			
			var j:int;
			var len:int = suitVOList.length;

			equipXml = _getFile("textures/equipmentInfo.xml");

			for(j=0;j<len;j++){
				var hasBone:Boolean = false;
				for each (var i:XML in equipXml.children()) {
					boneName = i.@bone;
					trace("boneName:"+boneName);
					
					if(suitVOList[j].bone == boneName){
						var equipList:XMLList = i.equipment;
						if(equipList.length()){
							var hasEquip:Boolean = false;
							for each(var k:XML in equipList){
								if(k.@name == "face")
									continue;
								if(k.@name == suitVOList[j].name){
									k.@x = suitVOList[j].x;
									k.@y = suitVOList[j].y;
									
									hasEquip = true;
									break;
								}
							}
							if(!hasEquip){
								var equipmentXml:XML = <equipment/>;
								equipmentXml.@name = suitVOList[j].name;
								equipmentXml.@type = suitVOList[j].type;
								equipmentXml.@order = suitVOList[j].order;
								equipmentXml.@x = suitVOList[j].x;
								equipmentXml.@y = suitVOList[j].y;
								equipmentXml.@data = suitVOList[j].data;
								
								i.equipment += equipmentXml;
							}
						}
						
						hasBone = true;
						break;
					}
				}
				//之前没有该骨骼装备，新添加
				if(!hasBone){
					var suitXml:XML = <suit/>;
					suitXml.@bone = suitVOList[j].bone;
					
					var equipmentXml2:XML = <equipment/>;
					equipmentXml2.@name = suitVOList[j].name;
					equipmentXml2.@type = suitVOList[j].type;
					equipmentXml2.@order = suitVOList[j].order;
					equipmentXml2.@x = suitVOList[j].x;
					equipmentXml2.@y = suitVOList[j].y;
					equipmentXml2.@data = suitVOList[j].data;
					
					suitXml.equipment += equipmentXml2;
					
					
					equipXml.suit += suitXml;
				}
			}
			
			var file:File; 
			var fs:FileStream;
			file = Global.document.resolvePath(Global.localPath +"/media/textures/equipmentInfo.xml");
			fs = new FileStream();				
			fs.open(file,FileMode.WRITE);
			fs.writeMultiByte(equipXml.toString(),PackData.BUFF_ENCODE);
			fs.close();
	
		}
		
		private function zoomBtnHandle(event:Event):void{
			if((event.target as Button).name == "Btn0"){
				charaterSp.scaleX = 1;
				charaterSp.scaleY = 1;
			}else if((event.target as Button).name == "Btn1"){
				charaterSp.scaleX = 2;
				charaterSp.scaleY = 2;
			}else{
				charaterSp.scaleX = 4;
				charaterSp.scaleY = 4;
			}
		}

		private function XSliderHandler(event:TouchEvent):void{
			var touch:Touch = event.getTouch(event.target as DisplayObject);
			if(touch){
				if(touch.phase == TouchPhase.MOVED){
					trace(XSlider.value.toString());
					XSliderValue.text = XSlider.value.toString();
					
					if(equipment){
						equipment.x = XSlider.value;
						
						setEquipInfo(equipment);
					}
				}
			}
		}
		private function YSliderHandler(event:TouchEvent):void{
			var touch:Touch = event.getTouch(event.target as DisplayObject);
			if(touch){
				if(touch.phase == TouchPhase.MOVED){
					trace(YSlider.value.toString());
					YSliderValue.text = YSlider.value.toString();
					
					if(equipment){
						equipment.y = YSlider.value;
						setEquipInfo(equipment);
					}
				}
			}
		}
		private function setEquipInfo(_equipment:BoneImage,isClear:Boolean=false):void{
			if(equipment && isClear==false){
				equipInfo.text = "<equipment name=\""+_equipment.name
					+"\" equipmentType=\" \" bone=\""+_equipment.boneName
					+"\" data=\""+_equipment.date
					+"\" type=\"s\" order=\"0\" y=\""+_equipment.y
					+"\" x=\""+_equipment.x
					+"\"\/>";
			}else{
				equipInfo.text = "<equipment name=\" \" equipmentType=\" \" bone=\" \" " +
					"data=\" \" type=\" \" order=\" \" y=\" \" x=\" \"\/>";
			}
		}
/**************************************************************************************************************/

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
			texture.dispose();
			
			(facade.retrieveProxy(ModuleConst.HUMAN_POOL) as HumanPoolProxy).object = charater;

			sendNotification(WorldConst.STOP_RANDOM_ACTION);
			
			view.removeChildren(0,-1,true);
			super.onRemove();
		}

		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
	}
}