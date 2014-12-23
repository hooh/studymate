package com.studyMate.controller
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.LicenseVO;
	import com.studyMate.model.vo.ServerRegisterVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.UpdateListVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.filesystem.File;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class ServerRegisterRecCommand extends SimpleCommand implements ICommand
	{
		public function ServerRegisterRecCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var vo:DataResultVO = notification.getBody() as DataResultVO;
			
			if(!vo.isErr){
				var svo:ServerRegisterVO = vo.para[0] as ServerRegisterVO;
				
				var licenseProxy:LicenseProxy = facade.retrieveProxy(LicenseProxy.NAME) as LicenseProxy;
				
//				sendNotification(CoreConst.SAVE_LICENSE,new LicenseVO(licenseProxy.getLicensFile(),PackData.app.CmdOStr[1],PackData.app.CmdOStr[2],svo.mac));
			}else{
				sendNotification(CoreConst.TOAST,new ToastVO("注册失败"));
			}
			
			
		}
		
	}
}