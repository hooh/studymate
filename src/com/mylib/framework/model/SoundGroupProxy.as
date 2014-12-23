package com.mylib.framework.model
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.model.vo.SoundVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.module.engLearn.api.LearnConst;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	
	/**
	 * note
	 * 2014-10-29下午12:06:59
	 * Author wt
	 *
	 */	
	
	public class SoundGroupProxy extends Proxy
	{
		public static const NAME:String = "SoundGroupProxy";

		private var fileStream:FileStream;
		private var mp3ByteArray:ByteArray;
		private var soundVec:Vector.<SoundVO>;
		
		private var sound:Sound;
		private var soundChannel:SoundChannel;
		private var soundTransform:SoundTransform;
		
		private var _url:String;
		private var _poistion:uint;
		private var _duration:uint;
		private var _complete:String;
		
		override public function onRegister():void
		{
			fileStream = new FileStream();
			mp3ByteArray = new ByteArray();
			
		}
		
		override public function onRemove():void
		{			
			stop();
			super.onRemove();
		}
		
		public function SoundGroupProxy(proxyName:String=null, data:Object=null)
		{
			super(NAME, data);
		}
		public function playVec(vec:Vector.<SoundVO>):void{
			soundVec = vec;
			//清理上一个声音
			stop();					
			//播放声音	
			var vo:SoundVO = vec.shift(); 
			loadSound(vo);
			if(sound){
				_complete = vo.completeNotice;
				sound.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			}
			if(soundChannel)
				soundChannel.addEventListener(Event.SOUND_COMPLETE,soundVecCompleteHandle);
			
		}
		
		public function play(vo:SoundVO):void{
			//文件和文件位置没有改变则用原来对象播放
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("play "+vo.position+ ":"+vo.duration,"SoundGroupProxy s",0));
			trace('playSound s',vo.url,vo.position,vo.duration);
			if(_url==vo.url && _poistion == vo.position && _duration==vo.duration && sound){
				if(soundChannel){
					soundChannel.stop();
				}
				soundChannel = sound.play(0,vo.loop);
				soundTransform = new SoundTransform(vo.initVolume);
				soundChannel.soundTransform = soundTransform;
			}else{//否则停掉原来播放的，重新加载声音
				//清理上一个声音
				stop();					
				//播放声音					
				loadSound(vo);
			}
		
			if(sound){
				_url = vo.url;
				_poistion = vo.position;
				_duration = vo.duration;
				_complete = vo.completeNotice;
				sound.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			}
			if(soundChannel)
				soundChannel.addEventListener(Event.SOUND_COMPLETE,soundCompleteHandle);
			
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("play "+vo.position+ ":"+vo.duration,"SoundGroupProxy e",0));
			trace('playSound e',vo.url,vo.position,vo.duration);

			
		}
		
		
		
		
		protected function loadSound(vo:SoundVO):void{
			if(vo.duration>0){
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("loadSound:"+vo.duration+":"+vo.position,"SoundProxy",0));
				
				var file:File = Global.document.resolvePath(vo.url);
				mp3ByteArray.clear();		
				if(file.exists){					
					try{
						fileStream.open(file,FileMode.READ);			
						fileStream.position = uint(vo.position/36)*576;
						fileStream.readBytes(mp3ByteArray,0,Math.ceil(vo.duration/36)*576);
						fileStream.close();				
						
						sound = new Sound();
						sound.loadCompressedDataFromByteArray(mp3ByteArray,mp3ByteArray.length);
						soundChannel = sound.play(0,vo.loop);
						soundTransform = new SoundTransform(vo.initVolume);
						soundChannel.soundTransform = soundTransform;	
					}catch(e:Error){
						sendNotification(CoreConst.TOAST,new ToastVO("文件"+vo.url+"不完整或参数设置错误!,您可以通过faq面板反馈给我们"));
						sendNotification(LearnConst.SOUND_COMPLETE);
					}
				}else{
					sendNotification(CoreConst.TOAST,new ToastVO(vo.url+"文件不存在!"));
					sendNotification(LearnConst.SOUND_COMPLETE);
				}
			}else{
				//整文件播放
				sendNotification(CoreConst.TOAST,new ToastVO("声音文件录入时长有问题!您可以通过faq反馈给我们。"));
				sendNotification(LearnConst.SOUND_COMPLETE);
			}
		}
		
		protected function ioErrorHandler(event:IOErrorEvent):void{			
			var str:String = '';
			if(sound)
				str = sound.url;
			str += "单词读音文件不完整,您可以通过faq面板反馈给我们";
			
			sendNotification(CoreConst.TOAST,new ToastVO(str));
			sendNotification(LearnConst.SOUND_COMPLETE);
		}
		
		private function soundCompleteHandle(event:Event):void{
			if(_complete!="" && _complete!=null){
				sendNotification(_complete);
			}
			sendNotification(LearnConst.SOUND_COMPLETE);
			trace("SoundProxy play complete");		
						
		}
		private function soundVecCompleteHandle(event:Event):void{
			if(soundVec.length>0){
				playVec(soundVec);
			}else{				
				if(_complete!="" && _complete!=null){
					sendNotification(_complete);
				}
				trace("SoundProxy play complete");	
				sendNotification(LearnConst.SOUND_COMPLETE);
			}
			
		}
		
		
		public function stop():void{
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