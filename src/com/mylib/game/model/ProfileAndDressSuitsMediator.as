package com.mylib.game.model
{
	import com.mylib.game.charater.HumanMediator;
	import com.mylib.game.charater.ICharater;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.controller.CreateCharaterCommand;
	import com.studyMate.world.model.vo.CharaterSuitsVO;
	import com.studyMate.world.model.vo.DressEquipmentVO;
	import com.studyMate.world.model.vo.DressSeriesItemVO;
	import com.studyMate.world.model.vo.DressSeriesVO;
	import com.studyMate.world.model.vo.DressSuitsVO;
	import com.studyMate.world.model.vo.EquipmentItemVO;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	
	import de.polygonal.ds.HashMap;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class ProfileAndDressSuitsMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ProfileAndDressSuitsMediator";

		private var dressSuitsProxy:DressSuitsProxy;
		
		private var dressListMap:HashMap;
		
		//全局装备信息数据
		private var dressSuitsVoList:Vector.<DressSuitsVO> = new Vector.<DressSuitsVO>;
		//全局装备等级数据
		private var dressSeriesVoList:Vector.<DressSeriesVO> = new Vector.<DressSeriesVO>;
		
		public function ProfileAndDressSuitsMediator(data:Object=null)
		{
			super(NAME, data);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			getNewEquipmentInfo("equipmentInfo2");
			dressSuitsProxy = facade.retrieveProxy(DressSuitsProxy.NAME) as DressSuitsProxy;
			dressSuitsProxy.init(getNewEquipmentInfo("BmpNpcEquipInfo"));
			
			createDressListMap();
			initBoneData();
			
			//装备等级管理
			getEquipSeries("equipmentConfig");
		}
		
		private function createDressListMap():void{
			dressListMap = new HashMap();
			
			for(var i:int=0;i<dressSuitsVoList.length;i++){
				//脸部 或者 bmp动画
				if(dressSuitsVoList[i].name == "face" || dressSuitsVoList[i].name == "bmpNpc"){
					for(var j:int=0;j<dressSuitsVoList[i].equipments.length;j++){
						
						dressListMap.insert(dressSuitsVoList[i].name+"_"+dressSuitsVoList[i].equipments[j].name,dressSuitsVoList[i].equipments[j]);
					}
				}else
					dressListMap.insert(dressSuitsVoList[i].name,dressSuitsVoList[i]);
			}
		}
		
		public function dressByDressList(_charater:ICharater,_dressList:String):void{
			dressSuitsProxy.delCharaterDress(_charater);
			dressSuitsProxy.addCharaterDress(_charater);
			
			var dressSuitsNameList:Array = _dressList.split(",");
			
			try{
				for(var i:int=0;i<dressSuitsNameList.length;i++){
					if(dressSuitsNameList[i].indexOf("_") != -1)
						dressSuitsProxy.dressCostume(_charater,dressSuitsNameList[i].split("_")[0],dressListMap.find(dressSuitsNameList[i]) as DressEquipmentVO);
					else
						dressSuitsProxy.dressUp(_charater,dressListMap.find(dressSuitsNameList[i]) as DressSuitsVO);
				}
			}catch(error:Error){
				trace("着装出错");
				trace(_charater.charaterName);
				//穿入装备错误，穿上默认服装。
//				dressSuitsProxy.dressFace(_charater,"face",dressListMap.find("face_face1") as DressEquipmentVO);
//				
//				dressSuitsProxy.dressUp(_charater,dressListMap.find("set5") as DressSuitsVO);
			}
//			dressSuitsProxy.delCharaterDress(_charater);
		}
		
		
		
		public function getItemList(costumeName:String):Array{
			var itemList:Array = new Array;
			
			var dressEquipmentVo:DressEquipmentVO = dressListMap.find(costumeName) as DressEquipmentVO;
			
			if(dressEquipmentVo.items){
				for each (var i:EquipmentItemVO in dressEquipmentVo.items) 
					itemList.push(i.name);
			}
			
			
			return itemList;
		}
		
		public function getDressList(_charater:ICharater):String{
			var dressList:Vector.<String> = new Vector.<String>;
			
			var dressVoList:Vector.<DressSuitsVO> = dressSuitsProxy.profileToDressSuitsVO(_charater.actor.getProfile());
			
			for(var i:int=0;i<dressVoList.length;i++){
				if(dressVoList[i].name == "face" || dressVoList[i].name == "bmpNpc"){
					dressList.push(dressVoList[i].equipments[0].name);
					
				}else
					dressList.push(dressVoList[i].name);
			}
			
			
			return dressList.join(",");
		}

		
		
		
		
		private function getNewEquipmentInfo(_fileName:String):Vector.<DressSuitsVO>{
			var dressSuitsVo:DressSuitsVO;
			var dressEquipmentVo:DressEquipmentVO;
			var items:EquipmentItemVO;
			
			var suitName:String;
			var suitType:String;
			var sex:String;
			var level:String;
			
			var equipXml:XML = getFile("textures/"+_fileName+".xml");
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
				
				//获取所有装备
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
						
						
						//获取所有表情
						var itemsList:XMLList = j.item;
						if(itemsList.length()){
							for each(var k:XML in itemsList){
								
								items = new EquipmentItemVO();
								items.name = k.@name;
								items.type = k.@type;
								
								if(k.@isDefault == "true")	items.isDefault = true;
								else	items.isDefault = false;
								
								items.data = Vector.<String>(String(k.@data).split(","));
								
								if(items.type == "d"){
									items.rate = k.@rate;
									
									
									
									var durationStr:String = k.@duration;
									if(durationStr!=""){
										var durations:Array = durationStr.split(",");

										for each (var p:String in durations) 
										{
											var durationItem:Array = p.split("_");
											items.duration||={};
											items.duration[durationItem[0]]=parseFloat(durationItem[1]);
										}
									}
								}
								
								dressEquipmentVo.items.push(items);
							}
						}
						
						dressSuitsVo.equipments.push(dressEquipmentVo);
						
					}
					
				}
				
				
				dressSuitsVoList.push(dressSuitsVo);
			}
			return dressSuitsVoList;
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
					boneDateMap.insert("hand1_2",new Point(i.hand1_2[0].@x,i.hand1_2[0].@y));
					boneDateMap.insert("hand2_2",new Point(i.hand2_2[0].@x,i.hand2_2[0].@y));
					boneDateMap.insert("leg1_2",new Point(i.leg1_2[0].@x,i.leg1_2[0].@y));
					boneDateMap.insert("leg2_2",new Point(i.leg2_2[0].@x,i.leg2_2[0].@y));
					
					break;
				}
			}
		}
		//获取整理过后的装备贴图
		public function getNormalEquipImg(_dressSuitsVO:DressSuitsVO, scale:Number=1):DisplayObject{
			if(!_dressSuitsVO)
				return null;
			
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
				sp.scaleX *= scale;
				sp.scaleY *= scale;
				return sp;
			}else{
				if(_dressSuitsVO.equipments && _dressSuitsVO.equipments.length > 0){
					img = CreateCharaterCommand.getTextureDisplay(Assets.charaterTexture,_dressSuitsVO.equipments[0].data) as Image;
					img.scaleX = scale;
					img.scaleY = scale;
				}
				return img;
			}
			
		}
		
		public function getEquipImgByName(_dressName:String, _scale:Number=1):DisplayObject{
			
			return getNormalEquipImg(dressListMap.find(_dressName) as DressSuitsVO, _scale);
		}
		
		
		
		private function getEquipSeries(_fileName:String):void{
			
			var seriesName:String;
			var dressSeriesVO:DressSeriesVO
			var dressSeriesItemVO:DressSeriesItemVO;
			
			var equipXml:XML = getFile("textures/"+_fileName+".xml");
			for each (var i:XML in equipXml.children()){
				
				seriesName = i.@name;
				
				dressSeriesVO = new DressSeriesVO;
				dressSeriesVO.name = seriesName;
				
				
				//获取所有装备
				var itemList:XMLList = i.item;
				if(itemList.length()){
					for each(var j:XML in itemList){
						
						dressSeriesItemVO = new DressSeriesItemVO;
						dressSeriesItemVO.name = j.@name;
						dressSeriesItemVO.level = j.@level;
						dressSeriesItemVO.seriesName = seriesName;
						
						dressSeriesVO.items.push(dressSeriesItemVO);
					}
				}
				dressSeriesVO.topLevel = dressSeriesVO.items.length;
				
				dressSeriesVoList.push(dressSeriesVO);
			}
		}
		/**
		 *取装备系列信息 
		 * @param _dressName
		 * @return 
		 * 
		 */		
		public function getEquipSerInfo(_dressName:String):DressSeriesVO{
			if(!dressSeriesVoList)
				return null;
			
			for (var i:int = 0; i < dressSeriesVoList.length; i++) 
			{
				for (var j:int = 0; j < dressSeriesVoList[i].items.length; j++) 
				{
					if(dressSeriesVoList[i].items[j].name == _dressName){
						
						return dressSeriesVoList[i];
						
					}
				}
			}
			return null;
		}
		/**
		 *取装备当前等级信息 
		 * @param _dressName
		 * @return 
		 * 
		 */		
		public function getEquipItemInfo(_dressName:String):DressSeriesItemVO{
			if(!dressSeriesVoList)
				return null;
			
			for (var i:int = 0; i < dressSeriesVoList.length; i++) 
			{
				for (var j:int = 0; j < dressSeriesVoList[i].items.length; j++) 
				{
					if(dressSeriesVoList[i].items[j].name == _dressName){
						
						return dressSeriesVoList[i].items[j];
						
					}
				}
			}
			return null;
		}
		/**
		 *取装备下一等级信息 
		 * @param _dressName
		 * @return 
		 * 
		 */		
		public function getNextLevelEquip(_dressName:String):DressSeriesItemVO{
			var equipInfo:DressSeriesVO = getEquipSerInfo(_dressName);
			var itemInfo:DressSeriesItemVO = getEquipItemInfo(_dressName);
			
			if(equipInfo){
				//还可以升级
				var itemLevel:int = int(itemInfo.level)
				if(itemLevel < equipInfo.topLevel){
					
					for (var i:int = 0; i < equipInfo.items.length; i++) 
					{
						//找到下一级装备
						if((int(equipInfo.items[i].level)) == (itemLevel+1))
							return equipInfo.items[i];
					}
				}
			}
			return null;
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
		
		
		
		override public function handleNotification(notification:INotification):void
		{
			var name:String = notification.getName();
			
			switch(name)
			{
				default:
				{
					break;
				}
			}
			
		}
		override public function listNotificationInterests():Array
		{
			return [];
		}
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
		}
		
		
		
	}
}