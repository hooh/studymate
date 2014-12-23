package com.studyMate.controller
{
	import com.edu.EduAllExtension;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.ExecuteGameServiceCommandVO;
	import com.studyMate.model.vo.RootInfoVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.utils.MyUtils;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class CheckSUCommand extends SimpleCommand implements ICommand
	{
		
		private var eduSerRoot:File = Global.document.resolvePath(Global.localPath+"systemFile/eduServerRoot.edu");
		private var rootVo:RootInfoVO = new RootInfoVO;
		
		public function CheckSUCommand()
		{
			super();
		}
		
		
		override public function execute(notification:INotification):void{
			
			
			
			//检查studyMate 权限
			var studyMateRoot:String = EduAllExtension.getInstance().rootAvailableExtension();
			
			if(studyMateRoot == "success")
				rootVo.studyMateRoot = "Root";
			else if(studyMateRoot == "false")
				rootVo.studyMateRoot = "UnRoot";
			
			
			
			getEduServerSU();
			
			
			
			Global.appRootVo = rootVo;
			
			
			sendNotification(CoreConst.CHECK_APP_ROOT_COMPLETE);
			
		}
		

		private function getEduServerSU():void{
			
			var stream:FileStream = new FileStream();
			if(eduSerRoot.exists){
				stream.open(eduSerRoot,FileMode.READ);
				var str:String = stream.readMultiByte(stream.bytesAvailable,PackData.BUFF_ENCODE);
				
//				if(str.split("+").length > 1 && str.split("+")[1] != ""){
					
				rootVo.eduServerRoot = str;
//				}
				
				
				stream.close();
				
				
			}
			
			/*writeRootFile();*/
			
			
			
		}
		
		/*
		//重新检查eduServer版本号，写入时间、root情况
		private function writeRootFile():void{
			
			
			var stream:FileStream = new FileStream();
			stream.open(eduSerRoot,FileMode.WRITE);
			stream.writeMultiByte(MyUtils.getTimeFormat()+" +",PackData.BUFF_ENCODE);
			stream.close();
			
			
			var command:String = "id >> /mnt/sdcard/edu/systemFile/eduServerRoot.edu";
			var operation:String = "exeCommands";
			
			sendNotification(CoreConst.EXECUTE_GAME_SERVICE,new ExecuteGameServiceCommandVO(command,operation));
		}*/
		
		
		
	}
}