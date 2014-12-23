package com.studyMate.world.controller
{
	import com.mylib.api.ISwitchScreenProxy;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.CmdStr;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.screens.CleanGpuMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class DefaultBeatCommand extends SimpleCommand
	{
		public function DefaultBeatCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			PackData.app.CmdIStr[0] = CmdStr.QRY_REALTIMEINFV2;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			
			var screenName:String;
			if(facade.hasProxy(ModuleConst.SWITCH_SCREEN_PROXY)&&(facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy).currentGpuScreen&&
				(facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy).currentGpuScreen.getMediatorName()!=CleanGpuMediator.NAME
			){
				screenName = (facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy).currentGpuScreen.getMediatorName();
			}else if(facade.hasProxy(ModuleConst.SWITCH_SCREEN_PROXY)&&(facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy).currentCpuScreen){
				screenName = (facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy).currentCpuScreen.getMediatorName();
			}
			PackData.app.CmdIStr[2] = screenName;
			
			PackData.app.CmdInCnt = 3;
			sendNotification(CoreConst.BEATING,[screenName]);
			sendNotification(CoreConst.SEND_11,new SendCommandVO(CoreConst.BEAT_REC,null,"cn-gb",null,SendCommandVO.SILENT));
			
		}
		
	}
}