package com.studyMate.module.classroom
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.utils.CacheTool;
	import com.studyMate.global.CmdStr;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	internal class ClassBeatCommand extends SimpleCommand
	{
		public function ClassBeatCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			PackData.app.CmdIStr[0] = CmdStr.QRY_REALTIMEINFV2;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();			
			var screenName:String = ClassroomMediator.NAME;
			PackData.app.CmdIStr[2] = screenName;
			PackData.app.CmdIStr[3] = CacheTool.getByKey(ClassroomMediator.NAME,'crid') as String;
//			trace( CacheTool.getByKey(ClassroomMediator.NAME,'crid') as String);
			PackData.app.CmdInCnt = 4;
			sendNotification(CoreConst.BEATING,[screenName]);
			sendNotification(CoreConst.SEND_11,new SendCommandVO(CoreConst.BEAT_REC,null,"cn-gb",null,SendCommandVO.SILENT));
			
		}
	}
}