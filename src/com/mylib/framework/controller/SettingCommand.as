package com.mylib.framework.controller
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.DataBaseProxy;
	import com.mylib.framework.utils.DBTool;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class SettingCommand extends SimpleCommand implements ICommand
	{
		public function SettingCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			initLogging();
			var db:DataBaseProxy = DBTool.proxy;
			sendNotification(CoreConst.STARTUP_STEP_BEGIN,"连接本地数据库");
			if(db.setUp()){
				sendNotification(CoreConst.INITIALIZE_ASSETS_CONFIG);
				db.close();
 			}
			sendNotification(CoreConst.BOOT_COMPLETE);
		}
		
		
		private function initLogging():void {
			
		}
	}
}