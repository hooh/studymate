package com.mylib.framework.model
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.RecordVO;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class MP3PlayerProxy extends Proxy implements IProxy
	{
		
		//public static const ID3_READY:String = "Id3Ready";
		
		public static const LOADED_COMPLETE:String = NAME+"LoadedComplete";
		
		public static const SOUND_COMPLETE:String= NAME+"SoundComplete";
		
		public static const SOUND_STOP:String = NAME + "SOUND_STOP";
		
		public static const SOUND_ERROR:String =NAME+ "SOUND_ERROR";
		
		public static const NAME:String = "MP3PlayerProxy";
		
		public var sound:Sound;
		public var soundChannel:SoundChannel;
		private var soundTransform:SoundTransform;
		
		private var startTime:Number=0;
		private var pauseTime:Number=0;
		private var loops:int=0;
		private var volume:Number=1;
		public var url:String = "";
		
//		public static var _mp3IsRunning:Boolean=false;//关屏判断有用。
//		private var id3Array:Array;
		
		
		
		public function MP3PlayerProxy(proxyName:String="MP3PlayerProxy")
		{
			super(proxyName);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		
		public function play(url:String,startTime:Number=0,loops:int=0,vol:Number=1):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("play ","MP3PlayerProxy",0));
			if(soundChannel){
				soundChannel.stop();
			}
			this.url = url;
			this.startTime = startTime
			this.loops = loops;
			this.volume = vol;
			var urlRequest:URLRequest = new URLRequest(url);
			soundTransform = new SoundTransform(vol);
			sound = new Sound();
//			sound.addEventListener(Event.ID3,encodeId3);
			sound.addEventListener(Event.COMPLETE,completeHandler);
			sound.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);			
			sound.load(urlRequest);
			soundChannel = sound.play(startTime,loops,soundTransform);
			if(soundChannel){
				soundChannel.addEventListener(Event.SOUND_COMPLETE,soundCompleteHandler);				
			}
			Global._mp3IsRunning = true;
			
		}
		
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			// TODO Auto-generated method stub
			trace("SoundProxy Sound IOError!");
			Global._mp3IsRunning = false;
			sendNotification(SOUND_ERROR);
			
		}
		
		protected function completeHandler(event:Event):void
		{
			if(sound){
				sound.removeEventListener(Event.COMPLETE,completeHandler);				
			}
			
			/*soundChannel = sound.play(startTime,loops,soundTransform);
			soundChannel.addEventListener(Event.SOUND_COMPLETE,soundCompleteHandler);*/
			Global._mp3IsRunning = true;
			sendNotification(LOADED_COMPLETE,url);
		}
		
		protected function soundCompleteHandler(event:Event):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("soundCompleteHandler ","MP3PlayerProxy",0));

			Global._mp3IsRunning = false;
			if(soundChannel){
				soundChannel.removeEventListener(Event.SOUND_COMPLETE,soundCompleteHandler);
				soundChannel.stop();
				soundChannel = null;
			}
			sendNotification(SOUND_COMPLETE);
		}
		//以下暂时用不到，误删
		/*public function getId3():Array{
			if(id3Array&&id3Array.length>0){
				return id3Array;
			}else{
				return null;
			}
		}
		
		protected function encodeId3(event:Event):void
		{
			sound.removeEventListener(Event.ID3,encodeId3);
			id3Array = [];
			var id3:ID3Info = (event.target as Sound).id3;
			var str:String
			for (var propName:String in id3) {
				str = propName;
				if(str=="TALB"){
					str="album";
				}else if(str=="TPE1"){
					str="artist";
				}else if(str=="COMM"){
					str="comment";
				}else if(str=="TCON"){
					str="genre";
				}else if(str=="TIT2"){
					str="songName";
				}else if(str=="TRCK"){
					str="track";
				}else if(str=="TYER"){
					str="year";
				}
					
				id3Array.push(str+":"+EncodeUtf8(id3[propName]));
			}
			sendNotification(ID3_READY,id3Array);
		}
		private function EncodeUtf8(str : String):String {
			var oriByteArr : ByteArray = new ByteArray();
			oriByteArr.writeUTFBytes(str);
			var tempByteArr : ByteArray = new ByteArray();
			for (var i:int = 0; i<oriByteArr.length; i++) {
				if (oriByteArr[i] == 194) {
					tempByteArr.writeByte(oriByteArr[i+1]);
					i++;
				} else if (oriByteArr[i] == 195) {
					tempByteArr.writeByte(oriByteArr[i+1] + 64);
					i++;
				} else {
					tempByteArr.writeByte(oriByteArr[i]);
				}
			}
			tempByteArr.position = 0;
			return tempByteArr.readMultiByte(tempByteArr.bytesAvailable,"chinese");
		}*/
		public function stop():void{
			startTime = 0;
			pauseTime = 0;
			loops = 0;
			volume = 1;
			if(soundChannel){
				soundChannel.removeEventListener(Event.SOUND_COMPLETE,soundCompleteHandler);
				soundChannel.stop();
				soundChannel=null;
			}
			try {
				sound.close();
			} catch(e:Error){}
			
			soundTransform = null;
			sound = null;
			Global._mp3IsRunning = false;
			
		}
		public function pause():void{
			if(soundChannel){
				pauseTime = soundChannel.position;
				soundChannel.stop();
				Global._mp3IsRunning = false;
			}
		}
		public function resume():void{
			if(sound&&soundTransform){
				if(soundChannel){
					soundChannel.stop();
				}
				try{
					soundChannel = sound.play(pauseTime,loops,soundTransform);
					soundChannel.addEventListener(Event.SOUND_COMPLETE,soundCompleteHandler);
					Global._mp3IsRunning = true;
					
				}catch(e:Error){
					trace("sound resume Error!");
				}
			}
		}
		public function jumpTime(_time:Number):void{
			pauseTime = _time;
			resume();
		}
		public function moveToPosition(percentage:Number):void{
			var position:Number = getLength()*percentage;
			jumpTime(position);
		}
		public function getPosition():Number{
			if(soundChannel){
				return soundChannel.position;
			}
			return 0;
		}
		public function getLength():Number{
			if(sound){
				return sound.length;
			}
			return 0;
		}
		public function get isRunning():Boolean{
			return Global._mp3IsRunning;
		}
		public function setVolume(vol:Number):void{
			if(soundChannel){
				soundTransform = new SoundTransform;
				soundTransform.volume = vol;
				soundChannel.soundTransform = soundTransform;
			}
		}
		//暂时用不到。且误删除
		/*public function getMP3Names(_url:String):Array{
			var url:Array = getMP3Urls(_url);
			url = url.map(mp3NameCallback);
			return url;
		}
		public function getMP3Urls(_url:String):Array{
			var file:File = Global.document.resolvePath(_url);
			var list:Array = file.getDirectoryListing();
			return list.filter(mp3UrlCallback);
		}
		
		
		private function mp3NameCallback(item:File, index:int, array:Array):String
		{
			return item.name;
		}
		private function mp3UrlCallback(item:File, index:int, array:Array):Boolean
		{
			if(item.url.substring(item.url.length-4)==".mp3"){
				return true;
			}
			return false;
		}*/
		override public function onRemove():void
		{
			stop();
			Global._mp3IsRunning = false;
			sendNotification(SOUND_STOP);
		}
	}
}