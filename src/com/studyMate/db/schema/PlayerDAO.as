package com.studyMate.db.schema
{
	import com.mylib.framework.utils.EncryptTool;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.vo.LoginHistoryVO;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.dns.AAAARecord;
	
	public class PlayerDAO implements IPlayerDAO
	{
		private var file:File = Global.document.resolvePath(Global.localPath+"login.ini");
		
		public function PlayerDAO(){
			if(!file.exists){
				var login:XML = <login></login>;
				writeFileAsXML(login);
			}
		}
		
		public function findPlayerByUsername(username:String):Player{
			if(hasUser(username)){
				var player:Player = new Player();
				var playerXML:XML = getUser(username);
				player.logincnt = playerXML["logincnt"];
				player.name = playerXML["realname"];
				player.operId = playerXML["operId"];
				var password:String = playerXML["password"];
				player.password = EncryptTool.dencyptRC4(password);
				player.region = playerXML["region"];
				player.tokennext = playerXML["tokennext"];
				player.userName = playerXML["userName"];
				player.savePassword = playerXML["savePassword"];
				if(!(player.operId && player.password &&  player.userName)){
					return null;
				}
				trace("find:");
				trace(player.logincnt,player.operId,player.password,player.region,player.tokennext,player.userName);
				
				if(int(player.operId)){
					return player;
				}else{
					deleteUser(username);
					return null;
				}
				
			}
			return null;
		}
		
		public function findAll():Array
		{
			return null;
		}
		
		public function insert(_data:Object):void
		{
			var player:Player = _data as Player;
			if(hasUser(player.userName)){
				update(player);
				return;
			}
			addUser(player.userName);
			updateDefUser(player.userName);
			var infoArray:Array = new Array;
			infoArray.push({key:"logincnt", value:player.logincnt});
			infoArray.push({key:"realname", value:player.name});
			infoArray.push({key:"operId", value:player.operId});
			var password:String = EncryptTool.encyptRC4(player.password);
			infoArray.push({key:"password", value:password});
			infoArray.push({key:"region", value:player.region});
			infoArray.push({key:"tokennext", value:player.tokennext});
			infoArray.push({key:"userName", value:player.userName});
			infoArray.push({key:"savePassword",value:player.savePassword});
			updateUser(player.userName, infoArray);
			trace("insert:");
			trace(player.logincnt,player.operId,player.password,player.region,player.tokennext,player.userName);
		}
		
		public function update(_data:Object):void
		{
			var player:Player = _data as Player;
			if(!hasUser(player.userName)){
				addUser(player.userName);
			}
			updateDefUser(player.userName);
			var infoArray:Array = new Array;
			infoArray.push({key:"logincnt", value:player.logincnt});
			infoArray.push({key:"realname", value:player.name});
			infoArray.push({key:"operId", value:player.operId});
			var password:String = EncryptTool.encyptRC4(player.password);
			infoArray.push({key:"password", value:password});
			infoArray.push({key:"region", value:player.region});
			infoArray.push({key:"tokennext", value:player.tokennext});
			infoArray.push({key:"userName", value:player.userName});
			infoArray.push({key:"savePassword",value:player.savePassword});
			updateUser(player.userName, infoArray);
			trace("update:");
			trace(player.logincnt,player.operId,player.password,player.region,player.tokennext,player.userName);
		}
		
		public function deleteItem(_data:Object):void
		{
			var player:Player = _data as Player;
			if(!hasUser(player.userName)) return;
			deleteUser(player.userName);
			trace("delete:");
			trace(player.userName);
		}
		
		private function hasUser(name:String):Boolean{
			if(!file.exists) return false;
			
			var login:XML = readFileAsXML();
			var users:XMLList = login.user;
			if(users.length() <= 0) return false;
			
			for(var i:int = 0; i < users.length(); i++){
				if(users[i].@id == name){
					return true;
				}
			}
			return false;
		}
		
		private function getUser(name:String):XML{
			if(!hasUser(name)) return new XML("");
			var login:XML = readFileAsXML();
			var users:XMLList = login.user;
			for(var i:int = 0; i < users.length(); i++){
				if(users[i].@id == name){
					var user:XML = users[i];
					return user;
				}
			}
			return new XML("");
		}
		
		private function addUser(name:String):void{
			if(hasUser(name)) return;
			
			var login:XML = readFileAsXML();
			var child:XML = <user id={name}>
								<name>{name}</name>
							</user>;
			login.appendChild(child);
			writeFileAsXML(login);
		}
		
		
		public function deleteUser(name:String):void{
			if(!file.exists) return;
			if(!hasUser(name)) return;
			
			var login:XML = readFileAsXML();
			login.user.((@id==name) && (delete parent().children()[valueOf().childIndex()]));
			writeFileAsXML(login);
		}
		
		private function updateUser(name:String, inf:Array):void{
			if(!file.exists) return;
			if(!hasUser(name)) addUser(name);
			
			var login:XML = readFileAsXML();
			var users:XMLList = login.user;
			var user:XML;
			for(var i:int = 0; i < users.length(); i++){
				if(users[i].@id == name){
					user = users[i];
					break;
				}
			}
			for(var j:int = 0; j < inf.length; j++){
				user[inf[j].key] = inf[j].value;
			}
			login.replace(user.childIndex(), user);
			writeFileAsXML(login);
		}
		
		private function updateDefUser(name:String):void{
			var login:XML = readFileAsXML();
			login.defaultUser = name;
			writeFileAsXML(login);
		}
		
		private function readFileAsXML():XML{
			var login:XML = <login></login>;
			if(!file.exists){
				writeFileAsXML(login);
				return login;
			}
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			var str:String = stream.readMultiByte(stream.bytesAvailable,PackData.BUFF_ENCODE);
			stream.close();
			if(str == ""){
				writeFileAsXML(login);
				return login;
			}
			login = XML(str);
			return login;
		}
		
		public function getFileUserName():Array
		{
			var login:XML;
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			var str:String = stream.readMultiByte(stream.bytesAvailable,PackData.BUFF_ENCODE);
			stream.close();
			login = XML(str);
			var _len:int = login.children().length()-1;
			var _vec:Array = new Array();
			for(var i:int = 0;i<_len;i++){
				_vec.push(String(login.user[i].@id));
			}	
			return _vec;
		}
		
		private function writeFileAsXML(login:XML):void{
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeMultiByte(login, PackData.BUFF_ENCODE);
			stream.close();
		}
		
		public function getDefUser():String{
			var login:XML = readFileAsXML();
			return login.defaultUser;
		}
		
		public function getUserInfByKey(name:String, key:String):String{
			if(!hasUser(name)) return "";
			var login:XML = readFileAsXML();
			var users:XMLList = login.user;
			for(var i:int = 0; i < users.length(); i++){
				if(users[i].@id == name){
					return users[i][key];
				}
			}
			return "";
		}
	}
}