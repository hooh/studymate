package com.mylib.framework.controller
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.UpdateProxy;
	import com.studyMate.model.vo.LocalFilesLoadCommandVO;
	import com.studyMate.model.vo.UpdateListItemVO;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class LocalFilesLoadCommand extends SimpleCommand implements ICommand
	{
		public function LocalFilesLoadCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var up:UpdateProxy = facade.retrieveProxy(UpdateProxy.NAME) as UpdateProxy;
			var vo:LocalFilesLoadCommandVO = notification.getBody() as LocalFilesLoadCommandVO;
			var files:Vector.<UpdateListItemVO> = vo.files;
			
			up.completeNotice = CoreConst.LOCAL_FILES_LOAD_UPDATE_COMPLETE;
			up.completeNoticeParameters = vo;
			up.updateFileSet(files);
			
			
			
		}
		
	}
}