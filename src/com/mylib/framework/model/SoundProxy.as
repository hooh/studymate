package com.mylib.framework.model
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.model.vo.SoundVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.utils.MyUtils;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public final class SoundProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "SoundProxy";
		private var fileStream:FileStream;
		
		private var mp3ByteArray:ByteArray;
		private var playingList:Vector.<SoundVO>;
		
		private var sound:Sound;
		private var soundChannel:SoundChannel;
		private var soundTransform:SoundTransform;
			
		public function SoundProxy(data:Object=null)
		{
			super(NAME, data);
			
		}
		
		private var _url:String;
		private var _poistion:uint;
		private var _duration:uint;
		private var _complete:String;
		
		public function play(vo:SoundVO=null):void{	
			TweenLite.killDelayedCallsTo(delayPlay);
			TweenLite.delayedCall(2,delayPlay,[vo],true);
		}
		
		protected function delayPlay(vo:SoundVO=null):void{

			if(vo==null){
				vo = getData() as SoundVO;
			}
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("delayPlay s"+vo.position+ ":"+vo.duration,"SoundProxy",0));
			if(vo){
				//文件和文件位置没有改变则用原来对象播放
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
			}else{
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("delayPlay return","SoundProxy",0));

				return;
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
			
			
			
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("delayPlay e","SoundProxy",0));

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
						sendNotification(CoreConst.TOAST,new ToastVO("文件"+vo.url+"不完整,您可以通过faq面板反馈给我们"));
					}
				}else{
					sendNotification(CoreConst.TOAST,new ToastVO(vo.url+"文件不存在!"));

				}
			}else{
				//整文件播放
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("loadSound all","SoundProxy",0));

				
//				sound = new Sound(new URLRequest(vo.url));
//				soundChannel = sound.play(vo.position,vo.loop);
			}
		}
		

		protected function ioErrorHandler(event:IOErrorEvent):void{
//			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("ioErrorHandler","SoundProxy",0));

			trace('SoundProxy ioErrorHandler');	
			var str:String = '';
			if(sound)
				str = sound.url;
			str += "单词读音文件不完整,您可以通过faq面板反馈给我们";
			
			sendNotification(CoreConst.TOAST,new ToastVO(str));
		}
		
		private function soundCompleteHandle(event:Event):void{
			if(_complete!="" && _complete!=null){
				sendNotification(_complete);
			}
			trace("SoundProxy play complete");		
			
//			sendNotification(CoreConst.FLOW_RECORD,new RecordVO("soundCompleteHandle"+_complete,"SoundProxy",0));

		}
		
		

		public function stop(vo:SoundVO=null):void{
			TweenLite.killDelayedCallsTo(delayPlay);
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
		
	}
}