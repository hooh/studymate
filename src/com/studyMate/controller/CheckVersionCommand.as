package com.studyMate.controller
{
	import com.edu.EduAllExtension;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.global.OSType;
	
	import flash.desktop.NativeApplication;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.as3commons.logging.api.getLogger;
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import com.studyMate.utils.MyUtils;
	
	
	public final class CheckVersionCommand extends SimpleCommand implements ICommand
	{
		
	/*	private var apkv:ApkVersionExtension;
		private var pv:PackageVersionExtension;
		private var apk:ApkExecuteExtension*/
		public function CheckVersionCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			MyUtils.checkOS();
			if(Global.OS==OSType.ANDROID){
				
				
				/*apkv = new ApkVersionExtension();
				pv = new PackageVersionExtension();
				apk = new ApkExecuteExtension();*/
				//var apkv:ApkExecuteExtension = new ApkExecuteExtension();
				if(!checkAirVersion()){
					return;
				}
				
				//var result:String = apkv.execute(Global.document.nativePath+"/"+Global.localPath+"StudyMate.apk");
				var result:String = EduAllExtension.getInstance().apkVersionExtension(Global.document.nativePath+"/"+Global.localPath+"StudyMate.apk");
				
				if(result=="call failed"){
					sendNotification(CoreConst.CHECK_VERSION_COMPLETE);
				}else if(result==null){
					//缺少文件,要求强制更新
					//sendNotification(ApplicationFacade.PUSH_VIEW,new PushViewVO(EasyDownloadView));
					sendNotification(CoreConst.EASY_DOWNLOAD);
					
				}else{
					
					var currentVersion:String = getAppVersion();
					var arr:Array = currentVersion.split(".");
					var p1:String;
					
					if(arr[0]=="0"){
						
						if(arr[1]=="0"){
							currentVersion = arr[2];
						}else{
							currentVersion = arr[1]+("0000"+arr[2]).substr(-3);
						}
						
					}else{
						p1 = arr[0];
						currentVersion = arr[0]+("0000"+arr[1]).substr(-3)+("0000"+arr[2]).substr(-3);
					}
					
					var updateVersion:String = result;
					sendNotification(CoreConst.STARTUP_STEP_BEGIN,"check app version");
					if(updateVersion==currentVersion){
						getLogger(CheckVersionCommand).debug(currentVersion);
						if(checkEduService()){
							
							sendNotification(CoreConst.CHECK_VERSION_COMPLETE);
							
						}
					}else{
						
						//apk.execute(Global.document.nativePath+"/"+Global.localPath+"StudyMate.apk");
						EduAllExtension.getInstance().apkExecuteExtension(Global.document.nativePath+"/"+Global.localPath+"StudyMate.apk");
						Global.isUserExit = true;
						NativeApplication.nativeApplication.exit();
						
					}
					
					
				}
				
			}else{
				checkAirVersion();
				sendNotification(CoreConst.CHECK_VERSION_COMPLETE);
			}
			
		}
		
		private function checkAirVersion():Boolean{
			
			try
			{
				sendNotification(CoreConst.STARTUP_STEP_BEGIN,"check air version");
				var airVersionFile:File = Global.document.resolvePath(Global.localPath+"AdobeAIR2.ver");
				var stream:FileStream = new FileStream();
				stream.open(airVersionFile,FileMode.READ);
				
				var ver:String = stream.readUTFBytes(stream.bytesAvailable);
				
				//var airVersion:String = pv.execute("com.adobe.air");
				var airVersion:String = EduAllExtension.getInstance().packageVersionExtension("com.adobe.air");
//				if(NativeApplication.nativeApplication.runtimeVersion!=ver){
				if(airVersion == "call failed")
					return true;
				if(airVersion!=ver){
					var airPath:String = Global.document.nativePath+"/"+Global.localPath+"AdobeAIR.apk";
					//apk.execute(airPath);
					EduAllExtension.getInstance().apkExecuteExtension(airPath);
					Global.isUserExit = true;
					NativeApplication.nativeApplication.exit();
					return false;
				}
				stream.close();
				
			}
			catch(error:Error) 
			{
				
			}
			
			return true;
		}
		
		private function checkEduService():Boolean{
			
			//var installVersion:String = pv.execute("com.eduonline.service");
			var installVersion:String = EduAllExtension.getInstance().packageVersionExtension("com.eduonline.service");
			sendNotification(CoreConst.STARTUP_STEP_BEGIN,"check edu service version");
			//apkv = new ApkVersionExtension();
			
			var eduServicePath:String = Global.document.nativePath+"/"+Global.localPath+"eduService.apk";
			
			//var appVersion:String = apkv.execute(eduServicePath);
			var appVersion:String = EduAllExtension.getInstance().apkVersionExtension(eduServicePath);
			
			if(appVersion!=installVersion){
				
				//apk.execute(eduServicePath);
				EduAllExtension.getInstance().apkExecuteExtension(eduServicePath);
				Global.isUserExit = true;
				NativeApplication.nativeApplication.exit();
				return false;
			}
			
			return true;
			
		}
		
		private function getAppVersion():String {
			var appXml:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appXml.namespace();
			var appVersion:String = appXml.ns::versionNumber[0];
			return appVersion;
		}
		
		
	}
}