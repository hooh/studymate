package com.mylib.framework
{
	
	
	
	public final class CoreConst
	{
		public static const NAME:String = "Core"; 
		
		public static const CORE:String = "core";
		
		public static const BACKGROUND:String = "background";
		

		/*命令名*/
		//启动
		public static const STARTUP:String = NAME + "Startup";
		//视图切换
		public static const MEDIATE_VIEW:String = NAME + "MediateView";
		//socket初始化
		public static const SOCKET_INIT:String = NAME + "SocketInit";
		//文件加载
		public static const FILE_LOAD:String = NAME + "loadFile";
		
		
		/**
		 *素材加载 
		 */		
		public static const ASSETS_LOAD:String = NAME + "assetsLoad";
		
		
		//public static const EXECUSE_SCRIPT:String = NAME + "execuseScript";//老界面的绘本显示命令
		public static const EXECUSE_SCRIPT_NEW:String = NAME + "execusescriptnew";//新的界面
				
		
		
		
		
		
		
		/**
		 * 声音播放
		 */
		public static const SOUND_PLAY:String = NAME + "soundPlay";
		
		/**
		 *声音停止 
		 */		
		public static const SOUND_STOP:String = NAME + "soundStop";
		
		public static const SOUND_LOAD_KILL:String = NAME + "soundLoadKill";
		
		
		
		public static const IM_LOGIN:String = NAME + "imLogin";
		
		
		/**
		 * 保存素材
		 */
		public static const ASSETS_SAVE:String = NAME + "assetsSave";
		
		/**
		 *调出IM 
		 */		
		public static const CALL_IM:String = NAME + "callIM";
		
		/**
		 *关闭IM
		 **/
		public static const CLOSE_IM:String=NAME+"closeIM";
		
		/**
		 *弹出窗口
		 **/
		public static const CALL_ALERT:String = NAME+"callAlert";
		
		public static const SEND_11:String = NAME + "send11";
		public static const SEND_1N:String = NAME + "send1N";
		public static const BEAT:String = NAME + "beat";
		public static const BEATING:String = NAME + "beating";
		
		public static const LOGIN:String = NAME + "login";
		
		public static const READ_BUFF:String = NAME + "readBuff";
		
		public static const START_TIMER:String = NAME + "startTimer";
		
		public static const SOCKET_TIME_OUT:String = NAME + "socketTimeOut";
		public static const SOCKET_CLOSED:String = NAME + "socketCloesed";
		public static const CLOSE_SOCKET:String = NAME + "closeSocket";
		public static const NETWORK_DISABLE:String= NAME + "socketDisable";
		public static const NETWORK_ERROR:String = NAME + "networkError";
		
		
		public static const SCRIPT_COMPLETE:String = NAME + "scriptComplete";
		public static const COMMAND_SCRIPT_COMPLETE:String = NAME + "commandScriptComplete";
		
		public static const FUN_START:String = NAME + "funStart";
		
		
		/**
		 *接收数据错误 
		 */		
		public static const RECEIVE_ERROR:String = NAME + "receiveError";
		
		public static const CONFIG:String = NAME + "config";
		
		
		/**
		 *一个单词完成 
		 */		
		public static const WORD_LEARINNG_ITEM_FINISH:String = NAME + "WordLearinngItemFinish";
		
		/**
		 *单词学习完成 
		 */		
		public static const WORD_LEARINNG_FINISH:String = "WordLearinngFinish";
		
		/**
		 * 解析代码
		 */		
		public static const EVAL:String = NAME + "Eval";
		
		public static const BOOT_COMPLETE:String = NAME + "BootComplete";
		public static const SETUP_DATA_WORKER:String = NAME + "setupDataWorker";
		public static const SETUP_UPDATER_WORKER:String = NAME + "setupUpdaterWorker";
		
		
		public static const BACKGROUND_COMMAND:String = NAME + "backgroundCommand";
		public static const SETUP_DATA_WORKER_COMPLETE:String = NAME + "setupDataWorkerComplete";
		public static const INIT_ROOT:String = NAME + "initRoot";
		
		public static const CHECK_VERSION_COMPLETE:String = NAME + "checkVersionComplete";
		
		public static const UPDATE_LIB:String = NAME + "updateLib";
		public static const LOAD_NEXT_LIB:String = NAME + "loadNextLib";
		
		/**
		 *建立socket链接 
		 */		
		public static const SOCKET_CONNECTED:String = NAME + "socketConnected";
		
		/**
		 *loading 
		 */		
		public static const LOADING:String = NAME + "Loading";
		
		/**
		 *重新登录完成 
		 */		
		public static const RELOGIN_COMPLETE:String = NAME + "reloginComplete";
		
		/**
		 *重新登录 
		 */		
		public static const RELOGIN:String = NAME + "relogin";
		
		/**
		 *提示信息 
		 */		
		public static const TOAST:String = NAME + "toast";
		
		/**
		 *切换网络
		 */		
		public static const SWITCH_NETWORK:String = NAME + "switchNetwork";
		
		public static const LOAD_SWF_BYTES:String = NAME + "loadSWFBytes";
		
		/**
		 *更新程序 
		 */		
		public static const UPDATE_ALL:String = NAME + "UpdateAll";
		
		public static const UPDATE_COMPLETE:String = NAME + "UpdateComplete";
		
		public static const REMOTE_FILE_LOAD:String = NAME + "RemoteFileLoad";
		
		
		public static const CALL_BACK_COMMAND:String = NAME + "CallBackCommand";
		
		public static const DOWNLOAD_CANCELED:String = NAME + "downloadCanceled";
		public static const DOWNLOAD_STOPED:String = NAME + "downloadStoped";
		
		public static const SAVE_TEMP_FILE:String = NAME + "SaveTempFile";
		
		public static const UPDATE_SINGLE_FILE_COMPLETE:String = NAME + "UpdateSingleFileComplete";
		
		public static const SETTING:String = NAME + "Setting";
		
		public static const INITIALIZE_ASSETS_CONFIG:String = NAME + "InitializeAssetsConfig";
		
		public static const LOGIN_SETTING:String = "LoginSettingCommand";
		
		
		/**
		 *验证登录结果 
		 */		
		public static const VERIFY_LOGIN_RESULT:String = "VerifyLoginResult";
		
		/**
		 *登录成功 
		 */		
		public static const LOGIN_SUCCESS:String = "LoginSuccess";
		
		/**
		 *缓存信息错 
		 */		
		public static const LOGIN_ERROR:String = "LoginError";
		
		/**
		 *登录失败 
		 */		
		public static const LOGIN_FAIL:String = NAME + "loginFail";
		
		/**
		 *用户信息初始化完成 
		 */		
		public static const PLAYER_READY:String = NAME + "playerReady";
		
		public static const HIDE_ALL_MENU_PANELS:String =  NAME +"hideAllMenuPanels";
		
		public static const LOADING_PROCESS:String = NAME + "LoadingProcess";
		public static const LOADING_TOTAL_PROCESS_MSG:String = NAME + "LoadingTotalProcessMSG";
		
		public static const LOADING_TOTAL:String = NAME + "LoadingTotal";
		
		public static const LOADING_INIT_PROCESS:String = NAME + "LoadingInitProcess";
		
		public static const LOADING_CLOSE_PROCESS:String = NAME + "LoadingCloseProcess";
		
		public static const LOADING_MSG:String = NAME + "LoadingMsg";
		
		public static const UPDATE_FILES:String = NAME + "UpdateFiles";
		
		public static const LOCAL_FILES_LOAD:String = NAME + "LocalFilesLoad";
		
		public static const LOCAL_FILES_LOAD_UPDATE_COMPLETE:String = NAME + "LocalFilesLoadUpdateComplete";
		
		public static const REGISTER_PAD:String = NAME + "RegisterPad";
		
		
		/**
		 *检查本地的注册文件 
		 */		
		public static const LOGIN_SETTING_COMPLETE:String = NAME + "LoginSettingComplete";
		
		public static const LICENSE_PASSED:String = NAME + "LicensePassed";
		
		
		/**
		 *注册 
		 */		
		public static const SERVER_REGISTER:String = NAME + "serverRegister";
		
		/**
		 *保存注册id到本地 
		 */		
		public static const SAVE_LICENSE:String = NAME + "saveLicense";
		
		/**
		 * 保存用户账号密码
		 */
		public static const SAVE_USER:String = NAME+"saveuser";
		/**
		 *接收服务器注册的返回信息 
		 */		
		public static const SERVER_REGISTER_REC:String = NAME + "serverRegisterRec";
		
		/**
		 *发取更新列表请求 
		 */		
		public static const GET_UPDATE_LIST:String = NAME + "GetUpdateList";
		
		/**
		 *接收更新列表 
		 */		
		public static const REC_UPDATE_LIST:String = NAME + "RecUpdateList";
		
		/**
		 *更新列表下载完毕 
		 */		
		public static const UPDATE_READY:String = NAME + "UpdateReady";
		
		/**
		 *开始更新素材 
		 */		
		public static const UPDATE_ASSETS:String = NAME + "UpdateAssets";
		
		/**
		 *检查版本 
		 */		
		public static const CHECK_VERSION:String = NAME + "CheckVersion";
		
		/**
		 *流量记录 
		 */		
		public static const FLOW_RECORD:String = NAME + "FlowRecord";
		
		/**
		 *初始化时间 
		 */		
		public static const GET_SER_TIME:String = NAME + "GetSerTime";
		
		public static const REC_SER_TIME:String = NAME + "RecSerTime";
		/**
		 *同步平板时间 
		 */		
		public static const SYN_PAD_TIME:String = NAME + "SynPadTime";
		public static const SYN_PAD_TIME_COMPLETE:String = NAME + "SynPadTimeComplete";
		
		
		
		//public static const CLOSE_KEYBOARD:String = NAME + "closeKeyboard";
		
		public static const SWITCH_KEYBOARD_INPUT:String = NAME + "switchKeyboardInput";
		
		public static const DATA_INITIALISED:String = NAME + "dataInitialised";
		/**
		 * 登陆后，向后台请求数据——取服务器时间、任务列表、家长提醒等 
		 */		
		public static const START_GET_INITIALIZE_DATA:String = NAME + "startGetInitializeData";
		public static const LIB_INITIALIZED:String = NAME + "LibInitialized";
		public static const RE_GET_INITIALIZE_DATA:String = NAME + "reGetInitializeData";
		
		/**
		 *读文本 
		 */		
		public static const READ_TEXT:String = NAME + "readText";
		

		public static const CLOSE_FACE_SHOW:String = NAME + "closeFaceShow";//通知绘本页码改变
		
		public static const DRAG_FACE_MOVE:String = NAME + "dragFaceMove";//拖动图标换位


		/**
		 *显示查字典组件 
		 */
		public static const SHOW_DICTIONARY:String = NAME + "ShowDictionary";
		
		/**
		 *显示弹出菜单组件(包含复制，粘贴，朗读，查字典功能) 
		 */
		public static const SHOW_POP_UP_MENU:String = NAME+"ShowPopUpMenu";	
		
		public static const CLOSE_POP_UP_MENU:String = NAME+"ClosePopUpMenu";
		
		/**
		 *显示奖励界面 
		 */
		public static const SHOW_BONUS:String = NAME+"ShowBonus";
		
		/**
		 *关闭奖励界面 
		 */
		public static const CLOSE_BONUS:String = NAME+"CloseBonus";
		
		/**
		 *更新游戏服务 
		 */		
		public static const UPDATE_GAME_SERVICE:String = NAME + "updateGameService";
		
		/**
		 *在eduService执行Commands 
		 */		
		public static const EXECUTE_GAME_SERVICE:String = NAME + "executeGameService";
		
		public static const INVOKE:String = NAME + "invoke";
		
		public static const FIRST_VIEW_READY:String = NAME + "firstViewReady";
		
		
		
		
		public static const ENTER_NEXT_TASK_VIEW:String = NAME+"EnterNextTaskView";
		
		public static const APP_ERR:String = NAME + "appErr";
		
		public static const FILL_BLANKS_MESSAGE:String = NAME+"FillBlanksMessage";
		public static const FILL_BLANKS_INITIALIZED:String = NAME+"FillBlanksInitialized";
		
		public static const SHOW_POP_UP_TIPS:String = NAME+"ShowPopUpTips";
		
		public static const SHOW_MP3_PLAYER:String = NAME+"ShowMp3Player";
		
		public static const SHOW_CAMERA:String = NAME+"ShowCamera";
		
		public static const STAGE_WEB_VIEW_READY:String = NAME+"StageWebViewReady";
		
		public static const WEBPAGE_LOADED:String = NAME+"webPage_Loaded";
		
		public static const UPLOAD_SEGMENT_COMPLETE:String = "UploadSegmentComplete";
		
		
		public static const UPLOAD_FILE:String = "UploadFile";
		
		public static const UPLOAD_COMPLETE:String = "UploadComplete";
		
		
		public static const RECOVER_BTN:String = "recoverBtn";
		
		/**----------------TextField的精确Draw----------------------*/
		public static const TEXTFIELD_DRAW_BEGIN:String = "TextFieldDrawBegin";//开始绘制
		public static const TEXTFIELD_DRAW_END:String = "TextFieldDrawEnd";//结束绘制
		public static const TEXTFIELD_DRAW_UPDATE:String = "TextFieldDrawUpdate";//刷新绘制
		
		//EasyDownload命令处理
		public static const EASY_DOWNLOAD:String = NAME + "EasyDownload";
		
		/*---查看并上传应用版本---*/
		public static const INUP_PAD_INFO:String = NAME + "GET_VERSION";
		public static const REC_VERSION:String = NAME + "REC_VERSION";
		
		
		public static const ERROR_REPORT:String = NAME + "errorReport";
		public static const STARTUP_STEP_BEGIN:String = NAME + "startupStepBegin";
		
		public static const HIDE_STARTUP_LOADING:String = NAME + "hideStartupLoading";
		public static const SHOW_STARTUP_LOADING:String = NAME + "showStartupInfo";
		public static const SHOW_STARUP_INFOR:String = NAME + "showStartupInfor";
		public static const HIDE_STARUP_INFOR:String = NAME + "hideStarupInfor";
		public static const CLEAN_STARUP_INFOR:String = NAME + "cleanStarupInfor";
		
		public static const ENABLE_CANCEL_DOWNLOAD:String = NAME + "enableCancelDownLoad";
		public static const DISABLE_CANCEL_DOWNLOAD:String = NAME + "disableCancelDownLoad";
		public static const CANCEL_DOWNLOAD:String = NAME + "cancelDownLoad";
		/**
		 *是否手动控制禁屏，true为手动控制禁屏，即通信时不禁屏
		 */		
		public static const MANUAL_LOADING:String = NAME + "manualLoading";
		public static const HIDE_ALERT_WINDOW:String = NAME + "HideAlertWindow";
		public static const FIX:String = NAME + "fix";
		
		public static const CHECK_LOGIN_TIME:String = NAME + "CheckLoginTime";
		public static const SEND_ERR:String = NAME + "SendErrorInfo";
		public static const REC_ERR_INFOR:String = NAME + "SendErrSucc";
		
		public static const LOAD_APP_MODULES:String = NAME + "LoadAppModules";
		public static const LOAD_MODULES:String = NAME + "LoadModules";
		public static const LOAD_MODULES_COMPLETE:String = NAME + "loadModulesComplete";
		public static const SWITCH_MODULE:String = NAME + "switchModule";
		
		public static const TEST_N:String = NAME + "TestN";
		
		
		public static const DEACTIVATE:String = NAME + "deActivate";
		public static const ACTIVATE:String = NAME + "activate";
		
		public static const CORE_READY:String = NAME + "coreReady";
		
		
		public static const SHOW_LOADING:String = NAME + "showLoading";
		public static const HIDE_LOADING:String = NAME + "hideLoading";
		public static const SHOW_BUSY:String = NAME + "showBusy";
		public static const REFRESH_LOADING:String = NAME + "refreshLoading";
		public static const SEND_JUMP_URI:String = NAME + "sendJumpUri";

		public static const INSTALL_APP_COMMAND:String = NAME + "InstallAppCommand";
//		public static const INSTALL_APP_COMPLETE:String = NAME + "InstallAppComplete";
		public static const INSTALL_SYS_APP_COMPLETE:String = NAME + "InstallSysAppComplete";
		public static const INSTALL_GAME_COMPLETE:String = NAME + "InstallGameComplete";
		
		
		public static const LOAD_EFFECT_SOUND:String = NAME+ "loadEffectSound";//加载特效声音
		public static const MUTE_EFFECT_SOUND:String = NAME  + "muteEffectSound";//禁止特效声音
		public static const PLAY_EFFECT_SOUND:String = NAME+ "playEffectSound";//播放特效声音
		public static const REMOVE_EFFECT_SOUND:String = NAME + "removeEffectSound";//移除特效声音
		
		public static const CHECK_APP_VERSION:String = NAME + "CheckAppVersion";	//检查程序版本
		public static const CHECK_APP_ROOT:String = NAME + "CheckAppRoot";	//检查程序权限
		public static const CHECK_APP_ROOT_COMPLETE:String = NAME + "CheckAppRootComplete";	//完成程序权限检查
		public static const CHECK_EDUSERVICE_ROOT:String = NAME + "CheckEduServiceRoot";	//检查eduService权限
		
		public static const CONFIG_IP_PORT:String = NAME + "configIPPort";
		public static const CONNECT_UPDATER:String = NAME + "connectUpdater";
		public static const BG_SEND:String = NAME + "bgSend";
		public static const BG_SEND_COMPLETE:String = NAME + "bgSendComplete";
		public static const SEND_LOGIN:String = NAME + "sendLogin";
		public static const SET_OPERID:String = NAME + "setOperid";
		
		public static const REQUEST_FILE_DATA:String = NAME + "requestFileData";
		public static const UPDATE_PLAYER:String = NAME + "updatePlayer";
		
		public static const WORKER_RUNNING:String = NAME + "workerRunning";
		public static const START_SETTING:String = NAME + "startSetting";
		public static const NOTIFICATION_PREP:String=NAME+"NotificationPrep";
		
		public static const RESTART_BG_WORKER:String = NAME + "restartBGWorker";
		public static const KILL_BG_WORKER:String = NAME + "killBGWorker";
		public static const DETECT_DATA:String = NAME +"detectData";
		public static const BG_WORKER_READY:String = NAME + "bgWorkerReady";
		public static const UPDATER_READY:String = NAME + "updaterReady";
		public static const EXIT_UPDATER:String = NAME + "exitUpdater";
		
		public static const GAME_DOWNLOAD_COMPLETE:String = NAME + "GameDownloadComplete";
		
		public static const SET_APP_NAME:String = NAME + "SetAppName";
		public static const RUN_UPDATE:String = NAME + "runUpdate";
		
		public static const OPER_TEMP_FILE:String = NAME + "OperTempFile";
		public static const FILE_DOWNLOADED:String = NAME + "FileDownloaded";
		public static const CONTINUTE_FILE_DOWNLOADED:String = NAME + "continuteFileDownload";
		public static const CHECK_UPDATE_FILES:String = NAME + "CheckUpdateFiles";
		public static const CHECK_UPDATE_FILES_COMPLETE:String = NAME + "checkUpdateFilesComplete";
		public static const OPER_UPDATE:String = NAME + "operUpdate";
		public static const OPER_UPDATE_COMPLETE:String = NAME + "operUpdateComplete";
		public static const INSTALL_UPDATE:String = NAME + "installUpdate";
		public static const INSTALL_UPDATE_COMPLETE:String = NAME + "installUpdateComplete";
		
		public static const COMMIT_UPDATE:String = NAME + "commitUpdate";
		public static const COMMIT_UPDATE_COMPLETE:String = NAME + "commitUpdateComplete";
		public static const REMOVE_UPDATE_FILE:String = NAME + "removeUpdateFile";
		public static const REMIND_UPDATE_COMPLETE:String = NAME + "remindUpdateComplete";
		
		public static const ACCEPT_RESTART:String = NAME + "acceptRestart";
		public static const REMIND_LATER:String = NAME + "remindLater";
		

		
		public static const START_BEAT:String = NAME + "startBeat";
		public static const STOP_BEAT:String = NAME + "stopBeat";
		
		public static const BEAT_REC:String = NAME+ "BeatRec";
		public static const SEND_QUEUE:String = NAME + "sendQueue";
		
		
		public static const SET_BEAT_DUR:String = NAME+"setBeatDur";
		public static const OPER_RECORD:String = NAME + "operRecord";
		public static const BROADCAST:String = NAME+"broadcast";
		public static const UPDATE_NETWORK_SPEED:String = NAME + "updateNetworkSpeed";
		
		public static const SILENT_SEND:String = NAME + "silentSend";
		public static const SILENT_SENDED:String = NAME + "silentSended";
		
		public static const STOP_REC:String = NAME + "stopRec";
		public static const SAFETY_QUIT:String = NAME + "safetyQuit";
		public static const REQUEST_QUIT:String = NAME + "requestQuit";
		public static const CLEAN_SILENT_REQUESTS:String = NAME + "cleanSilentRequests";
		
		public static const CANCEL_SWITCH:String = NAME + "cancelSwitch";
		public static const SHOW_NETWORKSTATE:String = NAME+'showNetWork';
		public static const HIDE_NETWORKSTATE:String = NAME+'hideNetWork';
		
		public static const CONTINUE_SEND_REQUEST:String = NAME +　"continueSendRequest";
		
		public static const BACKGROUND_OPER:String = NAME + "backgroundOper";
		
		
		public static const GET_MAC_ADDRESS:String = NAME + "getMacAddress";
		
		public static const BEGIN_SEND:String = NAME +　"beginSend";
		public static const BG_RESEND:String = NAME + "bgResend";
		
		
	}
}