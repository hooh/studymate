package com.studyMate.world.component.offline
{
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class FileRead
	{
		/**
		 * 
		 * @param path 相对路径
		 * @return 文件内容
		 * 
		 */		
		public static function getValue(path:String):String{
			var file:File = Global.document.resolvePath(Global.localPath+path);
			if(file.exists){
				var stream:FileStream = new FileStream();
				stream.open(file,FileMode.READ);				
				var str:String = stream.readMultiByte(stream.bytesAvailable,PackData.BUFF_ENCODE);
				stream.close();
				return str;
			}
			return "";
		}
	}
}