package com.studyMate.world.component.AndroidGame
{
	import com.mylib.framework.controller.SwitchScreenCommand;
	import com.studyMate.global.Global;
	import com.studyMate.world.screens.AndroidGameShowMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class MyGameSwitchScreenCommand extends SimpleCommand
	{
		public function MyGameSwitchScreenCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			//有下载，先取消下载
			if(Global.isLoading){
				
				sendNotification(AndroidGameShowMediator.SWITCH_TO_CANCELDOWN,notification.getBody(),notification.getType());
				
			}else{
				//没有下载，直接switchscreen
				
				facade.registerCommand(WorldConst.SWITCH_SCREEN,SwitchScreenCommand);
				sendNotification(WorldConst.SWITCH_SCREEN,notification.getBody(),notification.getType());
				
				facade.registerCommand(WorldConst.SWITCH_SCREEN,MyGameSwitchScreenCommand);
			}
		}
	}
}