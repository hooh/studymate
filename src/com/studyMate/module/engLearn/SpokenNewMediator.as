package com.studyMate.module.engLearn
{
	import com.edu.AMRMedia;
	import com.greensock.TweenLite;
	import com.mylib.api.IConfigProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.MP3PlayerProxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.UpdateFilesVO;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.module.engLearn.ui.SpokenAlertMySoundMediator;
	import com.studyMate.module.engLearn.vo.EgSpokenVO;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.screens.CleanCpuMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.ui.MusicSoundMediator;
	
	import flash.filesystem.File;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import mx.utils.StringUtil;
	
	import feathers.events.FeathersEventType;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.events.Event;
	import starling.events.TouchEvent;
	
	public class SpokenNewMediator extends EgLearnBaseMediator
	{
		public static const NAME:String = 'SpokenNewMediator';
		public static const GRADE_SPOKEN:String = "GRADE_SPOKEN";		
		private const GET_READ_INFO:String = NAME+ "GET_READ_ID";//获得文章
		private const SUBMIT_TASK_RETURN:String = NAME + "submitTaskReturn";//提交任务
		private const DOWN_STANDARD_SOUND:String = NAME + 'downStandardSound';//下载标准录音
		private var prepareVO:SwitchScreenVO;
		
		
		protected var TOTALTIMES:int;	//单词时长	
		
		private var startSS:Number=0;
		private var rrl:String;

		private var gradeStr:String;
		private var oralid:String;
		private var beginTime:String;
		private var endTime:String;
		private var learnTime:int;//学习时长秒数
		private var rewardData:Object={};
		
		private var spokenVO:EgSpokenVO;//存储后台返回的信息
		private var mp3Proxy:MP3PlayerProxy;
		private var _normalSentence:String;//正常模式
		private var _cutSentence:String;//断句模式
		
		private const url:String = Global.document.resolvePath(Global.localPath+'Market/record/spokenRecord.amr').nativePath;
		private const sizeSpoken:String = 'spokenSize';
		private var config:IConfigProxy;
		
		public function SpokenNewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function onRemove():void{			
			AMRMedia.getInstance().stopAMR();//移除必须加的。
			AMRMedia.getInstance().stopRecordAMR();//移除必须加的。
			mp3Proxy.onRemove();
			TweenLite.killDelayedCallsTo(startPlayTime);
			TweenLite.killDelayedCallsTo(startRecor);
			clearStandardFile();
			super.onRemove();
		}
			
		override public function onRegister():void{
			config = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CONFIGPROXY)  as IConfigProxy;
			if(facade.hasMediator(MusicSoundMediator.NAME)){
				facade.removeMediator(MusicSoundMediator.NAME);
			}
			super.onRegister();
			sendNotification(WorldConst.SHOW_BUTTON_BY_LEVEL, 1);
			mp3Proxy = facade.retrieveProxy(MP3PlayerProxy.NAME) as MP3PlayerProxy;
			view.init();
			beginTime = MyUtils.getTimeFormat();
			startSS = getTimer();
			if(spokenVO.title!=''){				
				view.titleTxt.htmlText = spokenVO.title;
				view.titleGpu.textField = view.titleTxt;
			}
			
//			view.contentTxt.htmlText = cutSentence;
//			view.contentGpu.textField = view.contentTxt;
			
			TOTALTIMES = int(spokenVO.WNum)/2;
			if(TOTALTIMES<15) TOTALTIMES = 15;			
//			TOTALTIMES = 3;
			view.familyGradeUI.delayTouch(TOTALTIMES);//延迟可点击时长
			
			view.idTxt.text = oralid;
			
			view.familyGradeUI.addEventListener(TouchEvent.TOUCH,gradeHandler);
			view.changeModeBtn.addEventListener(Event.TRIGGERED,changeModeHandler);
			view.recordStartBtn.addEventListener(Event.TRIGGERED,startRecordHandler);
			view.recordStopBtn.addEventListener(Event.TRIGGERED,stopRecordHandler);
			view.mySoundBtn.visible = false;
			view.mySoundBtn.addEventListener(Event.TRIGGERED,mySoundHandler);
			
			view.contentTxt.htmlText = cutSentence;
			var tmpString:String = config.getValueInUser(sizeSpoken);
			if(tmpString != ""){
				view.sizeSlider.value = parseInt(tmpString);
				var tf:TextFormat = new TextFormat("HeiTi",parseInt(tmpString),0,false);
				view.contentTxt.setTextFormat(tf);
			}else{
				view.sizeSlider.value = 22;
				config.updateValueInUser(sizeSpoken,22);
			}
			view.contentGpu.textField = view.contentTxt;
			
			view.sizeSlider.addEventListener(FeathersEventType.END_INTERACTION,sizeChangeHandler);
			
			if(spokenVO.assetsFlag!='0' && spokenVO.assetsFlag!='-1'){//有录音
				if( spokenVO.assetsPath!=''){
					view.initDownStandardBtn();//试听标准录音组件
					view.slider.addEventListener( FeathersEventType.END_INTERACTION, playSlider_changeHandler );
					var file:File =Global.document.resolvePath(Global.localPath + spokenVO.assetsPath);	
					
					if(file.exists){		//文件存在，显示播放	
						view.slider.visible = true;
						view.playStandardBtn.visible = true;
						view.playStandardBtn.addEventListener(Event.TRIGGERED,playStandardHandler);
						view.pauseStandardBtn.addEventListener(Event.TRIGGERED,playStandardHandler);
					}else{					//文件不存在，则不显示播放
						view.downStandardBtn.visible = true;
						view.downStandardBtn.addEventListener(Event.TRIGGERED,standardDownHandler);
					}
				}
			}
		}
		//调整字体大小
		private function sizeChangeHandler(event:Event):void
		{
			config.updateValueInUser(sizeSpoken,view.sizeSlider.value);
			var tf:TextFormat = new TextFormat("HeiTi",view.sizeSlider.value,0,false);
			if(changeBoo){
				view.contentTxt.htmlText = normalSentence;
			}else{				
				view.contentTxt.htmlText = cutSentence;
			}
			view.contentTxt.setTextFormat(tf);
			view.contentGpu.textField = view.contentTxt;
			view.listScroll.readjustLayout();
		}
		private function playSlider_changeHandler(event:Event):void{
			if(Global._mp3IsRunning){				
				mp3Proxy.jumpTime(view.slider.value*1000);
			}else{
				mp3Proxy.jumpTime(view.slider.value*1000);
				mp3Proxy.pause();
			}
			
		}
		private function startPlayTime():void{
			var total:int = int(mp3Proxy.getLength()/1000);
			view.slider.maximum = total;
			var current:int = int(mp3Proxy.getPosition()/1000);
			view.slider.value = current;
			TweenLite.delayedCall(1,startPlayTime);		
		}
		
		private function standardDownHandler():void
		{
			view.downStandardBtn.visible = false;
			var vec:Vector.<UpdateListItemVO> = new Vector.<UpdateListItemVO>;
			var _item:UpdateListItemVO = new UpdateListItemVO("",spokenVO.assetsPath,"","");
			_item.hasLoaded = true;//检查文件
			vec.push(_item);
			sendNotification(CoreConst.UPDATE_FILES,new UpdateFilesVO(vec,DOWN_STANDARD_SOUND));//检查本地文件
		}
		
		private function playStandardHandler():void
		{			
			if(Global._mp3IsRunning){	
				TweenLite.killDelayedCallsTo(startPlayTime);
				mp3Proxy.pause();
				view.playStandardBtn.visible = true;
				view.pauseStandardBtn.visible = false;
//				view.slider.visible = false;
			}else{		
				startPlayTime();
				view.playStandardBtn.visible = false;
				view.pauseStandardBtn.visible = true;
//				view.slider.visible = true;
				if(mp3Proxy.soundChannel){						
					mp3Proxy.resume();
				}else{					
					var path:String =Global.document.resolvePath(Global.localPath + spokenVO.assetsPath).url;	
					mp3Proxy.play(path,0,0,2.5);
				}
			}
		}
		//打开"我的录音"界面
		private function mySoundHandler():void
		{
			stopRecordHandler();
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SpokenAlertMySoundMediator,spokenVO,SwitchScreenType.SHOW,view,700,400)]);//家长评分
		}
		//结束录音
		private function stopRecordHandler():void
		{	
			view.mySoundBtn.touchable = true;
			view.recordStopBtn.visible = false;
			view.recordStartBtn.visible = true;
//			micro.stopLis();
			view.recordTimeTxt.text = '';
			TweenLite.killDelayedCallsTo(startRecor);
			AMRMedia.getInstance().stopRecordAMR();
			
			if(!facade.hasMediator(SpokenAlertMySoundMediator.NAME)){
				view.mySoundBtn.visible = true;
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SpokenAlertMySoundMediator,spokenVO,SwitchScreenType.SHOW,view,700,400)]);//家长评分
			}
		}
		//开始录音
		private function startRecordHandler():void
		{
			view.mySoundBtn.touchable = false;
			view.recordStopBtn.visible = true;
			view.recordStartBtn.visible = false;
//			micro.recordLis();
			AMRMedia.getInstance().RecordAMR(url);
			
			recordNum = 0.0;
			TweenLite.killDelayedCallsTo(startRecor);
			TweenLite.delayedCall(1,startRecor);
		}
		
		//计时间
		private var recordNum:Number = 0.0;
		private function startRecor():void{
			recordNum++;
			TweenLite.delayedCall(1,startRecor);
			view.recordTimeTxt.text = '已录音数据:'+recordNum+'s';
		}
		
		/**------------切换阅读模式----------------------*/
		private var changeBoo:Boolean;
		private function changeModeHandler(e:Event):void
		{
			changeBoo = !changeBoo;
			if(changeBoo){
				view.contentTxt.htmlText = normalSentence;
				view.changeModeTxt.text = '断句模式';
			}else{
				view.contentTxt.htmlText = cutSentence;
				view.changeModeTxt.text = '正常模式';
			}	
			var tf:TextFormat = new TextFormat("HeiTi",view.sizeSlider.value,0,false);
			view.contentTxt.setTextFormat(tf);
			view.contentGpu.textField = view.contentTxt;
			view.listScroll.readjustLayout();
		}		
		//处理文本，返回特殊模式
		private function get cutSentence():String{
			if(_cutSentence==null){				
				_cutSentence = spokenVO.content;
				_cutSentence = _cutSentence.replace(/`/g,"<font color='#4bacbf'>  / </font>");				
				_cutSentence = _cutSentence.replace(/\r\n/g,"<br>");
				_cutSentence = _cutSentence.replace(/,\s/g,",     ");
				_cutSentence = _cutSentence.replace(/\.\s/g,".     ");
				_cutSentence = _cutSentence.replace(/\"\s/g,"\"     ");
				_cutSentence = _cutSentence.replace(/?\s/g,"?     ");
				_cutSentence = _cutSentence.replace(/!\s/g,"!     ");
				_cutSentence = _cutSentence.replace(/;\s/g,";     ");
				_cutSentence = _cutSentence+"\n\n\n\n\n";
			}
			return _cutSentence;
		}
		
		//处理文本，返回特殊模式
		private function get normalSentence():String{
			if(_normalSentence==null){
				_normalSentence = spokenVO.content;
				_normalSentence = _normalSentence.replace(/`/g,"");	
				_normalSentence+="\n\n\n\n\n";
				_normalSentence = _normalSentence.replace(/\r/g,"<br>");
			}			
			return _normalSentence;
		}
		
		private function gradeHandler(e:TouchEvent):void
		{
			if(e.touches[0].phase=="ended"){				
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SpokenGradeMediator,spokenVO,SwitchScreenType.SHOW,view)]);//家长评分
			}
		}
		
		private var upflag:int = 0;//默认没有上传过录音
		override public function handleNotification(notification:INotification):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO('s '+notification.getName(),"SpokenNewMediator",0));

			var result:DataResultVO = notification.getBody() as DataResultVO;
			super.handleNotification(notification);
			switch(notification.getName()){
				case GET_READ_INFO:
					if(!result.isErr){//第一步获取阅读id
						spokenVO = new EgSpokenVO(PackData.app.CmdOStr.concat());
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,prepareVO);
					}else {
						Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.TOAST,new ToastVO("抱歉！后台口语数据有误！请退出."));
					}
					break;
				/*case MyRecordProxy.recordingTime:
					view.recordTimeTxt.text = '已录音数据:'+ notification.getBody()+'s';
					break;*/
				case DOWN_STANDARD_SOUND://下载完成
					view.slider.visible = true;
					view.playStandardBtn.visible = true;
					view.playStandardBtn.addEventListener(Event.TRIGGERED,playStandardHandler);
					view.pauseStandardBtn.addEventListener(Event.TRIGGERED,playStandardHandler);
					break;
				case CoreConst.UPLOAD_COMPLETE:
					upflag = 1;//也有可能是faq上传的文件.
					break;
				case GRADE_SPOKEN://评分完毕
					if(!isSubmit){						
						isSubmit = true;
						endTime = MyUtils.getTimeFormat();
						learnTime = int((getTimer() - startSS)*0.001);					
						gradeStr = notification.getBody() as String;//分数
						sendinServerInfo(CmdStr.SUBMIT_TASK_YYORAL,SUBMIT_TASK_RETURN,[rrl,oralid,String(learnTime),spokenVO.WNum,"0",spokenVO.WNum,gradeStr,beginTime,endTime,upflag])					
					}
					break;
				case SUBMIT_TASK_RETURN:
					if(!result.isErr){
						var _rrl:String = PackData.app.CmdOStr[1]
						if(_rrl)	rrl=StringUtil.trim(_rrl);
						else	rrl="";
						rewardData = {right:-1,wrong:0,time:String(learnTime)};
						rewardData.rrl = PackData.app.CmdOStr[1];						
						rewardData.gold = PackData.app.CmdOStr[3];
						rewardData.oralid = PackData.app.CmdOStr[2];
						rewardData.right = gradeStr;
						sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(RewardViewMediator,rewardData),new SwitchScreenVO(CleanCpuMediator)]);//奖励界面
					}else{//出错退出
						sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n抱歉，提交结果失败.请退出该界面\n",false,'EgLearnBaseMediator','EgLearnBaseMediator',false,null,quit));//提交订单
					}
					break;
				case WorldConst.GET_SCREEN_FAQ:
					var str1:String = "口语界面/ 口语id:"+ oralid;
					sendNotification(WorldConst.SET_SCREENT_FAQ,str1);
					break;
				case MP3PlayerProxy.SOUND_COMPLETE:
					if(view.playStandardBtn){		
						mp3Proxy.stop();
						TweenLite.killDelayedCallsTo(startPlayTime);
						view.slider.value = 0;
						view.playStandardBtn.visible = true;
						view.pauseStandardBtn.visible = false;
//						view.slider.visible = false;
					}
					break;
			}
			
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO('e ',"SpokenNewMediator",0));

		}
		override public function listNotificationInterests():Array{
			var arr:Array = super.listNotificationInterests();
			return arr.concat([GET_READ_INFO, 
//								MyRecordProxy.recordingTime,
								DOWN_STANDARD_SOUND,
								MP3PlayerProxy.SOUND_COMPLETE,
								GRADE_SPOKEN,
								CoreConst.UPLOAD_COMPLETE,
								SUBMIT_TASK_RETURN,WorldConst.GET_SCREEN_FAQ]);
		}
			
		//清理录音文件夹 保留最后8个标准声音
		private function clearStandardFile():void{
			var recordfile:File = Global.document.resolvePath(Global.localPath+"Market/record");	
			if(recordfile.exists){
				var list:Array = recordfile.getDirectoryListing();
				for(var i:int=0;i<list.length;i++){
					if(list[i].exists){
						list[i].deleteFile();
					}
				}
			}
			
			MyUtils.clearFileNum('oral',8,8);
		}
		override public function get viewClass():Class{
			return SpokenNewView;
		}
		public function get view():SpokenNewView{
			return getViewComponent() as SpokenNewView;
		}
		override public function prepare(vo:SwitchScreenVO):void{
			prepareVO = vo;
			oralid = vo.data.oralid;
//			oralid = '10';
			rrl = vo.data.rrl;
			sendinServerInfo(CmdStr.GET_YYOralByIdV2,GET_READ_INFO,["@y.O",oralid]);
		}
	}
}