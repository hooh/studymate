package com.mylib.framework.model
{
	import com.mylib.framework.model.vo.VideoLogVO;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	
	/**
	 * 视频配置。防止视频意外退出后。可以继续观看视频
	 * 2014-5-29下午1:52:47
	 * Author wt
	 *
	 */	
	
	public class VideoConfigProxy extends Proxy implements IProxy
	{
		public static const NAME:String = 'VideoConfigProxy';
		private var config:XML;
		private var file:File = Global.document.resolvePath(Global.localPath + "userTestLearn/videoLog.ini");
		private var stream:FileStream;
		
		public function VideoConfigProxy(proxyName:String=null, data:Object=null)
		{
			super("VideoConfigProxy", data);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			stream = new FileStream();
		}
		
		/**
		 * 更新视频标记 
		 * @param flag			是否已提交
		 * @param vidoLogVO		视频信息
		 */		
		public function updateValueInUser(flag:Boolean,vidoLogVO:VideoLogVO=null):void{
			if(!hasUser(Global.user)) addUser(Global.user);
			readConfig();
			var users:XMLList = config.user;
			for(var i:int = 0; i < users.length(); i++){
				if(users[i].@id == Global.user){
					var user:XML = users[i];
					if(flag){
						user['submit'] = 'true';
					}else{
						user['submit'] = 'false';
						if(vidoLogVO){							
							user['userid'] = vidoLogVO.userid;
							user['videoids'] = vidoLogVO.videoids;
							user['times'] = vidoLogVO.times;
							user['wtimes'] = vidoLogVO.wtimes;
							user['rtimes'] = vidoLogVO.rtimes;
							user['videoName'] = vidoLogVO.videoName;
							user['starttime'] = vidoLogVO.starttime;
							user['endtime'] = vidoLogVO.endtime;
						}
					}
					config.replace(user.childIndex(), user);
					break;
				}
			}
			writeConfig(config);
		}
		
		
		public function getValueInUser():VideoLogVO{
			if(!hasUser(Global.user)){
				addUser(Global.user);
				return null;
			}
			readConfig();
			var users:XMLList = config.user;
			for(var i:int = 0; i < users.length(); i++){
				if(users[i].@id == Global.user){
					var user:XML = users[i];
					if(users['submit']=='false'){
						var videoLogVO:VideoLogVO = new VideoLogVO();
						videoLogVO.userid = user['userid'];
						videoLogVO.videoids = user['videoids'];
						videoLogVO.times = user['times'];
						videoLogVO.wtimes = user['wtimes'];
						videoLogVO.rtimes = user['rtimes'];
						videoLogVO.videoName = user['videoName'];
						videoLogVO.starttime = user['starttime'];
						videoLogVO.endtime = user['endtime'];
						return videoLogVO;
					}else{
						return null;
					}
				}
			}
			return null;
		}
		
		private function hasUser(user:String):Boolean{
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
		
		private function addUser(user:String):void{
			readConfig();
			var userStr:String = "<user id=\"" + user + "\">" + "<name>" + user + "</name></user>";
			var userXML:XML = new XML(userStr);
			config.appendChild(userXML);
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