package com.mylib.framework.controller
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.UpdateGlobal;
	import com.mylib.framework.utils.DBTool;
	import com.studyMate.global.Global;
	import com.studyMate.global.OSType;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.model.vo.UpdateListVO;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import nochump.util.zip.CRC32;
	
	import org.as3commons.logging.api.getLogger;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class CheckUpdateFilesCommand extends SimpleCommand
	{
		public function CheckUpdateFilesCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var updateList:UpdateListVO = notification.getBody() as UpdateListVO;
			sendNotification(CoreConst.STARTUP_STEP_BEGIN,"检查文件..");
			if(!updateList){
				sendNotification(CoreConst.CHECK_UPDATE_FILES_COMPLETE);
			}else{
				DBTool.proxy.close();
				var result:UpdateListVO = updateList;
				var crc:CRC32 = new CRC32();
				var tf:File;
				var isDiff:Boolean;
				for (var i:int = 0; i < updateList.list.length; i++) 
				{
					if(notification.getType()=="l"){
						tf = Global.document.resolvePath(Global.localPath+updateList.list[i].wfname);
					}else{
						tf = UpdateGlobal.getTempFile(updateList.list[i]);
					}
					isDiff = false;
					getLogger("CheckUpdateFilesCommand").debug("checking "+updateList.list[i].path);
					sendNotification(CoreConst.LOADING_TOTAL_PROCESS_MSG,[null,i,"验证"+updateList.list[i].path]);
					if((updateList.list[i].wfname==Global.appName&&Global.OS==OSType.ANDROID)||(updateList.list[i].isUpdate)){
						continue;
					}
					
					if(!tf.exists||tf.size!=updateList.list[i].size){
						
						isDiff = true;
						
						
					}else if(notification.getType()!="s"&&updateList.list[i].crc&&updateList.list[i].wfname.substr(updateList.list[i].wfname.length-3,3)!="mp3"){
						
						var stream:FileStream = new FileStream;
						stream.open(tf,FileMode.READ);
						var bys:ByteArray = new ByteArray;
						stream.readBytes(bys);
						stream.close();
						crc.reset();
						crc.update(bys);
						
						if(crc.getValue().toString()!=updateList.list[i].crc){
							isDiff = true;
							tf.deleteFile();
							getLogger("CheckUpdateFilesCommand").debug(updateList.list[i].path+"     "+crc.getValue()+"    "+updateList.list[i].crc);
						}
						
						
					}
					
					
					if(!isDiff){
						if(notification.getType()=="l"){
							result.list[i].isUpdate = true;
						}else{
							result.list[i].hasLoaded = true;
						}
					}else{
						result.list[i].hasLoaded = false;
					}
					
					
				}
				
				sendNotification(CoreConst.CHECK_UPDATE_FILES_COMPLETE,result);
				
			}
			
			
		}
		
	}
}