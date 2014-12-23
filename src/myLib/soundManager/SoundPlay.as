package myLib.soundManager
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;

	/**
	 *
	 * @author wangtu
	 * 创建时间: 2014-9-28 下午5:54:32
	 * 
	 */	
	internal class SoundPlay
	{
		public var sound:Sound;
		public var soundChannel:SoundChannel;
		private var soundTransform:SoundTransform;
		
		public var _url:String;
		public var onComplete:Function;
			
		public function SoundPlay()
		{
		}
		public function set url(value:String):void{
			trace('加载声音',value);
			this._url = value;
			sound = new Sound();
			sound.addEventListener(Event.COMPLETE,completeHandler);
			sound.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);	
			var urlRequest:URLRequest = new URLRequest(value);
			sound.load(urlRequest);
		}
		
		public function play(url:String,startTime:Number=0,loops:int=0,vol:Number=1):void{
			if(soundChannel){
				soundChannel.stop();
			}
			this._url = url;
			soundTransform = new SoundTransform(vol);
			if(!sound){				
				var urlRequest:URLRequest = new URLRequest(url);
				sound = new Sound();
				sound.addEventListener(Event.COMPLETE,completeHandler);
				sound.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);			
				sound.load(urlRequest);				
			}
			soundChannel = sound.play(startTime,loops,soundTransform);
			soundChannel.addEventListener(Event.SOUND_COMPLETE,soundCompleteHandler);			
		}
		protected function completeHandler(event:Event):void
		{
			trace('soundEffect loadComplete!');
			if(sound)
				sound.removeEventListener(Event.COMPLETE,completeHandler);		
		}
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			trace("SoundEffect IOError!");
			if(sound){
				sound.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);			
			}
		}
		protected function soundCompleteHandler(event:Event):void
		{
			if(soundChannel){
				soundChannel.removeEventListener(Event.SOUND_COMPLETE,soundCompleteHandler);
				soundChannel.stop();
				soundChannel = null;
			}
			if(onComplete){
				onComplete.apply();
			}
		}
		
		public function stop():void{
			if(soundChannel){
				soundChannel.removeEventListener(Event.SOUND_COMPLETE,soundCompleteHandler);
				soundChannel.stop();
				soundChannel=null;
			}
			if(sound){				
				try {
					sound.close();
				} catch(e:Error){}
				sound = null;
			}			
			soundTransform = null;	
			onComplete = null;
		}
		
		public function set setVolume(vol:Number):void{
			if(soundChannel){
				soundTransform = new SoundTransform;
				soundTransform.volume = vol;
				soundChannel.soundTransform = soundTransform;
			}
		}
		
	}
}