package com.studyMate.controller
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.TimeProxy;
	import com.studyMate.global.CmdStr;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class GetSerTimeCommand extends SimpleCommand implements ICommand
	{
		public function GetSerTimeCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
			PackData.app.CmdIStr[0] = CmdStr.GET_HOST_DATETIME;
			PackData.app.CmdInCnt = 1;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(CoreConst.REC_SER_TIME,null,"cn-gb",null,SendCommandVO.QUEUE));
			
			
		}
		
	}
}