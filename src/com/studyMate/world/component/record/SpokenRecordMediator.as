package com.studyMate.world.component.record
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.CmdStr;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import feathers.controls.Button;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	public class SpokenRecordMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "SpokenRecordMediator";
		
		/*public static const isLoading:String = NAME + "isLoading";
		public static const loadingComplete:String = NAME + "loadingComplete";
		public static const isError:String = NAME + "isError";
		public static const loadingTime:String = NAME + "loadingTime" ;
		public static const sound_Complete:String = NAME +"sound_Complete" ;
		public static const isZero:String = NAME + "isZero";*/
		
		private var micro : MyRecordProxy;
		
		private var maxTime:int = 600;
		
		private var startRecordBtn:Button;
		private var stopRecordBtn:Button;
		private var playBtn:Button;
		private var stopBtn:Button;
		private var uploadBtn:Button;
		
		private var textfield:TextField;
		
		private var vo:SwitchScreenVO;
		
		
		public function SpokenRecordMediator( viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function onRemove():void{
			AppLayoutUtils.gpuLayer.touchable = true;
			TweenLite.killDelayedCallsTo(stopRecordHandler);
			facade.removeProxy(MyRecordProxy.NAME);
			super.onRemove();
		}
		override public function onRegister():void{
			textfield = new TextField(200,60,"","HeiTi",15);
			textfield.x = - 50;
			textfield.y = 100;
			view.addChild(textfield);
			
			micro = new MyRecordProxy(this.vo.data);
			facade.registerProxy(micro);
			
			startRecordBtn = new Button();
			startRecordBtn.label = "开始录音";
			view.addChild(startRecordBtn);
			
			stopRecordBtn = new Button();
			stopRecordBtn.label = "结束录音";
			view.addChild(stopRecordBtn);
			
			playBtn = new Button();
			playBtn.label = "试听";
			playBtn.y = 200;
			view.addChild(playBtn);
			
			stopBtn = new Button();
			stopBtn.label = "停止";
			stopBtn.y = 200;
			view.addChild(stopBtn);
			
			uploadBtn = new Button();
			uploadBtn.label = "上传";
			uploadBtn.y = 300;
			view.addChild(uploadBtn);
			
			startRecordBtn.addEventListener(Event.TRIGGERED,recordHandler);
			stopRecordBtn.addEventListener(Event.TRIGGERED,stopRecordHandler);
			playBtn.addEventListener(Event.TRIGGERED,playHandler);
			stopBtn.addEventListener(Event.TRIGGERED,stopHandle1);
			uploadBtn.addEventListener(Event.TRIGGERED,uploadHandle1);
			
			stopRecordBtn.visible = false;
			stopBtn.visible = false;			
		}
		
		private function uploadHandle1():void
		{
			TweenLite.killDelayedCallsTo(stopRecordHandler);
			textfield.text = '正在压缩并上传,请稍等、勿关闭平板。'
			stopBtn.visible = false;
			playBtn.visible = true;
			startRecordBtn.visible =true;
			stopRecordBtn.visible = false;
			micro.changToMp3AndUpload();
			
		}
		//试听
		private function playHandler():void
		{
			
			micro.playSound();	
			stopBtn.visible = true;
			playBtn.visible = false;
			startRecordBtn.visible =false;
			stopRecordBtn.visible = false;
		}
		//结束试听
		private function stopHandle1():void{
			textfield.text = '结束试听';
			micro.stopSound();
			stopBtn.visible = false;
			playBtn.visible = true;
			startRecordBtn.visible =true;
			stopRecordBtn.visible = false;
		}
		//停止录音
		private function stopRecordHandler():void
		{
			TweenLite.killDelayedCallsTo(stopRecordHandler);
			textfield.text = '结束录音'
			stopBtn.visible = false;
			playBtn.visible = true;
			startRecordBtn.visible =true;
			stopRecordBtn.visible = false;
			uploadBtn.visible = true;
			micro.stopLis();
		}
		//开始录音
		private function recordHandler():void
		{	
			TweenLite.killDelayedCallsTo(stopRecordHandler);
			TweenLite.delayedCall(maxTime,stopRecordHandler);
			textfield.text = '已录音数据:0.0s'
			stopBtn.visible = false;
			playBtn.visible = false;
			uploadBtn.visible = false;
			startRecordBtn.visible =false;
			stopRecordBtn.visible = true;
			micro.recordLis();
		}
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){				
				case MyRecordProxy.isLoading:
					textfield.text = "加载音频中..稍等";
					break;
				case MyRecordProxy.loadingComplete:
					textfield.text = '正在试听,总时长:'+notification.getBody()+'s';
					break;
				case MyRecordProxy.loadError:
					textfield.text = "抱歉加载出错，请重新录音";
					break;
				case MyRecordProxy.recordingTime:
					textfield.text = '已录音数据:'+ notification.getBody()+'s';
					break;
				case MyRecordProxy.playSoundComplete:
					textfield.text = '上传成功！'
					stopHandle1();
					break;
				case CoreConst.UPLOAD_COMPLETE:
					AppLayoutUtils.gpuLayer.touchable = true;
					textfield.text = '上传成功！'
					sendNotification(CoreConst.TOAST,new ToastVO('上传成功！'));
					micro.clearMp3File();
					
					PackData.app.CmdIStr[0] = CmdStr.Send_FAQ_Info;
					PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
					PackData.app.CmdIStr[2] = "上传录音";//菜单名称
					PackData.app.CmdIStr[3] = "id: "+PackData.app.head.dwOperID.toString();
					PackData.app.CmdInCnt = 4;	
					sendNotification(CoreConst.SEND_1N,new SendCommandVO(''));	//派发调用绘本列表参数，调用后台
					break;
				case MyRecordProxy.upLoadError:
					textfield.text = ''
					break;
			}
		}
		override public function listNotificationInterests():Array{
			return [MyRecordProxy.isLoading,
					MyRecordProxy.loadingComplete,
					MyRecordProxy.recordingTime,
					MyRecordProxy.playSoundComplete,
					MyRecordProxy.upLoadError,
					CoreConst.UPLOAD_COMPLETE,
					MyRecordProxy.loadError];
		}
		override public function get viewClass():Class{
			return starling.display.Sprite;
		}
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function prepare(vo:SwitchScreenVO):void{
			this.vo = vo;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
	}
}