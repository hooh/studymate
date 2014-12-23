package com.studyMate.world.component
{
	/**
	 * 绘本信息类
	 * 一个绘本书包含一个as脚本文件
	 * 0到多个swf素材文件
	 */
	public class BookPicture
	{
		public var orderId:int;
		public var rankid:String;
		public var title:String;
		public var facePath:String="";
		public var rrlPath:String;
		
		public var hasCache:Boolean;//默认false表示有缓存以下数据，true表示还未缓存数据
		public var needLoad:Boolean;//默认false表示不用下载，true表示需要下载
		public var asId:String;//素材id
		
		public var asPath:String;
		public var asSize:Number;				
		public var asVersion:String;		
		public var asType:String;
	
		public var swfId:Array=[];
		public var swfPath:Array=[];
		public var swfSize:Array=[];
		public var swfVersion:Array=[];
		public var swfType:Array=[];
	}
}