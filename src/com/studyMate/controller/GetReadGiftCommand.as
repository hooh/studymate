package com.studyMate.controller
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.CmdStr;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.screens.GiftManagementMediator;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class GetReadGiftCommand extends SimpleCommand implements ICommand
	{
		public function GetReadGiftCommand(){
			super();
		}
		
		override public function execute(notification:INotification):void{
			PackData.app.CmdIStr[0] = CmdStr.QUERYREADGIFT;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 2;
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(GiftManagementMediator.GET_READ_GIFT));
		}
		
	}
}