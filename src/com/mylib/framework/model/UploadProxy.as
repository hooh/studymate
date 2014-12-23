package com.mylib.framework.model
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.controller.UpLoadFileCommand;
	import com.mylib.framework.controller.UploadCompleteCommand;
	import com.mylib.framework.controller.UploadSegmentCompleteCommand;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.UpLoadCommandVO;
	
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class UploadProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "UploadProxy";
		
		override public function onRegister():void
		{
			facade.registerCommand(CoreConst.UPLOAD_FILE,UpLoadFileCommand);
			facade.registerCommand(CoreConst.UPLOAD_SEGMENT_COMPLETE,UploadSegmentCompleteCommand);
			facade.registerCommand(CoreConst.UPLOAD_COMPLETE,UploadCompleteCommand);
		}
		
		override public function onRemove():void
		{
			facade.removeCommand(CoreConst.UPLOAD_SEGMENT_COMPLETE);
			facade.removeCommand(CoreConst.UPLOAD_FILE);
			facade.removeCommand(CoreConst.UPLOAD_COMPLETE);
		}
		
		
		public function UploadProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		public function upload(vo:UpLoadCommandVO):void{
			sendNotification(vo.initCMD,vo);
			sendNotification(CoreConst.LOADING_TOTAL,vo.size);
			sendNotification(CoreConst.LOADING_PROCESS,vo.process);
		}
		
		
		public static function readBytes(vo:UpLoadCommandVO):ByteArray{
			var stream:FileStream = new FileStream();
			stream.open(vo.file,FileMode.READ);
			stream.position = vo.process;
			var upBytes:ByteArray = new ByteArray;
			
			//the last packetge
			if(vo.process+vo.segmentSize>vo.size){
				vo.segmentSize = vo.file.size - vo.process;
			}
			
			stream.readBytes(upBytes,0,vo.segmentSize);
			stream.close();
			
			return upBytes;
		}
		
		public function keepUpload(vo:UpLoadCommandVO):void{
			
			//vo.process+=vo.segmentSize;
			
			if(vo.process>=vo.size){
				sendNotification(vo.completeNotification,vo);
			}else{
				upload(vo);
			}
			
		}
		
		
		
	}
}