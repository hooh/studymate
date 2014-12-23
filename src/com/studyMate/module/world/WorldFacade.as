package com.studyMate.module.world
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.controller.PopScreenDataCommand;
	import com.mylib.framework.controller.StartupAppCommand;
	import com.mylib.framework.model.MP3PlayerProxy;
	import com.mylib.framework.model.SimpleScriptNewProxy;
	import com.mylib.game.card.HeroFightManager;
	import com.mylib.game.charater.CharaterUtils;
	import com.mylib.game.charater.logic.BMPCharaterFactoryProxy;
	import com.mylib.game.charater.logic.PetFactoryProxy;
	import com.mylib.game.controller.AddFlowerControlComand;
	import com.mylib.game.controller.PackMCTextureCommand;
	import com.mylib.game.controller.PackPNGTextureCommand;
	import com.mylib.game.controller.SortContainerMediator;
	import com.mylib.game.model.CharaterSuitsProxy;
	import com.mylib.game.model.DressSuitsProxy;
	import com.mylib.game.model.ProfileAndDressSuitsMediator;
	import com.studyMate.controller.BGMusicManagerMediator;
	import com.studyMate.controller.BroadcastCommand;
	import com.studyMate.controller.BroadcastManagerMediator;
	import com.studyMate.controller.CheckANRCommand;
	import com.studyMate.controller.ExecuseScriptNewCommand;
	import com.studyMate.controller.GetInitializeDataMediator;
	import com.studyMate.controller.GetReadGiftCommand;
	import com.studyMate.controller.IslandSwitchScreenFunCommand;
	import com.studyMate.controller.ReGetInitializeDataCommand;
	import com.studyMate.controller.ShowNetStateCommand;
	import com.studyMate.controller.SwitchFirstScreenCommand;
	import com.studyMate.controller.SwitchToOldVersionCommand;
	import com.studyMate.controller.UploadChristmasInitCommand;
	import com.studyMate.controller.UploadDefaultInitCommand;
	import com.studyMate.controller.UploadPersonInitCommand;
	import com.studyMate.controller.UploadSysLogCommand;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.world.controller.AddPetDogAICommand;
	import com.studyMate.world.controller.CallCameraCommand;
	import com.studyMate.world.controller.CharaterTextureReadyCommand;
	import com.studyMate.world.controller.ConfigDependedModelCommand;
	import com.studyMate.world.controller.CreateCharaterTextureCommand;
	import com.studyMate.world.controller.CreateTalkingBoxCommand;
	import com.studyMate.world.controller.DefaultBeatCommand;
	import com.studyMate.world.controller.DeleteTaskDataCacheCommand;
	import com.studyMate.world.controller.DestroyTalkingBoxCommand;
	import com.studyMate.world.controller.DialogBoxShowCommand;
	import com.studyMate.world.controller.DisplayChatViewCommand;
	import com.studyMate.world.controller.DownloadApkFaceCommand;
	import com.studyMate.world.controller.GetCharaterEquipmentCommand;
	import com.studyMate.world.controller.GetCharaterLevelCommand;
	import com.studyMate.world.controller.GetServerEquipmentCommand;
	import com.studyMate.world.controller.HideLeftButtonCommand;
	import com.studyMate.world.controller.HideMenuCommand;
	import com.studyMate.world.controller.HideNoticeBoardCommand;
	import com.studyMate.world.controller.HideOnShowScreenCommand;
	import com.studyMate.world.controller.HideScreenCommand;
	import com.studyMate.world.controller.HideTalkingBoxCommand;
	import com.studyMate.world.controller.InitTaskListCommand;
	import com.studyMate.world.controller.LetCharaterWalkToCommand;
	import com.studyMate.world.controller.MarkMyCharaterCommand;
	import com.studyMate.world.controller.MarkOtherPlayerCharaterCommand;
	import com.studyMate.world.controller.RandomActionCommand;
	import com.studyMate.world.controller.RecordLoginInfoCommand;
	import com.studyMate.world.controller.ScreenShotCommand;
	import com.studyMate.world.controller.SendSimSimiMessageCommand;
	import com.studyMate.world.controller.ShowChangeLogCommand;
	import com.studyMate.world.controller.ShowLeftButtonCommand;
	import com.studyMate.world.controller.ShowMenuCommand;
	import com.studyMate.world.controller.ShowMusicPlayerCommand;
	import com.studyMate.world.controller.ShowNoticeBoardCommand;
	import com.studyMate.world.controller.ShowPersonalInfoCommand;
	import com.studyMate.world.controller.ShowTalkingBoxCommand;
	import com.studyMate.world.controller.StopPlayerMoveCommand;
	import com.studyMate.world.controller.StopPlayerTalkingCommand;
	import com.studyMate.world.controller.StopRandomAction;
	import com.studyMate.world.controller.UnloadWorldModuleCommand;
	import com.studyMate.world.controller.UpdateStuSignCommand;
	import com.studyMate.world.controller.UpdateTaskDataCommand;
	import com.studyMate.world.controller.UpdateTaskListCommand;
	import com.studyMate.world.model.MyCharaterInforMediator;
	import com.studyMate.world.model.PerConfigManagerMediator;
	import com.studyMate.world.model.PromiseManagerMediator;
	import com.studyMate.world.model.SimSimiProxy;
	import com.studyMate.world.model.SoundeffectsMediator;
	import com.studyMate.world.model.TaskListManagementMediator;
	import com.studyMate.world.model.vo.CharaterSuitsVO;
	import com.studyMate.world.model.vo.EquipmentItemVO;
	import com.studyMate.world.model.vo.SuitEquipmentVO;
	import com.studyMate.world.model.vo.SuitVO;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.chatroom.UpImFileCommand;
	import com.studyMate.world.screens.offPictureBook.OffTalkBookMediator;
	
	import flash.net.registerClassAlias;
	
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class WorldFacade extends Facade
	{
		
		public function WorldFacade(key:String)
		{
			
			super(key);
		}
		
		override protected function initializeController():void
		{
			// TODO Auto Generated method stub
			super.initializeController();
			
			
		}
		
		override protected function initializeFacade():void
		{
			// TODO Auto Generated method stub
			super.initializeFacade();
			
//			OffBookshelfNewView2Mediator;
			OffTalkBookMediator;
		}
		
		
		override protected function initializeModel():void
		{
			// TODO Auto Generated method stub
			super.initializeModel();
			var coreFacade:IFacade = Facade.getInstance(CoreConst.CORE);
			
			
			coreFacade.registerMediator(new GetInitializeDataMediator());
			coreFacade.registerMediator(new WorldInitMediator);
			

			coreFacade.registerProxy(new SimpleScriptNewProxy());//新的绘本修改界面
			coreFacade.registerProxy(new CharaterSuitsProxy());
			coreFacade.registerProxy(new SimSimiProxy());
			coreFacade.registerProxy(new PetFactoryProxy);
			coreFacade.registerProxy(new DressSuitsProxy());
			coreFacade.registerProxy(new MP3PlayerProxy());
			coreFacade.registerProxy(new BMPCharaterFactoryProxy);
//			coreFacade.registerProxy(new SoundProxy());
			
			
			coreFacade.registerMediator(new MyCharaterInforMediator);
			coreFacade.registerMediator(new SortContainerMediator);
			coreFacade.registerMediator(new ProfileAndDressSuitsMediator);
//			coreFacade.registerMediator(new MessageManagerMediator);
			coreFacade.registerMediator(new BGMusicManagerMediator);
			coreFacade.registerMediator(new BroadcastManagerMediator);
			coreFacade.registerMediator(new HeroFightManager);
			coreFacade.registerMediator(new PromiseManagerMediator);
			coreFacade.registerMediator(new TaskListManagementMediator);
			coreFacade.registerMediator(new PerConfigManagerMediator);
			coreFacade.registerMediator(new SoundeffectsMediator);
			
			//coreFacade.registerMediator(new SoundManageMediator());//关屏和打开屏幕，是否播放由内部类自己处理
			
			GlobalModule.charaterUtils = new CharaterUtils;
			coreFacade.registerProxy(GlobalModule.charaterUtils as Proxy);
			
			registerClassAlias("com.studyMate.world.model.vo.CharaterSuitsVO",CharaterSuitsVO);
			registerClassAlias("com.studyMate.world.model.vo.SuitEquipmentVO",SuitEquipmentVO);
			registerClassAlias("com.studyMate.world.model.vo.SuitVO",SuitVO);
			registerClassAlias("com.studyMate.world.model.vo.EquipmentItemVO",EquipmentItemVO);
			registerClassAlias("String",String);
			registerClassAlias("XML",XML);
			
			
			coreFacade.registerCommand(WorldConst.RANDOM_ACTION,RandomActionCommand);
			coreFacade.registerCommand(CoreConst.RE_GET_INITIALIZE_DATA,ReGetInitializeDataCommand);
			coreFacade.registerCommand(WorldConst.STOP_RANDOM_ACTION,StopRandomAction);
			coreFacade.registerCommand(WorldConst.PACK_MC_TEXTURE,PackMCTextureCommand);
			coreFacade.registerCommand(WorldConst.PACK_PNG_TEXTURE,PackPNGTextureCommand);
			coreFacade.registerCommand(WorldConst.HIDE_SCREEN,HideScreenCommand);
			coreFacade.registerCommand(WorldConst.LET_CHARATER_WALK_TO,LetCharaterWalkToCommand);
			coreFacade.registerCommand(WorldConst.SEND_SIMSIMI_MSG,SendSimSimiMessageCommand);
			coreFacade.registerCommand(WorldConst.ADD_FLOWER_CONTROL,AddFlowerControlComand);
			coreFacade.registerCommand(WorldConst.SHOW_MAIN_MENU,ShowMenuCommand);
			coreFacade.registerCommand(WorldConst.HIDE_MAIN_MENU,HideMenuCommand);
			coreFacade.registerCommand(WorldConst.DIALOGBOX_SHOW,DialogBoxShowCommand);
			coreFacade.registerCommand(WorldConst.POP_SCREEN_DATA,PopScreenDataCommand);
			coreFacade.registerCommand(WorldConst.ADD_PET_DOG_AI,AddPetDogAICommand);
			coreFacade.registerCommand(WorldConst.SHOW_LEFT_MENU, ShowLeftButtonCommand);
			coreFacade.registerCommand(WorldConst.HIDE_LEFT_MENU,HideLeftButtonCommand);
			coreFacade.registerCommand(WorldConst.CHARATER_TEXTURE_READY,CharaterTextureReadyCommand);
			coreFacade.registerCommand(WorldConst.CREATE_TALKINGBOX,CreateTalkingBoxCommand);
			coreFacade.registerCommand(WorldConst.SHOW_TALKINGBOX,ShowTalkingBoxCommand);
			coreFacade.registerCommand(WorldConst.HIDE_TALKINGBOX,HideTalkingBoxCommand);
			coreFacade.registerCommand(WorldConst.DESTROY_TALKINGBOX,DestroyTalkingBoxCommand);
			coreFacade.registerCommand(WorldConst.SHOW_PERSONALINFO,ShowPersonalInfoCommand);
			coreFacade.registerCommand(WorldConst.MARK_MY_CHARATER,MarkMyCharaterCommand);
			coreFacade.registerCommand(WorldConst.MARK_OTHER_PLAYER_CHARATER,MarkOtherPlayerCharaterCommand);
			coreFacade.registerCommand(WorldConst.SWITCH_TO_OLD_VERSION,SwitchToOldVersionCommand);
			coreFacade.registerCommand(WorldConst.STOP_PLAYER_TALKING,StopPlayerTalkingCommand);
			coreFacade.registerCommand(WorldConst.STOP_PLAYER_MOVE,StopPlayerMoveCommand);
			coreFacade.registerCommand(WorldConst.HIDE_ONSHOW_SCREEN,HideOnShowScreenCommand);
			coreFacade.registerCommand(WorldConst.CONFIG_DEPENDED_MODEL,ConfigDependedModelCommand);
			coreFacade.registerCommand(WorldConst.UPDATE_STU_SIGN,UpdateStuSignCommand);
			
			coreFacade.registerCommand(WorldConst.SHOW_MUSICPLAYER,ShowMusicPlayerCommand);
			coreFacade.registerCommand(WorldConst.ISLAND_SWITCHSCREEN_FUN,IslandSwitchScreenFunCommand);
			coreFacade.registerCommand(WorldConst.GET_READ_GIFT,GetReadGiftCommand);
			coreFacade.registerCommand(WorldConst.SCREEN_SHOT, ScreenShotCommand);
			coreFacade.registerCommand(WorldConst.SHOW_CHANGE_LOG, ShowChangeLogCommand);
			coreFacade.registerCommand(WorldConst.CALL_CAMERA, CallCameraCommand);
			coreFacade.registerCommand(WorldConst.CREATE_CHARATER_TEXTURE,CreateCharaterTextureCommand);
			coreFacade.registerCommand(WorldConst.SWITCH_FIRST_SCREEN,SwitchFirstScreenCommand);
//			coreFacade.registerCommand(WorldConst.PACK_CHARATER_TEXTURE,PackCharaterTextureCommand);
			
			
			coreFacade.registerCommand(WorldConst.RECORD_LOGIN_INFO,RecordLoginInfoCommand);
			coreFacade.registerCommand(WorldConst.INIT_TASKLIST,InitTaskListCommand);
			coreFacade.registerCommand(WorldConst.UPDATE_TAKSLIST,UpdateTaskListCommand);
			coreFacade.registerCommand(WorldConst.UPDATE_TASK_DATA,UpdateTaskDataCommand);
			coreFacade.registerCommand(WorldConst.DEL_TASK_DATA_CACHE,DeleteTaskDataCacheCommand);
			coreFacade.registerCommand(WorldConst.GET_CHARATER_EQUIPMENT,GetCharaterEquipmentCommand);
			coreFacade.registerCommand(CoreConst.EXECUSE_SCRIPT_NEW,ExecuseScriptNewCommand);//新的as3的界面显示绘本
			coreFacade.registerCommand(WorldConst.STARTUP_APP,StartupAppCommand);
			coreFacade.registerCommand(WorldConst.UNLOAD_WORLD_MODULE,UnloadWorldModuleCommand);
			coreFacade.registerCommand(WorldConst.GET_SERVER_EQUIPMENT,GetServerEquipmentCommand);
			coreFacade.registerCommand(WorldConst.CHECK_ANR,CheckANRCommand);
			
			coreFacade.registerCommand(CoreConst.BROADCAST,BroadcastCommand);
			
			
			coreFacade.registerCommand(WorldConst.SHOW_CHAT_VIEW,DisplayChatViewCommand);
			
			coreFacade.registerCommand(WorldConst.DOWNLOAD_APK_FACE,DownloadApkFaceCommand);
			
			coreFacade.registerCommand(WorldConst.UPLOAD_DEFAULT_INIT,UploadDefaultInitCommand);
			coreFacade.registerCommand(WorldConst.UPLOAD_PERSON_INIT,UploadPersonInitCommand);
			coreFacade.registerCommand(WorldConst.UPLOAD_CHRISTPHOTO,UploadChristmasInitCommand);
//			coreFacade.registerCommand(WorldConst.UPLOAD_SPEECHCR_INIT,UploadSpeechCRCommand);
			
			coreFacade.registerCommand(WorldConst.UPLOAD_SYSTEM_LOG,UploadSysLogCommand);//上传系统日志
			coreFacade.registerCommand(CoreConst.BEAT,DefaultBeatCommand);
			
			
			//公告栏
			coreFacade.registerCommand(WorldConst.SHOW_NOTICE_BOARD,ShowNoticeBoardCommand);
			coreFacade.registerCommand(WorldConst.HIDE_NOTICE_BOARD,HideNoticeBoardCommand);
		
			
			coreFacade.registerCommand(WorldConst.UP_IM_FILE,UpImFileCommand);
			
			coreFacade.registerCommand(WorldConst.SHOW_NETSTATE_CHECK,ShowNetStateCommand);
			
			coreFacade.registerCommand(WorldConst.GET_STD_FNLVL,GetCharaterLevelCommand);
		}
		
		
		
		
	}
}