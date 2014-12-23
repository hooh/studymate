package com.mylib.framework.utils
{
	
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.model.vo.tcp.PackHead;
	
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getTimer;
	
	import org.as3commons.logging.api.getLogger;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	

	/** 
	 * socket数据流里的底层处理,从这里接受到服务器的数据,满足条件后就会抛出需要的字节 
	 * 对数据流的数据,不做任何处理 
	 */  
	public final class NetBottomHandler
	{  
		private var socket        :Socket;          
		private var listener    :Function;        //接受网络解析出来的数据  
		private var msgLen        :int;            //消息长度  
		private var msgLenMax    :int;            //收到的消息最大长度  
		private var headLen        :int;            //消息头长度  
		public var isReadHead    :Boolean;        //是否已经读了消息头  
		private var bytes        :ByteArray;        //所读数据的缓冲数据，读出的数据放在这里  
		private var headMark:String="";
		private static const TIME_OUT:uint = 15000;
		public var time:uint;
		
		public function NetBottomHandler()  
		{  
			msgLenMax = 32*1024;    //32k
			headLen = PackHead.LEN;        //包头20个字节  
			isReadHead = true;
			bytes = new ByteArray();  
			bytes.endian = Endian.LITTLE_ENDIAN;
		}  
		/** 
		 * 设置一个网络通讯实例 
		 */    
		public function setSocket(socket:Socket):void  
		{  
			dispose();
			
			
			this.socket = socket;  
			//监听......  
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onServerData,false,0,true);  
		}  
		/** 
		 * 接受在网络层里收到的原始数据,传递过来的数据为描述长度,以及ByteArray对象functon(len,bytes) 
		 * @param listener:接受数据函数 
		 */  
		public function receiverNetData(listener:Function):void  
		{  
			this.listener = listener;  
		}  
		/** 
		 * 服务器发送过来的数据都在这里接收,最底层的 
		 */  
		private function onServerData(event:ProgressEvent):void  
		{  
			//一有收到数据的事件，就通过这个函数进行检验  
			getLogger(NetBottomHandler).debug("###########################onServier###########################");
//			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("onServerData s","NetBottomHandler",0));

			parseNetData();  
			
//			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("onServerData e","NetBottomHandler",0));

		}  
		
		public function cleanCache():void{
			bytes.clear();
		}
		
		public function reset():void{
			isReadHead = true;
			headMark="";
			cleanCache();
		}
		
		public function dispose():void{
			if(this.socket){
				socket.removeEventListener(ProgressEvent.SOCKET_DATA, onServerData,false);  
			}
		}
		
		
		/** 
		 * 解析网络数据流 
		 */  
		private function parseNetData():void  
		{  
			time = getTimer()+TIME_OUT;
			//如果需要读信息头  
			if(isReadHead)  
			{  
				//服务端报错返回一个字节错误码
				if(socket.bytesAvailable>=1&&headMark==""){
					headMark = socket.readMultiByte(1,PackData.BUFF_ENCODE);
					Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO(headMark,"headMark",socket.bytesAvailable));
					if(headMark!="C"){
						
						if(headMark==""){
							headMark = "0";
						}
						
						bytes.position = 0;
						bytes.writeMultiByte(headMark,PackData.BUFF_ENCODE);
						listener(1,bytes);
						headMark = "";
						return;
					}
					
					
				}
				
				if(socket.bytesAvailable >= headLen-1)  
				{  
					//读出指示后面的数据有多大  
					//读包头
					
					bytes.position = 0;
					
					bytes.writeMultiByte(headMark,PackData.BUFF_ENCODE);
					headMark = "";
					bytes.writeMultiByte(socket.readMultiByte(1,PackData.BUFF_ENCODE),PackData.BUFF_ENCODE);
					bytes.writeByte(socket.readUnsignedByte());
					bytes.writeByte(socket.readUnsignedByte());
					bytes.writeUnsignedInt(socket.readUnsignedInt());
					bytes.writeUnsignedInt(socket.readUnsignedInt());
					msgLen = socket.readUnsignedInt();
					
					
					bytes.writeUnsignedInt(msgLen);
					
					
					
					isReadHead = false;  
				}  
			}  
			//如果已经读了信息头,则看能不能收到满足条件的字节数  
			if(!isReadHead && msgLen <= msgLenMax)  
			{  
				//如果为0,表示收到异常消息  
				if(msgLen == 0)  
				{  
					//一般消息长度为0的话，表示与服务器出了错，或者即将被断开等，通知客户端，进行特别处理  
					listener(msgLen,null);  
					return ;  
				}  
				//数据流里的数据满足条件，开始读数据  
				if(socket.bytesAvailable >= msgLen)  
				{  
					//指针回归  
					bytes.position = headLen;  
					
					//取出指定长度的网络字节  
					socket.readBytes(bytes, headLen, msgLen);  
					listener(msgLen,bytes);
					cleanCache();
					isReadHead = true;
					//如果数据流里还满足读取数据条件，继续读取数据  
					if(socket.connected&&socket.bytesAvailable >= headLen)  
					{  
						parseNetData();  
					} 
				}  
			}  
		}  
	}  
}