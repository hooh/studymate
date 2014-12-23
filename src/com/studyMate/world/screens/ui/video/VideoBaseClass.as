package com.studyMate.world.screens.ui.video
{
	import com.mylib.framework.utils.EncryptTool;
	import com.studyMate.global.Global;
	
	import flash.filesystem.File;

	public class VideoBaseClass
	{
		public var instid:String ;
		public var userId:String;//用户ID
		public var downId:String;//素材标识
		public var Name:String;//视频名称
		public var path:String;//需下载的视频路径
		public var Encrypt_path:String;//加密的视频路径(真实存储地址);
		public var size:String;//视频大小
		public var type:String;//视频类型
		public var totalTime:String="";//播放时长
		public var version:String;//版本号
		
		public var url:String;
		
		public var downPercent:String="-1";
		
		public var hasSource:Boolean;
		
		public function VideoBaseClass(arr:Array)
		{
			instid = arr[1];
			userId = arr[2];
			downId = arr[8];
			Name = arr[4];
			path = arr[9];
			var i:int = path.lastIndexOf("/");
			
			Encrypt_path = path.substring(0,i)+"/"+EncryptTool.encyptRC4(path.substring(i+1));
			//Encrypt_path = path.substring(0,i)+"/"+EncryptTool.encyptRC4("神奇校车04-GetsEaten.mp4");
			size = String(int(arr[11])>>20) + "M";
			totalTime = arr[12]
			type = arr[5];	
			version = arr[10];
			
			var file:File =Global.document.resolvePath(Global.localPath+Encrypt_path);	
			url = file.url;
			if(file.exists){//如果本地有资源	
				hasSource = true;				
			}else{
				hasSource = false;				
			
			}
			file = null;
		}
	}
}