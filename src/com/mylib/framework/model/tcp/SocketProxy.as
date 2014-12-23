package com.mylib.framework.model.tcp
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.utils.NetBottomHandler;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.LoginVO;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.model.vo.tcp.PackHead;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getTimer;
	
	import org.as3commons.logging.api.getLogger;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public final class SocketProxy extends Proxy implements IProxy
	{
		public static var NAME:String = "SocketProxy";
		public static var IM_NAME:String = "IMSocketProxy";
		
		private var _receiveEncode:String;
		
		
		public var socket:Socket;
		//主机地址
		public var host:String = "172.20.11.2";
		//socket端口
		public var port:int = 4180;
		private var netBottom:NetBottomHandler;
		private static var sendBuffer:ByteArray = new ByteArray();
		private static var recBuffer:ByteArray = new ByteArray();
		
		private var tmpByte:ByteArray = new ByteArray();
		
		public var connectFuntion:Function;
		public var connectFuntionParameters:Array;
		
		private var _packData:PackData;
		
		//用于判断超时
		private var timer:TweenLite;
		
		//超时时间
		private static var timeout:uint = 15000;
		private static var timeout1N:uint = 10000;
		
		/**
		 *socket最大重链接次数 
		 */		
		private static const reconnectMaxTimes:uint = 10;
		
		private var currentReconnectTimes:uint=0;
		
		/**
		 * 输入命令字
		 */		
		public var CmdIStr:Array = new Array(255);
		/**
		 * 输出命令字
		 */		
		public var CmdOStr:Array = new Array(255);
		
		private var _isSending:Boolean;
		
		
		/**
		 *接收命令后的消息通知 
		 */		
		private var receiveNotification:String;
		
		private var lastReceiveNotification:String;
		
		/**
		 *接收命令后的消息通知参数 
		 */		
		private var _receiveNotificationPara:Array;
		
		private var lastReceiveNotificationPara:Array;
		
		//是否异常
		public var isError:Boolean;
		
		private var testData:Array;
		
		/**
		 *是否中断向上层发送数据，当应用模块退出时为true 
		 */		
		private var isBreak:Boolean;
		
		private var cancel:Boolean;
		
		/**
		 *是否需要发送缓冲数据 
		 */		
		private var doFlushMark:Boolean;
		
		private var cache:ByteArray = new ByteArray();
		
		/**
		 *用于记录上次发送的请求 
		 */		
		private var lastRequest:Array = new Array(255);
		public var lastRequestCnt:uint;
		private var lastRequestType:String;
		private var lastRequestEncode:String;
		private var lastByteIdx:Vector.<int>;
		
		public var byteIdx:Vector.<int>;
		
		public var isConnecting:Boolean;
		public var isStoping:Boolean;
		
		
		public  var CmdInCnt:uint;
		public  var CmdOutCnt:uint;
		
		
		public function SocketProxy(name:String,data:PackData=null)
		{
			super(name, data);
			packData = data;
		}
		
		override public function onRegister():void
		{
			receiveEncode = PackData.BUFF_ENCODE;
			netBottom = new NetBottomHandler();
			netBottom.receiverNetData(packReceiveHandle);
			packData.initialize();
			
			recBuffer.endian = Endian.LITTLE_ENDIAN;
			sendBuffer.endian = Endian.LITTLE_ENDIAN;
			
			packData.outBuf = recBuffer;
			packData.inBuf =  sendBuffer;
			
			initSocket();
			TweenLite.delayedCall(0,loop,[null]);
			TweenLite.ticker.addEventListener("tick",loop,false,0,true);
			
		}
		
		private function loop(event:Event):void{
			
			if(netBottom.time>0&&getTimer()>netBottom.time){
				timeOutHandle();
				netBottom.time = 0;
			}
			
		}
		
		override public function onRemove():void
		{
			socket = null;
			TweenLite.ticker.removeEventListener("tick",loop,false);
		}
		
		
		private function initSocket():void{
			
			socket = new Socket();
			socket.addEventListener(Event.CONNECT,connectHandle,false,0,false);
			socket.addEventListener(Event.CLOSE,closeHandle,false,0,false);
			socket.addEventListener(IOErrorEvent.IO_ERROR,errorHandle,false,0,false);
			netBottom.setSocket(socket);
			
			socket.endian = Endian.LITTLE_ENDIAN;
			socket.timeout = 10000;
		}
		
		
		private function closeHandle(event:Event):void{
			sendNotification(CoreConst.FLOW_RECORD,new RecordVO("socket close "+socket.connected,CmdIStr[0],cache.length));
			getLogger(SocketProxy).debug("socket close");
			isError = true;
			isSending = false;
			isConnecting = false;
			sendNotification(CoreConst.SOCKET_CLOSED);
			cache.clear();
			packData.inBuf.clear();
			stopTimeOutHandle();
			socket.close();
			if(PackData.app.head.dwReqCnt){
				
				tryRelogin();
			}
		}
		
		private function errorHandle(event:IOErrorEvent):void{
			sendNotification(CoreConst.FLOW_RECORD,new RecordVO("network error"+event.toString(),CmdIStr[0],cache.length));
			getLogger(SocketProxy).error("network error");
			stopTimeOutHandle();
			
			sendNotification(CoreConst.TOAST,new ToastVO("网络故障"));
			
			isError = true;
			isSending = false;
			isConnecting = false;
			sendNotification(CoreConst.NETWORK_ERROR);
			
			packData.inBuf.clear();
			
			if(PackData.app.head.dwReqCnt){
				
				tryRelogin();
			}
		}
		
		
		private function tryRelogin(delay:Boolean = true):void{
			
			stopTimeOutHandle();
			
			TweenLite.killTweensOf(reLogin);
			getLogger(SocketProxy).debug("tryRelogin"+CmdIStr[0]+currentReconnectTimes);
			sendNotification(CoreConst.FLOW_RECORD,new RecordVO("tryRelogin",CmdIStr[0],currentReconnectTimes));
			if(currentReconnectTimes<reconnectMaxTimes){
				currentReconnectTimes++;
				if(delay){
					TweenLite.delayedCall(currentReconnectTimes*3,reLogin);
				}else{
					reLogin();
				}
			}else{
				sendNotification(CoreConst.TOAST,new ToastVO("网络连接有问题"));
				currentReconnectTimes=0;
				isError = false;
				isSending = false;
				sendNotification(CoreConst.NETWORK_DISABLE);
			}
			
			
		}
		
		
		
		private function connectHandle(event:Event):void{
			getLogger(SocketProxy).debug("socket connected");
			getLogger(SocketProxy).debug("local port:"+socket.localPort);
			sendNotification(CoreConst.FLOW_RECORD,new RecordVO("socket connected",CmdIStr[0],0));
			isError = false;
			isSending = false;
			isConnecting = false;
			currentReconnectTimes = 0;
			stopTimeOutHandle();
			
			sendNotification(CoreConst.SOCKET_CONNECTED);
			
			if(connectFuntion!=null){
				
				connectFuntion.apply(null,connectFuntionParameters);
				
				connectFuntion = null;
			}
			
		}
		
		
		
		/**
		 *接收数据 
		 * @param len
		 * @param bytes
		 * 
		 */		
		public function packReceiveHandle(len:int,bytes:ByteArray):void{
			stopTimeOutHandle();
			cache.clear();
			sendNotification(CoreConst.FLOW_RECORD,new RecordVO(CmdIStr[0],"d",len));
			getLogger(SocketProxy).debug("------------------数据接收"+len+"-----------------------------");
			var resultVO:DataResultVO = new DataResultVO();
			
			resultVO.para = receiveNotificationPara;
			
			if(len==1){
				bytes.position = 0;
				resultVO.type = bytes.readMultiByte(1,PackData.BUFF_ENCODE);
				resultVO.isEnd = true;
				if(resultVO.type=="0"){
					resultVO.isErr = true;
					resultVO.isEnd = true;
					isSending = false;
					CmdInCnt=0;
					sendNotification(CoreConst.RECEIVE_ERROR);
				}
				CmdOStr[0] = null;
				CmdOutCnt = 0;
				sendNotification(receiveNotification,resultVO);
				return;
			}
			unwrapPack(bytes);
			if(checkResult()){
				//收到数据是1:N
				if(packData.head.cCmdType=="N"){
					//1:N数据结束
					if(int(packData.head.byPkgCnt)==1&&int(packData.head.byPkgIdx)==1){
						
						//PackData.head.byPkgCnt==1&&PackData.head.byPkgIdx==1
						
						isSending = false;
						resultVO.isEnd = true;
						CmdInCnt=0;
						isStoping = false;
						getLogger(SocketProxy).debug("------------------1N接收结束-----------------------------");
					}else{
						netBottom.time = getTimer()+timeout1N;
					}
					
					//发送请求获取后面的数据
					
					if(!resultVO.isEnd&&int(packData.head.byPkgIdx) == int(packData.head.byPkgCnt)-1){
						//取消下载
						if(cancel){
							cancel=false;
						}else if(isStoping){
							
						}else{
							stopTimeOutHandle();
							resultVO.isBreak = true;
						}
						
						
					}
					
				}else{
					//1:1
					isSending = false;
					isStoping = false;
					resultVO.isEnd = true;
					CmdInCnt=0;
				}
			}else{
				//提示接收数据有错
				resultVO.isErr = true;
				resultVO.isEnd = true;
				isSending = false;
				CmdInCnt=0;
				sendNotification(CoreConst.RECEIVE_ERROR,[CmdOStr[1],CmdOStr[0]]);
			}
			//结束包不向上层传送
			if(!isBreak){
				//向上层传递数据
				resultVO.result = CmdOStr;
				resultVO.resultCnt = CmdOutCnt;
				sendNotification(receiveNotification,resultVO);
			}
			CmdOutCnt = 0;
			
			
			
			sendNotification(CoreConst.FLOW_RECORD,new RecordVO(CmdIStr[0],"packReceiveHandle end",len));

		}
		
		public function keepSend():void{
			
			
			if(isConnecting||!Global.hasLogin||isError){
				
				
				
				
				
			}else{
				packData.head.cDatType = "8";
				packData.head.byPkgCnt = "0";
				packData.head.byPkgIdx = "0";
				getLogger(SocketProxy).debug("------------------8请求继续推送-----------------------------");
				packData.toInBuf(CmdIStr,CmdInCnt);
				doFlushSendBuff();
			}
			
		}
		
		
		/**
		 *停止接收数据包 
		 * 
		 */		
		public function stopPackRec():void{
			
			
			if(!socket.connected||!Global.hasLogin){
				return;
			}
			isStoping = true;
			getLogger(SocketProxy).debug("stopPackRec");
			sendNotification(CoreConst.FLOW_RECORD,new RecordVO("stopPackRec","",0));
			socket.writeMultiByte("4",PackData.BUFF_ENCODE);
			socket.flush();
			sendBuffer.clear();
		}
		
		
		/**
		 *检查返回结果是否正确
		 * @return 
		 * 
		 */		
		private function checkResult():Boolean{
			
			if(CmdOStr[0].charAt(0)=="0"){
				return true;
			}
			
			if(CmdOStr[0].charAt(0)=="M" ||　CmdOStr[0]=="E"){
				return false;
			}
			
			
			return true;
		}
		
		
		
		public function connect():void{
			getLogger(SocketProxy).info("connect");
			sendNotification(CoreConst.FLOW_RECORD,new RecordVO("connect",CmdIStr[0],0));
			cacheRequest(receiveNotification,receiveNotificationPara,CmdIStr,CmdInCnt,receiveEncode,byteIdx);
			stopTimeOutHandle();
			close();
			isSending = true;
			isConnecting = true;
			Global.hasLogin = false;
			socket.connect(host,port);
			
		}
		
		public function close(_reLogin:Boolean=true):void{
			stopTimeOutHandle();
			if(socket&&socket.connected){
				sendNotification(CoreConst.SOCKET_CLOSED);
				sendNotification(CoreConst.FLOW_RECORD,new RecordVO("close network","test",0));
				socket.close();
				cache.clear();
			}
		}
		
		private function stopTimeOutHandle():void{
			trace("stopTimeOutHandle");
			netBottom.time = 0;
		}
		
		
		private function flushSendBuff():void{
			isBreak = false;
			
			if(!sendEnable){
				sendBuffer.clear();
				getLogger(SocketProxy).info("network error,abort");
				sendNotification(CoreConst.FLOW_RECORD,new RecordVO("network error,abort",PackData.app.CmdIStr[0],0));
				cacheRequest(receiveNotification,receiveNotificationPara,CmdIStr,CmdInCnt,receiveEncode,byteIdx);
				isSending = false;
				sendNotification(CoreConst.SOCKET_CLOSED);
				
//				if(!CONFIG::ARM){
					sendNotification(CoreConst.TOAST,new ToastVO("网络连接有问题,请检查网络"));
//				}
				
				tryRelogin(false);
				return;
			}
			
				
			doFlushSendBuff();
		}
		
		private function doFlushSendBuff():void{
			sendNotification(CoreConst.FLOW_RECORD,new RecordVO("doFlushSendBuff start","SocketProxy",0));

			netBottom.reset();
			cache.writeBytes(sendBuffer);
			socket.writeBytes(sendBuffer);
			socket.flush();
			sendNotification(CoreConst.FLOW_RECORD,new RecordVO(CmdIStr[0],"u",sendBuffer.length));
			
			sendBuffer.clear();
			isSending = true;
			netBottom.time = getTimer()+timeout;
			
			

		}
		
		
		public function resendLastRequest():void{
			
			sendNotification(CoreConst.FLOW_RECORD,new RecordVO("resendLastRequest",lastRequest[0],lastRequestCnt));
			
			
			if(lastRequestCnt>0){
				trace("resend request",lastRequest[0]);
				sendBuffer.clear();
				sendNotification(CoreConst.FLOW_RECORD,new RecordVO("lastReceiveNotification",lastReceiveNotification+" "+lastRequest[0],0));
				receiveNotification = lastReceiveNotification;
				receiveNotificationPara = lastReceiveNotificationPara;
				receiveEncode = lastRequestEncode;
				byteIdx = lastByteIdx;
				
				var lsp:Array = [];
				for (var i:int = 0; i < lastRequestCnt; i++) 
				{
					lsp[i] = CmdIStr[i] = lastRequest[i];
					
				}
				
				sendNotification(CoreConst.BG_RESEND,lsp);
				
				CmdInCnt = lastRequestCnt;
				
				if(lastRequestType=="1"){
					sendHostCmd11();
				}else{
					sendHostCmd1N();
				}
				
				lastRequest.splice(0,lastRequest.length);
				lastRequestCnt=0;
				
			}
		}
		
		
		public function sendHostCmd11():void{
			
			
				packData.isLogin = false;
				packData.head.cDatType = "C";
				packData.set11();
				packData.head.dwReqCnt++;
				packData.toInBuf(CmdIStr,CmdInCnt);
				//PackData.tmpOutput = PackData.printByte(PackData.inBuf);
				getLogger(SocketProxy).debug("------------------发送请求-----------------------------");
				packData.XORByRandomKey(packData.key,packData.inBuf,PackHead.LEN);
				
				flushSendBuff();
				
		}
		
		public function sendHostCmd1N():void{
			
				packData.set1N();
				packData.head.cDatType = "C";
				
				packData.isLogin = false;
				packData.head.dwReqCnt++;
				packData.toInBuf(CmdIStr,CmdInCnt);
				
				getLogger(SocketProxy).debug("------------------发送请求-----------------------------");
				packData.XORByRandomKey(packData.key,packData.inBuf,PackHead.LEN);
				
				flushSendBuff();
			
		}
		
		public function get sendEnable():Boolean{
			
			//return true;
			return !isError&&!isSending&&socket&&socket.connected;
		}
		
		
		public function sendLoginCmd():void{
			
			
			
			receiveEncode = PackData.BUFF_ENCODE;
			packData.isLogin = true;
			packData.toInBuf(CmdIStr,CmdInCnt);
			//PackData.printByte(PackData.app.inBuf);
			packData.XORByRandomKey(packData.key,packData.inBuf,PackHead.LEN);
			getLogger(SocketProxy).debug(this.proxyName+" send oper id:"+packData.head.dwOperID);
			flushSendBuff();
			
			
			
		}
		
		public function reLogin():void{
			stopTimeOutHandle();
			if(isConnecting){
				return;
			}
			
			connect();
			connectFuntion = sendLoginCommand;
			if(connectFuntionParameters&&connectFuntionParameters[1]=="B0"){
				
			}else{
				connectFuntionParameters = [true,"AB","n"];
			}
			
		}
		
		
		public function cacheRequest(__receiveNotification:String,__receiveNotificationPara:Array,paras:Array,len:int,__receiveEncode:String,__byteIdx:Vector.<int>):void{
				sendNotification(CoreConst.FLOW_RECORD,new RecordVO("try cache",__receiveNotification+" "+paras[0],0));
			if(len>0&&paras[0]!=CmdStr.ABLOGIN_ChkPasswd&&__receiveNotification!=CoreConst.VERIFY_LOGIN_RESULT){
				//重登录前把上次没成功的请求保存起来
				getLogger(SocketProxy).debug("cache request:"+__receiveNotification+" "+paras[0]);
				sendNotification(CoreConst.FLOW_RECORD,new RecordVO("cache request",__receiveNotification+" "+paras[0],0));
				lastRequestCnt = len;
				for (var i:int = 0; i < len; i++) 
				{
					lastRequest[i] = paras[i];
				}
				lastRequestType = "N";
				
				lastReceiveNotification = __receiveNotification;
				lastReceiveNotificationPara =__receiveNotificationPara;
				lastRequestEncode = __receiveEncode;
				lastByteIdx = __byteIdx;
			}
		}
		
		
		public function set B0LoginComplete(b:Boolean):void{
			connectFuntionParameters = null;
		}
		
		public function sendLoginCommand(sendCache:Boolean = false,type:String="AB",updateType:String="n"):void{
			sendNotification(CoreConst.LOGIN,new LoginVO(Global.user,Global.password,CoreConst.RELOGIN_COMPLETE,type,updateType,sendCache));
		}
		
		
		/**
		 *超时控制 
		 * 
		 */		
		private function timeOutHandle():void{
			sendNotification(CoreConst.FLOW_RECORD,new RecordVO("timeOut","test",0));
			isSending = false;
			isError = true;
			isConnecting = false;
			close();
			tryRelogin();
			sendNotification(CoreConst.SOCKET_TIME_OUT);
		}
		
		
		/**
		 * 解开数据包
		 * 
		 */		
		private function unwrapPack(pack:ByteArray):void{
			
			//PackData.printByte(pack);
			
			packData.XORByRandomKey(packData.key,pack,PackHead.LEN);
			pack.position = 0;
			packData.head.cDatType = pack.readMultiByte(1,PackData.BUFF_ENCODE);
			packData.head.cCmdType = pack.readMultiByte(1,PackData.BUFF_ENCODE);
			packData.head.byPkgCnt = pack.readUnsignedByte().toString();
			packData.head.byPkgIdx = pack.readUnsignedByte().toString();
			pack.readUnsignedInt();
			pack.readUnsignedInt();
			packData.head.dwDataLen = pack.readUnsignedInt();
			
			
			//PackData.head.sCPYF = ;
			
			if(pack.readMultiByte(4,PackData.BUFF_ENCODE)!="CPYF"){
				getLogger(SocketProxy).error("receive wrong data");
				CmdOStr[0] = "M";
				return;
			}
			
			//PackData.printByte(pack);
			//packData.print();
			
			CmdOutCnt = pack.readByte();
			CmdOStr.length = CmdOutCnt+1;
			var dataItemLen:uint;
			var idx:uint;
			var tailIdx:uint = CmdOutCnt-1;
			
			var bytes:ByteArray;
			while(pack.bytesAvailable){
				dataItemLen = pack.readUnsignedByte();
				
				if(idx!=tailIdx){
					
					if(idx==0||(idx!=0&&receiveEncode==PackData.BUFF_ENCODE)){
						
						if(byteIdx&&byteIdx.indexOf(idx)>=0){
							bytes = new ByteArray();
							if(dataItemLen>0){
								pack.readBytes(bytes,0,dataItemLen);
							}
							CmdOStr[idx]=bytes;
						}else{
							CmdOStr[idx]=pack.readMultiByte(dataItemLen,PackData.BUFF_ENCODE);
						}
						
						
						
					}else{
						bytes = new ByteArray();
						if(dataItemLen>0){
							pack.readBytes(bytes,0,dataItemLen);
						}
						CmdOStr[idx]=bytes;
					}
					
					
				}else{
					
					
					if(idx==0||(idx!=0&&receiveEncode==PackData.BUFF_ENCODE)){
						
						if(byteIdx&&byteIdx.indexOf(idx)>=0){
							
							bytes = new ByteArray();
							if(pack.bytesAvailable>1){
								pack.readBytes(bytes,0,pack.bytesAvailable-1);
							}
							
							CmdOStr[idx]=bytes;
							
						}else{
							CmdOStr[idx] = pack.readMultiByte(pack.bytesAvailable-1,PackData.BUFF_ENCODE);
						}
							
						
						
					}else{
						bytes = new ByteArray();
						
						if(pack.bytesAvailable>1){
							pack.readBytes(bytes,0,pack.bytesAvailable-1);
						}
						
						CmdOStr[idx]=bytes;
					}
				}
				
				
				idx++;
				pack.readByte();
			}
			
			
		}
		
		public function setReceiveNotification(name:String):void{
			receiveNotification = name;
		}
		
		public function set receiveNotificationPara(arr:Array):void{
			
			_receiveNotificationPara = arr;
			
		}
		
		public function get receiveNotificationPara():Array{
			return _receiveNotificationPara;
		}
		
		/**
		 *中断信息接收 
		 * 
		 */		
		public function breakNotification():void{
			isBreak = true;
		}

		/**
		 *socket正在发送的标志 
		 */
		public function get isSending():Boolean
		{
			return _isSending;
		}

		/**
		 * @private
		 */
		public function set isSending(value:Boolean):void
		{
			
			_isSending = value;
			
		}
		
		
		public function get packData():PackData{
			return _packData;
		}
		
		public function set packData(_p:PackData):void{
			_packData = _p;
		}

		public function get receiveEncode():String
		{
			return _receiveEncode;
		}

		public function set receiveEncode(value:String):void
		{
			_receiveEncode = value;
		}
		
		public function cancelDownload():void{
			cancel = true;
		}
		
	}
}