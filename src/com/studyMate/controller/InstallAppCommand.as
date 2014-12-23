package com.studyMate.controller
{
	import com.edu.EduAllExtension;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.InstallAppCommandVO;
	
	import flash.desktop.NativeApplication;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class InstallAppCommand extends SimpleCommand implements ICommand
	{
		private var apkPackageName:String = "";
		private var vo:InstallAppCommandVO;
		
		public function InstallAppCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void{
			
			vo = notification.getBody() as InstallAppCommandVO;
			
			//自动安装
			if(vo.type == "A"){
				//取安装包包名
				apkPackageName = EduAllExtension.getInstance().apkNameExtension(vo.path);
				
				
				EduAllExtension.getInstance().addCallBackHandle(installCompleteHandle);
				
				
				//权限检测
				var rootAvailable:String = EduAllExtension.getInstance().rootAvailableExtension();
				if(rootAvailable == "success")
					EduAllExtension.getInstance().rootExecuteExtension("pm install -r "+vo.path);
				else
					sendNotification(vo.completeNotice,"false");
				
			}else if(vo.type == "M"){
				//手动安装
				
				EduAllExtension.getInstance().apkExecuteExtension(vo.path);
				Global.isUserExit = true;
				NativeApplication.nativeApplication.exit();
				
				
			}
			
			
			
			
			
//			//eduServer 命令行安装
//			EduAllExtension.getInstance().launchAppExtension("com.eduonline.service","exeCommands",["pm install -r "+_path]);
		}
		
		
		//回调参数，带上安装标示、安装包名
		private function installCompleteHandle(_result:String):void{
			
			var data:Array = _result.split(";");
			
			//安装成功
			if(data[0] == "success"){
				
				if(data.length > 1 && data[1] == apkPackageName){
					
					
					sendNotification(vo.completeNotice,"success");
				}else
					
					sendNotification(vo.completeNotice,"false");
				
			}else{
				
				sendNotification(vo.completeNotice,"false");
				
			}
			
			
			
		}
		
		
	}
}