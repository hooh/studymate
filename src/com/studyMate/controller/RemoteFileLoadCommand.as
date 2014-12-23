package com.studyMate.controller
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.RemoteFileLoadVO;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class RemoteFileLoadCommand extends SimpleCommand implements ICommand
	{
		public function RemoteFileLoadCommand()
		{
			super();
		}
		
		private function accept3g():void{
			Global.isSwitching = false;
		}
		
		private function noHandle():void{
			
		}
		
		override public function execute(notification:INotification):void
		{
			
			if(Global.use3G){
				sendNotification(CoreConst.LOADING,false);
				sendNotification(WorldConst.ALERT_SHOW,new AlertVo("当前正在使用3g网络，不能下载",false,"yesHandler","noHandler",false,null,accept3g,null,noHandle));
				return;
			}
			
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			
			sendNotification(CoreConst.LOADING_MSG,(notification.getBody() as RemoteFileLoadVO).remotePath);
			sendNotification(CoreConst.REQUEST_FILE_DATA,notification.getBody());
			
			
		}
		
	}
}