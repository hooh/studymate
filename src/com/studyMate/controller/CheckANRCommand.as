package com.studyMate.controller
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.OSType;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public final class CheckANRCommand extends SimpleCommand implements ICommand
	{
		private var ANRFile:File = Global.document.resolvePath(Global.localPath+"anr.txt");
		
		public function CheckANRCommand()
		{
			super();
		}
		
		
		override public function execute(notification:INotification):void{
			
			
			//判断anr.txt文件是否存在，有则提交一条FAQ  Error
			
			var stream:FileStream = new FileStream();
			if(ANRFile.exists){
				stream.open(ANRFile,FileMode.READ);
				var str:String = stream.readMultiByte(stream.bytesAvailable,PackData.BUFF_ENCODE);
				
				stream.close();
				ANRFile.deleteFile();
				
				
				
//				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_ERR,str+"; studyVersion="+Global.appVersion);
				
				PackData.app.CmdIStr[0] = CmdStr.Send_FAQ_Info;
				PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
				PackData.app.CmdIStr[2] = "Error";
				PackData.app.CmdIStr[3] = str;
				PackData.app.CmdInCnt = 4;
				sendNotification(CoreConst.SEND_11,new SendCommandVO("",null,"cn-gb",null,SendCommandVO.QUEUE));
				
				
			}
			
		}
		
		
	}
}