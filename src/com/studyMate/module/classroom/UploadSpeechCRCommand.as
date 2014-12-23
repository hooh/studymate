package com.studyMate.module.classroom
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.UploadProxy;
	import com.mylib.framework.utils.CacheTool;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.UpLoadCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class UploadSpeechCRCommand extends SimpleCommand
	{
		public function UploadSpeechCRCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var vo:UpLoadCommandVO = notification.getBody() as UpLoadCommandVO;
			if(!vo.file.exists) return;
			PackData.app.CmdIStr[0] = CmdStr.UP_CR_FILE;
			PackData.app.CmdIStr[1] = CacheTool.getByKey(ClassroomMediator.NAME,'crid') as String;
			PackData.app.CmdIStr[2] = (facade.retrieveMediator(ExercisesLeftMediator.NAME) as ExercisesLeftMediator).current_Qid;//题目标识
			PackData.app.CmdIStr[3] = PackData.app.head.dwOperID.toString();//发送者标识
			PackData.app.CmdIStr[4] = Global.player.realName;
			PackData.app.CmdIStr[5] = vo.describe;
			PackData.app.CmdIStr[6] = (facade.retrieveMediator(ExerciseRightMediator.NAME) as ExerciseRightMediator).totalTime;
			PackData.app.CmdIStr[7] = vo.toPath;
			PackData.app.CmdIStr[8] = vo.size.toString();
			PackData.app.CmdIStr[9] = vo.process.toString();
			var upBytes:ByteArray = UploadProxy.readBytes(vo);
			PackData.app.CmdIStr[10] = vo.segmentSize.toString();			
			PackData.app.CmdIStr[11] = upBytes;
			PackData.app.CmdInCnt = 12;
//			if(Global.OS == OSType.WIN){//因为windows录音文件会随时删除
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(CoreConst.UPLOAD_SEGMENT_COMPLETE,[vo],'cn-gb',null,SendCommandVO.NORMAL));
//			}else{				
//				sendNotification(CoreConst.SEND_11,new SendCommandVO(CoreConst.UPLOAD_SEGMENT_COMPLETE,[vo],'cn-gb',null,SendCommandVO.QUEUE));
//			}
		}
	}
}