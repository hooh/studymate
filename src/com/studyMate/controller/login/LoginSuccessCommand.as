package com.studyMate.controller.login
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.model.vo.LoginSettingVO;
	import com.studyMate.model.vo.LoginVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import org.as3commons.logging.api.getLogger;
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class LoginSuccessCommand extends SimpleCommand implements ICommand
	{
		public function LoginSuccessCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			getLogger(LoginSuccessCommand).debug("登录成功");
			sendNotification(CoreConst.LOGIN_SETTING,new LoginSettingVO(PackData.app,notification.getBody() as LoginVO));
		}
		
	}
}