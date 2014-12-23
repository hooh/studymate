package com.studyMate.world.component.weixin
{
	import com.edu.AMRMedia;
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.MP3PlayerProxy;
	import com.studyMate.global.Global;
	import com.studyMate.global.OSType;
	import com.studyMate.model.vo.RemoteFileLoadVO;
	import com.studyMate.world.component.weixin.vo.WeixinVO;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	
	
	/**
	 * 语音广播核心模块,实现下载并听的功能.
	 * @author wt
	 * 
	 */	
	internal class VoiceBroadcastMediator extends Mediator
	{
		private var NAME:String = 'VoiceBroadcastMediator';
			
		private var mute:Boolean;//静音标志true代表禁音
		
		private var preVO:WeixinVO;
		//当前播放
		private var preWeixinVO:WeixinVO;
		//当前下载
		private var downWeixinVO:WeixinVO;
		private var downPath:String;
		private var mp3Proxy:MP3PlayerProxy;
		//下载结束
		private const DOWN_SPEECH_COMPLETE:String = 'down_speech_complete';
		
		public var core:String;
		
		public function VoiceBroadcastMediator(mediatorName:String=null, viewComponent:Object=null)
		{
//			if(mediatorName==null) mediatorName = NAME;
			NAME = mediatorName;
			super(NAME, viewComponent);
		}
		override public function onRemove():void{
			Facade.getInstance(CoreConst.CORE).removeMediator(NAME);
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SET_BG_MUSIC_VOLUME,1);
			AMRMedia.getInstance().removeEventListener(AMRMedia.PLAY_COMPLETE,playComplete);
			AMRMedia.getInstance().stopAMR();
			TweenLite.killDelayedCallsTo(whetherDownload);			
			preVO = null;
			preWeixinVO = null;
			downWeixinVO = null;
			mp3Proxy.onRemove();
			super.onRemove();
		}
		override public function onRegister():void{
			Facade.getInstance(CoreConst.CORE).registerMediator(this);
			mp3Proxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(MP3PlayerProxy.NAME) as MP3PlayerProxy;
		}
		override public function handleNotification(notification:INotification):void{			
			switch(notification.getName()) {
				case SpeechConst.WEIXIN_UI_CLICK://点击事件
					whetherDownload(notification.getBody() as WeixinVO);
					break;
				case DOWN_SPEECH_COMPLETE://下载完成后自动播放
					if(downWeixinVO){
						downWeixinVO.updateUIState = VoiceState.defaultState;
						whetherDownload(downWeixinVO);
					}
					break;
				case SpeechConst.ADD_NEW_SPEECH:
					if(VoicechatComponent.owner(core).configVoice.autoPlay && !mute){
						TweenLite.killDelayedCallsTo(whetherDownload);
						TweenLite.delayedCall(0.3,whetherDownload,[notification.getBody()]);						
					}
					break;
				case SpeechConst.STOP_AMR_SOUND:
					if(preWeixinVO && preWeixinVO.voiceState ==VoiceState.playState){
						preWeixinVO.updateUIState = VoiceState.defaultState;
						AMRMedia.getInstance().removeEventListener(AMRMedia.PLAY_COMPLETE,playComplete);
						AMRMedia.getInstance().stopAMR();
					}
					mp3Proxy.onRemove();
					mute = true;
					break;
				case SpeechConst.RECOVER_AMR_SOUND:
					mute = false;
					break;
				case MP3PlayerProxy.SOUND_COMPLETE:
					if(preWeixinVO){
						preWeixinVO.updateUIState = VoiceState.defaultState;
					}
					break;
			}
		}
		
		private function whetherDownload(voiceVO:WeixinVO):void{
			if(VoicechatComponent.owner(core).localFile(voiceVO.mtxt).exists && !mute){//真实下载目录中文件存在
				if(preWeixinVO == voiceVO){//点击的是同一个的时候
					if(preWeixinVO.voiceState==VoiceState.playState){
						preWeixinVO.updateUIState = VoiceState.defaultState;
						AMRMedia.getInstance().removeEventListener(AMRMedia.PLAY_COMPLETE,playComplete);
						AMRMedia.getInstance().pauseAMR();
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SET_BG_MUSIC_VOLUME,1);
					}else{
						if(voiceVO.mtxt.lastIndexOf('mp3')!=-1)	{
							if(mp3Proxy.soundChannel){	
								if(Global._mp3IsRunning)	mp3Proxy.pause();
								else mp3Proxy.resume();
								preWeixinVO.updateUIState = VoiceState.defaultState;
							}else{
								preWeixinVO.updateUIState = VoiceState.playState;
								mp3Proxy.play(VoicechatComponent.owner(core).localFile(voiceVO.mtxt).url,0,0,10);
							}						
						}else{	
							if(Global.OS == OSType.WIN){
								VoicechatComponent.owner(core).localFile(voiceVO.mtxt).openWithDefaultApplication();
							}else{							
								preWeixinVO.updateUIState = VoiceState.playState;
								AMRMedia.getInstance().addEventListener(AMRMedia.PLAY_COMPLETE,playComplete);
								AMRMedia.getInstance().playAMR(VoicechatComponent.owner(core).localFile(voiceVO.mtxt).nativePath);
							}
						}
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SET_BG_MUSIC_VOLUME,0);
					}
				}else{					
					if(preWeixinVO && preWeixinVO.voiceState ==VoiceState.playState){
						preWeixinVO.updateUIState = VoiceState.defaultState;
						AMRMedia.getInstance().stopAMR();
					}					
					preWeixinVO = voiceVO;					
					if(voiceVO.mtxt.lastIndexOf('mp3')!=-1)	{						
						mp3Proxy.stop();
						mp3Proxy.play(VoicechatComponent.owner(core).localFile(voiceVO.mtxt).url,0,0,10);
						preWeixinVO.updateUIState = VoiceState.playState;
					}else{	
						if(Global.OS == OSType.WIN){
							VoicechatComponent.owner(core).localFile(voiceVO.mtxt).openWithDefaultApplication();
						}else{
							preWeixinVO.updateUIState = VoiceState.playState;
							AMRMedia.getInstance().addEventListener(AMRMedia.PLAY_COMPLETE,playComplete);
							AMRMedia.getInstance().playAMR(VoicechatComponent.owner(core).localFile(voiceVO.mtxt).nativePath);
							Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SET_BG_MUSIC_VOLUME,0);
						}
					}
				}
			}else{
				if(VoicechatComponent.owner(core).configVoice.autoPlay || VoicechatComponent.owner(core).configVoice.autoDown){		
					
					if(Global.isLoading==false){						
						downPath = voiceVO.mtxt;
						downWeixinVO = voiceVO;
						downWeixinVO.updateUIState = VoiceState.loadingState;
						var downVO:RemoteFileLoadVO = new RemoteFileLoadVO(voiceVO.mtxt,VoicechatComponent.owner(core).localPath(voiceVO.mtxt),DOWN_SPEECH_COMPLETE);
						downVO.downType = RemoteFileLoadVO.USER_FILE;
						Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.REMOTE_FILE_LOAD,downVO);				
					}
				}
			}
		}
		
		//播放完成
		private function playComplete(e:flash.events.Event):void{
			AMRMedia.getInstance().stopAMR();
			AMRMedia.getInstance().removeEventListener(AMRMedia.PLAY_COMPLETE,playComplete);
			if(preWeixinVO){
				preWeixinVO.updateUIState = VoiceState.defaultState;
			}
			//恢复背景声音
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SET_BG_MUSIC_VOLUME,1);
			
			
		}
		
		
		
		override public function listNotificationInterests():Array{
			return [
				SpeechConst.STOP_AMR_SOUND,
				SpeechConst.ADD_NEW_SPEECH,
				SpeechConst.RECOVER_AMR_SOUND,
				DOWN_SPEECH_COMPLETE,
				MP3PlayerProxy.SOUND_COMPLETE,
				SpeechConst.WEIXIN_UI_CLICK];
		}
	}
}