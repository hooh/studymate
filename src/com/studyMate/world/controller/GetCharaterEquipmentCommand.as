package com.studyMate.world.controller
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.CmdStr;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class GetCharaterEquipmentCommand extends SimpleCommand implements ICommand
	{
		public function GetCharaterEquipmentCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
//			facade.registerMediator(new ProfileAndDressSuitsMediator);
			
			var operIdList:String = notification.getBody()[0];
			
			PackData.app.CmdIStr[0] = CmdStr.GET_CHARATER_EQUIPMENT;
			PackData.app.CmdIStr[1] = operIdList;
			PackData.app.CmdInCnt = 2;
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(WorldConst.GET_CHARATER_EQUIPMENT_COMPLETE,null,"cn-gb",null,SendCommandVO.QUEUE));
			
			
		}
		
	}
}