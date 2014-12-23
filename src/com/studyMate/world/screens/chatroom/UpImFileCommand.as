package com.studyMate.world.screens.chatroom
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
	
	public class UpImFileCommand extends SimpleCommand
	{
		public function UpImFileCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var vo:UpLoadCommandVO = notification.getBody() as UpLoadCommandVO;
			if(!vo || !vo.file.exists) return;
			PackData.app.CmdIStr[0] = CmdStr.UP_IM_FILE;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = Global.player.realName;
			PackData.app.CmdIStr[3] = CacheTool.getByKey(ChatRoomMediator.NAME,'recId') as String;
			PackData.app.CmdIStr[4] = CacheTool.getByKey(ChatRoomMediator.NAME,'recName') as String;
			PackData.app.CmdIStr[5] = vo.describe;
			PackData.app.CmdIStr[6] = vo.toPath;
			var upBytes:ByteArray = UploadProxy.readBytes(vo);
			PackData.app.CmdIStr[7] = vo.size.toString();
			PackData.app.CmdIStr[8] = vo.process.toString();
			PackData.app.CmdIStr[9] = vo.segmentSize.toString();
			PackData.app.CmdIStr[10] = upBytes;		
			PackData.app.CmdInCnt = 11;
//			if(Global.OS == OSType.WIN){//因为windows录音文件会随时删除
				sendNotification(CoreConst.SEND_11,new SendCommandVO(CoreConst.UPLOAD_SEGMENT_COMPLETE,[vo],'cn-gb',null,SendCommandVO.NORMAL));
//			}else{				
//				sendNotification(CoreConst.SEND_11,new SendCommandVO(CoreConst.UPLOAD_SEGMENT_COMPLETE,[vo],'cn-gb',null,SendCommandVO.QUEUE));
//			}
		}
	}
}