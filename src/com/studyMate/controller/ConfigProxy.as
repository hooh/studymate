package com.studyMate.controller
{
	import com.mylib.api.IConfigProxy;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class ConfigProxy extends Proxy implements IConfigProxy ,IProxy
	{
		
		private var file:File = Global.document.resolvePath(Global.localPath + "default2.ini");
		private var stream:FileStream = new FileStream();
		private var config:XML;
		
		public function ConfigProxy(data:Object=null){
			super(ModuleConst.CONFIGPROXY, data);
		}
		
		override public function onRegister():void{
			readConfig();
		}
		
		public function getValue(key:String):String{
			readConfig();
			if(config[key]){
				return config[key];
			}
			return "";
		}
		
		public function updateValue(key:String,value:Object):void{
			readConfig();
			config[key] = value;	
			writeConfig(config);
		}
		
		public function getValueInUser(key:String):String{
			if(!hasUser(Global.user)){
				addUser(Global.user);
				return "";
			}
			readConfig();
			var users:XMLList = config.user;
			for(var i:int = 0; i < users.length(); i++){
				if(users[i].@id == Global.user){
					if(users[i][key]){
						return users[i][key];
					}
				}
			}
			return "";
		}
		
		public function updateValueInUser(key:String, value:Object):void{
			if(!hasUser(Global.user)) addUser(Global.user);
			readConfig();
			var users:XMLList = config.user;
			for(var i:int = 0; i < users.length(); i++){
				if(users[i].@id == Global.user){
					var user:XML = users[i];
					user[key] = value;
					config.replace(user.childIndex(), user);
					break;
				}
			}
			writeConfig(config);
		}
		
		public function getUserConfig(user:String):String{
			if(!hasUser(user)){
				return "";
			}
			readConfig();
			var users:XMLList = config.user;
			for(var i:int = 0; i < users.length(); i++){
				if(users[i].@id == user){
					var userConfig:XML = users[i];
					return userConfig.toXMLString();
				}
			}
			return "";
		}
		
		public function updateUserConfig(userKey:String, value:String):void{
			readConfig();
			var user:XML = new XML(value);
			if(hasUser(userKey)){
				var users:XMLList = config.user;
				for(var i:int = 0; i < users.length(); i++){
					if(users[i].@id == userKey){
						config.replace(users[i].childIndex(), user);
						break;
					}
				}
			}else{
				config.appendChild(user);
			}
			writeConfig(config);
		}
		
		public function hasUser(user:String):Boolean{
			readConfig();
			var users:XMLList = config.user;
			if(users.length() <= 0) return false;
			for(var i:int = 0; i < users.length(); i++){
				if(users[i].@id == user){
					return true;
				}
			}
			return false;
		}
		
		public function addUser(user:String):void{
			readConfig();
			var userStr:String = "<user id=\"" + user + "\">" + "<name>" + user + "</name></user>";
			var userXML:XML = new XML(userStr);
			config.appendChild(userXML);
			writeConfig(config);
		}
		
		public function deleteUser(user:String):void{
			if(!hasUser(user)) return;
			readConfig();
			config.user.((@id==userName) && (delete parent().children()[valueOf().childIndex()]));
			writeConfig(config);
		}
		
		private function readConfig():void{
			if(!file.exists){
				initConfig();
				return;
			}
			
			stream.open(file, FileMode.READ);
			var str:String = stream.readMultiByte(stream.bytesAvailable,PackData.BUFF_ENCODE);
			stream.close();
			try{
				config = XML(str);
				if(config==""){
					initConfig();
				}
				
				return;
			}catch(error:Error){
				initConfig();
			}
		}
		
		private function writeConfig(config:XML):void{
			stream.open(file, FileMode.WRITE);
			stream.writeMultiByte(config.toXMLString(), PackData.BUFF_ENCODE);
			stream.close();
		}
		
		private function initConfig():void{
			config = <config></config>;
            stream.open(file, FileMode.WRITE);
			stream.writeMultiByte(config.toXMLString(), PackData.BUFF_ENCODE);
			stream.close();
		}
		
	}
}