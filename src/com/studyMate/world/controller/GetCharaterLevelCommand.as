package com.studyMate.world.controller
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.CmdStr;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class GetCharaterLevelCommand extends SimpleCommand implements ICommand
	{
		public function GetCharaterLevelCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
			var stdId:String = notification.getBody() as String;
			
			PackData.app.CmdIStr[0] = CmdStr.GET_STD_FNLVL;
			PackData.app.CmdIStr[1] = stdId;
			PackData.app.CmdInCnt = 2;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(WorldConst.GET_STD_FNLVL_COMPLETE,null,"cn-gb",null,SendCommandVO.QUEUE));
			
			
		}
		
	}
}