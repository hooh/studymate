package com.mylib.game.model
{
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import de.polygonal.ds.HashMap;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class CharaterSuitsInfoProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "CharaterSuitsInfoProxy";
		private var charaterSuitsData:XML;
		private var npcSuitsMap:HashMap;
		
		
		public function CharaterSuitsInfoProxy( data:Object=null)
		{
			super(NAME, data);
		}
		
		override public function onRegister():void
		{
			npcSuitsMap = new HashMap();
			
			init();
		}
		
		public function init():void{
			charaterSuitsData = getFile("charaterSuitsInfo.xml");
			
			var xmldata:XMLList = charaterSuitsData.charater;
			var name:String;
			var dress:String;
			for (var i:int = 0; i < xmldata.length(); i++) 
			{
				if(xmldata[i].@type=="npc"){
					
					name = xmldata[i].@name;
					dress = xmldata[i].@dress;
					npcSuitsMap.insert(name,dress);
				}
			}
			
		}

		private function getFile(fileName:String):XML{
			
			var file:File = Global.document.resolvePath(Global.localPath+"/media/charater/"+fileName);
			var fstream:FileStream = new FileStream();
			fstream.open(file,FileMode.READ);
			
			var xml:XML = XML(fstream.readMultiByte(fstream.bytesAvailable,PackData.BUFF_ENCODE));
			fstream.close();
			
			return xml;
		}
		//修改文件
		private function modifyXMLFile(fileName:String,xml:String):void{
			var file:File = Global.document.resolvePath(Global.localPath+"/media/charater/"+fileName);
			var fs:FileStream = new FileStream();			
			fs.open(file,FileMode.WRITE);
			fs.writeMultiByte(xml,PackData.BUFF_ENCODE);
			fs.close();
		}
		
		public function getNpcList():Array{
			return npcSuitsMap.getKeySet();
			
		}
		
		/**
		 *根据NPC名字取装备 
		 * @param name
		 * @return 
		 * 
		 */		
		public function getDress(name:String):String{
			if(npcSuitsMap.containsKey(name))
				return npcSuitsMap.find(name);
			else
				return null;
		}
		
		/**
		 *文件 charaterSuitsInfo.xml 中有的NPC个数 
		 * @return 
		 * 
		 */		
		public function getSize():int{
			return npcSuitsMap.size;
		}
		
		
		/**
		 *根据NPC名字，返回是否存在该NPC 
		 * @param name
		 * @return 
		 * 
		 */		
		public function hasNpc(name:String):Boolean{
			return npcSuitsMap.containsKey(name);
		}
		
		/**
		 *保存NCP 
		 * @param _name
		 * @param _dressList
		 * 
		 */		
		public function saveNPC(_name:String,_dressList:String):void{
			//npc存在，删除原来装备记录
			if(hasNpc(_name)){
				
				var xmldata:XMLList = charaterSuitsData.charater;
				var name:String;
				var dress:String;
				for (var i:int = 0; i < xmldata.length(); i++) 
				{
					if(xmldata[i].@name==_name){
						delete xmldata[i];
						
						break;
					}
				}
			}
			
			var charaterXml:XML = <charater/>;
			charaterXml.@name = _name;
			charaterXml.@dress = _dressList;
			charaterXml.@type = "npc";
			
			charaterSuitsData.charater+=charaterXml;
			modifyXMLFile("charaterSuitsInfo.xml",charaterSuitsData.toString());
		}
		
		public function delNPC(_name:String):void{
			//npc存在，删除原来装备记录
			if(hasNpc(_name)){
				
				var xmldata:XMLList = charaterSuitsData.charater;
				var name:String;
				var dress:String;
				for (var i:int = 0; i < xmldata.length(); i++) 
				{
					if(xmldata[i].@name==_name){
						delete xmldata[i];
						
						modifyXMLFile("charaterSuitsInfo.xml",charaterSuitsData.toString());
						
						npcSuitsMap.remove(_name);
						break;
					}
				}
			}
		}
		
		
		override public function onRemove():void
		{
			super.onRemove();
			
			charaterSuitsData = null;
			
			npcSuitsMap.clear();
		}

		
	}
}

