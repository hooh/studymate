package com.studyMate.controller
{
	import com.edu.EduAllExtension;
	import com.mylib.api.IConfigProxy;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.OSType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class SubPackInfoMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "SubPackInfoMediator";
		private var enPath:String = "appman/enPackList.p";
		private var disPath:String = "appman/disPackList.p";
		
		public function SubPackInfoMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		override public function onRemove():void
		{
			super.onRemove();
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case WorldConst.AUTO_SUB_PACKLIST :
					autoSubPacklist();
					break;
				case WorldConst.SUB_PACKLIST :
					subPacklist();
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.AUTO_SUB_PACKLIST, WorldConst.SUB_PACKLIST];
		}
		
		private function autoSubPacklist():void{
			if(Global.OS == OSType.WIN){
				sendNotification(WorldConst.REC_PACKLIST);
				return;
			}
			if(isGetPackage()){
				subPacklist();
			}else{
				sendNotification(WorldConst.REC_PACKLIST);
			}
		}
		
		private function subPacklist():void{
			getPackage();
			subPackage();
		}
		
		private function isGetPackage():Boolean{
			var today:Date = new Date(Global.nowDate.time);
			var config:IConfigProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CONFIGPROXY)  as IConfigProxy;
			var loginDateStr:String = config.getValue("UploadPackageList");
			if(loginDateStr == ""){
				config.updateValue("UploadPackageList",MyUtils.dateFormat(today));
				return true;
			}
			var year:int = parseInt(loginDateStr.substr(0,4));
			var month:int = parseInt(loginDateStr.substr(4,2));
			var day:int = parseInt(loginDateStr.substr(6,2));
			var loginDate:Date = new Date();
			loginDate.time = today.time;
			loginDate.setFullYear(year,month-1,day);
			var amongDay:int = (today.time - loginDate.time) / 1000 / 60 / 60 / 24;
			if(amongDay < 0 || amongDay > 1){
				config.updateValue("UploadPackageList",MyUtils.dateFormat(today));
				return true;
			}
			return false;
		}
		
		private function getPackage():void{
			EduAllExtension.getInstance().rootExecuteExtension("pm list package -e > /mnt/sdcard/edu/" + enPath);
			EduAllExtension.getInstance().rootExecuteExtension("pm list package -d > /mnt/sdcard/edu/" + disPath);
		}
		
		private function subPackage():void{
			var packageInfo:String = "";
			var file1:File = Global.document.resolvePath(Global.localPath + enPath);
			var file2:File = Global.document.resolvePath(Global.localPath + disPath);
			if(file1.exists && file2.exists){
				var stream:FileStream = new FileStream();
				stream.open(file1, FileMode.READ);
				var bytes:ByteArray = new ByteArray();
				stream.readBytes(bytes);
				stream.close();
				packageInfo = bytes.toString() + "#";
				
				stream.open(file2, FileMode.READ);
				var bytes2:ByteArray = new ByteArray();
				stream.readBytes(bytes2);
				stream.close();
				packageInfo += bytes2.toString();
				
				packageInfo = packageInfo.replace(/\n/g,";");
				packageInfo = packageInfo.replace(/package:/g,"");
			}
			var model:String = EduAllExtension.getInstance().getBuildModelFunction();
			
			PackData.app.CmdIStr[0] = CmdStr.SENDMACPACKAGELIST;
			PackData.app.CmdIStr[1] = Global.license.macid;
			PackData.app.CmdIStr[2] = PackData.app.head.dwOperID.toString() + "`" + model;
			PackData.app.CmdIStr[3] = packageInfo;
			PackData.app.CmdInCnt = 4;
			sendNotification(CoreConst.SEND_11, new SendCommandVO(WorldConst.REC_PACKLIST,null,"cn-gb",null,SendCommandVO.QUEUE));
			return;
		}
	}
}