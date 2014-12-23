package com.mylib.framework.controller
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.UpdateProxy;
	import com.studyMate.model.vo.UpdateFilesVO;
	import com.studyMate.model.vo.UpdateListItemVO;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class UpdateFilesCommand extends SimpleCommand implements ICommand
	{
		public function UpdateFilesCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var up:UpdateProxy = facade.retrieveProxy(UpdateProxy.NAME) as UpdateProxy;
			var vo:UpdateFilesVO = notification.getBody() as UpdateFilesVO;
			var files:Vector.<UpdateListItemVO> = vo.files;
			up.completeNotice = vo.completeNotice;
			up.completeNoticeParameters = vo;
			up.updateFileSet(files);
			
			if(vo.cancelable){
				sendNotification(CoreConst.ENABLE_CANCEL_DOWNLOAD);
			}
			
			
		}
		
	}
}