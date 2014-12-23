package com.mylib.framework.controller
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.UpdateGlobal;
	import com.mylib.framework.model.DataBaseProxy;
	import com.mylib.framework.utils.DBTool;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.model.vo.UpdateListVO;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class OperUpdateCommand extends SimpleCommand
	{
		public function OperUpdateCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var updateListVO:UpdateListVO = notification.getBody() as UpdateListVO;
			var f:File = Global.document.resolvePath(UpdateGlobal.UPDATE_FILE_PATH);
			var stream:FileStream = new FileStream;
			
			sendNotification(CoreConst.STARTUP_STEP_BEGIN,"安装文件:"+updateListVO.list.length+"个");
			
			
			for (var i:int = 0; i < updateListVO.list.length; i++) 
			{
				var vo:UpdateListItemVO = updateListVO.list[i];
				var file:File =UpdateGlobal.getTempFile(vo);
				
				if(!file.exists||vo.isUpdate){
					continue;
				}
				
				if(vo.type=="db"){
					var db:DataBaseProxy = DBTool.proxy;
					db.close();
				}
				
				var dotMark:int=0;
				for (var j:int = file.nativePath.length; j >0; j--) 
				{
					
					if(file.nativePath.charAt(j)=="."){
						dotMark++;
					}
					if(dotMark==2){
						break;
					}
					
				}
				
				var newPath:String;
				newPath = file.nativePath.substring(0,j).replace("\\tmpEDU\\","\\")
				newPath = newPath.replace("/tmpEDU/","/")
				file.moveTo(Global.document.resolvePath(newPath),true);
				
				vo.isUpdate = true;
				
				stream.open(f,FileMode.WRITE);
				stream.writeObject(updateListVO);
				stream.close();
				
			}
			
			sendNotification(CoreConst.OPER_UPDATE_COMPLETE);
			
			
			
			
			
		}
		
		
		
		
	}
}