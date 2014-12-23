package com.studyMate.world.screens
{
	import com.edu.Dialog.NativeAlertDialog;
	import com.edu.Dialog.events.NativeDialogEvent;
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.VideoConfigProxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.framework.model.vo.VideoLogVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.OSType;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.component.videoPlayer.SimpleStageVideo;
	import com.studyMate.world.model.vo.AlertVo;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import net.digitalprimates.volume.VolumeController;
	import net.digitalprimates.volume.events.VolumeEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.text.TextField;

	public class StageVideoMediator extends ScreenBaseMediator
	{
		private const NAME:String = "StageVideoMediator";
		
		private const WATCH_INFO:String = NAME + "WATCH_INFO";
		public static const NETSTREAM_STOP:String = NAME + "NETSTREAM_STOP";
		private const COST_GOLD_INFO:String = NAME+ "COST_GOLD_INFO";

		
		private var parentScreen:ScreenBaseMediator;
				
		private var playBtn:Button;		
		private var stopBtn:Button;
		private var simpleVideo:SimpleStageVideo;
		private var videoBar:Image;
		private var soundBar:Image;
		private var videoBarbg:Image;
		private var hasBar:Boolean = true;
		private var alreadyTimeTxt:TextField;
		private var finishTimeTxt:TextField;
		private var pareVO:SwitchScreenVO;
		
		private var canPlayPath:String='';
		//观看时间记录信息
		private var videoids:String ="";
		private var startTime:String = "";
		private var wtimes:String = "";//申请时长
		private var rtimes:String = "";//实际时长
		private var videoname:String = "";//视频名称
		private var endtime:String = "";//结束时间		
		private var startSS:int=0;
		
		public function StageVideoMediator(viewComponent:Object=null)
		{
			super(NAME,viewComponent);			
		}
		
		override public function onRegister():void{
			trace("StageVideoMediator onRegister");
			sendNotification(CoreConst.FLOW_RECORD,new RecordVO("start","StageVideoMediator",0));

			sendNotification(CoreConst.TOAST,new ToastVO("正在初始化电影,请稍等..."));
			
			sendNotification(WorldConst.HIDE_NOTICE_BOARD);
			sendNotification(CoreConst.STOP_BEAT);
			sendNotification(WorldConst.HIDE_MAIN_MENU);
			backHandle = keybackHandle;			
			startSS = getTimer();
			Global.stage.color = 0;
			sendNotification(CoreConst.FLOW_RECORD,new RecordVO("insertLog","StageVideoMediator",0));

			insertLog(false);
			
			TweenLite.delayedCall(0.5,initialize);
			
			sendNotification(CoreConst.FLOW_RECORD,new RecordVO("end","StageVideoMediator",0));

			
		}
		
		private function initialize():void
		{
			trace("StageVideoMediator initialize");
			sendNotification(CoreConst.FLOW_RECORD,new RecordVO("start initialize","StageVideoMediator",0));
			
			Global.stage.frameRate = 4;
//			Starling.current.showStats = false;
			var rect:Rectangle = new Rectangle(0,Global.stage.stageHeight/1.15106,Global.stage.stageWidth,Global.stage.stageHeight);
			Starling.current.viewPort = rect;
			
			var path:String = Global.document.resolvePath(Global.localPath+String(canPlayPath)).url;
			simpleVideo  = new SimpleStageVideo(path);
			Starling.current.nativeOverlay.addChild(simpleVideo);
					
			var bg:Image = new Image(Assets.getVideoTexture("video/playBarBg"));
			view.addChild(bg);
			bg.addEventListener(TouchEvent.TOUCH,SeekHandler);
			
			videoBarbg = new Image(Assets.getVideoTexture("video/videoBar"));
			videoBarbg.x = 57;
			videoBarbg.y = 13;
			videoBarbg.touchable = false;
			view.addChild(videoBarbg);
			
			
			var soudIcon:Image = new Image(Assets.getVideoTexture("video/soundIcon"));
			soudIcon.touchable = false;
			soudIcon.x = 20;
			soudIcon.y = 56;
			view.addChild(soudIcon);
			
			var soundBarbg:Image = new Image(Assets.getVideoTexture("video/soundBar"));
			soundBarbg.x = 57;
			soundBarbg.y = 54;
			view.addChild(soundBarbg);
			soundBarbg.touchable = false;
			
			simpleVideo.videobgLength = videoBarbg.width-6;
			simpleVideo.soundbgLength = soundBarbg.width-6;
			
			playBtn = new Button(Assets.getVideoTexture("video/playBtn"));
			stopBtn = new Button(Assets.getVideoTexture("video/stopBtn"));
			view.addChild(playBtn);			
			view.addChild(stopBtn);
			playBtn.x = stopBtn.x = 614;
			playBtn.y = stopBtn.y = 38;
			playBtn.visible = false;
			playBtn.addEventListener(starling.events.Event.TRIGGERED,SwitchPlayHandler);
			stopBtn.addEventListener(starling.events.Event.TRIGGERED,SwitchPlayHandler);
			
			videoBar = new Image(Assets.getVideoTexture("video/Bar"));
			videoBar.width = 1;
			videoBar.x = 62;
			videoBar.y = 15;
			videoBar.touchable = false;
			view.addChild(videoBar);
			
			soundBar = new Image(Assets.getVideoTexture("video/Bar"));
			soundBar.width = 1;
			soundBar.x = 62;
			soundBar.y = 55;
			soundBar.touchable = false;
			view.addChild(soundBar);
			
			
			alreadyTimeTxt = new TextField(54,28,"0:00:00","HeiTi",10,0xE4B701);
			alreadyTimeTxt.x = 0;
			alreadyTimeTxt.y = 8;
			alreadyTimeTxt.touchable = false;
			view.addChild(alreadyTimeTxt);
			
			finishTimeTxt = new TextField(54,28,"0:00:00","HeiTi",10,0xE4B701);
			finishTimeTxt.x = 1218;
			finishTimeTxt.y = 8;
			finishTimeTxt.touchable = false;
			view.addChild(finishTimeTxt);
			
			Global.stage.addEventListener(MouseEvent.CLICK,simpleVideoClickHandler);
			VolumeController.instance.addEventListener(VolumeEvent.VOLUME_CHANGED,volumeChangeHandler);
			Progress();
									
			trace("StageVideoMediator end");
			
			sendNotification(CoreConst.FLOW_RECORD,new RecordVO("end initialize","StageVideoMediator",0));

		}		
		
		
		/**
		 * 记录是否已提交 
		 * @param flag 提交标记
		 */		
		public function insertLog(flag:Boolean):void{
			if(flag){
				(facade.retrieveProxy(VideoConfigProxy.NAME) as VideoConfigProxy).updateValueInUser(true);				
			}else{
				endtime = MyUtils.getTimeFormat();
				var reg:RegExp =  /(\d*)/g;
				var videoLogVO:VideoLogVO = new VideoLogVO();
				var atime:String = wtimes.match(reg)[0];;
				videoLogVO.userid = PackData.app.head.dwOperID.toString();
				videoLogVO.videoids = videoids;
				videoLogVO.times = wtimes;
				videoLogVO.wtimes = atime;
				videoLogVO.rtimes = '1';
				videoLogVO.videoName = videoname;
				videoLogVO.starttime =  Global.nowDate.time.toString();
				videoLogVO.endtime = (Global.nowDate.time+ int(atime)*60*1000).toString();
				(facade.retrieveProxy(VideoConfigProxy.NAME) as VideoConfigProxy).updateValueInUser(false,videoLogVO);	
			}
		}
		
		
		
		private function keybackHandle():void{	
			if(Global.OS ==OSType.ANDROID){				
				NativeAlertDialog.showAlert( "确定退出观看吗？" , "提示" ,  Vector.<String>(["YES","NO"]) ,
					function someAnswerFunction(event:NativeDialogEvent):void{
						//event.preventDefault(); 
						// IMPORTANT: 
						//default behavior is to remove the default listener "someAnswerFunction()" and to call the dispose()
						if(event.index=='0'){
							submitHandle();
						}
					});
			}else{
				submitHandle();
			}
		}
		
		private function submitHandle():void{		
			var userId:String = PackData.app.head.dwOperID.toString();
			endtime = MyUtils.getTimeFormat();
			rtimes = String(int((getTimer()-startSS)*0.001/60)+1 );		
			var reg:RegExp =  /(\d*)/g;
			
			PackData.app.CmdIStr[0] = CmdStr.SUBMIT_WATCH_VIDEO_INFO;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = videoids;
			PackData.app.CmdIStr[3] = wtimes;
			PackData.app.CmdIStr[4] = wtimes.match(reg)[0];
			PackData.app.CmdIStr[5] = rtimes;
			PackData.app.CmdIStr[6] = videoname;
			PackData.app.CmdIStr[7] = startTime;
			PackData.app.CmdIStr[8] = endtime; 
			PackData.app.CmdInCnt = 9;	
			sendNotification(CoreConst.SEND_11,new SendCommandVO(COST_GOLD_INFO,null,'cn-gb',null,SendCommandVO.QUEUE|SendCommandVO.UNIQUE));
		}
		
		private function getTime(num:int):String {
			return ("0"+uint(num/3600)).substr(-2)+":"+("0"+uint(num/60) % 60).substr(-2)+":"+("0"+num%60).substr(-2);					
		}
		
		private function SeekHandler(e:TouchEvent):void{
			var touch:Touch = e.getTouch(e.target as DisplayObject);			
			if(touch){									
				var pointNum_X:Number = touch.globalX;
				var pointNum_Y:Number = touch.globalY;
				if(pointNum_X>57 && pointNum_X<1214 && pointNum_Y<36){//播放进度
					simpleVideo.seek(touch.globalX - 63);
				}else if(pointNum_X>57 && pointNum_X<166 && pointNum_Y>40){//声音
					simpleVideo.volumeChange(touch.globalX - 63);
					soundBar.width = touch.globalX - 63						
				}
			}
		}
		private function volumeChangeHandler(event:flash.events.Event=null):void
		{
			//trace("系统声音");
			soundBar.width = VolumeController.instance.systemVolume * simpleVideo.soundbgLength;	
		}
		
		
		private function simpleVideoClickHandler(event:MouseEvent):void
		{			
			if(event.stageY < Global.stage.stageHeight/1.27){//trace("关闭进度条");				
				hasBar = !hasBar;
				if(hasBar==true){//添加进度条。
					
					var rect:Rectangle = new Rectangle(0,Global.stage.stageHeight/1.15106,Global.stage.stageWidth,Global.stage.stageHeight);
					Starling.current.viewPort = rect;
				}else{
					rect = new Rectangle(0,Global.stage.stageHeight/1.08857,Global.stage.stageWidth,Global.stage.stageHeight);
					Starling.current.viewPort = rect;
				}
			}
			
		}
		
		// 播放开关
		private function SwitchPlayHandler(e:starling.events.Event):void{
			simpleVideo.onSwitchPlayer();
			if(playBtn.visible){
				TweenLite.delayedCall(1,Progress);
			}else{//暂停
				TweenLite.killDelayedCallsTo(Progress);
			}
			stopBtn.visible = playBtn.visible;
			playBtn.visible = !playBtn.visible;
		}
		
		private function Progress():void{
			//trace("videoBar.width : "+videoBar.width);
			videoBar.width = simpleVideo.getVidoLength();
			var n:int = simpleVideo.currentTime;
			alreadyTimeTxt.text = getTime(n);
			finishTimeTxt.text = getTime(simpleVideo.totalTime - n);
			TweenLite.delayedCall(1,Progress);
		}		
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()) {
				case NETSTREAM_STOP:
					submitHandle();
					break;
//				case WorldConst.CURRENT_DOWN_COMPLETE:
				case CoreConst.DEACTIVATE:					
					NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;											
					break;
				case COST_GOLD_INFO:			
					insertLog(true);
					trace("测试成功了！消费银币" + (PackData.app.CmdOStr[1] as String));
					sendNotification(WorldConst.POP_SCREEN);
					break;

			}
		}
		override public function listNotificationInterests():Array{
			return [CoreConst.DEACTIVATE,NETSTREAM_STOP,COST_GOLD_INFO];
		}
		override public function onRemove():void{
			TweenLite.killDelayedCallsTo(initialize);
			sendNotification(WorldConst.SHOW_NOTICE_BOARD);
			sendNotification(CoreConst.START_BEAT);
			
			Global.stage.frameRate = 60;
			VolumeController.instance.removeEventListener(VolumeEvent.VOLUME_CHANGED,volumeChangeHandler);
			TweenLite.killDelayedCallsTo(Progress);
			Global.stage.removeEventListener(MouseEvent.CLICK,simpleVideoClickHandler);
//			Starling.current.showStats = true;
			Global.stage.color = 0xFFFFFF;
			if(simpleVideo.parent){				
				Starling.current.nativeOverlay.removeChild(simpleVideo);
			}
			Starling.current.viewPort = new Rectangle(0,0,Global.stage.stageWidth,Global.stage.stageHeight);
//			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;			
			super.onRemove();
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class{
			return Sprite;
		}
		override public function prepare(vo:SwitchScreenVO):void{
			pareVO = vo;
			canPlayPath = pareVO.data.canPlayPath;
			videoname = pareVO.data.videoname;
			startTime = pareVO.data.startTime;
			videoids = pareVO.data.videoids;
			wtimes = pareVO.data.wtimes;
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;//不要放onReigter中。部分平板会报错。
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);				
		}
		
	}
}