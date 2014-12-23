package com.studyMate.controller
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.utils.CacheTool;
	import com.studyMate.global.Global;
	import com.studyMate.world.screens.HappyIslandMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class IslandSwitchScreenCommand extends SimpleCommand
	{
		public function IslandSwitchScreenCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			if(Global.isLoading){
				CacheTool.put(HappyIslandMediator.NAME,"switchScreenVO",notification.getBody());
				CacheTool.put(HappyIslandMediator.NAME,"switchType",notification.getType());
			}else{
				sendNotification(CoreConst.MANUAL_LOADING,false);
				sendNotification(WorldConst.ISLAND_SWITCHSCREEN_FUN,notification.getBody(),notification.getType());
			}
		}
		
	}
}