package com.studyMate.world.screens.ui.music
{
	import com.mylib.framework.utils.EncryptTool;
	import com.studyMate.global.Global;
	
	import flash.filesystem.File;
	

	public class MusicBaseClass
	{
		public var instid:String ;
		public var userId:String;//用户ID
		public var downId:String;//素材标识
		public var Name:String;//名称
		public var path:String;//需下载的路径
		public var size:String="无法获取文件大小";//大小
		public var type:String;//类型
		public var totalTime:String="";//时长
		public var version:String;//版本号
		public var author:String = "";
		public var encrypt:String;
		public var Encrypt_path:String;//加密的视频路径(真实存储地址);
		//public var encrypt_NativePath:String;
		public var hasSource:Boolean;
		public var downPercent:String="-1";

		public var goodsId:String="";
		public var isBgMusic:String;//0非背景音乐，不为0则已设为背景音乐
		
		
		public function MusicBaseClass(arr:Array)
		{
			instid = arr[1];
			userId = arr[2];
			goodsId = arr[3];
			downId = arr[8];
			Name = arr[4];
			path = arr[9];
			size = String(int(arr[11] )>>10)+"kb";;
			//size = String(int(arr[11])>>20) + "M";
			totalTime = arr[12]
			type = arr[5];	
			version = arr[10];
			
			author = arr[13];
			
			isBgMusic = arr[17];
			
			var i:int = path.lastIndexOf("/");
			
			encrypt = path.substring(0,i)+"/"+EncryptTool.encyptRC4(path.substring(i+1));
			//Encrypt_path = Global.document.resolvePath(Global.localPath+Encrypt_path).nativePath;
			Encrypt_path = Global.document.resolvePath(Global.localPath+encrypt).url;
			//encrypt_NativePath = Global.document.resolvePath(Global.localPath+encrypt).nativePath;
			var file:File =new File(Encrypt_path);;	
			if(file.exists){//如果本地有资源	
				hasSource = true;
			}else{
				hasSource = false;
			}
			file = null;
			
		}
	}
}