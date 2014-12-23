package com.studyMate.model.vo.tcp
{
	import flash.utils.ByteArray;

	/**
	 *数据包头 
	 * @author hoohuayip
	 * 
	 */	
	public final class PackHead
	{
		/**
		 * 应用数据类型: 'C'=CmdStr数组; 
		 */		
		public var cDatType:String;
		/**
		 * 命令字类型: '1'=1:1命令字; 'N'=1:N命令字
		 */		
		public var cCmdType:String;
		/**
		 * 归属包中的记录数
		 */		
		public var byPkgCnt:String;
		/**
		 * 归属包中的顺序号
		 */		
		public var byPkgIdx:String;
		private var _dwOperID:uint;
		private var _dwReqCnt:uint;
		/**
		 * 应用数据长;不包括该字段自身
		 */		
		public var dwDataLen:uint;
		/**
		 * 加密验证串;固定取值为"CPYF";不包括结尾零
		 * 包括该字段以后的数据在传输过程中需要加密 
		 */		
		public var sCPYF:String;//
		
		
		public static const LEN:uint = 16;
		
		public function PackHead()
		{
			
		}
		
		
		
		public function toByte():ByteArray{
			return null;
		}

		/**
		 * 命令请求计数;将来考虑纳入密钥;
		 */
		public function get dwReqCnt():uint
		{
			return _dwReqCnt;
		}

		/**
		 * @private
		 */
		public function set dwReqCnt(value:uint):void
		{
			_dwReqCnt = value;
		}

		/**
		 * 当前工号标识;取值0表示是登录命令字; 
		 */
		public function get dwOperID():uint
		{
			return _dwOperID;
		}

		/**
		 * @private
		 */
		public function set dwOperID(value:uint):void
		{
			_dwOperID = value;
		}

		
	}
}