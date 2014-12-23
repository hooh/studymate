package com.studyMate.world.component.record
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.UpLoadCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.events.ActivityEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.media.SoundTransform;
	import flash.utils.ByteArray;
	
	import cn.digitalland.media.sound.as3wavsound.WavSound;
	import cn.digitalland.media.sound.as3wavsound.WavSoundChannel;
	import cn.digitalland.media.sound.micrecorder.MicRecorder;
	import cn.digitalland.media.sound.micrecorder.encoder.WaveEncoder;
	import cn.digitalland.media.sound.micrecorder.events.RecordingEvent;
	import cn.digitalland.media.sound.shinemp3.ShineMP3Encoder;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	public class MyRecordProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "RecorderProxy";
		//正在加载录音
		public static const isLoading:String = NAME + "isLoading";
		//加载录音完成
		public static const loadingComplete:String = NAME + "loadingComplete";
		//加载录音错误
		public static const loadError:String = NAME + "isError";
		//录音时长
		public static const recordingTime:String = NAME + "loadingTime" ;
		//试听结束
		public static const playSoundComplete:String = NAME +"sound_Complete" ;
		//上传文件失败
		public static const upLoadError:String = NAME + "upLoadError";
		
		private const volume : Number = 1;
		private var wavEncoder : WaveEncoder;
		private var recorder : MicRecorder;
		private var mp3Encoder:ShineMP3Encoder;
		private var file:File;
		private var mp3File:File;
		private var path:String;
		private var soundChannel:WavSoundChannel;
		private var byte:ByteArray = new ByteArray();
		private var fileStream:FileStream = new FileStream();
		private var oralid:String;

				
		public function MyRecordProxy(data:Object=null)
		{
			oralid = String(data);
			super(NAME, data);
		}
		override public function onRegister():void
		{
			file =  Global.document.resolvePath(Global.localPath+"Market/record/spokenRecord.wav");
			/*path = Global.localPath+"Market/record/spokenRecord"+MyUtils.getTimeFormat()+".mp3";
			mp3File = Global.document.resolvePath(path);*/
		}
		override public function onRemove():void
		{		
			byte.clear();
			if(fileStream){
				try{
					fileStream.close();
				}catch(e:Error){
					
				}
			}
//			TweenLite.killDelayedCallsTo(leveSize);
			if(recorder){
				recorder.removeEventListener(RecordingEvent.RECORDING, onRecording);
				recorder.removeEventListener(Event.COMPLETE, onRecordComplete);
//				recorder.microphone.removeEventListener(ActivityEvent.ACTIVITY, micStartLis);
				recorder.clear();
				recorder = null;
			}
			if(soundChannel){
				soundChannel.removeEventListener(Event.SOUND_COMPLETE,soundComplete);
				soundChannel.stop();
				soundChannel = null;
			}
			
		}
		
		/*private function leveSize():void{
			System.gc();
			var num:Number = System.freeMemory;
			trace(num);			
			TweenLite.delayedCall(3,leveSize);
			
			if(num<2000){
				sendNotification(CoreConst.TOAST,new ToastVO("剩余空间不足，已自动帮您停止录音")); return;
				stopLis();
			}else if(num<3000){
				sendNotification(CoreConst.TOAST,new ToastVO("剩余录音空间即将不足，请及时停止停止")); return;
			}						
		}*/

		/**
		 * 停止播放 
		 * 
		 */		
		public function stopSound():void{
			byte.clear();
			if(soundChannel){
				soundChannel.stop();
				soundChannel = null;
			}
		}
		
		/**
		 * 播放 
		 * 
		 */		
		public function playSound() : void {
			if(file.exists && file.size>1024){
				if(soundChannel){
					soundChannel.stop();
				}

				sendNotification(isLoading);
				fileStream.openAsync(file,FileMode.READ);
				fileStream.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
				fileStream.addEventListener(Event.COMPLETE, fileCompleteHandler)
			}else{
				sendNotification(CoreConst.TOAST,new ToastVO("没有录音数据或数据量太少,请先录制声音!"))
			}
		}		
		private function fileCompleteHandler(event:Event):void {		
			byte.clear();
			fileStream.readBytes(byte);
			fileStream.close();
			try{
				var player:WavSound = new WavSound((new WaveEncoder).encode(byte,1));
				soundChannel = player.play(0,0,new SoundTransform(6,0));
				soundChannel.addEventListener(Event.SOUND_COMPLETE,soundComplete);
//				fileStream.close();
			}catch(e:Error){
				
			}
			
			
			sendNotification(loadingComplete,int(player.length/1000));
		}
		
		protected function soundComplete(event:Event):void
		{
			sendNotification(playSoundComplete);
		}
		
		protected function errorHandler(event:IOErrorEvent):void
		{
			trace("导入错误");	
			sendNotification(loadError);
		}
		/*private function getWovInformation(event:Event):void{			
			var loader:URLLoader=event.target as URLLoader;		
			var player:WavSound = new WavSound((new WaveEncoder).encode(loader.data,1));
			soundChannel = player.play();
		}*/
		
		/**
		 * 录音中ing、、、
		 */
		private function onRecording(event : RecordingEvent) : void {
			// trace("Recording since : " + event.time + " ms.");
			isChangeTime(int(event.time/1000));
			fileStream.writeBytes(event.bufferByte);
		}
		
		private var valueTime:int;
		private function isChangeTime(value:int):void{
			if(valueTime!=value){
				valueTime = value;
				sendNotification(recordingTime,valueTime);
			}
		}
		
		/**
		 * 录音制作完成
		 */
		private function onRecordComplete(event : Event) : void {									
			fileStream.close();
			recorder.clear();						
		}
		
		/**
		 * 开始录音
		 */
		public function recordLis() : void {
			byte.clear();
			if(wavEncoder==null){		
				wavEncoder = new WaveEncoder(volume);
				recorder = new MicRecorder(wavEncoder,null,50,44,10,10000);//声音低于20则视为静音
			}				
			if(!file.exists){
				file = new File(Global.document.resolvePath(Global.localPath+"Market/record/spokenRecord.wav").nativePath);				
			}	
//			TweenLite.killDelayedCallsTo(leveSize);
//			TweenLite.delayedCall(3,leveSize);
			recorder.addEventListener(RecordingEvent.RECORDING, onRecording);
			recorder.addEventListener(Event.COMPLETE, onRecordComplete);
			recorder.record();
//			recorder.microphone.addEventListener(ActivityEvent.ACTIVITY, micStartLis);
			
			fileStream.open(file,FileMode.WRITE);
		}
		
		
		public function changToMp3AndUpload():void{
			stopLis();
			if(file.exists){
				if(file.size<1024){
					sendNotification(CoreConst.TOAST,new ToastVO("没有录音数据或数据量太少,请先录制声音!"));
					sendNotification(upLoadError);
					return;
				}
			}
				try{
					fileStream.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
					fileStream.open(file,FileMode.READ);
					fileStream.readBytes(byte);
					fileStream.close();
				}catch(e:Error){
					//上传文件失败
					sendNotification(CoreConst.TOAST,new ToastVO("抱歉上传失败!"));
					sendNotification(upLoadError);
				}	
			if(byte.length>0){				
//				byte = (new WaveEncoder).encode(byte,1);
				AppLayoutUtils.gpuLayer.touchable = false;
				sendNotification(CoreConst.TOAST,new ToastVO("请稍等,正在压缩声音并上传服务器."));
				mp3Encoder = new ShineMP3Encoder((new WaveEncoder).encode(byte,1));
				mp3Encoder.addEventListener(Event.COMPLETE, mp3ChangeHandler);
				mp3Encoder.start();	
				
			}else{
				sendNotification(CoreConst.TOAST,new ToastVO("请先录制声音!"));
				sendNotification(upLoadError);

			}

		}
		
		protected function mp3ChangeHandler(event:Event):void
		{
//			if(!mp3File.exists){
				path = Global.localPath+"Market/record/R"+oralid+'-'+PackData.app.head.dwOperID.toString()+'-'+MyUtils.getTimeFormat()+".mp3";
				mp3File = new File(Global.document.resolvePath(path).nativePath);
//				mp3File = new File(Global.document.resolvePath(Global.localPath+"Market/record/spokenRecordMp3.mp3").nativePath);				
//			}
			fileStream.open(mp3File,FileMode.WRITE);
			fileStream.writeBytes(mp3Encoder.data);
			fileStream.close();
			mp3Encoder.data.clear();
			sendNotification(CoreConst.UPLOAD_FILE,new UpLoadCommandVO(mp3File,"spokenRecord/" + mp3File.name,null,WorldConst.UPLOAD_PERSON_INIT));
			
		}
		
		public function clearMp3File():void{
			if(mp3File && mp3File.exists){
				mp3File.deleteFile();
			}
		}
		
		/**
		 * 录音状态监听
		 */
		private function micStartLis(e : ActivityEvent) : void {
		}
		
		/**
		 * 结束录音
		 */
		public function stopLis() : void {
			try{
				fileStream.close();
			}catch(e:Error){
				
			}
			if(recorder){
				recorder.clear()
				recorder.removeEventListener(RecordingEvent.RECORDING, onRecording);
				recorder.removeEventListener(Event.COMPLETE, onRecordComplete);
//				recorder.microphone.removeEventListener(ActivityEvent.ACTIVITY, micStartLis);
				
			}
		}
	}
}