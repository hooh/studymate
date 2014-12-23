package com.studyMate.world.screens
{
	import com.edu.AMRMedia;
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.global.OSType;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.controller.vo.SpeechVO;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class SpeechChatView extends Sprite
	{
		public static const NAME:String = "SpeechChatView";
		public static const HIDE_SPEECH_VIEW:String = NAME + "HideSpeechView";
		public static const SEND_SPEECH:String = NAME + "SendSpeech";
		
		private var clickSp:Sprite = new Sprite();
		private var recordTips:TextField = new TextField;
		private var tipsTF:TextField = new TextField;
		private var tf:TextFormat = new TextFormat("HuaKanT",65,0xfeca00);
		private var tf1:TextFormat = new TextFormat("HuaKanT",28,0xccb86a);
		
		private var isRecording:Boolean = false;
		private var isExit:Boolean = false;
		private var beginY:Number = 0;
		private var isCancleSend:Boolean = false;
		private var startTime:Number;
		
		public function SpeechChatView()
		{
			super();
			
			init();
		}
		private function init():void{

			
			var bg:Sprite = new Sprite();
			bg.graphics.beginFill(0,0.5);
			bg.graphics.drawRect(0,0,1280,800);
			bg.graphics.endFill();
			addChild(bg);
			
			var split:Sprite = new Sprite();
			split.graphics.beginFill(0xa29159);
			split.graphics.drawRect(639,0,2,800);
			split.graphics.endFill();
			split.mouseEnabled = false;
			split.mouseChildren = false;
			addChild(split);
			
			
			clickSp.graphics.beginFill(0x251d00,0.5);
			clickSp.graphics.drawRect(641,0,639,800);
			clickSp.graphics.endFill();
			clickSp.visible = false;
			clickSp.mouseEnabled = false;
			clickSp.mouseChildren = false;
			addChild(clickSp);
			
			//添加取消录音提示
			createTips();
			
			
			
			var cancleTips:TextField = new TextField;
			cancleTips.x = 210;
			cancleTips.y = 540;
			cancleTips.width = 130;
			cancleTips.height = 70;
			cancleTips.text = "取消";
			cancleTips.embedFonts = true;
			cancleTips.setTextFormat(new TextFormat("HuaKanT",65,0xbda239));
			cancleTips.mouseEnabled = false;
			addChild(cancleTips);
			
			
			recordTips.x = 875;
			recordTips.y = 535;
			recordTips.width = 260;
			recordTips.height = 70;
			recordTips.text = "长按录音";
			recordTips.embedFonts = true;
			recordTips.setTextFormat(tf);
			recordTips.mouseEnabled = false;
			addChild(recordTips);
			
			
			
			this.addEventListener(MouseEvent.MOUSE_DOWN,downHandle);
			this.addEventListener(MouseEvent.MOUSE_UP,upHandle);
			this.addEventListener(MouseEvent.MOUSE_MOVE,moveHandle);
		}
		private function createTips():void{
			var tipsBg:Sprite = new Sprite;
			tipsBg.graphics.beginFill(0x251d00,0.5);
			tipsBg.graphics.drawCircle(995,367,108);
			tipsBg.graphics.endFill();
			tipsBg.mouseEnabled = false;
			tipsBg.mouseChildren = false;
			clickSp.addChild(tipsBg);
			
			
			var tipsBitmap:Bitmap = Assets.getTextureAtlasBMP(Assets.store["AtlasTexture"],Assets.store["AtlasXml"],"mainMenu/menuTalkBtn");
			tipsBitmap.x = 960;
			tipsBitmap.y = 303;
			tipsBg.addChild(tipsBitmap);
			
			
			tipsTF.x = 936;
			tipsTF.y = 372;
			tipsTF.width = 118;
			tipsTF.height = 70;
			tipsTF.text = "手指上滑取消发送";
			tipsTF.embedFonts = true;
			tipsTF.multiline = true;
			tipsTF.wordWrap = true;
			tipsTF.setTextFormat(tf1);
			tipsTF.mouseEnabled = false;
			tipsBg.addChild(tipsTF);
			
		}

		private var speechVo:SpeechVO = new SpeechVO;
		//进入语音界面
		public function enterSpeech(_rId:String,_rName:String):void{
			this.visible = true;
			
			speechVo.rId = _rId;
			speechVo.rName = _rName;
			
			
		}
		
		private function downHandle(e:MouseEvent):void{
			//初始化状态
			isExit = false;
			isRecording = false;
			isCancleSend = false;
			tipsTF.text = "手指上滑取消发送";
			tipsTF.setTextFormat(tf1);
			recordTips.text = "长按录音";
			recordTips.setTextFormat(tf);
			
			
			
			//点击左半屏，请求退出
			if(e.stageX < 640){
				isExit = true;
				
			}else if(e.stageX > 640 && !isRecording){
				if(Global.OS != OSType.ANDROID)
					return;
				
				if(Global.isLoading){
					recordTips.text = "加载中..";
					recordTips.setTextFormat(tf);
					
					TweenLite.delayedCall(0.8,rebackTips);
					
					return;
				}
				
				//点击右半屏
				trace("开始录音...........................................");
				
				//降低背景声音
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SET_BG_MUSIC_VOLUME,0);
				//计算时间，太短不发送
				startTime = getTimer();
				
				clickSp.visible = true;
				recordTips.text = "松开结束";
				recordTips.setTextFormat(tf);
				
				beginY = e.stageY;
				isRecording = true;
				record();
				
			}
			
		}
		private function upHandle(e:MouseEvent):void{
			
			//点击左半屏，退出
			if(e.stageX < 640 && isExit){
				isExit = false;
				
				//退出
				this.visible = false;
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SET_MODAL,false);
				Facade.getInstance(CoreConst.CORE).sendNotification(HIDE_SPEECH_VIEW);
				
			}else if(isRecording){
				//录音中，停止
				clickSp.visible = false;
				recordTips.text = "长按录音";
				recordTips.setTextFormat(tf);
				
				//退出
				isRecording = false;
				trace("录音完成...........................................");
				//回复背景声音
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SET_BG_MUSIC_VOLUME,1);
				//判断时间，时间小于700毫秒，不发送
				if((getTimer()-startTime)<700)	isCancleSend = true;
				
				AMRMedia.getInstance().stopRecordAMR();
				
				if(!isCancleSend){
					trace("发送录音..."+path+".............OK");
					
					speechVo.path = path;
					
					Facade.getInstance(CoreConst.CORE).sendNotification(SEND_SPEECH,speechVo);
					
				}else{
					trace("取消发送..."+path+".............OK");
					
				}
				
			}
			
		}
		private function moveHandle(e:MouseEvent):void{
			//录音中，监听移动操作
			if(isRecording){
				//向上滑超过100像素，取消发送
				if((e.stageY - beginY) <= -100){
					tipsTF.text = "松开手指取消发送";
					tipsTF.setTextFormat(tf1);
				
					
					isCancleSend = true;
				}else{
					
					tipsTF.text = "手指上滑取消发送";
					tipsTF.setTextFormat(tf1);
					
					isCancleSend = false;
				}
				
				
				
				
			}
			
			
		}
		private function rebackTips():void{
			recordTips.text = "长按录音";
			recordTips.setTextFormat(tf);
		}
		
		private var path:String = "";
		private function record():void{
			trace("录音中.......");
			path = PackData.app.head.dwOperID.toString()+(new Date).time.toString();
//			path = "631387338091773";
			
			var _path:String = Global.document.resolvePath(Global.localPath + "speech/" + path + ".amr").nativePath;
			AMRMedia.getInstance().RecordAMR(_path);
			
		}
		
		public function dispose():void{
			this.removeChildren(0,this.numChildren-1);
			
			TweenLite.killTweensOf(rebackTips);
			
		}
		
		
		
	}
}