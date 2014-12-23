package com.studyMate.world.screens.menu
{
	import com.mylib.api.ISwitchScreenProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.PopUpCommandVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.module.engLearn.WordLearningBGMediator;
	import com.studyMate.world.screens.CleanCpuMediator;
	import com.studyMate.world.screens.EnglishIslandMediator;
	import com.studyMate.world.screens.FAQChatMediator;
	import com.studyMate.world.screens.HappyIslandMediator;
	import com.studyMate.world.screens.HonourViewMediator;
	import com.studyMate.world.screens.MonthTaskInfoMediator;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.ShowProMediator;
	import com.studyMate.world.screens.SystemSetMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.WorldMediator;
	import com.studyMate.world.screens.email.EmailViewMediator;
	
	import flash.desktop.NativeApplication;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.events.Event;

	public class ShowMenuViewMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "ShowMenuViewMediator";
		
		private const GETMONEY:String = "GetMoney";
		
		private var parentScreen:ScreenBaseMediator;
		
		
		public function ShowMenuViewMediator(viewComponent:Object = null)
		{
			super(NAME,viewComponent)
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class
		{
			return ShowMenuView
		}
		
		public function get view():ShowMenuView
		{
			return getViewComponent()as ShowMenuView;
		}
		
		
		override public function onRegister():void
		{
//			sendNotification(WorldConst.OPEN_MENU);
			sendNotification(WorldConst.POPUP_SCREEN,(new PopUpCommandVO(this)));
			sendNotification(WorldConst.SET_ROLL_SCREEN,false);
			AppLayoutUtils.cpuLayer.visible = false;
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN,keybackHandle);
			getCustMoney("SYSTEM.GMONEY");
			addTouchEvent();
			distributionUI();
		}
		
		private function addTouchEvent():void
		{
			view.FAQBtn.addEventListener(Event.TRIGGERED,faqHandler);
			view.settingBtn.addEventListener(Event.TRIGGERED,settingHandler);
			view.appointBtn.addEventListener(Event.TRIGGERED,appointHandler);
			view.chatBtn.addEventListener(Event.TRIGGERED,chatHandler);
//			view.coachBtn.addEventListener(Event.TRIGGERED,coachHandler);
			view.emailBtn.addEventListener(Event.TRIGGERED,emailHandler);
			view.musicBtn.addEventListener(Event.TRIGGERED,musicHandler);
			view.achievementBtn.addEventListener(Event.TRIGGERED,achievementHandler);
			view.studyRepBtn.addEventListener(Event.TRIGGERED,studyRepHandler);
		}		
		
		private function studyRepHandler():void
		{
//			sendNotification(WorldConst.SHOW_CHAT_VIEW,new DisplayChatViewCommandVO(false));
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(MonthTaskInfoMediator,Global.player.operId.toString(),SwitchScreenType.SHOW,AppLayoutUtils.gpuPopUpLayer)]);
		}
		
		private function achievementHandler():void
		{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(HonourViewMediator),new SwitchScreenVO(CleanCpuMediator)]);
		}
		
		private function musicHandler():void
		{
			sendNotification(WorldConst.SHOW_MUSICPLAYER);
		}
		
		private function emailHandler():void
		{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(EmailViewMediator)]);		
		}
		

		
		private function chatHandler():void
		{
			
		}
		
		private function appointHandler():void
		{
			var data:String = ShowProMediator.SHOW_ALL;
			if(Global.myPromiseInf == null){
				data = ShowProMediator.SHOW_ALL;
			}else if(Global.myPromiseInf.newFinishCount != 0){
				data = ShowProMediator.SHOW_FINISH;
			}else if(Global.myPromiseInf.unFinishCount != 0){
				data = ShowProMediator.SHOW_UNFINISH;
			}
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(CleanCpuMediator),new SwitchScreenVO(ShowProMediator,data)]);
			
		}
		
		private function settingHandler():void
		{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SystemSetMediator),new SwitchScreenVO(CleanCpuMediator)]);
		}
		
		private function faqHandler():void
		{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(FAQChatMediator,null,SwitchScreenType.SHOW,null)]);			
		}
		
		private function getCustMoney(type:String):void
		{
			PackData.app.CmdIStr[0] = CmdStr.GET_MONEY;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = type;
			PackData.app.CmdInCnt = 3;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(GETMONEY,null,"cn-gb",null,SendCommandVO.QUEUE));
			
		}
		
		private function distributionUI():void
		{
			var currentScreen:ScreenBaseMediator = (facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy).currentGpuScreen;
			switch(currentScreen.getMediatorName())
			{
				case EnglishIslandMediator.NAME:
				{
					view.showButtonByLevel(2);	
					break;
				}
				case WorldMediator.NAME:
				{
					view.showButtonByLevel(-1);	
					break;
				}
				case HappyIslandMediator.NAME:
				{
					view.showButtonByLevel(-1);	
					break;
				}
				case ModuleConst.TASKLIST:
				{
					view.showButtonByLevel(2);
					break;
				}
				case WordLearningBGMediator.NAME:
				{
					view.showButtonByLevel(2);
					break;
				}

			}
		}
		
		protected function keybackHandle(event:KeyboardEvent):void
		{
			if(event.keyCode ==Keyboard.BACK || event.keyCode == Keyboard.ESCAPE){
				event.preventDefault();
				var proxy:ISwitchScreenProxy = facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy;
				if(proxy.gpuStack.lastTwoScreen()||proxy.cpuStack.lastTwoScreen()){
					view.removeChildren(0,-1,false);
//					sendNotification(WorldConst.REMOVE_POPUP_SCREEN,this);
				}
			}			
		}
		
		override public function onRemove():void
		{
			AppLayoutUtils.cpuLayer.visible = true;
			sendNotification(WorldConst.SET_ROLL_SCREEN,true);
			NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN,keybackHandle);
			sendNotification(WorldConst.REMOVE_POPUP_SCREEN,this);
	/*		var switchProxy:ISwitchScreenProxy = facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy;
			switchProxy.currentGpuScreen = parentScreen;*/

		}
		

		private function creatBackground():void
		{
			
		}
		
		private function menuButton():void
		{
				
		}
		
		
		override public function handleNotification(notification:INotification):void
		{
			var _result:DataResultVO = notification.getBody()as DataResultVO;
			switch(notification.getName()){
				case GETMONEY:
				{
					if(!_result.isErr){
						if(PackData.app.CmdOStr[0] == "000"){
							if(PackData.app.CmdOStr[2] == "SYSTEM.GMONEY"){
								view.diamondText.text = PackData.app.CmdOStr[4];
								getCustMoney("SYSTEM.SMONEY");
							}else if(PackData.app.CmdOStr[2] == "SYSTEM.SMONEY"){
								view.goldenText.text = PackData.app.CmdOStr[4];
							}
						}
					}
					break;	
				}

			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [GETMONEY];
		}
		
	}
}