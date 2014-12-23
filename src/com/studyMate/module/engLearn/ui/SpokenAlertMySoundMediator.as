package com.studyMate.module.engLearn.ui
{
	import com.edu.AMRMedia;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.PopUpCommandVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.UpLoadCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.engLearn.vo.EgSpokenVO;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Point;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	public class SpokenAlertMySoundMediator extends ScreenBaseMediator
	{
		public static const NAME:String = 'SpokenAlertMySoundMediator';
		private const RECEIVE_COMPLETE:String = NAME+ 'recieve_complete';
		private var pareVO:SwitchScreenVO;

		private var holder:Sprite;
		private var dragbg:Quad;
		
		private var soundTxt:TextField;
		private var tipTxt:TextField;
		private var playStandardBtn:starling.display.Button;
		private var pauseStandardBtn:starling.display.Button;
		private var uploadBtn:starling.display.Button;
		
		private const url:String = Global.document.resolvePath(Global.localPath+'Market/record/spokenRecord.amr').nativePath;
		
		public function SpokenAlertMySoundMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function onRemove():void{
//			AppLayoutUtils.gpuLayer.touchable = true;
			sendNotification(WorldConst.REMOVE_POPUP_SCREEN,this);
		}
		override public function onRegister():void{
//			AppLayoutUtils.gpuLayer.touchable = false;
			sendNotification(WorldConst.POPUP_SCREEN,(new PopUpCommandVO(this)));
			holder = new Sprite();
			view.addChild(holder);
			
			var bg:Image = new Image(Assets.getEgLearnSpokenTexture('mySoundBg'));
			holder.addChild(bg);
			
			this.dragbg = new starling.display.Quad(540,70,0);
			this.dragbg.alpha = 0;
			this.dragbg.addEventListener(TouchEvent.TOUCH,TOUCHHandler);
			holder.addChild(dragbg);
			
			var closeBtn:starling.display.Button = new starling.display.Button(Assets.getEgLearnSpokenTexture('closeBtn'));
			closeBtn.x = 498;
			closeBtn.y = -15;
			holder.addChild(closeBtn);
			closeBtn.addEventListener(starling.events.Event.TRIGGERED,closeHandler);
			
			var file:File =  Global.document.resolvePath(Global.localPath+"Market/record/spokenRecord.amr");
			if(file.exists){
				soundTxt = new TextField(220,74,'spokenRecord.amr','HeiTI',20,0,true);
				soundTxt.x = 60;
				soundTxt.y = 80;
				holder.addChild(soundTxt);								
				
				tipTxt = new TextField(300,74,'','HeiTi',20,0,true);
				tipTxt.x = 230;
				tipTxt.y = 85;
				holder.addChild(tipTxt);
				
				uploadBtn = new starling.display.Button(Assets.getEgLearnSpokenTexture('uploadSoundBtn'));
				uploadBtn.x = 230;
				uploadBtn.y = 260;
				holder.addChild(uploadBtn);
				uploadBtn.addEventListener(starling.events.Event.TRIGGERED,uploadHandler);
				
				//播放录音
				playStandardBtn = new starling.display.Button(Assets.getEgLearnSpokenTexture('playStandardBtn'));
				playStandardBtn.x = 430;
				playStandardBtn.y = 96;
				playStandardBtn.scaleX = 0.8;
				playStandardBtn.scaleY = 0.8;
				holder.addChild(playStandardBtn);
				playStandardBtn.addEventListener(starling.events.Event.TRIGGERED,playSoundHandler);
				//暂停录音
				pauseStandardBtn = new starling.display.Button(Assets.getEgLearnSpokenTexture('stopStandardBtn'));
				pauseStandardBtn.x = 430;
				pauseStandardBtn.y = 96;
				pauseStandardBtn.scaleX = 0.8;
				pauseStandardBtn.scaleY = 0.8;
				holder.addChild(pauseStandardBtn);
				pauseStandardBtn.visible = false;
				pauseStandardBtn.addEventListener(starling.events.Event.TRIGGERED,stopSoundHandler);
			}
		}
		
		private function stopSoundHandler():void
		{
			playStandardBtn.visible = true;
			pauseStandardBtn.visible = false;
			tipTxt.text = '暂停试听';
			AMRMedia.getInstance().pauseAMR();
		}
		
		private function playSoundHandler():void
		{
			tipTxt.text = '正在试听';
			playStandardBtn.visible = false;
			pauseStandardBtn.visible = true;
//			AMRMedia.getInstance().addEventListener(AMRMedia.PLAY_COMPLETE,playCompleteHandler);
			AMRMedia.getInstance().addEventListener(AMRMedia.PLAY_COMPLETE,playCompleteHandler);
			AMRMedia.getInstance().playAMR(url);
		}
		
		protected function playCompleteHandler(event:flash.events.Event):void
		{
			AMRMedia.getInstance().removeEventListener(AMRMedia.PLAY_COMPLETE,playCompleteHandler);
			tipTxt.text = '试听结束';
			playStandardBtn.visible = true;
			pauseStandardBtn.visible = false;
		}
		
		private function uploadHandler():void
		{
			
			var mp3File:File = new File(url);
			if(mp3File.exists){
				if(mp3File.size<1024){
					tipTxt.text = '您的录音时间太短了。';
					return;
				}
//				uploadBtn.touchable = false;
//				view.touchable = false;
				uploadBtn.visible = false;
				tipTxt.text = '正在上传,请稍等。';
				var spokenVO:EgSpokenVO =  pareVO.data as EgSpokenVO;
				var path:String = Global.localPath+"Market/record/R"+spokenVO.oralid+'-'+PackData.app.head.dwOperID.toString()+'-'+MyUtils.getTimeFormat()+".amr";
				var newFile:File = new File(Global.document.resolvePath(path).nativePath);
				mp3File.copyTo(newFile,true);
				sendNotification(CoreConst.UPLOAD_FILE,new UpLoadCommandVO(newFile,"spokenRecord/" + newFile.name,null,WorldConst.UPLOAD_PERSON_INIT));
			}else{
				tipTxt.text = '文件不存在';
			}
		}
		

		
		private function closeHandler():void
		{
			AMRMedia.getInstance().removeEventListener(AMRMedia.PLAY_COMPLETE,playCompleteHandler);
			AMRMedia.getInstance().stopAMR();
			pareVO.type = SwitchScreenType.HIDE;
			sendNotification(WorldConst.SWITCH_SCREEN,[pareVO]);
		}		
		
		/**-----------最精简的拖动函数了----------------*/
		private	var pos:Point = new Point();
		private var pos0:Point = new Point();
		private function TOUCHHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(view);	
			if(touch && touch.phase == TouchPhase.BEGAN){
				pos0 =  touch.getLocation(holder,pos0);
			}else if(touch && touch.phase == TouchPhase.MOVED){
				touch.getLocation(view,pos);
				holder.x = pos.x-pos0.x;
				holder.y = pos.y-pos0.y;
			}
		}
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				/*case MyRecordProxy.isLoading:
					tipTxt.text = "加载音频.请稍等";
					break;
				case MyRecordProxy.loadingComplete:
					tipTxt.text = '正在试听,总时长:'+notification.getBody()+'s';
					break;*/
				/*case MyRecordProxy.playSoundComplete:
					tipTxt.text = '播放结束';
					playStandardBtn.visible = true;
					pauseStandardBtn.visible = false;
					break;*/
				case CoreConst.UPLOAD_COMPLETE:					
					tipTxt.text = '上传成功！'
					sendNotification(CoreConst.TOAST,new ToastVO('上传成功！'));
//					(facade.retrieveProxy(MyRecordProxy.NAME) as MyRecordProxy).clearMp3File();
					
					PackData.app.CmdIStr[0] = CmdStr.Send_FAQ_Info;
					PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
					PackData.app.CmdIStr[2] = "上传录音";//菜单名称
					PackData.app.CmdIStr[3] = "id: "+PackData.app.head.dwOperID.toString();
					PackData.app.CmdInCnt = 4;	
					sendNotification(CoreConst.SEND_1N,new SendCommandVO(RECEIVE_COMPLETE));	//派发调用绘本列表参数，调用后台
					break;
				case RECEIVE_COMPLETE:
//					uploadBtn.touchable = true;
//					view.touchable = true;
//					AppLayoutUtils.gpuLayer.touchable = true;
					break;
				/*case MyRecordProxy.upLoadError:
					tipTxt.text = ''
					break;*/
				
			}
		}
		override public function listNotificationInterests():Array{
			return [
//				MyRecordProxy.isLoading,
//				MyRecordProxy.loadingComplete,
//				MyRecordProxy.playSoundComplete,				
//				MyRecordProxy.upLoadError,
				RECEIVE_COMPLETE,
				CoreConst.UPLOAD_COMPLETE,];
		}
		
		override public function get viewClass():Class{
			return starling.display.Sprite;
		}
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function prepare(vo:SwitchScreenVO):void{
			pareVO = vo;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);								
		}
	}
}