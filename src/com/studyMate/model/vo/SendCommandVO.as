package com.studyMate.model.vo
{
	public final class SendCommandVO
	{
		public var receiveNotification:String;
		public var para:Array;
		public var encode:String;
		public var byteIdx:Vector.<int>;
		public var type:uint;
		public var sendParameters:Array;
		public var doFilter:Boolean = true;
		
		public static const NORMAL:uint = 1;
		/**
		 *静默发送，如果当前线路忙会返回error 
		 */		
		public static const SILENT:uint = 2;
		/**
		 *队列发送，可和 UNIQUE,SCREEN组合
		 */		
		public static const QUEUE:uint = 8;
		/**
		 *唯一事件接收 
		 */		
		public static const UNIQUE:uint = 4;
		/**
		 * 界面互斥
		 */		
		public static const SCREEN:uint = 16;
		
		public function SendCommandVO(receiveNotification:String,para:Array=null,encode:String="cn-gb",byteIdx:Vector.<int>=null,type:uint = 1)
		{
			this.receiveNotification = receiveNotification;
			this.para = para;
			this.encode = encode;
			this.byteIdx = byteIdx;
			this.type = type;
		}
	}
}