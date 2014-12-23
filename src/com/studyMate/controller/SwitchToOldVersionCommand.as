package com.studyMate.controller
{
	import com.edu.EduAllExtension;
	import com.studyMate.global.Global;
	
	import flash.desktop.NativeApplication;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class SwitchToOldVersionCommand extends SimpleCommand
	{
		public function SwitchToOldVersionCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			//var pv:PackageVersionExtension = new PackageVersionExtension();
			//var apk:ApkExecuteExtension = new ApkExecuteExtension();
			
		//	var installVersion:String = pv.execute("air.com.eduOnline2011");
			var installVersion:String = EduAllExtension.getInstance().packageVersionExtension("air.com.eduOnline2011");
			
			//var apkv:ApkVersionExtension = new ApkVersionExtension();
			
			var oldVerPath:String = Global.document.nativePath+"/"+Global.localPath+"StudyMate2011.apk";
			
			//var appVersion:String = apkv.execute(oldVerPath);
			var appVersion:String = EduAllExtension.getInstance().apkVersionExtension(oldVerPath);
			//var launcher:LaunchAppExtension = new LaunchAppExtension;
			
			if(appVersion!=installVersion){
				
				EduAllExtension.getInstance().apkExecuteExtension(oldVerPath);
				
			}else{
				Global.isUserExit = true;
				EduAllExtension.getInstance().launchAppExtension("air.com.eduOnline2011","");
				NativeApplication.nativeApplication.exit();
				
			}
			
			
			
			
		}
		
	}
}