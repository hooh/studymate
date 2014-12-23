package com.studyMate.model.vo.tcp
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.model.vo.RecordVO;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import org.as3commons.logging.api.getLogger;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	

	public final class PackData
	{
		private  var _dwPkgLen:uint;
		private  var _dwDataLen:uint;
		public  var head:PackHead = new PackHead();
		/**
		 * 输入命令字
		 */		
		public var CmdIStr:Array;
		/**
		 * 输出命令字
		 */		
		public var CmdOStr:Array;
		
		public  var CmdInCnt:uint;
		public  var CmdOutCnt:uint;
		
		public static const BUFF_ENCODE:String = "cn-gb";
		
		/**
		 * 输入缓冲
		 */		
		public  var inBuf:ByteArray;
		/**
		 * 输出缓冲
		 */		
		public  var outBuf:ByteArray;
		
		public  var key:RandomKeyData = new RandomKeyData();
		
		/**
		 *用于加密的key字节 
		 */		
		public  var keyByte:ByteArray = new ByteArray();
		
		//临时字节数组，用于计算字符字节长度
		private  var tmpByte:ByteArray = new ByteArray();
		
		public  var isLogin:Boolean;
		
		public  var tmpOutput:String;
		
		
		/*public static const LOGIN_dwSector:uint = 368;
		public static const LOGIN_dwOperID:uint = 111;
		public static const LOGIN_dwRandomServer:uint = 1225;*/
		
		public static const LOGIN_dwSector:uint = 0;
		public static const LOGIN_dwRandomServer:uint = 0x20110808;
		
		public  var dwSector:uint;
		
		/**
		 *应用数据 
		 */		
		public static var app:PackData;
		public static var im:PackData;
		
		
		/**
		 * 应用数据长;不包括该字段自身
		 */
		public  function get dwDataLen():uint
		{
			return head.dwDataLen;
		}

		/**
		 * @private
		 */
		public  function set dwDataLen(value:uint):void
		{
			head.dwDataLen = value;
		}

		/**
		 *整个数据包长;包括该字段自身
		 */
		public  function get dwPkgLen():uint
		{
			return head.dwDataLen;
		}

		/**
		 * @private
		 */
		public  function set dwPkgLen(value:uint):void
		{
			head.dwDataLen = value;
		}

		public  function initialize():void{
			head.sCPYF = "CPYF";
			keyByte.endian = Endian.LITTLE_ENDIAN;
		}
		
		public  function toOutBuf(buf:ByteArray):void{
			outBuf.writeBytes(buf);
		}
		
		public  function toInBuf(iStr:Array,cnt:int):void{
			
			toByte(iStr,cnt,inBuf);
			
		}
		
		
		/**
		 *包装数据写入缓存 
		 * @param _input
		 * @param _cnt
		 * @param buf
		 * @return 
		 * 
		 */		
		public  function toByte(_input:Array,_cnt:uint,buf:ByteArray):void{
//			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("toByte s","PackData",0));

			
			tmpByte.clear();
			dwDataLen = 0;
			var tmpLen:uint;
			var initPos:uint = buf.length;
			
			//buf.writeUnsignedInt(0); //整个数据包长;包括该字段自身
			buf.writeMultiByte(head.cDatType,BUFF_ENCODE);
			
			getLogger(PackData).debug("dwReqCnt:"+head.dwReqCnt);
			getLogger(PackData).debug("dwRandomClient:"+key.dwRandomClient);
			getLogger(PackData).debug("dwRandomServer:"+key.dwRandomServer);
			getLogger(PackData).debug("dwSector:"+dwSector);
			getLogger(PackData).debug("dwOperID:"+head.dwOperID);
			
			
			
			if(head.cDatType!="8"&&head.cDatType!="4"){
				buf.writeMultiByte(head.cCmdType,BUFF_ENCODE);
				
				//登录和其他请求的头四个字节含义不同
				if(!isLogin){
					buf.writeByte(int(head.byPkgCnt));
					buf.writeByte(int(head.byPkgIdx));
				}else{
					buf.writeMultiByte(head.byPkgCnt,BUFF_ENCODE);
					buf.writeMultiByte(head.byPkgIdx,BUFF_ENCODE);
				}
				
				
				buf.writeUnsignedInt(head.dwOperID);
				buf.writeUnsignedInt(head.dwReqCnt);
				buf.writeUnsignedInt(0);//应用数据长;不包括该字段自身
				
				//20
				
				/*应用数据部分*/
				if(_cnt>0){
					buf.writeMultiByte("CPYF",BUFF_ENCODE);
					buf.writeByte(_cnt);
				}
				for (var i:int = 0; i < _cnt; i++) 
				{
					
					if(_input[i] is ByteArray){
						tmpByte.writeBytes(_input[i],0,(_input[i] as ByteArray).length);
					}else{
						tmpByte.writeMultiByte(String(_input[i]),BUFF_ENCODE);
					}
					
					tmpLen = tmpByte.length;
					dwDataLen += tmpLen+2;
					if(i>=_cnt-1&&tmpLen>255){
						
						buf.writeByte(0);
						
					}else{
						buf.writeByte(tmpLen);
					}
					buf.writeBytes(tmpByte);
					buf.writeByte(0);
					tmpByte.clear();
				}
				//指针回到包头设置数据长度的位置
				buf.position = 12 + initPos;
				//加上应用数据包长度的一个字节长度 + cpyf长度
				dwDataLen+=5;
				buf.writeUnsignedInt(dwDataLen);
			}
			//初始位置设置这个包长
			//buf.position = initPos;
			//buf.writeUnsignedInt(PackHead.LEN+dwDataLen);
			
//			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("toByte e","PackData",0));

			
		}
		
		public  function setBLogin(str:String):void{
			head.byPkgIdx = str.charAt(3);
			head.byPkgCnt = str.charAt(2);
			head.cCmdType = str.charAt(1);
			head.cDatType = str.charAt(0);
		}
		
		public  function setALogin():void{
			
			head.byPkgCnt = "0";
			head.byPkgIdx = "1";
			head.cCmdType = "1";
			head.cDatType = "C";
			
		}
		
		
		
		
		public  function set1N():void{
			head.byPkgCnt = "1";
			head.byPkgIdx = "1";
			head.cCmdType = "N";
		}
		
		public  function set11():void{
			head.byPkgCnt = "1";
			head.byPkgIdx = "1";
			head.cCmdType = "1";
		}
		
		
		
		public  function print():void{
			var str:String = "";
			
			str = "head.byPkgCnt:"+head.byPkgCnt+" head.byPkgIdx:"+head.byPkgIdx+" head.cCmdType:"+head.cCmdType+" head.cDatType:"+head.cDatType+" head.dwOperID:"+head.dwOperID
				+" head.dwReqCnt:"+head.dwReqCnt+" head.dwDataLen:"+head.dwDataLen+" "+head.sCPYF;
			
			//str = " head.dwDataLen:"+head.dwDataLen;
			
			
			log(str);
			
			
			
			
		}
		
		public static function printByte(byte:ByteArray):void{
			var initPos:uint = byte.position;
			byte.position = 0;
			var str:String = "";
			var oi:uint;
			
			
			while(byte.bytesAvailable>0){
				
				
				str += byte.readUnsignedByte()+" ";
					
				
			}
			
			
			
			
			log(str);
			byte.position = initPos;
			
			
		}
		
		/**
		 *数据加密 
		 * @param key
		 * @param pInOut
		 * @param offset
		 * 
		 */		
		public  function XORByRandomKey(key:RandomKeyData,pInOut:ByteArray,offset:uint):void{
			
			if(offset>pInOut.length){
				return;
			}
			
			
			if(isLogin){
				//dwSector = LOGIN_dwSector;
			}else{
				dwSector = head.dwReqCnt;
			}
			
			
			
			
			
			var useKey:RandomKeyData = new RandomKeyData((key.dwRandomServer+key.dwRandomClient)+dwSector,
				(key.dwRandomServer - key.dwRandomClient)|dwSector);
			
			keyByte.clear();
			
			//log("server:"+key.dwRandomServer+" client:"+key.dwRandomClient);
			
			keyByte.writeUnsignedInt(useKey.dwRandomServer);
			keyByte.writeUnsignedInt(useKey.dwRandomClient);
			
			//log("useKey.dwRandomServer:"+useKey.dwRandomServer.toString());
			//log("useKey.dwRandomClient:"+useKey.dwRandomClient.toString());
			//PackData.printByte(keyByte);
			//log("pInOut.length:"+pInOut.length);
			for (var i:int = offset; i < pInOut.length; i++) 
			{
				pInOut[i] = (pInOut[i] as uint)^(keyByte[(i-offset)%RandomKeyData.len] as uint);
			}
			
		}
		
		private static function log(str:String):void{
			
			
			getLogger(PackData).debug(str);
			
		}
		
		
		
		
	}
}