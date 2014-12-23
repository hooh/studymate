package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.CmdStr;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.vo.RegisterVO;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class RegisterDataMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "RegisterDataMediator";
		public static const REGISTER:String = NAME + "Register";
		public static const REGISTER_OPER:String = NAME + "RegisterOper";
		public static const REGISTER_STUDENT:String = NAME + "RegisterStudent";
		public static const REGISTER_ERR:String = NAME + "RegisterErr";
		public static const REGISTER_SUCCESS:String = NAME +　"RegisterSuccess";
		
		private var registerVO:RegisterVO;
		
		public function RegisterDataMediator(viewComponent:Object=null)
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
				case REGISTER : 
					registerVO = notification.getBody() as RegisterVO;
					registerOper(registerVO);
					break;
				case REGISTER_OPER : 
					if(result.isErr){
						var errNo:String = PackData.app.CmdOStr[0];
						if(errNo == "M02"){
							sendNotification(REGISTER_ERR, "登录账号已被注册，请换一个登录账号.");
						}
						trace("错误: " + errNo);
					}else{
						registerVO.operid = parseInt(PackData.app.CmdOStr[1]);
						registerStudent(registerVO);
					}
					break;
				case REGISTER_STUDENT : 
					if(result.isErr){
						sendNotification(REGISTER_ERR, "注册失败.");
					}else{
						sendNotification(REGISTER_SUCCESS);
					}
					break;
				default : 
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [REGISTER, REGISTER_OPER, REGISTER_STUDENT];
		}
		
		private function registerOper(r:RegisterVO):void{
			PackData.app.CmdIStr[0] = CmdStr.REGISTER_OPER_ID;
			PackData.app.CmdIStr[1] = r.loginName;
			PackData.app.CmdIStr[2] = "gdgz";
			PackData.app.CmdInCnt = 3;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(REGISTER_OPER));
		}
		
		private function registerStudent(r:RegisterVO):void{
			PackData.app.CmdIStr[0] = CmdStr.REGISTER_STUDENT;
			PackData.app.CmdIStr[1] = r.operid.toString();
			PackData.app.CmdIStr[2] = r.loginName;
			PackData.app.CmdIStr[3] = r.nickName;
			PackData.app.CmdIStr[4] = r.realName;
			PackData.app.CmdIStr[5] = r.telephone;
			PackData.app.CmdIStr[6] = r.password;
			PackData.app.CmdIStr[7] = r.birthday;
			PackData.app.CmdIStr[8] = "0";
			PackData.app.CmdIStr[9] = "";
			PackData.app.CmdIStr[10] = "";
			PackData.app.CmdIStr[11] = "";
			PackData.app.CmdIStr[12] = "";
			PackData.app.CmdIStr[13] = "";
			PackData.app.CmdIStr[14] = "";
			PackData.app.CmdIStr[15] = "";
			PackData.app.CmdIStr[16] = "";
			PackData.app.CmdIStr[17] = "";
			PackData.app.CmdIStr[18] = r.sex.toString();
			PackData.app.CmdIStr[19] = "";
			PackData.app.CmdIStr[20] = r.entranceDelta.toString();
			PackData.app.CmdInCnt = 21;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(REGISTER_STUDENT));
		}
		
	}
}