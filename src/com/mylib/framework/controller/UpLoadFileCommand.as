package com.mylib.framework.controller
{
	import com.mylib.framework.model.UploadProxy;
	import com.studyMate.model.vo.UpLoadCommandVO;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class UpLoadFileCommand extends SimpleCommand implements ICommand
	{
		public function UpLoadFileCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var proxy:UploadProxy = facade.retrieveProxy(UploadProxy.NAME) as UploadProxy;
			
			proxy.upload(notification.getBody() as UpLoadCommandVO);
			
			
		}
		
	}
}