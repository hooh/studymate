package com.studyMate.controller
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.ExecuteGameServiceCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.utils.MyUtils;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class CheckEduServiceSUCommand extends SimpleCommand implements ICommand
	{
		
		private var eduSerRoot:File = Global.document.resolvePath(Global.localPath+"systemFile/eduServerRoot.edu");
		
		public function CheckEduServiceSUCommand()
		{
			super();
		}
		
		
		override public function execute(notification:INotification):void{
			

			writeRootFile();
			
		}
		

		
		//检查eduServer版本号，写入时间、root情况
		private function writeRootFile():void{
			
			
			var stream:FileStream = new FileStream();
			stream.open(eduSerRoot,FileMode.WRITE);
			stream.writeMultiByte(MyUtils.getTimeFormat()+" +",PackData.BUFF_ENCODE);
			stream.close();
			
			
			var command:String = "id >> /mnt/sdcard/edu/systemFile/eduServerRoot.edu";
			var operation:String = "exeCommands";
			
			sendNotification(CoreConst.EXECUTE_GAME_SERVICE,new ExecuteGameServiceCommandVO(command,operation));
		}
		
		
		
	}
}