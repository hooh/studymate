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
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getTimer;
	
	import org.as3commons.logging.api.getLogger;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class CheckSocketProxy extends Proxy implements IProxy
	{
		public static const NAME :String = "CheckSocketProxy";
		
		private static const HEAD_MARK:String = "z";
		/*private static const STANDARD_DATA:String = "eduOnlineStudymate";*/
		private static var STANDARD_DATA:Array = [];
		
		private var socket:Socket;
		private static var sendBuffer:ByteArray = new ByteArray();
		
		private var startTime:Number = 0;	//开始计时
		private var nowIdx:int = 0;
		private var numIp:int = 0;
		private var nowIpVo:IPSpeedVO;
		private var checklist:Array = [];
		
		private static var timeout:uint = 10;
		
		private var isWebCheck:Boolean = false;	//网页认证用，区分当前测试是否用于网页认证
		private var canConnect:Boolean = false;	//网页认证用，判断能否接入系统
		
		private var isRemove:Boolean = false;	//打断移除后的连接测试
		
		private var isChecking:Boolean = false;	//判断是否在测试连接
		private var needRemove:Boolean = false;	//是否可以移除

		public function CheckSocketProxy( data:Object=null)
		{
			super(NAME, data);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			sendBuffer.endian = Endian.LITTLE_ENDIAN;
			initSocket();
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			
			isRemove = true;
			
			stopTimeOutHandle();
			socket.removeEventListener(Event.CONNECT,connectHandle);
			socket.removeEventListener(Event.CLOSE,closeHandle);
//			socket.removeEventListener(IOErrorEvent.IO_ERROR,errorHandle);
			socket.removeEventListener(ProgressEvent.SOCKET_DATA, onServerData);
			close();
			socket = null;
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
			isChecking = false;
			if(needRemove){
				doRemove();
				return true;
			}
			return false;
		}
		private function doRemove():void{
			facade.removeProxy(NAME);
			
		}
		
		private function initSocket():void{
			socket = new Socket();
			socket.addEventListener(Event.CONNECT,connectHandle,false,0,false);
			socket.addEventListener(Event.CLOSE,closeHandle,false,0,false);
			socket.addEventListener(IOErrorEvent.IO_ERROR,errorHandle,false,0,true);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onServerData,false,0,true);  
			socket.endian = Endian.LITTLE_ENDIAN;
			socket.timeout = 10000;
			
		}
		
		private function readIplist():void{
			checklist = [];
			var ipReader:IPReaderProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(IPReaderProxy.NAME) as IPReaderProxy;
			var ipList:XML = ipReader.getIpList();
			if(!ipList)
				return;
			
			var ips:XMLList = ipList.ip;
			for each (var ip:XML in ips) {
				var ipvo:IPSpeedVO = new IPSpeedVO(ip["name"], ip["host"], parseInt(ip["port"]));
				if(ip["networkId"] != "1")
					checklist.push(ipvo);
			}
		}
		
		public function startCheck(isWeb:Boolean=false):void{
			isWebCheck = isWeb;
			
			readIplist();
			STANDARD_DATA = getSendData();
			
			nowIdx = 0;
			numIp = checklist.length;
			nowIpVo = null;
			doCheck();
		}
		
		private function doCheck():void{
			stopTimeOutHandle();
			close();
			isChecking = false;
			
			if(isRemove)	return;
			
			if(nowIdx < numIp)
			{
				nowIpVo = checklist[nowIdx] as IPSpeedVO;
				socket.connect(nowIpVo.host,nowIpVo.port);
				
				nowIdx++;
				isChecking = true;
			}else{	
				//测试完成，派发网页认证命令
				if(isWebCheck)
					sendNotification(WorldConst.CHECK_SOCKET_RESULT,canConnect);
				else
					sendNotification(WorldConst.IP_SPEED_COMPLETE);
				
			}
		}
		
		private function connectHandle(event:Event):void{
			getLogger(CheckSocketProxy).debug("socket connected "+nowIpVo.name);
			if(checkRemove()){
				return;
			}
			startTime = getTimer();
			flushSendBuff();
		}
		
		private function closeHandle(event:Event):void{
			getLogger(CheckSocketProxy).debug("socket close "+nowIpVo.name);
			if(checkRemove()){
				return;
			}
			
		}
		
		private function errorHandle(event:IOErrorEvent):void{
			getLogger(CheckSocketProxy).debug("network error "+nowIpVo.name);
			if(checkRemove()){
				return;
			}
			
			var ipvo:IPSpeedVO = nowIpVo;
			ipvo.stat = IPSpeedVO.SOCKET_ERROR;
			/*sendNotification(WorldConst.IP_SPEED_RESULT, ipvo);*/
			sendIpSpeedResult(ipvo);
			
			
			TweenLite.delayedCall(0.1,doCheck);
//			doCheck();
		}
		
		private function onServerData(event:ProgressEvent):void  
		{
			stopTimeOutHandle();

			var offTime:Number = getTimer() - startTime;
			var val:String = "";
			if(socket.bytesAvailable>=1){
				/*val = socket.readMultiByte(socket.bytesAvailable,PackData.BUFF_ENCODE);*/
				val = socket.readMultiByte(4,PackData.BUFF_ENCODE);
				for (var i:int = 0; i < STANDARD_DATA.length; i++) 
				{
					val += socket.readUnsignedInt();
				}
			}
			
			getLogger(CheckSocketProxy).debug("------------------测试"+nowIpVo.name+"连接，接收数据"+val+"------------------");
			var ipvo:IPSpeedVO = nowIpVo;
			ipvo.stat = analyseData(val);	//数据分析
			if(ipvo.stat == IPSpeedVO.SOCKET_NORMAL){
				canConnect = true;
				ipvo.timeout = offTime;
			}
			/*sendNotification(WorldConst.IP_SPEED_RESULT, ipvo);*/
			sendIpSpeedResult(ipvo);
			
			doCheck();
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
		
		private function flushSendBuff():void{
			sendBuffer.writeMultiByte("^EDU",PackData.BUFF_ENCODE);
			for (var i:int = 0; i < STANDARD_DATA.length; i++) 
			{
				sendBuffer.writeUnsignedInt(STANDARD_DATA[i]);
				
			}
			
			socket.writeBytes(sendBuffer);
			socket.flush();
			
			sendBuffer.clear();
			
			TweenLite.delayedCall(timeout,timeOutHandle);
		}
		
		private function timeOutHandle():void{
			close();
			
			//接收数据超时
			var ipvo:IPSpeedVO = nowIpVo;
			ipvo.stat = IPSpeedVO.DATA_TIMEOUT;
//			sendNotification(WorldConst.IP_SPEED_RESULT, ipvo);
			sendIpSpeedResult(ipvo);
			
			doCheck();
		}
		
		private function sendIpSpeedResult(ipvo:IPSpeedVO):void{
			if(!isRemove)
				sendNotification(WorldConst.IP_SPEED_RESULT, ipvo);
		}
		
		private function stopTimeOutHandle():void{
			TweenLite.killDelayedCallsTo(timeOutHandle);
		}
		
		private function close():void{
			stopTimeOutHandle();
			if(socket&&socket.connected){
				socket.close();
				sendBuffer.clear();
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
			array.push(16);
			return array;
		}
	}
}