package com.studyMate.model.vo
{
	public class IPSpeedVO
	{
		public var name:String;   //名称
		public var host:String;   //IP地址
		public var port:int;      //端口
		public var timeout:int = -1;   //毫秒数
		public var conCount:int;  //连接次数
		public var failCount:int; //连接失败次数
		public var speed:Number;	//网速
		
		public var networkId:int;
	
		public var stat:int = -1;	//-1无效状态
		
		
		/**
		 * 用于测试计时 
		 */		
		public var checkTime:Number = 0;
		
		/**
		 * 用于数据包计时 
		 */		
		public var packTime:Number = 0;
		
		
		/**
		 * 已经第一次连接
		 */		
		public var hadConnected:Boolean = false;
		
		
		/**
		 * 已读数据 
		 */		
		public var readNum:int = 0;
		
		
		/**
		 * 测试状态：-1：未测试   0：正在测试  1：测试完成 
		 */		
		public var checkState:int = -1;
		
		/**
		 * socket 连接正常
		 */	
		public static const SOCKET_NORMAL:uint = 1;
		/**
		 * socket 网络故障 (连接超时/错误)
		 */		
		public static const SOCKET_ERROR:uint = 2;
		/**
		 * socket 连接关闭
		 */		
		public static const SOCKET_CLOSE:uint = 4;
		/**
		 * 验证数据  接收正常
		 */		
		public static const DATA_NORMAL:uint = 8;
		/**
		 * 验证数据  接收超时
		 */		
		public static const DATA_TIMEOUT:uint = 16;
		/**
		 * 验证数据  z标记错误
		 */		
		public static const DATA_HEAD_ERROR:uint = 32;
		/**
		 * 验证数据  z标记正确，尾部数据错误
		 */		
		public static const DATA_ERROR:uint = 64;
		
		
		
		
		public function IPSpeedVO(_name:String, _ip:String, _port:int = 0, _time:int = 0, _networkId:int=1)
		{
			name = _name;
			host = _ip;
			port = _port;
			timeout = _time;
			conCount = 0;
			failCount = 0;
			networkId = _networkId;
		}
	}
}