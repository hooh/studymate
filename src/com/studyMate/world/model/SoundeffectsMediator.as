package com.studyMate.world.model
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.studyMate.controller.BGMusicManagerMediator;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.world.model.vo.LoadSoundEffectVO;
	import com.studyMate.world.model.vo.PlaySoundEffectVO;
	
	import flash.utils.Dictionary;
	
	import myLib.soundManager.SoundAs;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
		
	public class SoundeffectsMediator extends Mediator
	{
		public static const NAME:String = 'SoundeffectsMediator';
		public var dic:Dictionary;
		
		
		public function SoundeffectsMediator( viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function handleNotification(notification:INotification):void
		{
//			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("handleNotification"+notification.getName(),"SoundeffectsMediator",0));
			switch(notification.getName()){
				case CoreConst.LOAD_EFFECT_SOUND:
					var soundEffectVO:LoadSoundEffectVO = notification.getBody() as LoadSoundEffectVO;
					dic[soundEffectVO.type] = soundEffectVO.url;
					if((facade.retrieveMediator(BGMusicManagerMediator.NAME) as BGMusicManagerMediator).canPlay){						
						SoundAs.loadSound(soundEffectVO.url,soundEffectVO.type);
					}
					break;				
				case CoreConst.PLAY_EFFECT_SOUND:
					TweenLite.killDelayedCallsTo(delayPlay);
					TweenLite.delayedCall(3,delayPlay,[notification.getBody()],true);
					
					break;
				case CoreConst.REMOVE_EFFECT_SOUND:
					delete dic[notification.getBody()];
					SoundAs.removeSound(notification.getBody() as String);
					break;
				case CoreConst.MUTE_EFFECT_SOUND:
					var boo:Boolean = notification.getBody() as Boolean;
					if(boo){
						SoundAs.volume = 0;
					}else{
						SoundAs.volume = 1;
					}
					break;				
			}
			
//			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("handleNotification end","SoundeffectsMediator",0));

		}
		
		protected function delayPlay(soundplayEffectVO:PlaySoundEffectVO):void{
//			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("delayPlay s","SoundeffectsMediator",0));
			if((facade.retrieveMediator(BGMusicManagerMediator.NAME) as BGMusicManagerMediator).canPlay){				
				if(soundplayEffectVO){								
					if(SoundAs.hasSound(soundplayEffectVO.type)){
						SoundAs.play(soundplayEffectVO.type,soundplayEffectVO.volume);
					}else{
						if(dic[soundplayEffectVO.type]){						
							SoundAs.loadSound(dic[soundplayEffectVO.type],soundplayEffectVO.type);
							SoundAs.play(soundplayEffectVO.type,soundplayEffectVO.volume);
						}
					}
	
				}
			}
//			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("delayPlay e","SoundeffectsMediator",0));

		}
		
		override public function listNotificationInterests():Array
		{
			return [CoreConst.PLAY_EFFECT_SOUND,CoreConst.LOAD_EFFECT_SOUND,CoreConst.REMOVE_EFFECT_SOUND,CoreConst.MUTE_EFFECT_SOUND];
		}
		
		override public function onRegister():void
		{
			dic = new Dictionary();
		}
		
		override public function onRemove():void
		{
			super.onRemove();
		}
		
	}
}