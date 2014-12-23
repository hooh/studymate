package com.mylib.framework.model
{
	import cn.digitalland.media.sound.as3wavsound.WavSound;
	import cn.digitalland.media.sound.as3wavsound.sazameki.core.AudioSetting;
	import cn.digitalland.media.sound.micrecorder.MicRecorder;
	import cn.digitalland.media.sound.micrecorder.encoder.WaveEncoder;
	
	import com.studyMate.global.Global;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public final class RecorderProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "RecorderProxy";
		
		public var recorder:MicRecorder;   //录音文件
		public var player:WavSound;   //存储成Wav格式
		public var _file:File   //默认保存文件位置

		public function RecorderProxy(data:Object=null)
		{
			super(NAME, data);
		}

		override public function onRegister():void
		{
			recorder = new MicRecorder(new WaveEncoder(),null,50,8);
			recorder.addEventListener(Event.COMPLETE,onrecord_CompleteHandler);
		}
		
		override public function onRemove():void
		{
			recorder = null;
			player = null;
		}
		
		/*开始录音*/
		public function record():void{
			recorder.record();
		}
		
		/*停止录音*/
		public function stop():void{
			recorder.stop();
		}
		
		public function onrecord_CompleteHandler(evet:Event):void{
			var audiosetting:AudioSetting = new AudioSetting(1,8000,16);
			player = new WavSound(recorder.output,audiosetting);
			player.play();
			
			//固定位置保存录音文件。
			_file = new File(Global.document.resolvePath(Global.localPath+"recorded/"+new Date().time+".wav").nativePath);

			var fileStream:FileStream = new FileStream();
			fileStream.open(_file,FileMode.WRITE);
			fileStream.writeBytes(recorder.output);
			fileStream.close();
		}
	}
}