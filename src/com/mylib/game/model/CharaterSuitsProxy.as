package com.mylib.game.model
{
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.model.vo.CharaterSuitsVO;
	import com.studyMate.world.model.vo.EquipmentItemVO;
	import com.studyMate.world.model.vo.SuitEquipmentVO;
	import com.studyMate.world.model.vo.SuitVO;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import de.polygonal.ds.HashMap;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class CharaterSuitsProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "CharaterSuitsProxy";
		public var charaterSuitsData:XML;
		public var suitsMap:HashMap;
		public var freeNPCList:Vector.<String>;
		
		public var freeNPCListSource:Vector.<String>;
		
		
		public function CharaterSuitsProxy( data:Object=null)
		{
			super(NAME, data);
		}
		
		override public function onRegister():void
		{
			suitsMap = new HashMap();
			
			freeNPCList = new Vector.<String>;
			
		}
		
		public function init():void{
			charaterSuitsData = getFile("charaterSuits.xml");
			parseCharaterSuits();
			
			var xmldata:XMLList = charaterSuitsData.charater;
			for (var i:int = 0; i < xmldata.length(); i++) 
			{
				if(xmldata[i].@type=="npc"){
					freeNPCList.push(xmldata[i].@name);
				}
			}
			freeNPCListSource = freeNPCList.concat();
			
			charaterSuitsData = null;
			
		}
		
		public function reset():void{
			freeNPCList = freeNPCListSource.concat();
			
		}
		
		private function getFile(fileName:String):XML{
			
			var file:File = Global.document.resolvePath(Global.localPath+"/media/charater/"+fileName);
			var fstream:FileStream = new FileStream();
			fstream.open(file,FileMode.READ);
			
			var result:XML = XML(fstream.readMultiByte(fstream.bytesAvailable,PackData.BUFF_ENCODE));
			fstream.close();
			return result;
			
		}
		
		public function getCharaterSuit(charaterName:String,copy:Boolean=false):CharaterSuitsVO{
			if(!copy){
				return suitsMap.find(charaterName) as CharaterSuitsVO;
			}else{
				return (suitsMap.find(charaterName) as CharaterSuitsVO).clone();
			}
		}
		
		public function getSuitId(charaterName:String,bone:String):SuitVO{
			
			if(suitsMap.containsKey(charaterName)){
				return (suitsMap.find(charaterName) as CharaterSuitsVO).bones[bone] as SuitVO;
				
			}
			
			return null;
		}
		
		public function convertDataToCharaterSuitsVO(suit:XML):CharaterSuitsVO{
			var charater:CharaterSuitsVO = new CharaterSuitsVO();
			charater.sex = suit.@sex;
			
			for each (var j:XML in suit.children()) 
			{
				var bone:SuitVO = new SuitVO();
				bone.id = j.@id;
				bone.bone = j.@bone;
				charater.bones[bone.bone] = bone;
				var color:XMLList = j.attribute("color");
				if(color.length()){
					bone.color = parseInt(j.@color,16);
				}
				
				var equipments:XMLList = j.equipment;
				
				if(equipments.length()){
					
					for each (var k:XML in equipments) 
					{
						var equipment:SuitEquipmentVO = new SuitEquipmentVO();
						equipment.data = k.@data;
						equipment.order = k.@order;
						equipment.x = k.@x;
						equipment.y = k.@y;
						color = k.attribute("color");
						if(color.length()){
							equipment.color = parseInt(k.@color,16);
						}
						equipment.bone = j.@bone;
						equipment.type = k.@type;
						equipment.name = k.@name;
						equipment.faceName = k.@faceName;
						
						var itemList:XMLList = k.item;
						
						if(itemList.length()){
							
							equipment.items = new Vector.<EquipmentItemVO>;
							
							for each (var i2:XML in itemList) 
							{
								var item:EquipmentItemVO = new EquipmentItemVO;
								item.data = Vector.<String>(String(i2.@data).split(","));
								item.name = i2.@name;
								item.rate = i2.@rate;
								item.type = i2.@type;
								
								var durationStr:String = i2.@duration;
								
								if(durationStr!=""){
									
									var durations:Array = durationStr.split(",");
									
									
									for each (var i3:String in durations) 
									{
										var durationItem:Array = i3.split("_");
										item.duration||={};
										item.duration[durationItem[0]]=parseFloat(durationItem[1]);
									}
								}
								equipment.items.push(item);
								
							}
							
							
						}
						
						charater.addEquip(equipment); 
					}
				}
				
				
				
			}
			
			return charater;
			
		}
		
		private function parseCharaterSuits():void{
			
			var itemName:String;
			var suit:XML;
			for each (var i:XML in charaterSuitsData.children()) 
			{
				itemName = i.@name;
				suit = getFile(i.@suit_path);
				var charater:CharaterSuitsVO = convertDataToCharaterSuitsVO(suit);
				suitsMap.insert(itemName,charater);
				
			}
			
		}
		
		public function export(fileName:String,profile:CharaterSuitsVO,sex:String=""):void{
//			trace("骨骼："+"========================");
//			for(var _boneName1:String in profile.bones){
//				trace("骨骼["+_boneName1+"] = "+profile.bones[_boneName1].id);
//			}
			
			
//			trace("导出XML："+"========================");
			var suitsXml:XML = <suits/>;
			if(sex == "")
				suitsXml.@sex = profile.sex;
			else
				suitsXml.@sex = sex;
			var suitXml:XML;
		

			for(var _boneName:String in profile.bones){
				suitXml = <suit/>;
				suitXml.@bone = _boneName;
				suitXml.@id = profile.bones[_boneName].id;
				
				setEquipment(suitXml,profile,_boneName);
				
				suitsXml.suit += suitXml;
			}
//			trace(suitsXml);
			
			
			var file:File; 
			var fs:FileStream;
//			file = Global.document.resolvePath(Global.localPath +"/media/charater/captain"+new Date().time+".xml");
			file = Global.document.resolvePath(Global.localPath +"/media/charater/"+fileName+".xml");
			fs = new FileStream();				
			fs.open(file,FileMode.WRITE);
			fs.writeMultiByte(suitsXml.toString(),PackData.BUFF_ENCODE);
			fs.close();
			
			
		}
		
		private function setEquipment(_suitXml:XML,_profile:CharaterSuitsVO,_boneName:String):void{
			var equipmentXml:XML = <equipment/>;
			var len:int = _profile.equipments.length;
			for(var i:int=0;i<len;i++){
				if(_boneName == _profile.equipments[i].bone){
					equipmentXml.@name = _profile.equipments[i].name;
					equipmentXml.@type = _profile.equipments[i].type;
					equipmentXml.@order = _profile.equipments[i].order;
					equipmentXml.@x = _profile.equipments[i].x;
					equipmentXml.@y = _profile.equipments[i].y;
					if(_profile.equipments[i].faceName != "" && _profile.equipments[i].faceName != null)	equipmentXml.@faceName = _profile.equipments[i].faceName;
					
					if(_profile.equipments[i].data == "" || _profile.equipments[i].data == null){
						var itemXml:XML = <item/>;
						var itemLen:int = _profile.equipments[i].items.length;
						for(var j:int=0;j<itemLen;j++){
							itemXml.@name = _profile.equipments[i].items[j].name;
							itemXml.@type = _profile.equipments[i].items[j].type;
							if(_profile.equipments[i].items[j].type == "d"){
								itemXml.@isDefault = _profile.equipments[i].items[j].isDefault;
								
								itemXml.@rate = _profile.equipments[i].items[j].rate;
								
								var obj:Object = _profile.equipments[i].items[j].duration;
								var durationArr:Array = [];
								for(var d:Object in obj)
									durationArr.push(d+"_"+obj[d]);
									
								itemXml.@duration = durationArr.join(",");
							}
							itemXml.@data = _profile.equipments[i].items[j].data;
							equipmentXml.item += itemXml;
							delete itemXml.@*;
						}
					}else
						equipmentXml.@data = _profile.equipments[i].data;
					
					_suitXml.equipment += equipmentXml;
					delete equipmentXml.item;
				}
			}
		}
		
		
		
		
	}
}

