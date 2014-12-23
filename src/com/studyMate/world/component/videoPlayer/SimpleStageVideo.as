package com.studyMate.world.component.videoPlayer
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.world.screens.StageVideoMediator;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.events.StageVideoEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.media.StageVideo;
	import flash.media.StageVideoAvailability;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import net.digitalprimates.volume.VolumeController;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	
	
	public class SimpleStageVideo extends Sprite
	{
		private var videoPath:String="";
		private var canPlay:Boolean;
		private var nc:NetConnection;
		private var ns:NetStream;
		private var sv:StageVideo;
		private var _totalTime:Number=0;
		private var videoRect:Rectangle;
//		private var thumb:Shape;
		public var videobgLength:Number = 0;
		public var soundbgLength:Number = 0;
		private var volumens:SoundTransform = new SoundTransform();  //声明音量控制器
		private var playTime:int=0;//播放了的时间/s
		
		public function SimpleStageVideo(path:String)
		{
			videoPath = path;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE,removeFromeToStage);
		}
		
		
		public function get totalTime():int
		{
			return int(_totalTime);
		}

		private function onAddedToStage(event:Event):void{			
			
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);	

//			Starling.current.stage.visible = false;
			Global.stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onStageVideoState);
		}		
		
		
		
		private function onNetStatus(event:NetStatusEvent):void
		{
			trace("SimpleStageVideo onNetStatus",event.info.code);
			switch(event.info.code){
				case "NetStream.Play.StreamNotFound":
					trace("没有找到该视频");
					break;
				case "NetStream.Seek.Notify":
					trace("搜寻操作完成。");
					break;
				case "NetStream.Play.Stop":
					trace("播放已结束。");
					if(ns!=null){
						ns.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
						ns.close();					
						ns = null;
					}
					if(nc!=null){
						nc.close();
						nc = null;
					}
					
					Facade.getInstance(CoreConst.CORE).sendNotification(StageVideoMediator.NETSTREAM_STOP);
					break;
				case "NetStream.Buffer.Empty":
					trace("缓存为空");
					break;
			}
			
		}
		
		public function onPlayStatus(info:Object):void
		{			
			trace("调到了："+"info.code");
			if (info.code == "NetStream.Play.Complete")
			{        
				canPlay = false;
				if(ns!=null){
					ns.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
					ns.close();					
					ns = null;
				}
				if(nc!=null){
					nc.close();
					nc = null;
				}
			}
			
		}

			

		public function onStageVideoState(event:StageVideoAvailabilityEvent):void
		{	
			//return;
			Global.stage.removeEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onStageVideoState);
			if(event.availability == StageVideoAvailability.AVAILABLE){
				trace("硬件加速可用");				
				if(sv==null){
					trace("硬件加速可用 sv");	
					nc = new NetConnection();
					nc.connect(null);
					ns = new NetStream(nc);
					ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
					/*var client:Object = new Object();
					client.onPlayStatus = forNsStatus;
					client.onMetaData = onMetaData;*/
					ns.client = this;
					sv = stage.stageVideos[0];
					sv.addEventListener(StageVideoEvent.RENDER_STATE, stageVideoStateChange);					
				}
				sv.attachNetStream(ns);
				//var FILE_NAME:String = File.documentsDirectory.resolvePath("edu/Market/video/"+"E87EEE9E55E6A6F4C5F4A08C").url;
				ns.play(videoPath);
				trace("硬件加速可用 play");	
			}
		}
		public function onMetaData ( evt:Object ):void{
			canPlay = true;
			_totalTime = evt.duration;
		}
		
		private function stageVideoStateChange(e:StageVideoEvent=null):void{
			if(videoRect == null){
				videoRect = getVideoRect(sv.videoWidth, sv.videoHeight);
			}
			trace("播放器大小 长："+videoRect.width+"  宽："+videoRect.height);
			sv.viewPort = videoRect;
		}
		private function getVideoRect(width:uint, height:uint):Rectangle
		{	
			var videoWidth:uint = width;
			var videoHeight:uint = height;
			var scaling:Number = Math.min ( stage.stageWidth / videoWidth, (stage.stageHeight-60) / videoHeight );
			
			videoWidth *= scaling, videoHeight *= scaling;
			
			var posX:uint = stage.stageWidth - videoWidth >> 1;
//			var posY:uint = stage.stageHeight - videoHeight >> 1;
			videoRect = new Rectangle(0, 0, 0, 0)
			videoRect.x = posX;
			videoRect.y = 0;
			videoRect.width = videoWidth;
			videoRect.height = videoHeight;
			
			return videoRect;
		}
		/**
		 * @param barLength 进度条总长图
		 * @return 当前播放长度
		 */		
		public function getVidoLength():Number 
		{
			var ratio:Number = 1;
			if(canPlay){
				if(ns){
					ratio = (ns.time / _totalTime) * videobgLength;	
					playTime = ns.time;
					
				}
			}
			trace("SimpleStageVideo getVidoLength ",ratio);
			return ratio;
		}
		
		public function get currentTime():int{
			
			return playTime;
		}
		
		//播放与暂停
		public function onSwitchPlayer():void{
			if(canPlay){
				if(ns)
					ns.togglePause();				
			}
		}
		
		/**
		 * 
		 * @param 传入点击进度条的时的长度值
		 * 
		 */		
		public function seek(length:Number):void{
			trace("查询进度："+length);
			if(canPlay && length>0){
				var seekTime:Number = length / videobgLength * _totalTime ;
				if(ns){
					ns.seek( seekTime )	;
				}
			}
		}
		
		/**
		 * //声音控制
		 * @param length 传入点击进度条的时的长度值
		 * 
		 */		
		public function volumeChange(length:Number):void{
			if(canPlay && length>0){
				VolumeController.instance.setVolume(length/soundbgLength);
			}
		}
		
		
		private function removeFromeToStage(e:Event):void{	
			if(sv){
				sv.viewPort = new Rectangle();
				sv.removeEventListener(StageVideoEvent.RENDER_STATE, stageVideoStateChange);
				sv = null;
			}
			if(nc!=null){
				nc.close();
				nc = null;
			}
			
			if(ns!=null){
				ns.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				ns.close();		
				ns.dispose();
				ns = null;
			}
			//Starling.current.start();
			//Starling.current.stage.visible = true;
			if(Global.stage.hasEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY))
				Global.stage.removeEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onStageVideoState);
			removeEventListener(Event.REMOVED_FROM_STAGE,removeFromeToStage);
		}
	}
}