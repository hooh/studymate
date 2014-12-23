package com.studyMate.controller
{
	import com.edu.EduAllExtension;
	import com.mylib.api.IConfigProxy;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.module.ModuleConst;
	
	import flash.desktop.NativeApplication;
	
	import feathers.controls.Alert;
	import feathers.data.ListCollection;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public final class SynPadTimeCommand extends SimpleCommand implements ICommand
	{
		public function SynPadTimeCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			//检查studyMate 权限
			var studyMateRoot:String = EduAllExtension.getInstance().rootAvailableExtension();
			
			if(studyMateRoot == "success"){
				//studymate有权限
				
				var date:Date = notification.getBody() as Date;
				var nowDate:Date = new Date();
				//相差5分钟，调整平板时间
				if(Math.abs(nowDate.time - date.time)>=300000){
					
					var synTime:String = "date "+(date.time/1000).toString();
					EduAllExtension.getInstance().rootExecuteExtension(synTime);
					
					//隐藏过度界面 
					sendNotification(CoreConst.HIDE_STARTUP_LOADING);
					Alert.show( "平板时间已同步，请重新打开应用", '温馨提示', new ListCollection(
						[
							{ label: "退出应用",triggered:function exit():void{Global.isUserExit = true;NativeApplication.nativeApplication.exit();} }
						]));
					trace("已同步平板时间");
				}else{
					sendNotification(CoreConst.SYN_PAD_TIME_COMPLETE);
				}
				
			}else if(studyMateRoot == "false"){
				sendNotification(CoreConst.SYN_PAD_TIME_COMPLETE);
				trace("没权限，不同步");
			}
			
			
			
		}
		
	}
}