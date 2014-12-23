package com.mylib.framework.controller
{
	import com.studyMate.global.Global;
	import com.studyMate.global.OSType;
	import com.studyMate.model.vo.RemoteFileLoadVO;
	import com.studyMate.model.vo.SaveTempFileVO;
	
	import flash.desktop.NativeApplication;
	import flash.filesystem.File;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class MoveTempFileCommand extends SimpleCommand
	{
		public function MoveTempFileCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var vo:SaveTempFileVO = notification.getBody() as SaveTempFileVO;
			var remote:RemoteFileLoadVO = vo.remoteFileLoadVO;
			
			//删除.tmp后续
			var dotMark:int=0;
			for (var i:int = vo.nativePath.length; i >0; i--) 
			{
				
				if(vo.nativePath.charAt(i)=="."){
					dotMark++;
				}
				if(dotMark==2){
					break;
				}
				
			}
			
			var oldFile:File = new File(vo.nativePath);
			if(remote.remotePath==Global.appName){
				
				if(Global.OS!=OSType.ANDROID){
					//@@win
					var f:File = new File(File.applicationDirectory.resolvePath(Global.appName).nativePath);
					oldFile.moveTo(f,true);
				}
			}else{
				
				var newPath:String;
				newPath = vo.nativePath.substring(0,i).replace("\\tmpEDU\\","\\");
				newPath = newPath.replace("/tmpEDU/","/");
				oldFile.moveTo(Global.document.resolvePath(newPath),true);
			}
		}
		
	}
}