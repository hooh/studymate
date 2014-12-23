package com.studyMate.world.controller
{
	import com.greensock.TimelineMax;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Linear;
	import com.greensock.plugins.EndArrayPlugin;
	import com.greensock.plugins.PhysicsPropsPlugin;
	import com.greensock.plugins.RoundPropsPlugin;
	import com.greensock.plugins.TransformAroundCenterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.text.SplitTextField;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.controller.AddCpuScreenDataCommand;
	import com.mylib.framework.controller.AddGpuScreenDataCommand;
	import com.mylib.framework.controller.BatchUpdaterMediator;
	import com.mylib.framework.controller.CancelSwitchCommand;
	import com.mylib.framework.controller.CleanScreenCommand;
	import com.mylib.framework.controller.CommitUpdateCommand;
	import com.mylib.framework.controller.ContinuteFileDownloadCommand;
	import com.mylib.framework.controller.LibInitializedCommand;
	import com.mylib.framework.controller.LoadInitLibCommand;
	import com.mylib.framework.controller.LoginFailUICommand;
	import com.mylib.framework.controller.MoveTempFileCommand;
	import com.mylib.framework.controller.PopScreenCommand;
	import com.mylib.framework.controller.RemoveUpdateFileCommand;
	import com.mylib.framework.controller.ScreenAssetsLoadedCommand;
	import com.mylib.framework.controller.ScreenPrepareCompleteCommand;
	import com.mylib.framework.controller.ScreenPrepareDataCompleteCommand;
	import com.mylib.framework.controller.ScreenPrepareReadyCommand;
	import com.mylib.framework.controller.SwitchModuleMediator;
	import com.mylib.framework.controller.SwitchScreenCommand;
	import com.mylib.framework.model.BeatMediator;
	import com.mylib.framework.model.ModuleManagerMediator;
	import com.mylib.framework.model.PrepareViewProxy;
	import com.mylib.framework.model.SilentRequestMediator;
	import com.mylib.framework.model.SwitchScreenProxy;
	import com.studyMate.controller.CheckEduServiceSUCommand;
	import com.studyMate.controller.CheckLogTmCommand;
	import com.studyMate.controller.CheckSUCommand;
	import com.studyMate.controller.CheckTimeLimitCommand;
	import com.studyMate.controller.EasyDownloadCommand;
	import com.studyMate.controller.ExecuteGameServiceCommand;
	import com.studyMate.controller.GetSerTimeCommand;
	import com.studyMate.controller.GetUpdateListCommand;
	import com.studyMate.controller.IPReaderProxy;
	import com.studyMate.controller.InstallAppCommand;
	import com.studyMate.controller.InupPadInfoCommand;
	import com.studyMate.controller.LicenseProxy;
	import com.studyMate.controller.RecUpdateListCommand;
	import com.studyMate.controller.RegisterPadCommand;
	import com.studyMate.controller.SaveLicenseCommand;
	import com.studyMate.controller.ServerRegisterCommand;
	import com.studyMate.controller.ServerRegisterRecCommand;
	import com.studyMate.controller.SynPadTimeCommand;
	import com.studyMate.controller.UpdateGameServiceCommand;
	import com.studyMate.model.GameServiceProxy;
	import com.studyMate.view.component.Physics2DPlugin;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ConfigWorldModelCommand extends SimpleCommand implements ICommand
	{
		public function ConfigWorldModelCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			sendNotification(CoreConst.STARTUP_STEP_BEGIN,"注册界面显示模块");
			
			facade.registerCommand(WorldConst.SWITCH_SCREEN,SwitchScreenCommand);
			facade.registerCommand(WorldConst.SCREEN_PREPARE_READY,ScreenPrepareReadyCommand);
			facade.registerCommand(WorldConst.SCREEN_PREPARE_COMPLETE,ScreenPrepareCompleteCommand);
			facade.registerCommand(WorldConst.SCREEN_ASSETS_LOADED,ScreenAssetsLoadedCommand);
			facade.registerCommand(WorldConst.POP_SCREEN,PopScreenCommand);
			facade.registerCommand(WorldConst.CLEAN_SCREEN,CleanScreenCommand);
			facade.registerCommand(WorldConst.SCREEN_PREPARE_DATA_COMPLETE,ScreenPrepareDataCompleteCommand);
			facade.registerCommand(WorldConst.REMOVE_GPU_LIBS,RemoveGpuLibsCommand);
			facade.registerCommand(WorldConst.ADD_GPU_SCREEN_DATA,AddGpuScreenDataCommand);
			facade.registerCommand(WorldConst.ADD_CPU_SCREEN_DATA,AddCpuScreenDataCommand);
			facade.registerCommand(WorldConst.BUILD_THEME,BuildThemeCommand);
			facade.registerCommand(WorldConst.LOAD_INIT_LIB,LoadInitLibCommand);
			facade.registerCommand(WorldConst.ENABLE_GPU_SCREENS,EnableGpuScreensCommand);
			facade.registerCommand(WorldConst.ALERT_SHOW,AlertShowCommand);
			facade.registerCommand(CoreConst.SHOW_STARTUP_LOADING,ShowStartupLoadingCommand);
			facade.registerCommand(CoreConst.HIDE_STARTUP_LOADING,HideStartupLoadingCommand);
			facade.registerCommand(CoreConst.CANCEL_SWITCH,CancelSwitchCommand);
			facade.registerCommand(CoreConst.LIB_INITIALIZED,LibInitializedCommand);
			facade.registerCommand(CoreConst.LOGIN_FAIL,LoginFailUICommand);
			facade.registerCommand(CoreConst.REGISTER_PAD,RegisterPadCommand);
			facade.registerCommand(CoreConst.INSTALL_APP_COMMAND,InstallAppCommand);
			facade.registerCommand(CoreConst.CHECK_APP_ROOT,CheckSUCommand);
			facade.registerCommand(CoreConst.CHECK_EDUSERVICE_ROOT,CheckEduServiceSUCommand);
//			facade.registerCommand(CoreConst.CHECK_LOGIN_TIME,CheckLogTmCommand);
			facade.registerCommand(WorldConst.HIDE_SCREEN,HideScreenCommand);
			
			facade.registerCommand(CoreConst.GET_SER_TIME,GetSerTimeCommand);
			facade.registerCommand(CoreConst.SYN_PAD_TIME,SynPadTimeCommand);
			facade.registerCommand(CoreConst.UPDATE_GAME_SERVICE,UpdateGameServiceCommand);
			facade.registerCommand(CoreConst.EXECUTE_GAME_SERVICE,ExecuteGameServiceCommand);
			facade.registerCommand(CoreConst.EASY_DOWNLOAD,EasyDownloadCommand);
			facade.registerCommand(CoreConst.INUP_PAD_INFO,InupPadInfoCommand);
			
			facade.registerCommand(CoreConst.SERVER_REGISTER,ServerRegisterCommand);
			facade.registerCommand(CoreConst.SAVE_LICENSE,SaveLicenseCommand);
			facade.registerCommand(CoreConst.SERVER_REGISTER_REC,ServerRegisterRecCommand);
			facade.registerCommand(CoreConst.GET_UPDATE_LIST,GetUpdateListCommand);
			facade.registerCommand(CoreConst.REC_UPDATE_LIST,RecUpdateListCommand);
			
			facade.registerCommand(CoreConst.CONTINUTE_FILE_DOWNLOADED,ContinuteFileDownloadCommand);
			facade.registerCommand(CoreConst.COMMIT_UPDATE,CommitUpdateCommand);
			facade.registerCommand(CoreConst.REMOVE_UPDATE_FILE,RemoveUpdateFileCommand);
			facade.registerCommand(CoreConst.OPER_TEMP_FILE,MoveTempFileCommand);
			facade.registerCommand(WorldConst.CHECK_TIME_LIMIT,CheckTimeLimitCommand);
			
			facade.registerProxy(new PrepareViewProxy());
			facade.registerProxy(new SwitchScreenProxy());
			facade.registerProxy(new GameServiceProxy());
			facade.registerMediator(new SwitchModuleMediator);
			facade.registerProxy(new IPReaderProxy());
			facade.registerProxy(new LicenseProxy);
			
			facade.registerMediator(new BatchUpdaterMediator);
			facade.registerMediator(new BeatMediator);
			facade.registerMediator(new SilentRequestMediator);
			
			
			TimelineMax;
			SplitTextField;
			Elastic;
			Circ;
			Linear;
			TweenPlugin.activate([PhysicsPropsPlugin,RoundPropsPlugin,com.studyMate.view.component.Physics2DPlugin,EndArrayPlugin,TransformAroundCenterPlugin]);
		}
		
	}
}