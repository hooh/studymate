package com.studyMate.controller.login
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.DataBaseProxy;
	import com.mylib.framework.utils.DBTool;
	import com.studyMate.db.schema.Player;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.LoginVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class LoginErrorCommand extends SimpleCommand
	{
		public function LoginErrorCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
			var db:DataBaseProxy = DBTool.proxy;
			var p:Player = Global.player;
			if(p){
				db.playerDAO.deleteItem(Global.player);
			}
			Global.player = null;
			
			PackData.app.key.dwRandomServer = PackData.LOGIN_dwRandomServer;
			PackData.app.key.dwRandomClient = 0;
			
			var vo:LoginVO = notification.getBody() as LoginVO;
			
			
			sendNotification(CoreConst.SOCKET_INIT,[vo.resendCache,"AB",vo.updateType]);
			
			
		}
		
	}
}