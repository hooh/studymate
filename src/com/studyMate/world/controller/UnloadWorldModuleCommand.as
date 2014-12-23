package com.studyMate.world.controller
{
	import com.greensock.TweenMax;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.MP3PlayerProxy;
	import com.mylib.framework.model.SimpleScriptNewProxy;
	import com.mylib.game.card.HeroFightManager;
	import com.mylib.game.charater.DialogBoxShowProxy;
	import com.mylib.game.charater.TalkToSomeoneProxy;
	import com.mylib.game.charater.TalkingProxy;
	import com.mylib.game.charater.logic.BMPCharaterFactoryProxy;
	import com.mylib.game.charater.logic.HumanTalkShowProxy;
	import com.mylib.game.charater.logic.PetFactoryProxy;
	import com.mylib.game.controller.SortContainerMediator;
	import com.mylib.game.model.CharaterSuitsProxy;
	import com.mylib.game.model.DressSuitsProxy;
	import com.mylib.game.model.ProfileAndDressSuitsMediator;
	import com.studyMate.controller.BGMusicManagerMediator;
	import com.studyMate.controller.BroadcastManagerMediator;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.module.world.WorldInitMediator;
	import com.studyMate.world.model.MyCharaterInforMediator;
	import com.studyMate.world.model.PerConfigManagerMediator;
	import com.studyMate.world.model.PromiseManagerMediator;
	import com.studyMate.world.model.SimSimiProxy;
	import com.studyMate.world.model.SoundeffectsMediator;
	import com.studyMate.world.model.TaskListManagementMediator;
	import com.studyMate.world.screens.CalloutMenuMediator2;
	import com.studyMate.world.screens.MenuMainViewMediator;
	import com.studyMate.world.screens.NetworkStateMediator;
	import com.studyMate.world.screens.NoticeBoardMediator;
	
	import akdcl.skeleton.ConnectionData;
	import akdcl.skeleton.Tween;
	
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class UnloadWorldModuleCommand extends SimpleCommand
	{
		public function UnloadWorldModuleCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
		
			var coreFacade:IFacade = Facade.getInstance(CoreConst.CORE);
			
			coreFacade.removeMediator(ModuleConst.GET_INITIALIZE_DATA_MEDIATOR);
			coreFacade.removeMediator(WorldInitMediator.NAME);
			coreFacade.removeMediator(CalloutMenuMediator2.NAME);
//			coreFacade.removeMediator(ShowMenuViewMediator.NAME);
			coreFacade.removeMediator(NetworkStateMediator.NAME);
			coreFacade.removeMediator(PromiseManagerMediator.NAME);
			coreFacade.removeMediator(TaskListManagementMediator.NAME);
			coreFacade.removeMediator(PerConfigManagerMediator.NAME);
			coreFacade.removeMediator(MyCharaterInforMediator.NAME);
			coreFacade.removeMediator(SortContainerMediator.NAME);
			coreFacade.removeMediator(ProfileAndDressSuitsMediator.NAME);
//			coreFacade.removeMediator(MessageManagerMediator.NAME);
			coreFacade.removeMediator(BGMusicManagerMediator.NAME);
			coreFacade.removeMediator(BroadcastManagerMediator.NAME);
			coreFacade.removeMediator(HeroFightManager.NAME);
			coreFacade.removeMediator(ModuleConst.SOUND_MANAGER);
			coreFacade.removeMediator(ModuleConst.MY_KEYBOARD_COMPONENT);
			coreFacade.removeMediator(SoundeffectsMediator.NAME);
			coreFacade.removeMediator(NoticeBoardMediator.NAME);
			coreFacade.removeMediator(MenuMainViewMediator.NAME);
			
			coreFacade.removeProxy(SimpleScriptNewProxy.NAME);
			coreFacade.removeProxy(CharaterSuitsProxy.NAME);
			coreFacade.removeProxy(SimSimiProxy.NAME);
			coreFacade.removeProxy(PetFactoryProxy.NAME);
			coreFacade.removeProxy(DressSuitsProxy.NAME);
			coreFacade.removeProxy(MP3PlayerProxy.NAME);
			coreFacade.removeProxy(BMPCharaterFactoryProxy.NAME);
			coreFacade.removeProxy(ModuleConst.CHARATER_UTILS);
//			coreFacade.removeProxy(SoundProxy.NAME);
			
			GlobalModule.charaterUtils = null;
			facade.removeProxy(ModuleConst.HUMAN_POOL);
			facade.removeProxy(ModuleConst.BMP_FIGHTER_POOL);
			
			facade.removeProxy(HumanTalkShowProxy.NPC);
			facade.removeProxy(HumanTalkShowProxy.PLAYER);
			facade.removeProxy(TalkToSomeoneProxy.NAME);
			facade.removeProxy(TalkingProxy.NAME);
			facade.removeProxy(DialogBoxShowProxy.NAME);
			ConnectionData.animationDatas = {};
			ConnectionData.armarureDatas={};
			Tween.prepared.length=0;
			TweenMax.killAll(true);
		}
		
	}
}