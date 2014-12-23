package com.mylib.framework.model
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.SoundVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.module.engLearn.api.LearnConst;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import treefortress.sound.SoundAS;
	
	
	/**
	 * note
	 * 2014-11-18下午4:47:32
	 * Author wt
	 *
	 */	
	
	public class SoundGroup2Proxy extends Proxy
	{
		public static const NAME:String = "SoundGroup2Proxy";
		
		public function SoundGroup2Proxy(proxyName:String=null, data:Object=null)
		{
			super(NAME, data);
		}
		
		
		private var sound:Sound;
		private var soundChannel:SoundChannel;
		private var soundTransform:SoundTransform;
		
		private var _url:String;
		private var _startPosition:uint;
		private var _duration:uint;
		
		private var soundVec:Vector.<SoundVO>;
		
		override public function onRemove():void
		{			
			dispose();
			super.onRemove();
		}
		override public function onRegister():void
		{
			
		}
		public function playVec(vec:Vector.<SoundVO>):void{
			soundVec = vec;
			play(vec.shift())
			
		}
		
		
		public function play(vo:SoundVO):void{
			
			if(_url==vo.url){
				if(sound){					
					if(soundChannel){
						soundChannel.stop();
					}
					soundChannel = sound.play(vo.position,vo.loop);
					soundTransform = new SoundTransform(vo.initVolume);
					soundChannel.soundTransform = soundTransform;
					
					trace("startTime",_startPosition,_duration);
					trace('读同一个文件');
				}else{
					soundNewPlay(vo.url,vo.position);
					trace('读加载的新文件1');
				}								
			}else{												
				soundNewPlay(vo.url,vo.position);
				trace('读加载的新文件2');
			}
			
			
			
			this._url = vo.url;
			this._startPosition = vo.position;
			this._duration = vo.duration;
			
			if(soundChannel){
				stopCheckEnd();
				checkEnd();
				soundChannel.addEventListener(Event.SOUND_COMPLETE,soundCompleteHandle);
			}
			if(sound)
				sound.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);	
			
		}
		
		
		private function soundNewPlay(url:String,startTime:Number=0,loops:int=0,vol:Number=1):void{
			if(soundChannel){
				soundChannel.stop();
			}
			var urlRequest:URLRequest = new URLRequest(Global.document.resolvePath(url).url);
			soundTransform = new SoundTransform(vol);
			sound = new Sound();					
			sound.load(urlRequest);
			soundChannel = sound.play(startTime,loops,soundTransform);
			trace("startTime",startTime);
		}
		
		private function checkEnd():void{
			if(soundChannel){
				TweenLite.delayedCall(0.1,checkEnd);
				if(soundChannel.position >= this._startPosition+this._duration){
					if(soundChannel){
						soundChannel.stop();
					}
					stopCheckEnd();
					soundCompleteHandle();
					soundChannel.removeEventListener(Event.SOUND_COMPLETE,soundCompleteHandle);
				}				
			}
			
		}
		private function stopCheckEnd():void{
			TweenLite.killDelayedCallsTo(checkEnd);
		}
		

		private function soundCompleteHandle(event:Event = null):void{
			if(soundChannel) soundChannel.removeEventListener(Event.SOUND_COMPLETE,soundCompleteHandle);
			if(soundVec && soundVec.length>0){
				playVec(soundVec);
			}else{				
				sendNotification(LearnConst.SOUND_COMPLETE);
				trace("SoundProxy play complete");					
			}
		}
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			dispose();
			var str:String = this._url;
			str += "读音文件不完整,您可以通过faq面板反馈给我们";
			
			sendNotification(CoreConst.TOAST,new ToastVO(str));
			sendNotification(LearnConst.SOUND_COMPLETE);
		}
		public function stop():void{
			TweenLite.killDelayedCallsTo(checkEnd);
			if(soundVec) soundVec.length = 0;
			if(soundChannel){
				soundChannel.removeEventListener(Event.SOUND_COMPLETE,soundCompleteHandle);
				soundChannel.stop();
			}
		}
		
		private function dispose():void{
			TweenLite.killDelayedCallsTo(checkEnd);
			if(soundVec) soundVec.length = 0;
			if(soundChannel){
				soundChannel.removeEventListener(Event.SOUND_COMPLETE,soundCompleteHandle);
				soundChannel.stop();
				soundChannel=null;
			}
			try {
				sound.close();
			} catch(e:Error){}
			
			soundTransform = null;
			sound = null;	
		}
	}
}