package com.studyMate.model.vo
{
	import flash.filesystem.File;

	public final class ServerRegisterVO
	{
		public var mac:String;
		public var region:String;
		
		
		public function ServerRegisterVO(mac:String,region:String)
		{
			this.mac = mac;
			this.region = region;
		}
	}
}