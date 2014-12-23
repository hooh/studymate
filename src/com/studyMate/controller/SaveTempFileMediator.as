package com.studyMate.controller
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.RemoteFileLoadVO;
	import com.studyMate.model.vo.SaveTempFileVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public final class SaveTempFileMediator extends Mediator
	{
		public static const NAME:String = "SaveTempFileMediator";
		public var cancel:Boolean;
		private var total:int;
		
		public function SaveTempFileMediator()
		{
			super(NAME);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case CoreConst.SAVE_TEMP_FILE:{
					save(notification.getBody() as DataResultVO);
					
					break;
				}
				case CoreConst.CANCEL_DOWNLOAD:{
					cancel = true;
					break;
				}
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [CoreConst.SAVE_TEMP_FILE,CoreConst.CANCEL_DOWNLOAD];
		}
		
		override public function onRegister():void
		{
		}
		
		
		private function save(data:DataResultVO):void
		{
			var result:DataResultVO = data;
			var vo:SaveTempFileVO = result.para[0];
			var stream:FileStream = new FileStream();
			var f:File = new File(vo.nativePath);
			if(!f.exists){
				stream.open(f,FileMode.WRITE);
				stream.close();
			}
			
			var remote:RemoteFileLoadVO = vo.remoteFileLoadVO;
			
			
			
			if(result.isEnd){
				if(remote.isEnd||result.result[1]==result.result[2]||!remote.isModified){
					
					//since wrong file size,reload
					if(f.size!=parseInt(result.result[2])){
						remote.position = 0;
						f.deleteFile();
						sendNotification(CoreConst.CALL_BACK_COMMAND,remote);
						return;
					}
					
					if(parseInt(result.result[1])==0){
						sendNotification(CoreConst.FILE_DOWNLOADED,remote);
						return;
					}
					
					
					sendNotification(CoreConst.FILE_DOWNLOADED,vo);
					
//					NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
				}else{
					
					if(cancel){
						cancel = false;
						sendNotification(CoreConst.DOWNLOAD_STOPED);
						NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
						return;
					}
					
					remote.isModified = false;
					sendNotification(CoreConst.LOADING_TOTAL_PROCESS_MSG,[total,remote.position]);
					sendNotification(CoreConst.CALL_BACK_COMMAND,remote);

				}
				
				
			}else if((result.result[0] as String).charAt(0)=="0"){
				stream.open(f,FileMode.APPEND);
				if(parseInt(result.result[1])==parseInt(result.result[2])){
					remote.isEnd = true;
				}
				remote.isModified = true;
				remote.position = parseInt(result.result[2]);
				
				total = parseInt(result.result[1]);
				if(f.size==parseInt(result.result[2])-parseInt(result.result[3])){
					stream.writeBytes(result.result[4]);
				}else{
					trace("throw data");
				}
				
				stream.close();
			}else{
				sendNotification(CoreConst.LOADING,false);
				throw new Error(remote.remotePath+" "+result.result[1]+" data error");
				
			}
			
		}
		
		
	}
}