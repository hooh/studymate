package com.mylib.game.model
{
	import com.mylib.game.charater.ICharater;
	import com.mylib.game.charater.item.BoneImage;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.world.controller.CreateCharaterCommand;
	import com.studyMate.world.model.vo.CharaterSuitsVO;
	import com.studyMate.world.model.vo.DressEquipmentVO;
	import com.studyMate.world.model.vo.DressSuitsVO;
	import com.studyMate.world.model.vo.SuitEquipmentVO;
	
	import de.polygonal.ds.HashMap;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import starling.extensions.PixelHitArea;
	
	/**
	 * 实现换装逻辑的 proxy
	 * @author lsj
	 * 
	 */	
	public class DressSuitsProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "DressSuitsProxy";
//		public var dressMap:HashMap;

		public var dressSuitsVoList:Vector.<DressSuitsVO>;
		
		private var hit_1:PixelHitArea;
		
		public function DressSuitsProxy( data:Object=null)
		{
			super(NAME, data);
		}
		
		override public function onRegister():void
		{
//			dressMap = new HashMap();
			
//			init();
		}

		public function init(_dressSuitsVoList:Vector.<DressSuitsVO>):void{

			dressSuitsVoList = _dressSuitsVoList;
			
//			hit_1 = new PixelHitArea(Assets.store["myCharater"],0.5);
		}
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
		}
		
		private var tmpDress:Vector.<DressSuitsVO> = null;
		public function addCharaterDress(_charater:ICharater):void{
//			if(dressMap.containsKey(_charater)){
//				
//			}else{
//				var dressList:Vector.<DressSuitsVO> = profileToDressSuitsVO(_charater.actor.getProfile());
//				dressMap.insert(_charater,dressList);
//			}
			var dressList:Vector.<DressSuitsVO> = profileToDressSuitsVO(_charater.actor.getProfile());
			tmpDress = dressList;
		}
		public function delCharaterDress(_charater:ICharater):void{
//			if(dressMap.containsKey(_charater)){
//				dressMap.remove(_charater);
//			}
			tmpDress = null;
		}
		
		
		public function profileToDressSuitsVO(_profile:CharaterSuitsVO):Vector.<DressSuitsVO>{
			var _dressList:Vector.<DressSuitsVO> = new Vector.<DressSuitsVO>;
			
			var _dressSuitVo:DressSuitsVO;
			var _dressEquipmentVo:DressEquipmentVO;
			
			var len:int = _profile.equipments.length;
			for(var i:int=0;i<len;i++){
				if(_profile.equipments[i].name == "face" || _profile.equipments[i].name == "bmpNpc"){
					
					_dressSuitVo = new DressSuitsVO();
					_dressSuitVo.name = _profile.equipments[i].name;
					
					_dressEquipmentVo = new DressEquipmentVO();
					_dressEquipmentVo.name = _profile.equipments[i].name+"_" + _profile.equipments[i].faceName;
					
					_dressSuitVo.equipments.push(_dressEquipmentVo);
					_dressList.push(_dressSuitVo);
					continue;
					
				}
					
				
				
				var len2:int = _dressList.length;
				
				var hasItem:Boolean = false;
				for(var j:int=0;j<len2;j++){
					
					if(_dressList[j].name == _profile.equipments[i].name.split("|")[0]){
						_dressEquipmentVo = new DressEquipmentVO();
						
						_dressEquipmentVo.name = _profile.equipments[i].name.split("|")[1];
						_dressEquipmentVo.type = _profile.equipments[i].name;
						_dressEquipmentVo.x = _profile.equipments[i].x;
						_dressEquipmentVo.y = _profile.equipments[i].y;
						_dressEquipmentVo.data = _profile.equipments[i].data;
						_dressEquipmentVo.color = _profile.equipments[i].color;
						_dressEquipmentVo.bone = _profile.equipments[i].bone;
						_dressEquipmentVo.order = _profile.equipments[i].order;
						_dressEquipmentVo.equipmentType = getEquipmentType(_dressList[j].name,_dressEquipmentVo.name);
						
						_dressList[j].equipments.push(_dressEquipmentVo);
						
						
						hasItem = true;
						break;
					}

				}
				if(!hasItem){
					_dressSuitVo = new DressSuitsVO();
					
					_dressSuitVo.name = _profile.equipments[i].name.split("|")[0];
					
					_dressEquipmentVo = new DressEquipmentVO();
					_dressEquipmentVo.name = _profile.equipments[i].name.split("|")[1];
					_dressEquipmentVo.type = _profile.equipments[i].name;
					_dressEquipmentVo.x = _profile.equipments[i].x;
					_dressEquipmentVo.y = _profile.equipments[i].y;
					_dressEquipmentVo.data = _profile.equipments[i].data;
					_dressEquipmentVo.color = _profile.equipments[i].color;
					_dressEquipmentVo.bone = _profile.equipments[i].bone;
					_dressEquipmentVo.order = _profile.equipments[i].order;
					_dressEquipmentVo.equipmentType = getEquipmentType(_dressSuitVo.name,_dressEquipmentVo.name);
					
					_dressSuitVo.equipments.push(_dressEquipmentVo);
					_dressList.push(_dressSuitVo);
				}
			}
			
			return _dressList;

		}
		private function getEquipmentType(_suitName:String,_equipName:String):String{
			var len:int = dressSuitsVoList.length;
			for(var i:int=0;i<len;i++){
				if(dressSuitsVoList[i].name == _suitName){
					var len2:int = dressSuitsVoList[i].equipments.length;
					for(var j:int=0;j<len2;j++){
						if(dressSuitsVoList[i].equipments[j].name == _equipName)
							return dressSuitsVoList[i].equipments[j].equipmentType;
					}
				}
			}
			return null;
		}
		
		//给角色穿上装备
		public function dressUp(_charater:ICharater,_dressSuitVo:DressSuitsVO):void{
			if(tmpDress){
				
				var dressList:Vector.<DressSuitsVO> = tmpDress;
				var deleteDressList:Vector.<DressSuitsVO> = new Vector.<DressSuitsVO>;
				
				var len:int = dressList.length;
				var len3:int = _dressSuitVo.equipments.length;
				
				//dress相同的装备则当做卸下
				var isDressSame:Boolean = false;
				for(var i:int=0;i<len;i++){
					var len2:int = dressList[i].equipments.length;
					//角色身上穿着现在穿上的衣服
					if(dressList[i].name == _dressSuitVo.name){
						
						//将该套装备全部拆除
						removeProfileSuit(_charater,dressList[i])
						deleteDressList.push(dressList[i]);

						isDressSame = true;
						break;
					}
					
					
					for(var j:int=0;j<len2;j++){
						var hasSameType:Boolean = false;
						
						for(var k:int=0;k<len3;k++){
							
							if(dressList[i].equipments[j].equipmentType == _dressSuitVo.equipments[k].equipmentType){
								
								removeProfileSuit(_charater,dressList[i]);
								deleteDressList.push(dressList[i]);
								
								hasSameType = true;
								break;
								
							}
						}
						if(hasSameType)
							break;
					}
				}
				
				//可以穿了
				removeDressSuit(dressList,deleteDressList);
				
				if(!isDressSame){
					
					
					for(var p:int=0;p<len3;p++){
						var equipment:BoneImage = CreateCharaterCommand.getTextureDisplay(
							Assets.charaterTexture,_dressSuitVo.equipments[p].data) as BoneImage;
//						equipment.hitArea = hit_1;
						equipment.boneName = _dressSuitVo.equipments[p].bone;
						equipment.name = _dressSuitVo.name + "|" + _dressSuitVo.equipments[p].name;
						equipment.x = _dressSuitVo.equipments[p].x;
						equipment.y = _dressSuitVo.equipments[p].y;
						equipment.order = _dressSuitVo.equipments[p].order;
						
						_charater.actor.addBoneDisplay(equipment.boneName,equipment,_dressSuitVo.equipments[p].data,equipment.order);
						
					}
					dressList.push(_dressSuitVo);
				}else{
					if(_dressSuitVo.suitType == "foot" || _dressSuitVo.suitType == "set")
						GlobalModule.charaterUtils.humanDressFun(_charater,"shoes1");
					
				}
			}
		}
		//卸除指定人物所有装备
		public function dressDown(_charater:ICharater):void{
			if(tmpDress){
				var dressList:Vector.<DressSuitsVO> = tmpDress;
				var deleteDressList:Vector.<DressSuitsVO> = new Vector.<DressSuitsVO>();
				var len:int = dressList.length;
				for(var i:int=0;i<len;i++){
					deleteDressList.push(dressList[i]);
				}
				
				removeDressSuit(dressList,deleteDressList);
			}
		}
		
		//移除角色profile的所有该套装备
		private function removeProfileSuit(_charater:ICharater,_dressSuitVo:DressSuitsVO):void{
			var len:int = _dressSuitVo.equipments.length;
			
			for(var i:int=0;i<len;i++){
				
				_charater.actor.removeBoneDisplayItem(_dressSuitVo.equipments[i].bone,_dressSuitVo.name+"|"+_dressSuitVo.equipments[i].name);
				
			}
		}
		//移除角色dressMap.find(_charater)的所有该套装备
		private function removeDressSuit(_dressList:Vector.<DressSuitsVO>,_deleteDressList:Vector.<DressSuitsVO>):void{
			var len:int = _deleteDressList.length;
			
			for(var i:int=0;i<len;i++){
				
				if(_dressList.indexOf(_deleteDressList[i])>-1){
					
					_dressList.splice(_dressList.indexOf(_deleteDressList[i]),1);
					
					
				}
			}
		}
		
		/**
		 * 给骨骼配上动画<br>
		 * 实现 "换脸"、"bmp"动画换装<br><br>
		 * @param _charater
		 * @param dressTyle
		 * @param _dressEquipVo
		 * 
		 */		
		public function dressCostume(_charater:ICharater,dressTyle:String,_dressEquipVo:DressEquipmentVO):void{
			if(tmpDress){
				var dressList:Vector.<DressSuitsVO> = tmpDress;
				
				var isSame:Boolean = false;
				
				var len:int = dressList.length;
				for(var i:int=0;i<len;i++){
					
					if(dressList[i].name == dressTyle){
						//相同的脸，删除
						if(dressList[i].equipments[0].name == dressTyle+"_"+_dressEquipVo.name){

							isSame = true;
							break;
						}
					}
				}
				//不同脸，再添加
				if(!isSame){
					_charater.actor.removeBoneDisplayItem("head",dressTyle);
					
					var suitEquipmentVo:SuitEquipmentVO = new SuitEquipmentVO();
					
					suitEquipmentVo.bone = _dressEquipVo.bone;
					suitEquipmentVo.name = dressTyle;
					suitEquipmentVo.type = _dressEquipVo.type;
					suitEquipmentVo.x = _dressEquipVo.x;
					suitEquipmentVo.y = _dressEquipVo.y;
					suitEquipmentVo.order = _dressEquipVo.order;
					suitEquipmentVo.items = _dressEquipVo.items.concat();
					suitEquipmentVo.faceName = _dressEquipVo.name;
					
					_charater.actor.addFace(suitEquipmentVo);

				}
			}
		}
		
		
		
		//保存对人物的修改
		public function saveCharater(suitsProxy:CharaterSuitsProxy,_charater:ICharater,_sex:String=""):void{
			if(_sex!="")
//				_charater.actor.getProfile().sex = _sex;
				_charater.sex = _sex;
			
			if(suitsProxy.suitsMap.containsKey(_charater.charaterName))
				suitsProxy.suitsMap.remove(_charater.charaterName);
			suitsProxy.suitsMap.insert(_charater.charaterName,_charater.actor.getProfile());
			
			suitsProxy.export(_charater.charaterName,_charater.actor.getProfile(),_sex);
		}
		
		

		
	}
}

