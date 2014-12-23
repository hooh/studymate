package com.studyMate.controller
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.db.schema.Player;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.UpdateListVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class CheckLicenseCommand extends SimpleCommand implements ICommand
	{
		public function CheckLicenseCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{

			/*var licenseProxy:LicenseProxy = facade.retrieveProxy(LicenseProxy.NAME) as LicenseProxy;

			Global.license = licenseProxy.getLicense();*/
			
			
			if(Global.player.region=="@000"){
				sendNotification(CoreConst.TOAST,new ToastVO("管理员登录成功"));
				
				
				sendNotification(CoreConst.REGISTER_PAD,"gdgz");
					
			}else if(Global.license){
				sendNotification(CoreConst.LICENSE_PASSED,notification.getBody());
			}else{
				Global.hasLogin = false;
				Global.player = null;
				sendNotification(CoreConst.LOADING,false);
				sendNotification(CoreConst.TOAST,new ToastVO("请管理员先注册本机器"));
				
			}
		}
		
		
		
		
	}
}