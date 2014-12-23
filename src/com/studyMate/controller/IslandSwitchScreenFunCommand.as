package com.studyMate.controller
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.controller.SwitchScreenCommand;
	import com.mylib.framework.utils.CacheTool;
	import com.studyMate.world.screens.HappyIslandMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class IslandSwitchScreenFunCommand extends SimpleCommand
	{
		public function IslandSwitchScreenFunCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			/*var mutiOnl:MutiOnlineTransferMediator = facade.retrieveMediator(MutiOnlineTransferMediator.NAME) as MutiOnlineTransferMediator;
			if(mutiOnl)
				TweenLite.killTweensOf(mutiOnl.update);*/
			/*var mutiOnl:MutiOLTransferMediator = facade.retrieveMediator(MutiOLTransferMediator.NAME) as MutiOLTransferMediator;
			if(mutiOnl)
				TweenLite.killTweensOf(mutiOnl.update);*/
			
			sendNotification(WorldConst.MUTICONTROL_STOP);
			sendNotification(WorldConst.DELAY_SWITCH_STOP);
			sendNotification(WorldConst.DO_SWITCH_STOP);
			
			facade.registerCommand(WorldConst.SWITCH_SCREEN,SwitchScreenCommand);
			sendNotification(CoreConst.LOADING,false);
			sendNotification(WorldConst.SWITCH_SCREEN,notification.getBody(),notification.getType());
			
			CacheTool.clr(HappyIslandMediator.NAME,"switchScreenVO");
		}
		
	}
}