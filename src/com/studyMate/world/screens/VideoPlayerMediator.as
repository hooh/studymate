package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.studyMate.global.Global;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.world.screens.view.NetStreamClient;
	import com.studyMate.world.screens.view.VideoPlayerView;
	
	import fl.events.SliderEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.filesystem.File;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	public class VideoPlayerMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "VideoPlayerMediator";
		private var _duration:Number;
		private var _folderUrl:String;
		private var con:NetConnection;
		private var stm:NetStream;
		private var video:Video;
		private var videoArray:Array;
		private var videoNameArray:Array;
		private var playIndex:int;
		private var isPause:Boolean = false;
		public function VideoPlayerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}

		override public function onRegister():void{
			view.videoRec.addChild(video);
			trace(Global.document.resolvePath(Global.localPath+"/mp3").url);
			folderUrl = Global.localPath+"/mp3";
			
			view.playBtn.addEventListener(MouseEvent.CLICK, playVideoHandler);
			view.pauseBtn.addEventListener(MouseEvent.CLICK, pauseVideoHandler);
			view.nextBtn.addEventListener(MouseEvent.CLICK, nextVideoHandler);
			view.preBtn.addEventListener(MouseEvent.CLICK, lastVideoHandler);
			view.stopBtn.addEventListener(MouseEvent.CLICK, stopVideoHandler);
			view.volumeSlider.addEventListener(SliderEvent.THUMB_DRAG,volumeChangeHandler);
			view.positionSlider.addEventListener(SliderEvent.THUMB_PRESS, positionPressHandler);
			view.positionSlider.addEventListener(SliderEvent.THUMB_DRAG,positionDragHandler);
			view.positionSlider.addEventListener(SliderEvent.THUMB_RELEASE, positionReleaseHandler);
			view.videoRec.addEventListener(MouseEvent.CLICK, clickVideoHandler);
			view.controlRec.addEventListener(MouseEvent.MOUSE_DOWN,clickControlRecHandler);
		}
		
		private function nsNetStatus(e:NetStatusEvent):void{
			switch(e.info.code){
				case "NetStream.Play.StreamNotFound": 
					trace("没有可播放的视频");
					trace("0");
					break;
				case "NetStream.Play.Start": 
					trace("1");
					break;
				case "NetStream.Buffer.Empty":
					trace("2");
					break;
				case "NetStream.Buffer.Full": 
					trace("3");
					break;
				case "NetStream.Seek.Notify":
					trace("4");
					break;
				case "NetStream.Play.Stop": 
					trace("5");
					break;
				case "NetStream.Seek.InvalidTime":
					trace("6");
					break;
				case "NetStream.Seek.Failed":
					trace("7");
					break;
			}
		}
		
		private function clickControlRecHandler(e:MouseEvent):void{
			TweenLite.killDelayedCallsTo(clickVideoHandler);
		}
		
		private function clickVideoHandler(e:MouseEvent):void{
			view.hideControlRec = !view.hideControlRec;
		}
		
		private function playVideoHandler(e:MouseEvent):void{
			view.playBtn.visible = false;
			view.pauseBtn.visible = true;
			if(isPause){
				stm.resume();
				isPause = false;
			}else{
				stm.play((videoArray[playIndex] as File).url);
				view.nameOfVideoText.text = videoNameArray[playIndex];
			}
			TweenLite.delayedCall(1,sliderAutoChange);
			TweenLite.killDelayedCallsTo(clickVideoHandler);
			TweenLite.delayedCall(5,clickVideoHandler,[null]);
		}
		
		private function pauseVideoHandler(e:MouseEvent):void{
			view.pauseBtn.visible = false;
			view.playBtn.visible = true;
			stm.pause();
			isPause = true;
			TweenLite.killDelayedCallsTo(sliderAutoChange);
		}
		
		private function stopVideoHandler(e:MouseEvent):void{
			stm.close();
			isPause = false;
			view.playBtn.visible = true;
			view.pauseBtn.visible = false;
			view.positionSlider.value = 0;
			view.positionText.text = "00:00:00";
			view.sumTimeText.text = "00:00:00";
			video.clear();
			TweenLite.killDelayedCallsTo(sliderAutoChange);
		}
		
		private function nextVideoHandler(e:MouseEvent):void{
			stm.close();
			playIndex++;
			if(playIndex == videoArray.length) playIndex = 0;
			TweenLite.killDelayedCallsTo(sliderAutoChange);
			playVideoHandler(null);
		}
		
		private function lastVideoHandler(e:MouseEvent):void{
			stm.close();
			playIndex--;
			if(playIndex < 0) playIndex = videoArray.length - 1;
			TweenLite.killDelayedCallsTo(sliderAutoChange);
			playVideoHandler(null);
		}
		
		private function volumeChangeHandler(e:SliderEvent):void{
			var sf:SoundTransform = stm.soundTransform;
			sf.volume = view.volumeSlider.value;
			stm.soundTransform = sf;
		}
		
		private function positionPressHandler(e:SliderEvent):void{
//			stm.pause();
			pauseVideoHandler(null);
		}
		
		private function positionDragHandler(e:SliderEvent):void{
			view.positionText.text = getTimeFmt(_duration * view.positionSlider.value / view.positionSlider.maximum);
			stm.seek(_duration * view.positionSlider.value / view.positionSlider.maximum);
		}
		
		private function positionReleaseHandler(e:SliderEvent):void{
//			stm.resume();
			playVideoHandler(null);
		}
		
		private static function getTimeFmt(sec:Number):String{
			var s:int = sec;
			var m:int = int(s/60);
			var h:int = int(m/60);
			s -= m*60;
			m -= h*60;
			return make2Str(h) + ":" + make2Str(m) + ":" + make2Str(s);
		}
		
		private static function make2Str(i:int):String{
			if(i<10) return "0" + i;
			else return "" + i;
		}
		
		private function sliderAutoChange():void{
			TweenLite.delayedCall(1,sliderAutoChange);
			view.positionSlider.value = (stm.time / _duration) * view.positionSlider.maximum;
			view.positionText.text = getTimeFmt(stm.time);
			if(view.positionText.text == view.sumTimeText.text) nextVideoHandler(null);
		}
		
		public function setRect(h:Number,w:Number):void{
			if(w/h > 1280/768){  //以宽为基准
				video.width = 1280;
				video.height = h / w * 1280;
				video.x = 0;
				video.y = (768 - video.height) / 2;
			}else{  //以高为基准
				video.height = 768;
				video.width = w / h * 768;
				video.y = 0;
				video.x = (1280 - video.width) / 2;
			}
		}
		
		public function set duration(value:Number):void{
			_duration = value;
			view.sumTimeText.text = getTimeFmt(_duration);
		}
		
		public function set folderUrl(url:String):void{
			this._folderUrl = url;
			var file:File = Global.document.resolvePath(url);
			trace(file.url);
			var list:Array = file.getDirectoryListing();
			videoArray.length = 0;
			videoArray = list.filter(flvUrlCallback);
			videoNameArray.length = 0;
			videoNameArray = videoArray.map(flvNameCallback);
			playIndex = 0;
			playVideoHandler(null);
		}
		
		private function flvUrlCallback(item:File, index:int, array:Array):Boolean{
			if(item.url.substring(item.url.length-4)==".flv" || item.url.substring(item.url.length-4)==".mp4") return true;
			return false;
		}
		
		private function flvNameCallback(item:File, index:int, array:Array):String{
			return item.name;
		}
		
		override public function prepare(vo:SwitchScreenVO):void{
			con = new NetConnection();
			con.connect(null);
			stm = new NetStream(con);
			stm.bufferTime = 3;
			stm.client = new NetStreamClient(this);
			stm.addEventListener(NetStatusEvent.NET_STATUS, nsNetStatus);
			video = new Video();
			video.attachNetStream(stm);
			videoArray = new Array();
			videoNameArray = new Array();
			Facade.getInstance(ApplicationFacade.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function onRemove():void{
			super.onRemove();
		}
		
		public function get view():VideoPlayerView{
			return getViewComponent() as VideoPlayerView;
		}
		
		override public function get viewClass():Class{
			return VideoPlayerView;
		}
		
	}
}