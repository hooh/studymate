package com.studyMate.controller
{
	//	import com.greensock.plugins.PhysicsPropsPlugin;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.controller.AssetSaveCommand;
	import com.mylib.framework.controller.AssetsLoadCommand;
	import com.mylib.framework.controller.FileLoadCommand;
	import com.mylib.framework.controller.LoadNextLibCommand;
	import com.mylib.framework.controller.LoadSwfBytes;
	import com.mylib.framework.controller.LocalFilesLoadCommand;
	import com.mylib.framework.controller.LocalFilesLoadUpdateCompleteCommand;
	import com.mylib.framework.controller.SettingCommand;
	import com.mylib.framework.controller.UpdateAssetsCommand;
	import com.mylib.framework.controller.UpdateFilesCommand;
	import com.mylib.framework.controller.UpdateLibCommand;
	import com.mylib.framework.controller.UpdateSingleFileCompleteCommand;
	import com.mylib.framework.model.AssetLibProxy;
	import com.mylib.framework.model.CacheProxy;
	import com.mylib.framework.model.DataBaseProxy;
	import com.mylib.framework.model.FileLoadProxy;
	import com.mylib.framework.model.ModuleManagerMediator;
	import com.mylib.framework.model.OperRecordProxy;
	import com.mylib.framework.model.TimeProxy;
	import com.mylib.framework.model.UpdateProxy;
	import com.mylib.framework.model.UploadProxy;
	import com.mylib.framework.model.VideoConfigProxy;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class ModelPrepCommand extends SimpleCommand implements ICommand
	{
		public function ModelPrepCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeCommand(CoreConst.WORKER_RUNNING);
			sendNotification(CoreConst.STARTUP_STEP_BEGIN,"注册核心功能");
			
			
			/*----------------------------------命令-------------------------------------------*/
			facade.registerCommand(CoreConst.FIX,FixCommand);
			facade.registerCommand(CoreConst.FILE_LOAD,FileLoadCommand);
//			facade.registerCommand(CoreConst.SOUND_PLAY,SoundPlayCommand);
			facade.registerCommand(CoreConst.ASSETS_SAVE,AssetSaveCommand);
			facade.registerCommand(CoreConst.RECEIVE_ERROR,ReceiveErrorCommand);
//			facade.registerCommand(CoreConst.SOUND_STOP,SoundStopCommand);
			facade.registerCommand(CoreConst.UPDATE_LIB,UpdateLibCommand);
			facade.registerCommand(CoreConst.LOAD_NEXT_LIB,LoadNextLibCommand);
			facade.registerCommand(CoreConst.TOAST,ToastCommand);
			facade.registerCommand(CoreConst.ASSETS_LOAD,AssetsLoadCommand);
			facade.registerCommand(CoreConst.LOAD_SWF_BYTES,LoadSwfBytes);
			facade.registerCommand(CoreConst.REMOTE_FILE_LOAD,RemoteFileLoadCommand);
			facade.registerCommand(CoreConst.UPDATE_SINGLE_FILE_COMPLETE,UpdateSingleFileCompleteCommand);
			facade.registerCommand(CoreConst.INITIALIZE_ASSETS_CONFIG,InitializeAssetsConfigCommand);
			facade.registerCommand(CoreConst.UPDATE_FILES,UpdateFilesCommand);
			facade.registerCommand(CoreConst.LOCAL_FILES_LOAD,LocalFilesLoadCommand);
			facade.registerCommand(CoreConst.LOCAL_FILES_LOAD_UPDATE_COMPLETE,LocalFilesLoadUpdateCompleteCommand);
			facade.registerCommand(CoreConst.LOGIN_SETTING_COMPLETE,CheckLicenseCommand);
			
			facade.registerCommand(CoreConst.UPDATE_ASSETS,UpdateAssetsCommand);
			facade.registerCommand(CoreConst.CHECK_VERSION,CheckVersionCommand);
			facade.registerCommand(CoreConst.CHECK_VERSION_COMPLETE,CheckVersionCompleteCommand);
			
			//			facade.registerCommand(CoreConst.SEND_ERR,SendErrorCommand);
			facade.registerCommand(WorldConst.DISPOSE_CHECK_SOCKET,DisposeCheckSocketCommand);
			facade.registerCommand(WorldConst.CHECK_SOCKET_CONNECT, CheckSocketCommand);
			facade.registerCommand(CoreConst.SEND_JUMP_URI,SendJumpUriCommand);
			facade.registerCommand(CoreConst.INIT_ROOT,InitRootCommand);
			
			facade.registerCommand(CoreConst.START_SETTING,SettingCommand);
			facade.registerCommand(CoreConst.FLOW_RECORD,FlowRecordCommand);
			
			/*----------------------------------业务模块-------------------------------------------*/
			
			//			facade.registerProxy(new SocketProxy(SocketProxy.NAME,PackData.app=new PackData));
			//			facade.registerProxy(new SocketProxy(SocketProxy.IM_NAME,PackData.im));
			//facade.registerProxy(new SharedObjectProxy());
			//facade.registerProxy(new ScriptEngineProxy());
			
			facade.registerProxy(new DataBaseProxy());
			facade.registerProxy(new CacheProxy());
			facade.registerProxy(new FileLoadProxy());
			facade.registerProxy(new AssetLibProxy());
			facade.registerProxy(new UpdateProxy());
			facade.registerProxy(new TimeProxy());
			facade.registerProxy(new UploadProxy());
			
			facade.registerProxy(new OperRecordProxy);
			
			facade.registerMediator(new ModuleManagerMediator);
			facade.registerProxy(new VideoConfigProxy);
			
			
			//			facade.registerProxy(new RecorderProxy());
			//			facade.registerProxy(new TTSProxy());
			
			sendNotification(CoreConst.START_SETTING);
			
			facade.registerCommand(CoreConst.GET_MAC_ADDRESS,GetMacAddressCommand);
			sendNotification(CoreConst.GET_MAC_ADDRESS);
			
			
		}
		
		
	}
}