package com.studyMate.world.component.AndroidGame
{
	import flash.display.Bitmap;

	public class AndroidGameVO
	{
		public var gid:String;	//游戏标示
		
		
		public var packageName:String;	//包名
//		public var apkName:String;	//apk文件名
		public var gameName:String;	//游戏中文名
		
		
		public var faceId:String;	//封面素材id
		public var faceName:String;	//封面素材name
		public var apkId:String;	//apk素材id
		public var apkName:String;	//apk素材name
		
		
		public var perPoint:int;
		public var gold:int;	//购买金币
		public var level:int;	//评级 1-5
		
		public var isOpen:String;	//标记游戏是否被开启，游戏下架了则为关闭
		public var type:String;	//应用类型
		
		
		
		public var bitmap:Bitmap;	//显示图标用
		
		/**
		 * play:已下载、已安装，可以玩</br>
		 * down:未下载</br>
		 * install:未安装 
		 * 
		 */		
		public var state:String = "play";	//标识app在本地状态
		
		public function AndroidGameVO()
		{
		}
	}
}