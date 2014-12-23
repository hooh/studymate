package com.studyMate.world.controller
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.CmdStr;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class GetServerEquipmentCommand extends SimpleCommand implements ICommand
	{
		public function GetServerEquipmentCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var onCompleteParams:String = notification.getBody()[0] as String;
			
			PackData.app.CmdIStr[0] = CmdStr.QRY_EQUIPMENT;
			PackData.app.CmdIStr[1] = "*";
			PackData.app.CmdIStr[2] = "*";
			PackData.app.CmdInCnt = 3;
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(onCompleteParams));
			
			
		}
		
	}
}