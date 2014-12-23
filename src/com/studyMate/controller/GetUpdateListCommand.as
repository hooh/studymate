package com.studyMate.controller
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.UpdateListVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class GetUpdateListCommand extends SimpleCommand implements ICommand
	{
		public function GetUpdateListCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var vo:UpdateListVO = notification.getBody() as UpdateListVO;
			
			if(vo.updateType=="f"){
				PackData.app.CmdIStr[0] = CmdStr.LIST_ALL_BIN_FILE;
			}else if(vo.updateType=="a"){
				PackData.app.CmdIStr[0] = CmdStr.LIST_ALL_BIN_FILE_AUTO;
			}else{
				PackData.app.CmdIStr[0] = CmdStr.LIST_NEWER_BIN_FILE;
			}
			
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = Global.license.macid;
			PackData.app.CmdIStr[3] = Global.license.hexserial;
			PackData.app.CmdIStr[4] = Global.license.regmac;
			PackData.app.CmdIStr[5] = vo.fileType;
			PackData.app.CmdInCnt = 6;
			
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(vo.completeNotice,[vo]));
			
		}
		
	}
}