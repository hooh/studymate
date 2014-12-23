package com.studyMate.controller
{
	import com.greensock.TweenLite;
	import com.mylib.api.IConfigProxy;
	import com.mylib.api.ISwitchScreenProxy;
	import com.mylib.framework.CoreConst;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.screens.EnglishIslandMediator;
	import com.studyMate.world.screens.HappyIslandMediator;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.SystemSetMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.WorldMediator;
	
	import myLib.soundManager.SoundAs;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import stateMachine.StateMachine;
	import stateMachine.StateMachineEvent;

	
	public class BGMusicManagerMediator extends Mediator
	{
		private const BG1:String = "bg1";
		private const MUTE:String = "mute";
		private const HappyLandBG:String = 'HappyLandBG';
		
		public static const NAME:String = "BGMusicManagerMediator";
		private var mainList:Vector.<String>;
		private var state:StateMachine;
		private var reset:Boolean=true;//是否修改声音配置文件
		
		public var canPlay:Boolean=true;
		
		public function BGMusicManagerMediator()
		{
			super(NAME);						
			
		}
		override public function onRemove():void{
			mainList.length = 0;
			mainList = null;
			SoundAs.removeAll();
			super.onRemove();
		}
		
		override public function onRegister():void
		{
			mainList = Vector.<String>(["music_mainTheme.mp3","music_minigame_love.mp3","music_minigame_tiptoe.mp3","music_minigame_waltz.mp3"]);
			state = new StateMachine();
			state.addState(BG1,{enter:enterBG1Handle,from:["*"]});
			state.addState(MUTE,{enter:enterMuteHandle,from:["*"]});			
			state.addState(HappyLandBG,{enter:HappyLandBGHandle,from:["*"]});
			state.initialState=MUTE;
		}
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case WorldConst.SET_BG_MUSIC_VOLUME:
					var i:Number = notification.getBody() as Number;
					SoundAs.volume = i;
					break;
				case CoreConst.DEACTIVATE:
					TweenLite.killTweensOf(switchMusic);;				
					state.changeState(MUTE);
					break;
				case WorldConst.SWITCH_SCREEN_COMPLETE:
				case CoreConst.ACTIVATE:
					TweenLite.killTweensOf(switchMusic);
					TweenLite.delayedCall(12,switchMusic,null,true);					
					break;
				case CoreConst.CHECK_EDUSERVICE_ROOT://意味着返回登录界面了
				case CoreConst.MUTE_EFFECT_SOUND:
					reset = true;
					break;
			}
		}
		override public function listNotificationInterests():Array
		{
			return [
				CoreConst.CHECK_EDUSERVICE_ROOT,
				CoreConst.MUTE_EFFECT_SOUND,
				CoreConst.ACTIVATE,
				CoreConst.DEACTIVATE,
				WorldConst.SET_BG_MUSIC_VOLUME,
				WorldConst.SWITCH_SCREEN_COMPLETE
			];
		}

		
		private function switchMusic():void{
			var currentScreen:ScreenBaseMediator = (facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy).currentGpuScreen;
			if(!currentScreen) return;//连续进入两个cpu Screen退出=null。如绘本
			switch(currentScreen.getMediatorName())
			{
				case HappyIslandMediator.NAME:	
					checkSound(HappyLandBG);
					break;
				case WorldMediator.NAME:
				case EnglishIslandMediator.NAME:
				case SystemSetMediator.NAME:
					checkSound(BG1);					
					break;	
				default:
					state.changeState(MUTE);
					break;
			}		
		}
		
		private function checkSound(mark:String):void{
			if(reset){	
				reset = false;
				var config:IConfigProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CONFIGPROXY)  as IConfigProxy;
				var tmpString:String  = config.getValueInUser("setSoundEffects");
				if(tmpString == "true"){
					canPlay = true;
				}else if(tmpString == "false"){
					canPlay = false;
				}else{					
					canPlay = true;					
					config.updateValueInUser("setSoundEffects",true);						
				}
			}
			if(canPlay){
				state.changeState(mark);
			}
		}
		
		//娱乐岛背景音乐
		private function HappyLandBGHandle(event:StateMachineEvent):void{
			SoundAs.removeSound(event.fromState);			
			SoundAs.removeSound(event.toState);
//			trace('移除',event.fromState);
			var fileName:String = 'christmas.mp3';
			var path:String = MyUtils.getSoundPath(fileName);
			SoundAs.loadSound(path, event.toState);			
			SoundAs.play(event.toState,1,0,10);						
		}
		//普通界面背景音乐	
		private function enterBG1Handle(event:StateMachineEvent):void{
			SoundAs.removeSound(event.fromState);			
			SoundAs.removeSound(event.toState);
//			trace('移除',event.fromState);
			var fileName:String = randomPick();
			var path:String = MyUtils.getSoundPath(fileName);
			SoundAs.loadSound(path, event.toState);			
			SoundAs.play(event.toState,1,0,0);	
			SoundAs.soundCompleted(event.toState,BG1CompleteHandle);
		}
		//禁音		
		private function enterMuteHandle(event:StateMachineEvent):void{
			SoundAs.removeAll();
		}
		
		private function BG1CompleteHandle():void{
			SoundAs.removeSound(BG1);
			SoundAs.loadSound(MyUtils.getSoundPath(randomPick()), BG1);
			SoundAs.play(BG1,1,0,0);
			SoundAs.soundCompleted(BG1,BG1CompleteHandle);
		}
		
		private function randomPick():String{
			return mainList[int(mainList.length*Math.random())];
		}
		
		
	}
}