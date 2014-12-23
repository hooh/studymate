package com.studyMate.controller
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.LicenseVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class SaveLicenseCommand extends SimpleCommand implements ICommand
	{
		public function SaveLicenseCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var vo:LicenseVO = notification.getBody() as LicenseVO;
			
			var sream:FileStream = new FileStream();
			
			
			
			sream.open(vo.file,FileMode.WRITE);
			sream.writeMultiByte(vo.macid,PackData.BUFF_ENCODE);
			sream.writeByte(10);
			sream.writeMultiByte(vo.hexserial,PackData.BUFF_ENCODE);
			sream.writeByte(10);
			sream.writeMultiByte(vo.regmac,PackData.BUFF_ENCODE);
			sream.close();
			
			Global.license = vo;
			vo.file = null;
			sendNotification(CoreConst.TOAST,new ToastVO("注册成功"));
		}
		
	}
}