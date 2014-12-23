package com.studyMate.world.controller
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.CmdStr;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	
	public class UpdateStuSignCommand extends SimpleCommand
	{
		public function UpdateStuSignCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			PackData.app.CmdIStr[0] = CmdStr.UPDATE_STU_SIGN;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = notification.getBody() as String;
			PackData.app.CmdInCnt = 3;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(WorldConst.UPDATE_STU_SIGN_COMPLETE));
		}
		
	}
}