package com.studyMate.world.controller
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.CmdStr;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	
	public class RecordLoginInfoCommand extends SimpleCommand
	{
		public function RecordLoginInfoCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			PackData.app.CmdIStr[0] = CmdStr.RECORD_LOGININFO;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 2;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(WorldConst.RECORD_LOGIN_INFO_COMPLETE,null,"cn-gb",null,SendCommandVO.QUEUE));
		}
		
	}
}