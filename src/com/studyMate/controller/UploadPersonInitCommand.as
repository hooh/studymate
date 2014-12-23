package com.studyMate.controller
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.UploadProxy;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.UpLoadCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class UploadPersonInitCommand extends SimpleCommand
	{
		public function UploadPersonInitCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var vo:UpLoadCommandVO = notification.getBody() as UpLoadCommandVO;
			PackData.app.CmdIStr[0] = CmdStr.UP_PERSONAL_FILE_TO_HOST;
			PackData.app.CmdIStr[1] = Global.player.operId;
			PackData.app.CmdIStr[2] = vo.describe;
			PackData.app.CmdIStr[3] = vo.toPath;
			PackData.app.CmdIStr[4] = vo.size.toString();
			PackData.app.CmdIStr[5] = vo.process.toString();
			var upBytes:ByteArray = UploadProxy.readBytes(vo);
			PackData.app.CmdIStr[6] = vo.segmentSize.toString();
			PackData.app.CmdIStr[7] = upBytes;
			PackData.app.CmdInCnt = 8;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(CoreConst.UPLOAD_SEGMENT_COMPLETE,[vo]));
		}
		
	}
}