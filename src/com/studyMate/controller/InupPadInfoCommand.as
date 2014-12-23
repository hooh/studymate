package com.studyMate.controller
{
	import com.edu.EduAllExtension;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.ShareConst;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.OSType;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.filesystem.File;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class InupPadInfoCommand extends SimpleCommand implements ICommand
	{
		public function InupPadInfoCommand()
		{
			super();
		}

		override public function execute(notification:INotification):void{
			if(Global.OS == OSType.WIN){
			  sendNotification(CoreConst.REC_VERSION);
			  return;
			}
			

			
			var spaceAvailable:Number = File.documentsDirectory.spaceAvailable/1024/1024/1024;//磁盘剩余大小
			
			PackData.app.CmdIStr[0] = CmdStr.INUP_PAD_INFO;
			PackData.app.CmdIStr[1] = Global.license.macid;
			PackData.app.CmdIStr[2] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[3] = Global.getSharedProperty(ShareConst.IP)+":"+Global.getSharedProperty(ShareConst.PORT);
			PackData.app.CmdIStr[4] = EduAllExtension.getInstance().getBuildModelFunction();
			PackData.app.CmdIStr[5] = EduAllExtension.getInstance().packageVersionExtension("com.adobe.air")
			PackData.app.CmdIStr[6] = EduAllExtension.getInstance().packageVersionExtension("air.com.eduOnline");
			PackData.app.CmdIStr[7] = EduAllExtension.getInstance().packageVersionExtension("com.eduonline.service");
			PackData.app.CmdIStr[8] = Global.appRootVo.studyMateRoot;
			PackData.app.CmdIStr[9] = Global.appRootVo.eduServerRoot;
			PackData.app.CmdIStr[10] =  "磁盘剩余："+spaceAvailable.toFixed(2)+"G";
			PackData.app.CmdInCnt = 11;
			sendNotification(CoreConst.SEND_11, new SendCommandVO(CoreConst.REC_VERSION,null,"cn-gb",null,SendCommandVO.QUEUE));
		}
		
	}
}