package com.studyMate.controller
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.OSType;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ServerRegisterVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.utils.MyUtils;
	
	import flash.system.Capabilities;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class ServerRegisterCommand extends SimpleCommand implements ICommand
	{
		public function ServerRegisterCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var vo:ServerRegisterVO = notification.getBody() as ServerRegisterVO;
			
			MyUtils.checkOS();
			
			
			PackData.app.CmdIStr[0] = CmdStr.REGISTER_MAC;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = vo.mac;
			if(Global.OS == OSType.ANDROID){
				PackData.app.CmdIStr[3] = "A";
			}else{
				PackData.app.CmdIStr[3] = "F";
			}
			PackData.app.CmdIStr[4] = Capabilities.os.toLocaleLowerCase();
			PackData.app.CmdIStr[5] = "student";
			PackData.app.CmdIStr[6] = vo.region;
			PackData.app.CmdInCnt = 7;
			
			
			sendNotification(CoreConst.SEND_11,new SendCommandVO(CoreConst.SERVER_REGISTER_REC,[vo]));
			
			
			
			
		}
		
	}
}