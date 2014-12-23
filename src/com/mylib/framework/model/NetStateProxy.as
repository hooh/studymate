package com.mylib.framework.model
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.studyMate.controller.IPReaderProxy;
	import com.studyMate.controller.LicenseProxy;
	import com.studyMate.db.schema.Player;
	import com.studyMate.db.schema.PlayerDAO;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.IPSpeedVO;
	import com.studyMate.model.vo.LicenseVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getTimer;
	
	import org.as3commons.logging.api.getLogger;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class NetStateProxy extends Proxy implements IProxy
	{
		public static const NAME :String = "NetStateProxy";
		
		private static const HEAD_MARK:String = "z";
		/*private static const STANDARD_DATA:String = "eduOnlineStudymate";*/
		private static var STANDARD_DATA:Array = [];
		
		
		
		private var checklist:Array = [];
		
		private static var timeout:uint = 10;
		
		private var isWebCheck:Boolean = false;	//网页认证用，区分当前测试是否用于网页认证
		private var canConnect:Boolean = false;	//网页认证用，判断能否接入系统
		
		private var isRemove:Boolean = false;	//打断移除后的连接测试
		
		public var isChecking:Boolean = false;	//判断是否在测试连接
		private var needRemove:Boolean = false;	//是否可以移除

		private var sockets:Array = [];
		
		private var tmpPackage:String = "@TEP";
		
		public function NetStateProxy( data:Object=null)
		{
			super(NAME, data);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
//			sendBuffer.endian = Endian.LITTLE_ENDIAN;
			
			for (var i:int = 0; i < 4092; i++) 
			{
				tmpPackage+= "a";
			}
			
			
			readIplist();
			initSocket();
		}
		
		private function initSocket():void{
			
			var socket:Socket;
			for (var i:int = 0; i < checklist.length; i++) 
			{
				socket = new Socket();
				socket.addEventListener(Event.CONNECT,connectHandle,false,0,false);
				socket.addEventListener(Event.CLOSE,closeHandle,false,0,false);
				socket.addEventListener(IOErrorEvent.IO_ERROR,errorHandle,false,0,true);
				socket.addEventListener(ProgressEvent.SOCKET_DATA, onServerData,false,0,true);  
				socket.endian = Endian.LITTLE_ENDIAN;
				socket.timeout = 10000;
				
				sockets.push(socket);
			}
			
		}
		
		private function readIplist():void{
			checklist = [];
			var ipReader:IPReaderProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(IPReaderProxy.NAME) as IPReaderProxy;
			var ipList:XML = ipReader.getIpList();
			if(!ipList)
				return;
			
			var ips:XMLList = ipList.ip;
			for each (var ip:XML in ips) {
				var ipvo:IPSpeedVO = new IPSpeedVO(ip["name"], ip["host"], parseInt(ip["port"]), 0, ip["networkId"]);
				if(ip["networkId"] != "1")
					checklist.push(ipvo);
				/*if(ip["networkId"] == "1")
					checklist.push(ipvo);*/
			}
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			
			isRemove = true;
			
			for (var i:int = 0; i < sockets.length; i++) 
			{
				stopTimeOutHandle(sockets[i]);
				sockets[i].removeEventListener(Event.CONNECT,connectHandle);
				sockets[i].removeEventListener(Event.CLOSE,closeHandle);
//				sockets[i].removeEventListener(IOErrorEvent.IO_ERROR,errorHandle);
				sockets[i].removeEventListener(ProgressEvent.SOCKET_DATA, onServerData);
				close(sockets[i]);
				sockets[i] = null;
			}
			
			
			
		}
		public function applyDispose():void{
			isRemove = true;
			
			//如果在连接，先不移除本类
			if(isChecking){
				needRemove = true;
				
			}else{
				doRemove();
				
			}
		}
		private function checkRemove():Boolean{
//			isChecking = false;
			if(needRemove){
				doRemove();
				return true;
			}
			return false;
		}
		private function doRemove():void{
			facade.removeProxy(NAME);
			
		}
		
		
		
		public function startCheck(isWeb:Boolean=false):void{
			isWebCheck = isWeb;
			
			STANDARD_DATA = getSendData();
			
			doCheck();
		}
		
		private function doCheck():void{
			
			if(isChecking){
				return;
			}
			
			isChecking = true;
			canConnect = false;
			
			if(isRemove)	return;
			
			numChecked = 0;
			
			for (var i:int = 0; i < checklist.length; i++) 
//			for (var i:int = 0; i < 1; i++) 
			{
				var tmpvo:IPSpeedVO = checklist[i];
				
				sendNotification(WorldConst.IP_SPEED_CHECKING, tmpvo);
				sockets[i].connect(tmpvo.host,tmpvo.port);
				checklist[i].hadConnected = false;
				checklist[i].readNum = 0;
//				checklist[i].checkTime = getTimer();
			}
			
			
		}
		
		
		private function getIpvo(_socket:Socket):IPSpeedVO{
			for (var i:int = 0; i < sockets.length; i++) 
			{
				if(sockets[i] == _socket)
				{
					return checklist[i];
				}
			}
			return null;
		}
		
		private function connectHandle(event:Event):void{
			if(checkRemove()){
				return;
			}
			
			var _socket:Socket = event.target as Socket;
			
//			var offTime:Number = getTimer() - getIpvo(_socket).checkTime;
//			getIpvo(_socket).timeout = offTime;
			
			
			getLogger(CheckSocketProxy).debug("socket connected "+getIpvo(_socket).name);
			getIpvo(_socket).checkTime = getTimer();
			
			if(getIpvo(_socket).hadConnected){
				getIpvo(_socket).packTime = getTimer();
				trace("开始=="+getIpvo(_socket).packTime);
				packageCheck(_socket);
				
			}else{
				flushSendBuff(_socket);
				
			}
			
		}
		
		private function closeHandle(event:Event):void{
			if(checkRemove()){
				return;
			}
			getLogger(CheckSocketProxy).debug("socket close "+getIpvo(event.target as Socket).name);
			
		}
		
		private function errorHandle(event:IOErrorEvent):void{
			if(checkRemove()){
				return;
			}
			
			var _ipvo:IPSpeedVO = getIpvo(event.target as Socket);
			getLogger(CheckSocketProxy).debug("network error "+_ipvo.name);
			
			var ipvo:IPSpeedVO = _ipvo;
			ipvo.stat = IPSpeedVO.SOCKET_ERROR;
			/*sendNotification(WorldConst.IP_SPEED_RESULT, ipvo);*/
			sendIpSpeedResult(ipvo);
			
			
		}
		
		
		private function onServerData(event:ProgressEvent):void  
		{
			var _socket:Socket = event.target as Socket;
			stopTimeOutHandle(_socket);

			var offTime:Number = getTimer() - getIpvo(_socket).checkTime;
			var packTime:Number = 0;
			var val:String = "";
			
			if(_socket.bytesAvailable>=1){
				trace("总共："+_socket.bytesAvailable);
				/*val = _socket.readMultiByte(_socket.bytesAvailable,PackData.BUFF_ENCODE);*/
				
				
				if(getIpvo(_socket).hadConnected){
					trace("这里："+_socket.bytesAvailable);
					/*val += _socket.readMultiByte(_socket.bytesAvailable,PackData.BUFF_ENCODE);*/
					
					if(getIpvo(_socket).readNum == 0){
						val = _socket.readMultiByte(4,PackData.BUFF_ENCODE);
						for (var i:int = 0; i < STANDARD_DATA.length; i++) 
						{
							val += _socket.readUnsignedInt();
						}
						getIpvo(_socket).readNum = 16;
						
					}
					
					if(_socket.bytesAvailable != 0 ){
						getIpvo(_socket).readNum += _socket.bytesAvailable;
						val += _socket.readMultiByte(_socket.bytesAvailable,PackData.BUFF_ENCODE);
					}
					if(getIpvo(_socket).readNum != 4112){
						TweenLite.to(_socket,0,{delay:timeout, onComplete:timeOutHandle, onCompleteParams:[_socket]});
						return;
						
					}
					packTime = getTimer() - getIpvo(_socket).packTime
					
					
				}else{
//					getIpvo(_socket).hadConnected = true;
					
					
					val = _socket.readMultiByte(4,PackData.BUFF_ENCODE);
					for (i = 0; i < STANDARD_DATA.length; i++) 
					{
						val += _socket.readUnsignedInt();
					}
				}
				
				
			}
			
			var ipvo:IPSpeedVO = getIpvo(_socket);
			getLogger(CheckSocketProxy).debug("------------------接收到连接   "+ipvo.name+"||接收数据"+val+"------------------");
			
			if(!getIpvo(_socket).hadConnected){
				ipvo.stat = analyseData(val);	//数据分析
				trace("状态："+ipvo.stat);
				if(ipvo.stat == IPSpeedVO.SOCKET_NORMAL){
					canConnect = true;
					ipvo.timeout = offTime;
					
					//接受正常，测试连接速度
//					getIpvo(_socket).packTime = getTimer();
//					packageCheck(_socket);
					
					reConnect(_socket);
				}else{
					sendIpSpeedResult(ipvo);
					
				}
			}else{
				//package,分析时间
				var ptime:Number = packTime - ipvo.timeout;
				ipvo.speed = 4000/packTime;
				trace("包时间："+packTime+"ms");
				trace("链路时间："+ipvo.timeout+"ms");
				trace("计算后包时间："+ptime+"ms");
				trace("速度："+ipvo.speed.toFixed(2)+"Kb/s");
				
				sendIpSpeedResult(ipvo);
			}
			
			getIpvo(_socket).hadConnected = !getIpvo(_socket).hadConnected;
			
			
			
			/*sendNotification(WorldConst.IP_SPEED_RESULT, ipvo);*/
//			
			
		}
		
		private function analyseData(val:String):int{
			if(!val || val == "")
				return IPSpeedVO.DATA_HEAD_ERROR;
			
			var headMark:String = val.substr(0,1);
			var restData:String = val.substring(1);
			if(headMark == "z")
			{
				var standStr:String = "EDU"+STANDARD_DATA.join("");
				if(standStr.indexOf(restData) >= 0){
					return IPSpeedVO.SOCKET_NORMAL;//数据正确
					
				}else{
					return IPSpeedVO.DATA_ERROR;//数据头正确，尾随数据错误，可能有协议冲突
				}
				
			}else{
				return IPSpeedVO.DATA_HEAD_ERROR;//数据接收错误
				
			}
		}
		
		private function flushSendBuff(_socket:Socket):void{
			var sendBuffer:ByteArray = new ByteArray();
			sendBuffer.endian = Endian.LITTLE_ENDIAN;
			
			sendBuffer.writeMultiByte("^EDU",PackData.BUFF_ENCODE);
			for (var i:int = 0; i < STANDARD_DATA.length; i++) 
			{
				sendBuffer.writeUnsignedInt(STANDARD_DATA[i]);
				
			}
			
			_socket.writeBytes(sendBuffer);
			_socket.flush();
			
			sendBuffer.clear();
			
			TweenLite.to(_socket,0,{delay:timeout, onComplete:timeOutHandle, onCompleteParams:[_socket]});
			
//			TweenLite.delayedCall(timeout,timeOutHandle,[_socket]);
		}
		
		private function timeOutHandle(_socket:Socket):void{
			close(_socket);
			
			//接收数据超时
			var ipvo:IPSpeedVO = getIpvo(_socket);
			ipvo.stat = IPSpeedVO.DATA_TIMEOUT;
			
			sendIpSpeedResult(ipvo);
			
		}
		
		
		//断开、重连
		private function reConnect(_socket:Socket):void{
			trace("二次连接"+getIpvo(_socket).name);
			_socket.close();
			_socket.connect(getIpvo(_socket).host,getIpvo(_socket).port);
			
		}
		
		
		//4K数据包测试
		private function packageCheck(_socket:Socket):void{
			
			var sendBuffer:ByteArray = new ByteArray();
			sendBuffer.endian = Endian.LITTLE_ENDIAN;
			
			
			sendBuffer.writeMultiByte("^EDU",PackData.BUFF_ENCODE);
			for (var i:int = 0; i < STANDARD_DATA.length; i++) 
			{
				if(i == STANDARD_DATA.length-1){
					sendBuffer.writeUnsignedInt(4096);
				}else{
					sendBuffer.writeUnsignedInt(STANDARD_DATA[i]);
				}
				
				
			}
			sendBuffer.writeMultiByte(tmpPackage,PackData.BUFF_ENCODE);
			
			_socket.writeBytes(sendBuffer);
			_socket.flush();
			
			sendBuffer.clear();
			
			TweenLite.to(_socket,0,{delay:timeout, onComplete:timeOutHandle, onCompleteParams:[_socket]});

			
		}
		
		
		
		
		
		
		
		private var numChecked:int = 0;
		private function sendIpSpeedResult(ipvo:IPSpeedVO):void{
			if(!isRemove)
			{
				sendNotification(WorldConst.IP_SPEED_RESULT, ipvo);
				
				//检查是否测试完成
				numChecked++;
				if(numChecked >= checklist.length)
				{
					isChecking = false;
					
					if(isWebCheck){
						sendNotification(WorldConst.CHECK_SOCKET_RESULT,canConnect);
					}else{
						sendNotification(WorldConst.IP_SPEED_COMPLETE,canConnect);
					}
					
				}
			}
				
		}
		
		private function stopTimeOutHandle(_socket:Socket):void{
			TweenLite.killTweensOf(_socket);
		}
		
		private function close(_socket:Socket):void{
			stopTimeOutHandle(_socket);
			if(_socket&&_socket.connected){
				_socket.close();
//				sendBuffer.clear();
			}
		}
		
		//取operId、macId
		private function getSendData():Array{
			var array:Array = [];
			
			//operId
			var playDao:PlayerDAO = new PlayerDAO;
			var player:Player = playDao.findPlayerByUsername(playDao.getDefUser());
			if(player){
				array.push(int(player.operId));
				
			}else{
				array.push(0);
			}
			
			//macId
			var licenseProxy:LicenseProxy = facade.retrieveProxy(LicenseProxy.NAME) as LicenseProxy;
			if(licenseProxy){
				var licenseVo:LicenseVO = licenseProxy.getLicense();
				array.push(int(licenseVo.macid));
				
			}else{
				array.push(0);
			}
			
			//dataLength
			array.push(0);
			return array;
		}
	}
}