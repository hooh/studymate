package com.studyMate.controller.login
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.ShareConst;
	import com.mylib.framework.model.DataBaseProxy;
	import com.mylib.framework.model.tcp.SocketProxy;
	import com.mylib.framework.utils.DBTool;
	import com.studyMate.db.schema.Player;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.LoginVO;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	
	import org.as3commons.logging.api.getLogger;
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 *发送登录命令 
	 * @author hoohuayip
	 * 
	 */	
	public final class LoginCommand extends SimpleCommand implements ICommand
	{
		public static const NAME:String = "LoginCommand";
		
		override public function execute(notification:INotification):void
		{
			var vo:LoginVO = notification.getBody() as LoginVO;
			
			if(vo.userName==""||vo.userName==null){
				sendNotification(CoreConst.TOAST,new ToastVO("用户名不能为空"));
				return;
			}
			
			if(vo.password==""||vo.password==null){
				sendNotification(CoreConst.TOAST,new ToastVO("用户名密码不能为空"));
				return;
			}
			
			
			var db:DataBaseProxy = DBTool.proxy;
			
			//换用户登录，数据库没有默认用户
			
			var newPlayer:Player = db.playerDAO.findPlayerByUsername(vo.userName);
			if(Global.player&&vo.userName!=Global.player.userName||Global.player==null){
				Global.player = newPlayer;
			}
			
			
			if(vo.type== "AB"||vo.type== "B0"){
				//新登录	
				var proxy:SocketProxy = facade.retrieveProxy(SocketProxy.NAME) as SocketProxy;
				//proxy.setReceiveNotification(vo.completeNotice);
				sendNotification(CoreConst.FLOW_RECORD,new RecordVO("login cmd","",0));
				proxy.setReceiveNotification(CoreConst.VERIFY_LOGIN_RESULT);
				proxy.CmdIStr[0] = CmdStr.ABLOGIN_ChkPasswd;
				sendNotification(CoreConst.FLOW_RECORD,new RecordVO("PackData.app.CmdIStr[0]",PackData.app.CmdIStr[0],0));
				
				//B登录
				//本地有存储用户数据和用相同帐号重复登录
				
				var isA:Boolean;
				
				if(Global.player){
					
					if(Global.hasLogin&&Global.user==(vo.userName)){
						isA = false;
					}else if(Global.hasLogin&&Global.user!=(vo.userName)){
						isA = true;
					}else{
						isA = false;
					}
					
					
					
				}else{
					isA= true;
				}
				
		
				
				if(!isA){
					PackData.app.head.dwOperID = uint(Global.player.operId);
					getLogger(LoginCommand).debug("B");
					
					getLogger(LoginCommand).debug("-----------------------"+Global.player.logincnt);
					
					PackData.app.key.dwRandomClient = Number(Global.player.logincnt);
					PackData.app.key.dwRandomServer = Number(Global.player.tokennext);
					PackData.app.dwSector = Global.cntsocket;
					PackData.app.setBLogin(Global.player.region);
				}else{
					//A登录
					
					getLogger(LoginCommand).debug("A");
					PackData.app.head.dwOperID = 0;
					PackData.app.key.dwRandomClient = 0x0927;
					PackData.app.dwSector = 0;
					//设置服务端密匙
					PackData.app.key.dwRandomServer = PackData.LOGIN_dwRandomServer;//0x20110808;
					PackData.app.setALogin();
				}
				
				
				if(vo.type== "B0"){
					PackData.app.head.dwReqCnt = 0;
					PackData.app.dwSector = 0;
				}
				
				
				
				var address:String;
//				vo.mac = address = Global.address;
				vo.mac = address = Global.getSharedProperty(ShareConst.ADDRESS);
				
				
				proxy.CmdIStr[1] = vo.userName;
				proxy.CmdIStr[2] = vo.password;
				proxy.CmdIStr[3] = PackData.app.key.dwRandomClient.toString();
				proxy.CmdIStr[4] = address;
				proxy.CmdInCnt = 5;
				
				proxy.receiveNotificationPara = [vo];
				sendNotification(CoreConst.FLOW_RECORD,new RecordVO("send login cmd",PackData.app.CmdIStr[0],0));
				proxy.sendLoginCmd();
			}
		}
		
	}
}