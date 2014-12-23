package com.studyMate.world.screens
{
	public class WorldConst
	{
		public static const NAME:String = "WorldConst";
		public static const UPDATE_CAMERA:String = NAME+"updateCmaera";
		public static const UPDATE_SCALE:String = NAME + "updateScale";
		
		public static const UPDATE_FLIP_PAGE_INDEX:String = NAME + "UpdateFlipPageIndex";
		public static const CLEAR_FLIP_PAGE:String = NAME + "ClearFlipPage";
		
		public static const UPDATE_FLIP_PAGES:String = NAME+"UpdateFlipPages";
		
		public static const SWITCH_SCREEN:String = NAME + "SwitchScreen";
		public static const SCREEN_PREPARE_READY:String = NAME + "ScreenPrepareReady";
		public static const SCREEN_PREPARE_COMPLETE:String = NAME + "ScreenPrepareComplete";
		public static const SCREEN_ASSETS_LOADED:String = NAME + "ScreenAssetsLoaded";
		public static const SWITCH_SCREEN_COMPLETE:String = NAME + "SwtichScreenComplete";
		public static const SHOW_SCREEN_COMPLETE:String = NAME + "ShowScreenComplete";
		public static const SWITCH_BG_MUSIC:String = NAME + "SwitchBGMusic";
		public static const SET_BG_MUSIC_VOLUME:String = NAME+'SET_BG_MUSIC_VOLUME';//调节额音量
		
		public static const POP_SCREEN:String = NAME + "PopScreen";
		public static const POP_SCREEN_DATA:String = NAME + "PopScreenData";
		public static const ADD_GPU_SCREEN_DATA:String = NAME + "AddGpuScreenData";
		public static const ADD_CPU_SCREEN_DATA:String = NAME + "AddCpuScreenData";
		
		public static const CLEAN_SCREEN:String = NAME + "CleanScreen";
		public static const REMOVE_GPU_LIBS:String = NAME + "RemoveGpuLibs";
		public static const CONFIG_WORLD_MODEL:String = NAME + "ConfigWorldModel";
		public static const STARTUP_APP:String = NAME + "StartupApp";
		public static const POPUP_SCREEN:String = NAME + "PopUpScreen";
		public static const REMOVE_POPUP_SCREEN:String = NAME + "RemovePopUpScreen";
		public static const CLEANUP_POPUP:String = NAME + "CleanUpPopUp";
		public static const SCREEN_PREPARE_DATA_COMPLETE:String = NAME + "ScreenPrepareDataComplete";
		public static const HIDE_SCREEN:String = NAME + "HideScreen";
		/*关闭所有show出来的view*/
		public static const HIDE_ONSHOW_SCREEN:String = NAME + "HideOnShowScreen";
		
		/*人物ai*/
		public static const ADD_RANDOM_ACTION:String = NAME+ "AddRandomAction";
		public static const OPEN_GAME:String = NAME + "OpenGame";
		public static const STOP_RANDOM_ACTION:String = NAME + "StopRandomAction";
		public static const ADD_TALK_ACTION:String = NAME + "AddTalkAction";
		public static const ADD_APPEAR_CONTROL:String = NAME + "AddAppearControl";
		public static const ADD_CHARATER_INERATION:String = NAME + "AddCharaterIneration";
		
		public static const ADD_FLOWER_CONTROL:String = NAME + "AddFlowerControl";
		
		public static const ADD_PET_DOG_AI:String = NAME + "addPetDogAI";
		
		public static const SEND_SIMSIMI_MSG:String = NAME + "SendSimsimiMSG";
		public static const REC_SIMSIMI_MSG:String = NAME + "ReceiveSimsimiMSG";
		
		public static const CHANGE_HSCROLL_DIRECTION:String = NAME + "ChangeHScrollDirection";
		
		public static const SET_HSCROLL_RL:String = NAME +　"setHScrollRL";
		
		
		/**
		 * 邮件数
		 */
		public static const EMAIL_NUM:String = NAME+"emailnum";
		public static const IS_EMAIL:String = NAME+"unreadEmail";
		public static const DELEMAIL:String = NAME+"delEmail";
		
		/**
		 * 快捷方式
		 */
		public static const SHOW_SHORTCUT:String = NAME+"shortcut";
		public static const HAPPY_SHOWCHAT:String = NAME+"happy_showchat";
		public static const HAPPY_HIDECHAT:String = NAME+"happy_hidechat";
		
		
		/**
		 * 删除登录记录
		 */
		public static const DELHISTORYLOGIN:String = NAME+"del_history_login"
		
		/**
		 * 刷新未读数量
		 */
		public static const REFRESH_NUM:String = NAME+"refresh_num";
			
		/**
		 *
		 * true:禁屏	false:不禁屏 
		 */		
		public static const SET_MODAL:String = NAME + "modal";
		
		public static const BUILD_THEME:String = NAME+"buildTheme";
		
		/**
		 * 禁止菜单按钮
		 */
		public static const HIDE_MENU_BUTTON:String = NAME +"hideMenuButton";
		
		/**
		 * 开启菜单按钮
		 */
		public static const SHOW_MENU_BUTTON:String = NAME+"showMenuButton";
		
		
		/**
		 *显示不同皮肤的对话框 
		 */		
		public static const DIALOGBOX_SHOW:String = NAME + "DialogBoxShow";
		
		//显示弹出框
		public static const ALERT_SHOW:String = NAME + "alertShow";//sendNotification(WorldConst.ALERT_SHOW,new AlertVo(data.str,true,"yesHandler","noHandler"));
		//学单词的通信消息
		public static const CHANGE_INPUT:String = NAME + "CHANGE_INPUT";//切换输入方式
		public static const WL_QUESTION_TIP:String = NAME +"WLquestionTip";//给出答案的问题提示
		public static const WL_PLAYSOUND:String = NAME+"WL_PLAYSOUND";//播放声音
		public static const WL_YESRIGHT:String= NAME +"yesRightImg";//	答对了
		public static const ZHONGWEN_TIP:String = NAME + "zhongwenTip";
		public static const YINGWEN_TIP:String = NAME + "yingwenTip";
		public static const SHOW_CHANGEINPUTBUTTON:String = NAME + "showChangeButton";
		
		//弹出FAQ窗口
		public static const SHOW_FAQ_ALERT:String = NAME +"showFAQAlert";
		public static const GET_SCREEN_FAQ:String = NAME + "GET_SCREEN_FAQ";
		public static const SET_SCREENT_FAQ:String = NAME+"SET_SCREENT_FAQ";
		public static const CHECK_SENTENCE:String = NAME + "checkSentence";//阅读查询句子
		
		//显示音乐播放器
		public static const SHOW_MUSICPLAYER:String = NAME+"showMusicPlayer";
		
		public static const Del_Music:String = NAME  + "Del_Music";//删除音乐
		public static const Move_BgMusic:String = NAME + "Move_BgMusic";//移动到背景音乐

		public static const DICTIONARY_SHOW:String = NAME + "dictionaryShow";
		
		/**
		 * 单词引导
		 */
		public static const GUIDEWORLD:String = NAME+"guideworld";
		
		public static const SORT_CONTAINER:String = NAME + "sortContainer";
		public static const LET_CHARATER_WALK_TO:String = NAME + "LetCharaterWalkTo";
		
		public static const UPDATE_PLAYER_CHARATER:String = NAME + "updatePlayerCharater";
		public static const UPDATE_PLAYER_MAP:String = NAME + "updatePlayerMap";
		public static const UPDATE_PLAYER_CHARATER_POSITION:String = NAME + "updatePlayerCharaterPosition";
		public static const UPDATE_PLAYER_MARK:String = NAME + "updatePlayerMark";
		
		
		//正在下载的对象
		public static const CURRENT_DOWN_RESINFOSP:String =NAME+ "current_down_resBaseInfoSp";
		public static const CURRENT_DOWN_COMPLETE:String = NAME +"currentDownVideoSp";
		
		/*对应MyCharaterControlMediator*/
		public static const ADD_MYCHARATER_CONTROL:String = NAME + "AddMyCharaterControl";
		/*对应CharaterControlMediator*/
		public static const ADD_CHARATER_CONTROL:String = NAME + "AddCharaterControl";
		
		public static const CHARATER_LEAVE:String = NAME + "charaterLeave";
		public static const UPDATE_CHARATER_STATE:String = NAME + "updateCharaterState";
		
		//主菜单消息
		public static const SHOW_MAIN_MENU:String = NAME + "ShowMainMenu";	//启用主菜单
		public static const HIDE_MAIN_MENU:String = NAME + "HideMainMenu";	//禁用主菜单
		public static const OPEN_MAIN_MENU:String = NAME + "openMainMenu";	//打开主菜单
		public static const CLOSE_MAIN_MENU:String = NAME + "closeMainMenu"; //关闭菜单
		public static const ADD_MAINMENU_BUTTON:String = NAME + "addMainMenuButton";	//添加按钮
		public static const REMOVE_MAINMENU_BUTTON:String = NAME + "removeMainMenuButton";	//删除按钮
		public static const SHOW_MAINMENU_BUTTON:String = NAME + "ShowMainMenuButton";
		public static const HIDE_MAINMENU_BUTTON:String = NAME + "HideMainMenuButton";
		public static const SHOW_BUTTON_BY_LEVEL:String = NAME + "ShowButtonByLevel";
		public static const ADD_BLINK_ICON:String = NAME + "AddBlinkIcon";
		public static const CHANGE_BUTTON_TIPS:String = NAME + "ChangeButtonTips";
		
		//多人在线使用
		public static const MYCHARATER_SAY:String = NAME + "MycharaterSay";
		
		
		public static const INIT_TASKLIST:String = NAME+"initTaskList";//初始化任务列表
		public static const UPDATE_TAKSLIST:String = NAME+"updateTaskList";//更新任务列表
		public static const UPDATE_TASK_DATA:String = NAME + "updateTaskData";//更新任务数据
		public static const DEL_TASK_DATA_CACHE:String = NAME + "delTaskDataCache";//删除任务数据缓存
		
		public static const CHARATER_TEXTURE_READY:String = NAME + "charaterTexutreReady";
		public static const SHOW_INDEX:String = NAME + "showIndex";
		
		public static const INIT_UI:String = NAME + "initUI";
		public static const SWITCH_FIRST_SCREEN:String = NAME + "switchFirstScreen";
		public static const CONFIG_DEPENDED_MODEL:String = NAME+"configDependedModel";
		
		/**
		 *设置随机运动<br /><br />
		 * 
         * 范例：<br /><br /><code>
		 * var jellyfish:Object = new Object();<br />
		 * jellyfish["charater/jellyfish"]=new MovieClip(Assets.getAtlas().getTextures("charater/jellyfish"));<br />
		 * sendNotification(WorldConst.RANDOM_ACTION,{displayObject:JELLYfISH,holder:view,randomSize:false,<br />
				fps:4,setFrameDuration:[0.128,0.112,0.32,0.16]});<br /><br /></code>
		 * 
		 * <ul><li><b> displayObject </b>-显示对象 </li>
		 * <li><b> holder </b>-显示对象的容器 </li>
		 * <li><b> range </b>-（可选）显示对象的范围，为Rectangle对象，指定x,y,width,height。默认为holder</li>
		 * <li><b> randomSize </b>-（可选）是否随机大小，随机范围为对象原始大小的0.8~1.2倍。默认为true</li>
		 * <li><b> randomAction </b>-（可选）是否随机运动，在指定运动范围内，随机获取两点直接淡入淡出运动。默认为true</li>
		 * <li><b> actionDirection </b>-（可选）当randomAction为false时有效，指定非随机运动的运动路径，可选参数"LTR"、"RTL"、"DTU"、"UTD"，默认为"LTR",从左向右</li>
		 * <li><b> fps </b>-（可选）指定显示对象movieclip的fps。默认为8</li>
		 * <li><b> setFrameDuration </b>-（可选）设置显示对象movieclip每帧的执行时长（单位：秒）</li></ul>
		 * <br /><br />
		 * @author lsj<br /><br />
		 */		
		public static const RANDOM_ACTION:String = NAME + "RandomAction";
		
		
		public static const INJECT_CHARATER_FSM_COMMAND:String = NAME + "InjectCharaterFSMCommand";
		
		public static const UPDATE_WORLD_TIME:String = NAME + "updateWorldTime";
		
		public static const SHOW_BACK:String = NAME + "ShowBack";
		public static const HIDE_BACK:String = NAME + "HideBack";

		public static const GET_PLAY_GAME_TIME:String = NAME + "GetPlayGameTime";
		public static const ITEM_TASK_INFO:String = NAME + "ItemTaskInfo";
		public static const UPDATE_TASKLIST_COMPLETE:String = NAME + "updateTaskListComplete";
		public static const UPDATE_TASK_NUM_COMPLETE:String = NAME + "UpdateTaskNumComplete";
		
		public static var stageWidth:int;
		public static var stageHeight:int;
		
		public static const GPU:uint=1;
		public static const CPU:uint=2;
		public static const CLEAN_ASSETS:uint=4;
		
		public static const PUSH:String="push";
		public static const POP:String="pop";
		public static const REPLACE:String = "replace";
		
		public static const PACK_MC_TEXTURE:String = NAME+"packMcTexture";
		public static const PACK_PNG_TEXTURE:String = NAME+"packPngTexture";
		
		public static const PACK_CHARATER_TEXTURE:String = NAME + "PackCharaterTexture";
		public static const CREATE_CHARATER_TEXTURE:String = NAME + "createCharaterTexture";
		
		public static const WORD_LEARN_KEYBOARD:String=NAME+"WORDLEARNKEYBOARD";
		
		public static const HIDE_SHOWPROMISEVIEW:String = NAME + "HIDESHOWPROMISEVIEW";
		
		public static const SHOW_LEFT_MENU:String = NAME + "SHOW_LEFT_MENU";
		public static const HIDE_LEFT_MENU:String = NAME + "HIDE_LEFT_MENU";
		public static const UPDATE_LEFT_MENU_GOLD:String = NAME + "UpdateLeftMenuGold";
		public static const SHOW_LEFT_MENU_GOLD:String = NAME + "ShowLeftMenuGold";
		
		public static const HIDE_SHOWMESSAGEVIEW:String = NAME + "HIDE_SHOWMESSAGEVIEW";
		public static const REMOVE_MSG_BTN:String = NAME + "REMOVE_MSG_BTN";
		
		public static const GUIDE_END:String = NAME + "GUIDE_END";
		public static const PLAY_PHOTOS_END:String = NAME + "PLAY_PHOTOS_END";
		
		public static const UPDATE_FLIP_DAOHANG:String = NAME + "UPDATE_FLIP_DAOHANG";
		
		public static const SET_ROLL_SCREEN:String = NAME + "SetRollScreen";
		public static const SET_ROLL_TARGETX:String = NAME + "SetRollTargetX";
		
		public static const CREATE_TALKINGBOX:String = NAME + "CreateTalkingBox";
		public static const SHOW_TALKINGBOX:String = NAME + "ShowTalkingBox";
		public static const HIDE_TALKINGBOX:String = NAME + "HideTalkingBox";
		public static const DESTROY_TALKINGBOX:String = NAME + "DestroyTalkingBox";
		
		public static const SHOW_PERSONALINFO:String = NAME + "ShowPersonalInfo";
		
		public static const MARK_MY_CHARATER:String = NAME + "MarkMyCharater";
		public static const MARK_OTHER_PLAYER_CHARATER:String = NAME + "MarkOtherPlayerCharater";
		public static const SWITCH_TO_OLD_VERSION:String = NAME + "SwitchToOldVersion";
		public static const STOP_PLAYER_ACTION:String = NAME + "StopPlayerAction";
		
		public static const STOP_PLAYER_TALKING:String = NAME + "StopPlayerTalking";
		public static const STOP_PLAYER_MOVE:String = NAME + "StopPlayerMove";
		
		
		public static const RECORD_LOGIN_INFO:String = NAME+ "RecordLoginInfo";
		public static const RECORD_LOGIN_INFO_COMPLETE:String = NAME+ "RecordLoginInfoComplete";
		
		public static const UPDATE_STU_SIGN:String = NAME + "UpdateStuSign";
		public static const UPDATE_STU_SIGN_COMPLETE:String = NAME + "UpdateStuSignComplete";

		public static const LOAD_INIT_LIB:String = NAME + "loadInitLib";
		
		public static const UPDATE_MARKET_PER_INFO:String = NAME + "UpdateMarketPerInfo";
		
		public static const HAVE_NEW_MESSAGE:String = NAME + "Have_New_Message";
		public static const GET_TEXT_MESSAGE:String = NAME + "Get_Text_Message";
		public static const MESSAGE_DATA:String = NAME + "Message_Data";
		public static const GET_GIFT:String = NAME + "Get_Gift";
		
		
		
		public static const START_PLAYER_CONTROL:String = NAME + "startPlayerControl";
		public static const STOP_PLAYER_CONTROL:String = NAME + "stopPlayerControl";
		public static const RECLAIM_CHARATER_FROM_BATTLE:String = NAME + "reclaimCharaerFromBattle";
		
		public static const CHECK_PROMISE:String = NAME + "CheckPromises";
		public static const CHECK_PROMISE_OVER:String = NAME + "CheckPromiseOver";

		public static const GET_SERVER_EQUIPMENT:String = NAME + "GetServerEquipment";
		public static const GET_CHARATER_EQUIPMENT:String = NAME + "GetCharaterEquipment";
		public static const GET_CHARATER_EQUIPMENT_COMPLETE:String = NAME + "GetCharaterEquipmentComplete";
		public static const UPDATE_CHARATER_EQUIPMENT:String = NAME + "UpdateCharaterEquipment";
		public static const UPDATE_CHARATER_EQUIPMENT_COMPLETE:String = NAME + "UpdateCharaterEquipmentComplete";
		
		public static const ADD_FIGHT_STATE:String = NAME + "addFightState";
		public static const REMOVE_FIGHT_STATE:String = NAME + "removeFightState";
		public static const CHARATER_STATE_REMOVED:String = NAME + "charaterStateRemoved";
		
		//public static const PICK_UP_BACKGROUND_MUSIC:String = NAME + "pickUpbackgroundMusic";
		
		/*---上传应用列表---*/
		public static const AUTO_SUB_PACKLIST:String = NAME + "AutoSubmitPackList";
		public static const SUB_PACKLIST:String = NAME + "SubmitPackList";
		public static const REC_PACKLIST:String = NAME + "RecPackList";
		public static const GET_READ_GIFT:String = NAME + "GetReadedGift";
		
		public static const GET_UNREAD_MESSAGE:String = NAME + "GetUnreadMessage";
		public static const GET_ALL_MESSAGE:String = NAME + "GetAllMessage";
		
		public static const ISLAND_SWITCHSCREEN_FUN:String = NAME + "IslandSwitch";
		public static const SCREEN_SHOT:String = NAME + "ScreenShot";

		public static const ADD_ISLAND_HOUSE:String = NAME + "AddIslandHouse";
		public static const QRY_PER_ROOM_COMPLETE:String = NAME + "QryPerroomComplete";
		
		public static const HIDE_SETTING_SCREEN:String = NAME + "HideSettingScreen";
		
		public static const CHECK_SOCKET_CONNECT:String = NAME + "CheckSocketConnect";
		public static const CHECK_SOCKET_RESULT:String = NAME + "CheckSocketResult";
		public static const DISPOSE_CHECK_SOCKET:String = NAME + "DisposeCheckSocket";
		public static const SELECT_IN_PORT:String = NAME + "SelectInPort";
		public static const CHECK_TO_RELOGIN:String = NAME + "CheckToRelogin";
		public static const SHOW_NETSTATE_CHECK:String = NAME + "ShowNetStateCheck";
		
		public static const IP_GET_FASTED:String = NAME + "TestIpSpeedGetFasted";
		public static const IP_CMP_SPEED:String = NAME + "TestIpSpeedCmpSpeed";
		public static const IP_SPEED_RESULT:String = NAME + "TestIpSpeedResult";
		public static const IP_SPEED_FASTEST:String = NAME + "TestIpSpeedFasted";
		public static const IP_SPEED_COMPLETE:String = NAME + "IpSpeedComplete";
		public static const IP_SPEED_CHECKING:String = NAME + "IpSpeedChecking";
		
		public static const SHOW_CHANGE_LOG:String = NAME + "ShowChangeLog";
		public static const CALL_CAMERA:String = NAME + "CallCamera";
		public static const CAMERA_OVER:String = NAME + "CameraOver";
		
		public static const GET_PER_CONFIG:String = NAME + "GetPerConfig";
		public static const GET_PER_CONFIG_OVER:String = NAME + "GetPerConfigOver";
		public static const SEND_PER_CONFIG:String = NAME + "SendPerConfig";
		public static const SEND_PER_CONFIG_OVER:String = NAME + "SendPerConfigOver";
		public static const GET_BGMUSIC_LIST:String = NAME + "GetBGMusicList";
		public static const GET_BGMUSIC_LIST_OVER:String = NAME + "GetBgMusicListOver";
		public static const DEL_BGMUSIC:String = NAME + "DelBgMusic";
		public static const DEL_BGMUSIC_OVER:String = NAME + "DelBgMusicOver";
		public static const ADD_BGMUSIC:String = NAME + "AddBgMusic";
		public static const ADD_BGMUSIC_OVER:String = NAME + "AddBgMusicOver";
		
		public static const ENABLE_GPU_SCREENS:String = NAME + "disableGpuScreens";
		
		public static const STOP_ALL_FORMULA:String = NAME+ "STOP_ALL_FORMULA";
		public static const SET_FORMULA_IMAGE:String = NAME + "SetFormulaImage";
		public static const GET_FORMULA_IMAGE:String = NAME + "GetFormulaImage";
		public static const COMPLETE_ALL_FORMULA:String = NAME + "COMPLETE_ALL_FORMULA";
		
		public static const GET_COMMAND:String = NAME + "GetCommand";
		public static const GET_COMMAND_OVER:String = NAME + "GetCommandOver";
		
		public static const UNLOAD_WORLD_MODULE:String = NAME + "UnloadWorldModule";
		
		
		public static const DO_SWITCH_STOP:String = NAME + "DoSwitchStop";
		public static const DELAY_SWITCH_STOP:String = NAME + "DelaySwitchStop";
		public static const MUTICONTROL_START:String = NAME + "MutiControlStart";
		public static const MUTICONTROL_STOP:String = NAME + "MutiControlStop";
		public static const MUTICONTROL_READY:String = NAME + "MutiControlReady";
		public static const SHOW_CHAT_VIEW:String = NAME + "ShowChatView";
		public static const MUTI_CHOSE_REMIND:String = NAME + "MutiChoseRemind";
		public static const REMIND_PRIVATE_MESS:String = NAME + "RemindPrivateMess";
		
		public static const REMIND_FIGHT_GAME:String = NAME + "RemindFightGame";
		public static const APPLY_FIGHT:String = NAME + "ApplyFight";
		
		public static const DOWNLOAD_APK_FACE:String = NAME + "DownloadApkFace";
		public static const DOWNLOAD_APK_FACE_COMPLETE:String = NAME + "DownloadApkFaceComplete";
		
		public static const UPLOAD_DEFAULT_INIT:String = NAME+"UploadDefaultInit";
		public static const UPLOAD_PERSON_INIT:String = NAME + "UploadPersonInit";
		public static const UPLOAD_USERFILE_INIT:String = NAME + "UploadUserfileInit";
		public static const UPLOAD_SPEECHCR_INIT:String = NAME  + "UploadSpeechCrInit";//上传辅导教室语音
		public static const UPLOAD_BOOKWENJIANINIT:String = NAME +"Upload_BookWenJianInit";//上传MP3文件
		public static const UPLOAD_CHRISTPHOTO:String = NAME +"Upload_ChristPhoto";//上传圣诞照片
		
		public static const BROADCAST_FAQ:String = NAME + "broadcast_FAQ";
		public static const BROADCAST_MAIL:String = NAME + "broadcast_mail";
		public static const BROADCAST_CHAT:String = NAME + "broadcast_chat";
		public static const BROADCAST_SYS:String = NAME + "broadcast_sys";
		public static const BROADCAST_CMD:String = NAME + "broadcast_cmd";
		public static const BROADCAST_CLASS:String = NAME + "broadcast_class";//教室
		public static const BROADCAST_CHATROOM:String = NAME + "broadcast_chatRoom";
		public static const BROADCAST_ONLINE:String = NAME + "broadcast_online";
		public static const BROADCAST_ISLAND:String = NAME + "broadcast_island";
		
		//公告栏
		public static const SHOW_NOTICE_BOARD:String = NAME + "ShowNoticeBoard";
		public static const HIDE_NOTICE_BOARD:String = NAME + "HideNoticeBoard";
		
		public static const UPLOAD_SYSTEM_LOG:String = NAME + 'uploadSystemLog';//上传系统日志
		
		public static const OPEN_MENU:String = NAME + "openMenu";
		public static const CLOSE_MENU:String = NAME + "closeMenu";
		public static const DISPOSE_MENU:String = NAME + "disposeMenu";
		
		public static const DISABLE_WORLD_BACK:String = NAME + "disableWorldBack";
		public static const ENABLE_WORLD_BACK:String = NAME + "enableWorldBack";
		public static const REGIST_MENU_SCREEN:String = NAME + "registMenuScreen";
		public static const REMOVE_MENU_SCREEN:String = NAME + "removeMenuScreen";
		public static const AUTO_LOGIN:String = NAME + "autoLogin";
		public static const VIEW_READY:String = NAME + "viewReady";
		public static const ANDROIDGAME_ICON_LOADED:String = NAME + "androidgameIconLoaded";
		
		public static const UP_IM_FILE:String = NAME + "upImFile";
		
		public static const CHECK_ANR:String = NAME + "checkAnr";
		
		public static const CHECK_TIME_LIMIT:String = NAME + "checkLimitTime";
		public static const CHECK_TIME_LIMIT_COMPLETE:String = NAME + "checkTimeLimitComplete";
		
		public static const RECORD_ACTION_FLAG:String = NAME + "recordActionFlag";
		
		public static const GET_STD_FNLVL:String = NAME + "getStdFnlvl";
		public static const GET_STD_FNLVL_COMPLETE:String = NAME + "getStdFnlvlComplete";
		public static const GET_LEVEL_LIST:String = NAME + "getLevelList";
		public static const GET_LEVEL_LIST_COMPLETE:String = NAME + "getLevelListComplete";
		
		public static const P2P_CONENCT:String = NAME + "P2pConnect";
		public static const P2P_CONNECT_ON:String = NAME + "P2pConnectOn";
		public static const P2P_CONNECT_OFF:String = NAME + "P2pConnectOff";
	}
}