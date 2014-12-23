package com.studyMate.controller
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.model.vo.ToastVO;
	
	import org.as3commons.logging.api.getLogger;
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class ReceiveErrorCommand extends SimpleCommand implements ICommand
	{
		public function ReceiveErrorCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			getLogger(ReceiveErrorCommand).error("data error");
			
			var msg:String = (notification.getBody() as Array)[0];
			if(!msg){
				msg = (notification.getBody() as Array)[1];
			}
			sendNotification(CoreConst.TOAST,new ToastVO(msg));
			
			if((notification.getBody() as Array)[1]=="M10"){
				sendNotification(CoreConst.LOGIN_FAIL);
				
			}else{
//				throw new Error("数据错误,"+msg);
			}
			
			
			
		}
		
	}
}