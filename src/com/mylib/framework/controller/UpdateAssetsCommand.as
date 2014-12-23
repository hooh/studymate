package com.mylib.framework.controller
{
	
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.UpdateProxy;
	import com.studyMate.model.vo.UpdateListVO;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class UpdateAssetsCommand extends SimpleCommand implements ICommand
	{
		public function UpdateAssetsCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var vo:UpdateListVO = notification.getBody() as UpdateListVO;
			
			var proxy:UpdateProxy = facade.retrieveProxy(UpdateProxy.NAME) as UpdateProxy;
			proxy.completeNotice = CoreConst.UPDATE_COMPLETE;
			proxy.completeNoticeParameters = vo;
			proxy.updateByVO(vo);
			
			
			
			
		}
		
	}
}