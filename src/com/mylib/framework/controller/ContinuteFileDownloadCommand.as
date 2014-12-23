package com.mylib.framework.controller
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.UpdateProxy;
	import com.studyMate.model.vo.SaveTempFileVO;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ContinuteFileDownloadCommand extends SimpleCommand
	{
		public function ContinuteFileDownloadCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var vo:SaveTempFileVO = notification.getBody() as SaveTempFileVO;
			
			var updater1:UpdateProxy = facade.retrieveProxy(UpdateProxy.NAME) as UpdateProxy;
			
			if(!updater1.updateMode){
				sendNotification(CoreConst.OPER_TEMP_FILE,vo);
			}
			
//			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
			sendNotification(CoreConst.LOADING,false);
			sendNotification(vo.remoteFileLoadVO.completeNotice,vo.remoteFileLoadVO.completeNoticeParameters);
		}
		
	}
}