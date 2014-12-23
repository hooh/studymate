package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.charater.ICharater;
	import com.mylib.game.charater.item.EquipmentItemButton;
	import com.mylib.game.model.CharaterSuitsProxy;
	import com.mylib.game.model.DressSuitsProxy;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.world.controller.CreateCharaterCommand;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.model.vo.CharaterSuitsVO;
	import com.studyMate.world.model.vo.DressEquipmentVO;
	import com.studyMate.world.model.vo.DressSuitsVO;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	
	import de.polygonal.ds.HashMap;
	
	import feathers.controls.NumericStepper;
	import feathers.controls.ScrollContainer;
	import feathers.controls.TabBar;
	import feathers.core.PropertyProxy;
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
	
	public class DressPanelMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "DressPanelMediator";
		private var vo:SwitchScreenVO;
		
		private var suitsProxy:CharaterSuitsProxy;
		private var dressSuitsProxy:DressSuitsProxy;
		private var dressTabBar:TabBar;
		
		private var charater:ICharater; 
		private var hasCreate:String;
		
		public function DressPanelMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}
		override public function prepare(vo:SwitchScreenVO):void{
			this.vo = vo;
			this.charater = vo.data[0];
			this.hasCreate = vo.data[1];
			
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		
		override public function onRegister():void{
			dressSuitsProxy = facade.retrieveProxy(DressSuitsProxy.NAME) as DressSuitsProxy;
			dressSuitsProxy.init(getNewEquipmentInfo());
			dressSuitsProxy.addCharaterDress(charater);
			
			suitsProxy = facade.retrieveProxy(CharaterSuitsProxy.NAME) as CharaterSuitsProxy;
			
			initBoneData();
			init();
		}
		private function init():void{
			
			dressTabBar = new TabBar();
			dressTabBar.dataProvider = new ListCollection(
				[				
					{ label: "头部" ,type:"head"},				
					{ label: "身体" ,type:"body"},	
					{ label: "手部" ,type:"hand"},	
					{ label: "脚" ,type:"foot"},		
					{ label: "套装" ,type:"set"},		
				]);
			
			dressTabBar.width = 70*dressTabBar.dataProvider.length;
			var tabPro:PropertyProxy = new PropertyProxy();
			tabPro.downSkin = new Image(Assets.getAtlas().getTexture("Tab_DownSkin"));
			tabPro.defaultSelectedSkin = new Image(Assets.getAtlas().getTexture("Tab_UpSkin"));
			dressTabBar.tabProperties = tabPro;
			dressTabBar.addEventListener(Event.CHANGE, dressTabBarChangeHandler);
			
			view.addChild(dressTabBar);
			
			
			var bg:Image = new Image(Assets.getTexture("dressPanelBg"));
			bg.y = 50;
			view.addChild(bg);
			
			//世界杯套装 ==输入球衣数字
			var numStep:NumericStepper = new NumericStepper();
			numStep.x = 980;
			numStep.y = 100;
			numStep.minimum = 0;
			numStep.maximum = 20;
			numStep.step = 1;
			numStep.value = 0;
			numStep.addEventListener( Event.CHANGE, numStepChangeHandler );
			view.addChild( numStep );
			
			
			var saveBtn:Button = new Button(Assets.getAtlas().getTexture("dressSaveBtn"));
			saveBtn.x = 990;
			saveBtn.y = 167;
			saveBtn.addEventListener(Event.TRIGGERED,saveBtnHandle);
			view.addChild(saveBtn);
			
			if(hasCreate != null && hasCreate !=""){
				var completeBtn:Button = new Button(Assets.getAtlas().getTexture("dressCompleteBtn"));
				completeBtn.x = 990;
				completeBtn.y = 227;
				completeBtn.addEventListener(Event.TRIGGERED,completeBtnHandle);
				view.addChild(completeBtn);
				
			}
			
			
			
			layout = new TiledRowsLayout();
			layout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			layout.gap = 2;
			layout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			layout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
			layout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
			layout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_MIDDLE;
			
			createDressHolder();
			
			showEquipmentByType("head",charater.sex);
		}
		
		private var dressHolder:Sprite;
		private var layout:TiledRowsLayout;
		private var _equipItemcontainer:ScrollContainer;
		private function createDressHolder():void{
			_equipItemcontainer = new ScrollContainer();
			_equipItemcontainer.x = 25;
			_equipItemcontainer.y = 75;
			_equipItemcontainer.width = 900;
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
		
		//球衣号码选择
		private function numStepChangeHandler(e:Event):void{
			//当前穿的衣服
			var bodyDress:String = getDressList(charater.actor.getProfile());
			if(bodyDress.indexOf("WCset") == -1){	//没穿球服，不能选数字
				return;
				
			}
			
			var newDress:String = bodyDress;
			//如果服装内已经有数字，则去除
			if(bodyDress.indexOf("WCnumber") != -1){
				trace("有数字衣服："+bodyDress);
				
				var tmp:Array = bodyDress.split(",");
				for (var i:int = 0; i < tmp.length; i++) 
				{
					if((tmp[i] as String).indexOf("WCnumber") != -1){
						tmp.splice(i,1);
						break;
						
					}
				}
				newDress = tmp.join(",");
			}
			
			var val:int = (e.target as NumericStepper).value;
			if(val == 0){	//0，不加数字
				GlobalModule.charaterUtils.configHumanFromDressList(charater,newDress,null);
				
			}else{
				var num:String = val < 10 ? ("0"+val.toString()) : val.toString();
				GlobalModule.charaterUtils.configHumanFromDressList(charater,newDress+",WCnumber"+num,null);
				
				
			}
			
			
		}
		private function isClothes(vo:DressSuitsVO):Boolean{
			if(!vo.equipments){
				return false;
			}
			
			for (var i:int = 0; i < vo.equipments.length; i++) 
			{
				if(vo.equipments[i].equipmentType == "clothes"){
					return true;
					
				}
			}
			return false;
		}
		
		
		
		
		//读取装备信息文件 equipmentInfo2.xml 获取装备信息列表 dressSuitsVoList	
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
		
		public function showEquipmentByType(_suitType:String,_sex:String):void{
			
			_equipItemcontainer.removeChildren();
			var itemBg:Image;
			var itemBtn:EquipmentItemButton;
			var len:int = dressSuitsVoList.length;
			for(var i:int=0;i<len;i++){
				if((dressSuitsVoList[i].suitType == _suitType 
					&& _sex == "A" && (dressSuitsVoList[i].level == "0" || dressSuitsVoList[i].level == "1"))
					|| (dressSuitsVoList[i].suitType == _suitType 
						&& (dressSuitsVoList[i].sex == _sex || dressSuitsVoList[i].sex == "B") 
						&& (dressSuitsVoList[i].level == "0"))){
					var len2:int = dressSuitsVoList[i].equipments.length;
					itemBg = CreateCharaterCommand.getTextureDisplay(Assets.charaterTexture,"equipItemBg");
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
						
						//卸下 === 有球服，穿了不是球服 || 有球服 ，穿了相同球服
						var bodyDress:String = getDressList(charater.actor.getProfile());
						if(bodyDress.indexOf("WCset") != -1 && isClothes(btn.dressSuitsVo)){
							if(btn.dressSuitsVo.name.indexOf("WCset") == -1 || bodyDress.indexOf(btn.dressSuitsVo.name) != -1){
								var newDress:String = bodyDress;
								//如果服装内已经有数字，则去除
								if(bodyDress.indexOf("WCnumber") != -1){
									trace("有数字衣服："+bodyDress);
									
									var tmp:Array = bodyDress.split(",");
									for (var i:int = 0; i < tmp.length; i++) 
									{
										if((tmp[i] as String).indexOf("WCnumber") != -1){
											tmp.splice(i,1);
											break;
											
										}
									}
									newDress = tmp.join(",");
								}
								GlobalModule.charaterUtils.configHumanFromDressList(charater,newDress,null);
								
								
							}
							
						}
						dressSuitsProxy.dressUp(charater,btn.dressSuitsVo);
					}
				}
			}
			
		}
		private var isSave:Boolean;
		private function saveBtnHandle(event:Event):void{
			suitsProxy.suitsMap.remove("captain");
			suitsProxy.suitsMap.insert("captain",charater.actor.getProfile());
			
			suitsProxy.export("captain",charater.actor.getProfile());
			
			isSave = true;
			
			updateEquipToServer(getDressList(charater.actor.getProfile()));
		}
		private function completeBtnHandle(event:Event):void{
			suitsProxy.suitsMap.remove("captain");
			suitsProxy.suitsMap.insert("captain",charater.actor.getProfile());
			
			suitsProxy.export("captain",charater.actor.getProfile());
			
			isSave = false;
			
			updateEquipToServer(getDressList(charater.actor.getProfile()));
			
			
		}
		public function getDressList(_profile:CharaterSuitsVO):String{
			var dressList:Vector.<String> = new Vector.<String>;
			
			var dressVoList:Vector.<DressSuitsVO> = dressSuitsProxy.profileToDressSuitsVO(_profile);
			
			for(var i:int=0;i<dressVoList.length;i++){
				if(dressVoList[i].name == "face"){
					dressList.push(dressVoList[i].equipments[0].name);
					
				}else
					dressList.push(dressVoList[i].name);
			}
			
			
			return dressList.join(",");
		}
		private function updateEquipToServer(dressList:String):void{
			PackData.app.CmdIStr[0] = CmdStr.UPDATE_CHARATER_EQUIPMENT;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = dressList;
			PackData.app.CmdInCnt = 3;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(WorldConst.UPDATE_CHARATER_EQUIPMENT_COMPLETE));
			
			
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
					
					if(_dressSuitsVO.suitType == "foot" ||_dressSuitsVO.suitType == "body" ||_dressSuitsVO.suitType == "set"||_dressSuitsVO.suitType == "hand"){
						
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
		//读文件	
		private function getFile(fileName:String):XML{
			var file:File = Global.document.resolvePath(Global.localPath+"/media/"+fileName);
			var fstream:FileStream = new FileStream();
			fstream.open(file,FileMode.READ);
			
			var xml:XML = XML(fstream.readMultiByte(fstream.bytesAvailable,PackData.BUFF_ENCODE));
			fstream.close();
			
			return xml;
		}
		
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				case WorldConst.UPDATE_CHARATER_EQUIPMENT_COMPLETE:
					Global.myDressList = getDressList(charater.actor.getProfile());
					
					if(isSave){
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.parent.parent,640,381,null,"温馨提醒：换装修改已保存！"));
					}else{
						sendNotification(WorldConst.POP_SCREEN_DATA);
						sendNotification(WorldConst.SWITCH_FIRST_SCREEN);
					}
					
					
					break;
			}
		}
		override public function listNotificationInterests():Array{
			return [WorldConst.UPDATE_CHARATER_EQUIPMENT_COMPLETE];
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