package com.studyMate.controller
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.UploadProxy;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.UpLoadCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.utils.MyUtils;
	
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class UpLoadBookInitCommand extends SimpleCommand
	{
		public function UpLoadBookInitCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var vo:UpLoadCommandVO = notification.getBody() as UpLoadCommandVO;
			PackData.app.CmdIStr[0] = CmdStr.UPFILETOHOSTV1;
			PackData.app.CmdIStr[1] = Global.license.macid;
			PackData.app.CmdIStr[2] = Global.player.operId;
			PackData.app.CmdIStr[3] = "BOOK";
			PackData.app.CmdIStr[4] = "0";
			PackData.app.CmdIStr[5] =  MyUtils.getTimeFormat()
			PackData.app.CmdIStr[6] = "false";
			PackData.app.CmdIStr[7] = vo.toPath;
			PackData.app.CmdIStr[8] = vo.size.toString();
			PackData.app.CmdIStr[9] = vo.process.toString();
			var upBytes:ByteArray = UploadProxy.readBytes(vo);
			PackData.app.CmdIStr[10] = vo.segmentSize.toString();
			PackData.app.CmdIStr[11] = upBytes;
			PackData.app.CmdInCnt = 12;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(CoreConst.UPLOAD_SEGMENT_COMPLETE,[vo]));
		}
		
	}
}


