package com.studyMate.controller
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.UploadProxy;
	import com.studyMate.global.CmdStr;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.UpLoadCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class UploadChristmasInitCommand extends SimpleCommand
	{
		public function UploadChristmasInitCommand()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var vo:UpLoadCommandVO = notification.getBody() as UpLoadCommandVO;
			PackData.app.CmdIStr[0] = CmdStr.UP_FILE_TO_HOST;
			PackData.app.CmdIStr[1] = "chrpic/"
			PackData.app.CmdIStr[2] = vo.toPath;
			PackData.app.CmdIStr[3] = vo.size.toString();
			PackData.app.CmdIStr[4] = vo.process.toString();
			var upBytes:ByteArray = UploadProxy.readBytes(vo);
			PackData.app.CmdIStr[5] = vo.segmentSize.toString();
			
			PackData.app.CmdIStr[6] = upBytes;
			PackData.app.CmdInCnt = 7;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(CoreConst.UPLOAD_SEGMENT_COMPLETE,[vo]));
		}
	}
}