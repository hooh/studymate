package com.studyMate.controller
{
	import com.mylib.framework.CoreConst;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	

	public class EasyDownloadCommand extends SimpleCommand implements ICommand
	{
		public function EasyDownloadCommand()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
				//sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(EasyDownloadMediator)]);
			sendNotification(CoreConst.ERROR_REPORT, "文件出错"+notification.getBody());
			
		}
	}
}