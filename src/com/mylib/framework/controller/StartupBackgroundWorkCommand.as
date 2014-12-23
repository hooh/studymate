package com.mylib.framework.controller
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.CacheProxy;
	import com.mylib.framework.model.DataBaseProxy;
	import com.mylib.framework.model.FlowRecordProxy;
	import com.mylib.framework.model.SoundProxy;
	import com.mylib.framework.model.tcp.SocketProxy;
	import com.studyMate.controller.ConfigProxy;
	import com.studyMate.controller.FlowRecordCommand;
	import com.studyMate.controller.GetMacAddressCommand;
	import com.studyMate.controller.IPReaderProxy;
	import com.studyMate.controller.ReloginCommand;
	import com.studyMate.controller.ReloginCompleteCommand;
	import com.studyMate.controller.SaveTempFileMediator;
	import com.studyMate.controller.SendErrorCommand;
	import com.studyMate.controller.SocketInitCommand;
	import com.studyMate.controller.SoundPlayCommand;
	import com.studyMate.controller.SoundStopCommand;
	import com.studyMate.controller.login.LoginCommand;
	import com.studyMate.controller.login.LoginErrorCommand;
	import com.studyMate.controller.login.LoginFailCommand;
	import com.studyMate.controller.login.LoginSettingCommand;
	import com.studyMate.controller.login.LoginSuccessCommand;
	import com.studyMate.controller.login.VerifyLoginResultCommand;
	import com.studyMate.model.vo.tcp.PackData;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class StartupBackgroundWorkCommand extends SimpleCommand
	{
		public function StartupBackgroundWorkCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.registerCommand(CoreConst.SOCKET_INIT,SocketInitCommand);
			if(CONFIG::ARM){
				facade.registerCommand(CoreConst.BG_SEND,BGSendCommand);
			}else{
				facade.registerCommand(CoreConst.BG_SEND,TestBgSendCommand);
			}
			
			facade.registerCommand(CoreConst.LOGIN,LoginCommand);
			facade.registerCommand(CoreConst.LOGIN_SETTING,LoginSettingCommand);
			facade.registerCommand(CoreConst.VERIFY_LOGIN_RESULT,VerifyLoginResultCommand);
			facade.registerCommand(CoreConst.LOGIN_SUCCESS,LoginSuccessCommand);
			facade.registerCommand(CoreConst.LOGIN_ERROR,LoginErrorCommand);
			facade.registerCommand(CoreConst.LOGIN_FAIL,LoginFailCommand);
			facade.registerCommand(CoreConst.REQUEST_FILE_DATA,RequestFileDataCommand);
			facade.registerCommand(CoreConst.RELOGIN_COMPLETE,ReloginCompleteCommand);
			facade.registerCommand(CoreConst.SWITCH_NETWORK,SwitchNetworkCommand);
			facade.registerCommand(CoreConst.RELOGIN,ReloginCommand);
			facade.registerCommand(CoreConst.SEND_ERR,SendErrorCommand);
			facade.registerCommand(CoreConst.FLOW_RECORD,FlowRecordCommand);
			facade.registerCommand(CoreConst.STOP_REC,StopRecCommand);
			
			facade.registerCommand(CoreConst.CHECK_UPDATE_FILES,CheckUpdateFilesCommand);
			facade.registerCommand(CoreConst.OPER_UPDATE,OperUpdateCommand);
			PackData.app = new PackData;
			PackData.app.CmdIStr = new Array(255);
			PackData.app.CmdOStr = new Array(255);
			facade.registerProxy(new SocketProxy(SocketProxy.NAME,PackData.app));
			facade.registerProxy(new DataBaseProxy());
			facade.registerProxy(new CacheProxy());
			facade.registerProxy(new IPReaderProxy());
			facade.registerProxy(new FlowRecordProxy());
			Facade.getInstance(CoreConst.CORE).registerProxy(new FlowRecordProxy());
			
			/*facade.registerCommand(CoreConst.GET_MAC_ADDRESS,GetMacAddressCommand);
			sendNotification(CoreConst.GET_MAC_ADDRESS);*/
			
			facade.registerMediator(new SaveTempFileMediator());
			
			facade.registerProxy(new SoundProxy());
			facade.registerCommand(CoreConst.SOUND_PLAY,SoundPlayCommand);
			facade.registerCommand(CoreConst.SOUND_STOP,SoundStopCommand);
		}
		
	}
}