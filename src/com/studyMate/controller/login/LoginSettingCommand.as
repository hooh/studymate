package com.studyMate.controller.login
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.DataBaseProxy;
	import com.mylib.framework.model.tcp.SocketProxy;
	import com.mylib.framework.utils.DBTool;
	import com.studyMate.db.schema.Player;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.LicenseVO;
	import com.studyMate.model.vo.LoginSettingVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import org.as3commons.logging.api.getLogger;
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 *成功登录后 设置 
	 * @author hoohuayip
	 * 
	 */	
	public final class LoginSettingCommand extends SimpleCommand implements ICommand
	{
		
		override public function execute(notification:INotification):void
		{
						
			
			var vo:LoginSettingVO = notification.getBody() as LoginSettingVO;
			var socket:SocketProxy = facade.retrieveProxy(SocketProxy.NAME) as SocketProxy;
			var ostr:Array = socket.CmdOStr;
			
			PackData.app.head.dwOperID = parseInt(ostr[1]);
			PackData.app.key.dwRandomServer = parseInt(ostr[12]);
			
			
			
			Global.hasLogin = true;
									
			
			Global.cntsocket = uint(ostr[5]);
			vo.pack.head.dwReqCnt++;
			
			var db:DataBaseProxy = DBTool.proxy;
			
			if(Global.player==null){
				
				createPlayer();
				
			}else if(Global.player.userName!=Global.user){
				
				
				Global.player = db.playerDAO.findPlayerByUsername(Global.user);
				
				if(Global.player==null){
					createPlayer();
				}
				
			}
			
			saveLoginData(ostr[1],ostr[3],ostr[4],ostr[10],ostr[5],ostr[7],ostr[6]);
			if(Global.user!=Global.fixUserName){
				
				Global.player.password = Global.password;
				
				db.playerDAO.insert(Global.player);
				//var config:IConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
				
			}
			
			if(socket.CmdOutCnt==15){
				Global.license = new LicenseVO(null,ostr[13],ostr[14],vo.loginVO.mac);
			}
			
			
			
			if(vo.loginVO.updateType=="n"){
				sendNotification(vo.loginVO.completeNotice,vo.loginVO);
			}else{
				sendNotification(CoreConst.LOGIN_SETTING_COMPLETE,vo.loginVO.updateType);
			}
			
		}
		
		
		
		private function createPlayer():void{
			var player:Player = Global.player = new Player(); 
			Global.player.userName = Global.user;
			Global.player.password = Global.password;
			
			
		}
	
		
		public function saveLoginData(_operid:String,_region:String,_tokennext:String,_logincnt:String,_cntsocket:String,_playerName:String,_realName:String):void{
			var player:Player = Global.player;
			player.operId = _operid;
			player.region =_region;
			player.tokennext = _tokennext;
			player.logincnt = _logincnt;
			player.cntsocket = _cntsocket;
			player.name = _playerName;
			player.realName = _realName;
			player.savePassword = Global.savePassword;
			getLogger(LoginSettingCommand).debug("tokennext:"+_tokennext);
		}
	}
}