package com.studyMate.world.model
{
	import com.mylib.api.IConfigProxy;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PerConfigManagerMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PerConfigManagerMediator";
		public static const SEND_CONFIG:String = NAME + "SendConfig";
		public static const GET_CONFIG:String = NAME + "GetConfig";
		
		public function PerConfigManagerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void{
			super.onRegister();
		}
		
		override public function onRemove():void{
			super.onRemove();
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case WorldConst.SEND_PER_CONFIG :
					sendCommand();
					break;
				case WorldConst.GET_PER_CONFIG : 
					getPerConfig();
					break;
				case SEND_CONFIG :
					if(!result.isErr){
						sendNotification(WorldConst.GET_PER_CONFIG_OVER);
					}
					break;
				case GET_CONFIG :
					if(!result.isErr){
						var config:String = PackData.app.CmdOStr[2];
						cmpConfigVer(config);
					}
					break;
				default :
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.SEND_PER_CONFIG, WorldConst.GET_PER_CONFIG, SEND_CONFIG, GET_CONFIG];
		}
		
		private function sendCommand():void{
			var configUtils:IConfigProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CONFIGPROXY)  as IConfigProxy;
			var today:Date = new Date(Global.nowDate.time);
			configUtils.updateValueInUser("UpConfigTime", MyUtils.dateFormat(today));
			var configStr:String = configUtils.getUserConfig(Global.user);
			sendPerConfig(configStr);
		}
		
		private function updateFileConfig(userConfig:String):void{
			var configUtils:IConfigProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CONFIGPROXY)  as IConfigProxy;
			configUtils.updateUserConfig(Global.user, userConfig);
		}
		
		private function cmpConfigVer(config:String):void{
			if(needUpload(config)){ //上传
				sendCommand();
			}else{ //下载
				updateFileConfig(config);
				sendNotification(WorldConst.GET_PER_CONFIG_OVER);
			}
		}
		
		private function needUpload(configStr:String):Boolean{ //true上传 	 false下载
			if(configStr == "") return true;
			try{
				var configXml:XML = new XML(configStr);
			}catch(error:Error) {
				return true;
			}
			
			var config:IConfigProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CONFIGPROXY)  as IConfigProxy;
			var localVer:String = config.getValueInUser("UpConfigTime");
			if(localVer == "") return false;
			var serverVer:String = configXml["UpConfigTime"];
			if(serverVer == localVer) return true;
			return false;
		}
		
		private function sendPerConfig(config:String):void{
			PackData.app.CmdIStr[0] = CmdStr.SEND_PER_CONFIG;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = config;
			PackData.app.CmdInCnt = 3;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(SEND_CONFIG,null,"cn-gb",null,SendCommandVO.QUEUE));
		}
		
		private function getPerConfig():void{
			PackData.app.CmdIStr[0] = CmdStr.GET_PER_CONFIG;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 2;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(GET_CONFIG,null,"cn-gb",null,SendCommandVO.QUEUE));
		}
		
	}
}