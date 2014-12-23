package com.studyMate.controller.login
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.LoginVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class VerifyLoginResultCommand extends SimpleCommand implements ICommand
	{
		public function VerifyLoginResultCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			var loginVO:LoginVO = result.para[0];
			if(result.type=="E"||result.type=="e"){
				sendNotification(CoreConst.LOGIN_ERROR,loginVO);
			}else if(result.resultCnt&&(result.result[0] as String).charAt(0)=="M"){
				sendNotification(CoreConst.LOGIN_FAIL);
			}else if(result.resultCnt&&result.result[0]=="000"){
				sendNotification(CoreConst.LOGIN_SUCCESS,loginVO);
			}else{
				sendNotification(CoreConst.LOGIN_FAIL,"数据错误");
			}
			
			
			
		}
		
	}
}