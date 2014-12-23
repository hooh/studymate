package com.studyMate.model.vo
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.filesystem.File;
	
	public class UpLoadCommandVO
	{
		public var file:File;
		public var toPath:String;
		
		public var process:Number;
		
		public var segmentSize:uint;
		public var size:Number;
		
		public var describe:String;
		
		public var fileid:int;
		
		public var initCMD:String;
		public var completeNotification:String
		
		
		public function UpLoadCommandVO(file:File=null,toPath:String="",_describe:String = null,_initCMD:String=null,_completeNotification:String="")
		{
			
			this.file= file;
			this.toPath = toPath;
			if(_completeNotification==""){
				completeNotification = CoreConst.UPLOAD_COMPLETE;
			}else{
				completeNotification = _completeNotification;
			}
			process = 0;
			segmentSize = 30100;
			size = file.size;
			describe = _describe;
			initCMD = _initCMD;
			if(!initCMD){
				initCMD = WorldConst.UPLOAD_DEFAULT_INIT;
			}
			
			
		}
		
		
		
		
	}
}