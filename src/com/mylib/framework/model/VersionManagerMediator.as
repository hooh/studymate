package com.mylib.framework.model
{
	import com.edu.EduAllExtension;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.InstallListVO;
	import com.studyMate.global.Global;
	import com.studyMate.global.OSType;
	import com.studyMate.model.vo.InstallAppCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.utils.MyUtils;
	
	import flash.desktop.NativeApplication;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class VersionManagerMediator extends Mediator implements IMediator
	{
		
		public function VersionManagerMediator(viewComponent:Object=null)
		{
			super(ModuleConst.VERSION_MANAGER, viewComponent);
		}
		
		override public function onRegister():void
		{
			loadInstall();
			
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case CoreConst.CHECK_APP_VERSION:
					
					
					
					MyUtils.checkOS();
					
					
					checkAirVersion();
					
					
					break;
				case CoreConst.INSTALL_SYS_APP_COMPLETE:
					
					var flag:String = notification.getBody() as String;
					
					//安装成功
					if(flag == "success"){
						
						sendNotification(CoreConst.STARTUP_STEP_BEGIN,currentAPK+" 安装完成");
						
						checkListVersion();
						
						
					}else{
						//静默安装失败，改用手动安装
						
						installByWindow(Global.document.nativePath+"/"+Global.localPath+currentAPK);
						
					}
					break;
				
				
				
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [CoreConst.CHECK_APP_VERSION,CoreConst.INSTALL_SYS_APP_COMPLETE];
		}
		
		private function checkAirVersion():void{
			
			if(Global.OS==OSType.ANDROID){
				
				//检查air版本号
				if(!checkAppVersion()){
					return;
				}
				
				checkStudyMateVersion();
				
				
				
				
			}else{
				sendNotification(CoreConst.CHECK_VERSION_COMPLETE);
			}
		}
		
		
		/**
		 * 检查air版本号 
		 * @param _appName
		 * @return 
		 * 
		 */		
		private function checkAppVersion(_appName:String=""):Boolean{
			try
			{
				sendNotification(CoreConst.STARTUP_STEP_BEGIN,"检查 air 版本");
				var airVersionFile:File = Global.document.resolvePath(Global.localPath+"AdobeAIR2.ver");
				var stream:FileStream = new FileStream();
				stream.open(airVersionFile,FileMode.READ);
				
				//文件内，标准版本号
				var ver:String = stream.readUTFBytes(stream.bytesAvailable);
				stream.close();
				
				var airVersion:String = EduAllExtension.getInstance().packageVersionExtension("com.adobe.air");
				
				if(airVersion == "call failed")
					return true;
				if(airVersion!=ver){
					var airPath:String = Global.document.nativePath+"/"+Global.localPath+"AdobeAIR.apk";

					EduAllExtension.getInstance().apkExecuteExtension(airPath);
					Global.isUserExit = true;
					NativeApplication.nativeApplication.exit();
					return false;
				}
				
			}
			catch(error:Error) 
			{
				
			}
			
			return true;
		}
		
		/**
		 *检查StudyMate版本号 
		 * 
		 */		
		private function checkStudyMateVersion():void{
			sendNotification(CoreConst.STARTUP_STEP_BEGIN,"检查 StudyMate 版本");
			
			var studyMateVersion:String = EduAllExtension.getInstance().apkVersionExtension(Global.document.nativePath+"/"+Global.localPath+"StudyMate.apk");
			
			if(studyMateVersion=="call failed"){
				sendNotification(CoreConst.CHECK_VERSION_COMPLETE);
			}else if(studyMateVersion==null){
				//缺少文件,要求强制更新
//				sendNotification(CoreConst.EASY_DOWNLOAD);
				sendNotification(CoreConst.CHECK_VERSION_COMPLETE);
			}else{
				
				var currentVersion:String = getXmlVersion();
				var arr:Array = currentVersion.split(".");
				
				if(arr[0]=="0"){
					
					if(arr[1]=="0"){
						currentVersion = arr[2];
					}else{
						currentVersion = arr[1]+("0000"+arr[2]).substr(-3);
					}
					
				}else{
					currentVersion = arr[0]+("0000"+arr[1]).substr(-3)+("0000"+arr[2]).substr(-3);
				}
				
				
				//版本相同，不用更新StudyMate，检查eduserver版本号
				if(studyMateVersion==currentVersion){
					
					//根据列表检查各程序版本
					checkListVersion();
					
					
				}else{
					
					
					installByWindow(Global.document.nativePath+"/"+Global.localPath+"StudyMate.apk");
					
				}
			}
		}
		
		//列表程序版本检查
		private function checkListVersion():void{
			
			var isFinish:Boolean = true;
			
			for(var i:int=0;i<instllList.length;i++){
				
				//版本相同，不用更新，检查下一个
				if(checkList(instllList[i]))
					continue;
				else{
					
					isFinish = false;
					break;
					
				}
			}
			
			if(isFinish)
				sendNotification(CoreConst.CHECK_VERSION_COMPLETE);
			
		}
		
		
		
		
		
		
		private var currentAPK:String = "";
		
		/**
		 *检查列表程序版本号 
		 * @return 
		 * 
		 */
		private function checkList(_installVO:InstallListVO):Boolean{
			sendNotification(CoreConst.STARTUP_STEP_BEGIN,"检查 "+_installVO.apkName+" 版本");
			
			//检查apk文件是否存在
			var apkFile:File = Global.document.resolvePath(Global.localPath+_installVO.apkName);
			if(!apkFile.exists){
				//缺少文件,要求强制更新
//				sendNotification(CoreConst.EASY_DOWNLOAD,apkFile.nativePath);
				
				return true;
			}
			
			var packageVersion:String = EduAllExtension.getInstance().packageVersionExtension(_installVO.packName);
			var apkPath:String = Global.document.nativePath+"/"+Global.localPath+_installVO.apkName;
			var apkVersion:String = EduAllExtension.getInstance().apkVersionExtension(apkPath);

			//版本号不对，需要安装
			if(apkVersion!=packageVersion){
				
				if(currentAPK =="" || currentAPK != _installVO.apkName){
					currentAPK = _installVO.apkName;
					
					sendNotification(CoreConst.STARTUP_STEP_BEGIN,"正在"+_installVO.installType+"操作安装 "+_installVO.apkName+"......");
					//自动安装
					if(_installVO.installType == "A")
						//采用静默安装
						installBySilent(apkPath);
						
					else if(_installVO.installType == "M")
						//手动安装
						installByWindow(apkPath);
					
					
				}else if(currentAPK == _installVO.apkName){
					//还是安装同一个程序，有可能静默安装失败，执行手动安装
					
					
					installByWindow(apkPath);
					
				}
				return false;
			}
			
			return true;
			
		}
		
		
		
		
		
		//根据studymate的xml文件取版本号
		private function getXmlVersion():String {
			var appXml:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appXml.namespace();
			var appVersion:String = appXml.ns::versionNumber[0];
			return appVersion;
		}
		
		
		
		//窗口安装
		private function installByWindow(_path:String):void{
			
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.INSTALL_APP_COMMAND,new InstallAppCommandVO("M",_path,CoreConst.INSTALL_SYS_APP_COMPLETE));
			
		}
		//静默安装
		private function installBySilent(_path:String):void{
			
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.INSTALL_APP_COMMAND,new InstallAppCommandVO("A",_path,CoreConst.INSTALL_SYS_APP_COMPLETE));
			
		}
		
		
		
		
		private var InstallFile:File = Global.document.resolvePath(Global.localPath+"systemFile/installList.edu");
		private var instllList:Vector.<InstallListVO> = new Vector.<InstallListVO>;
		//读取安装列表
		private function loadInstall():void{
			
			var stream:FileStream = new FileStream();
			if(InstallFile.exists){
				stream.open(InstallFile,FileMode.READ);
				var str:String = stream.readMultiByte(stream.bytesAvailable,PackData.BUFF_ENCODE);
				
				var strArr:Array = str.split("\r\n");
				
				var installVO:InstallListVO;
				var itemArr:Array;
				for(var i:int=0;i<strArr.length;i++){
					
					if(strArr[i] != ""){
						
						itemArr = strArr[i].split("|");
						trace(itemArr[0]+"|"+itemArr[0]+"|"+itemArr[0]+"|");
						installVO = new InstallListVO(itemArr[0],itemArr[1],itemArr[2]);
						
						instllList.push(installVO);
					}
					
				}
				stream.close();
			}else{
				stream.open(InstallFile,FileMode.WRITE);
				stream.writeMultiByte("\r\n",PackData.BUFF_ENCODE);
				stream.close();
				
			}
			
			
			
			
		}
		
		
		
		
		override public function onRemove():void
		{
//			TweenLite.killTweensOf(installByWindow);
		}
		
		
		
		
		
	}
}