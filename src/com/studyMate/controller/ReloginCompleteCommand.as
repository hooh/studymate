package com.studyMate.controller
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.tcp.SocketProxy;
	import com.studyMate.model.vo.LoginVO;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class ReloginCompleteCommand extends SimpleCommand implements ICommand
	{
		public function ReloginCompleteCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
			if((notification.getBody() as LoginVO).resendCache){
				
				var saveTemp:SaveTempFileMediator = facade.retrieveMediator(SaveTempFileMediator.NAME) as SaveTempFileMediator;
				var socket:SocketProxy = facade.retrieveProxy(SocketProxy.NAME) as SocketProxy;
				
				if(saveTemp && saveTemp.cancel){
					saveTemp.cancel = false;
					socket.lastRequestCnt = 0;
					sendNotification(CoreConst.DOWNLOAD_CANCELED);
					
					
				}else{
					if(socket)
					socket.resendLastRequest();
				}
				
				
				
			}
				
			
		}
		
	}
}