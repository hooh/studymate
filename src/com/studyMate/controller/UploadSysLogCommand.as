package com.studyMate.controller
{
	import com.coltware.airxzip.ZipFileWriter;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.UpLoadCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.filesystem.File;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class UploadSysLogCommand extends SimpleCommand
	{
		public function UploadSysLogCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{			
			if(notification.getBody()){
				var max:uint = uint(notification.getBody());
			}else{
				max = 9;//默认上传的文件数量
			}
			
			
			var id:String = PackData.app.head.dwOperID.toString();
			var temp:File = Global.document.resolvePath(Global.localPath+id+"client_Log.zip");
			var writer:ZipFileWriter = new ZipFileWriter();
			writer.open(temp);
			
			var file:File = Global.document.resolvePath(Global.localPath+'flowRecord.txt');
			if(file.exists){
				writer.addFile(file,file.name);
			}
			file = Global.document.resolvePath(Global.localPath+'operRecord.txt');
			if(file.exists){
				writer.addFile(file,file.name);
			}
			
			file = Global.document.resolvePath(Global.localPath+'records');
			if(file.exists){
				var list:Array = file.getDirectoryListing();
				list.sort(compare,Array.CASEINSENSITIVE);//用户列表内的按时间排序(时间最近的排在前面)
				for (var i:int = 0; i < list.length; i++) {
					if(list[i].exists){
						if(!list[i].isDirectory){
							if(i>=max){
								break;
							}
							writer.addFile(list[i],list[i].name);
						}
					}
				}
				
			}						
			writer.close();		
			
			uploadSysFaq(temp);
		}
		
		private function compare(a:File,b:File):Number{
			if(a.modificationDate.time>b.modificationDate.time){
				return -1;
			}else if(a.modificationDate.time==b.modificationDate.time){
				return 0;
			}else{
				return 1;
			}				
		}
		
		private function uploadSysFaq(temp:File):void{
			if(temp.exists){				
				sendNotification(CoreConst.UPLOAD_FILE,new UpLoadCommandVO(temp,"LogRecord/" + temp.name,null,WorldConst.UPLOAD_DEFAULT_INIT));
			}
		}
	}
}