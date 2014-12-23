package com.studyMate.model.vo.tcp
{
	public final class RandomKeyData
	{
		public var dwRandomServer:Number;//服务端随机数
		public var dwRandomClient:Number;//客户端随机数
		
		public static const len:uint = 8;
		
		public function RandomKeyData(dwRandomServer:uint=0,dwRandomClient:uint=0)
		{
			this.dwRandomServer = dwRandomServer;
			this.dwRandomClient = dwRandomClient;
		}
	}
}