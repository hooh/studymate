package com.studyMate.model.vo
{
	public final class FileVO
	{
		public var id:String;
		public var filePath:String;
		public var onLoadNotification:String;
		public var encoded:String;
		public var parameters:Object;
		
		
		/**
		 *是否已经加载完 
		 */		
		public var isLoaded:Boolean;
		
		public var position:Number;
		public var length:Number;
		
		public var type:String;
		
		/**
		 *是否库文件 
		 */		
		public var isLib:Boolean;
		public var domain:String;
		
		public function FileVO(id:String,filePath:String,onLoadNotification:String,encoded:String,isLib:Boolean = false,position:Number=0,length:Number=-1,type:String="",domain:String="c")
		{
			this.id = id;
			this.filePath = filePath;
			this.onLoadNotification = onLoadNotification;
			this.encoded = encoded;
			this.isLib = isLib;
			this.position = position;
			this.length = length;
			this.type = type;
			this.domain = domain;
		}
	}
}