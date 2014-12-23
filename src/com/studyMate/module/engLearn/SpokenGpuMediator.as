package com.studyMate.module.engLearn
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.view.component.GpuTextField.TextFieldToGPU;
	import com.studyMate.world.component.record.SpokenRecordMediator;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.screens.CleanCpuMediator;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.view.EduAlertMediator;
	
	import flash.events.MouseEvent;
	import flash.globalization.DateTimeFormatter;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;
	
	import mx.utils.StringUtil;
	
	import feathers.controls.Button;
	import feathers.controls.ScrollContainer;
	import feathers.layout.VerticalLayout;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;

	internal class SpokenGpuMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "SpokenGpuMediator";
		
		public static const GRADE_SPOKEN:String = "GRADE_SPOKEN";		
		private const GET_READ_INFO:String = NAME+ "GET_READ_ID";
		private const SUBMIT_TASK_RETURN:String = NAME + "submitTaskReturn";
		private var listScroll:ScrollContainer;
		
		private const delayTimeQuit:int = 180;
		
		private var startSS:Number=0;
		private var title:String="";
		private var content:String="";
		private var rrl:String;
		private var WNum:String;//单词树
		private var textType:String;
		private var oralid:String;
		private var beginTime:String;
		private var endTime:String;
		private var learnTime:int;//学习时长秒数
		private var rewardData:Object={};
		
		private var gradeStr:String;
		
		protected var TOTALTIMES:int;
		private var timeTxt:flash.text.TextField;
		
		private var prepareVO:SwitchScreenVO;
		private var readCompleteBtn:starling.display.Button;
		private var adultGradeBtn:starling.display.Button;
		
		private var yesHandler:String = NAME+ "yesHandler";
		private var quiteSuccess:Boolean;
		
		private var contentTxt:flash.text.TextField;
		private var contentGpu:TextFieldToGPU;
		
		public function SpokenGpuMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function onRegister():void{
			beginTime = getTimeFormat();
			startSS = getTimer();
			var bg:Image = new Image(Assets.getTexture("spokenBg"));
			bg.blendMode = BlendMode.NONE;
			bg.touchable = false;
			view.addChild(bg);
			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = 2;
			layout.paddingBottom =20;
			listScroll = new ScrollContainer();
			listScroll.x = 0;
			listScroll.y = 122;
			listScroll.paddingLeft = 308;
			listScroll.width = 1280;
			listScroll.height = 590;
			listScroll.layout = layout;
			listScroll.snapScrollPositionsToPixels = true;	
			view.addChild(listScroll);
			
			
			var changeBtn:feathers.controls.Button = new feathers.controls.Button();
			changeBtn.x = 20;
			changeBtn.y = 132;
			changeBtn.label = "切换阅读模式";
			changeBtn.addEventListener(Event.TRIGGERED,changeReadModeHandler);
			view.addChild(changeBtn);
			
			var tf1:TextFormat = new TextFormat("HeiTi",22,0,true);
			tf1.align = TextFormatAlign.CENTER;
			var titleTxt:flash.text.TextField = new flash.text.TextField();
			titleTxt.defaultTextFormat = tf1;
			titleTxt.autoSize = TextFieldAutoSize.CENTER;
			titleTxt.wordWrap = true;
			titleTxt.multiline = true;
			titleTxt.embedFonts = true;
			titleTxt.antiAliasType = AntiAliasType.ADVANCED;
			titleTxt.width = 800;
			titleTxt.height = 50;
			titleTxt.text = title;
			
			
			var tf:TextFormat = new TextFormat("HeiTi",22,0x262626,true);
			tf.leading = 7;			
			contentTxt = new flash.text.TextField();
			contentTxt.embedFonts = true;
			contentTxt.autoSize = TextFieldAutoSize.LEFT;
			contentTxt.antiAliasType = AntiAliasType.ADVANCED;
			contentTxt.defaultTextFormat = tf;
			contentTxt.width = 686;
			contentTxt.multiline = true;
			contentTxt.wordWrap = true;
			var tempStr:String = content;			
			tempStr = tempStr.replace(/`/g,"<font color='#c7c7c7'>  / </font>");
			tempStr = tempStr.replace(/\r\n/g,"<br>");
			tempStr = tempStr.replace(/,\s/g,",     ");
			tempStr = tempStr.replace(/\.\s/g,".     ");
			tempStr = tempStr.replace(/\"\s/g,"\"     ");
			tempStr = tempStr.replace(/?\s/g,"?     ");
			tempStr = tempStr.replace(/!\s/g,"!     ");
			tempStr = tempStr.replace(/;\s/g,";     ");
			contentTxt.htmlText = tempStr+"\n\n\n\n\n";
			
			var idTxt:starling.text.TextField = new starling.text.TextField(100,24,oralid,"HeiTi",20);
			idTxt.x = 52;
			idTxt.y = 0;
			view.addChild(idTxt);
			
			
			var titleGpu:TextFieldToGPU = new TextFieldToGPU(titleTxt);
			titleGpu.x = 238;
			titleGpu.y = 52;
			contentGpu = new TextFieldToGPU(contentTxt);			
			view.addChild(titleGpu);
			listScroll.addChild(contentGpu);
			
			var timeTf:TextFormat = new TextFormat("HeiTi",22,0xFFFFFF,true);
			timeTxt = new flash.text.TextField();
			timeTxt.x = 56;
			timeTxt.y = 72;
			timeTxt.width = 136;
			timeTxt.height = 38;
			timeTxt.embedFonts = true;
			timeTxt.antiAliasType = AntiAliasType.ADVANCED;
			timeTxt.defaultTextFormat = timeTf;
			timeTxt.mouseEnabled = false;
			timeTxt.selectable = false;
			Starling.current.nativeOverlay.addChild(timeTxt);
			
			timeTxt.text = getTimeUsed(TOTALTIMES);
			//TOTALTIMES = 10;//测试用
			TweenLite.delayedCall(1,startTime);	
			
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SpokenRecordMediator,oralid,SwitchScreenType.SHOW,view,1126,100)]);
		}
		
		/**------------切换阅读模式----------------------*/
		private var changeBoo:Boolean;
		private function changeReadModeHandler():void
		{
			changeBoo = !changeBoo;
			var tempStr:String = content;
			if(changeBoo){
				tempStr = tempStr.replace(/`/g,"");				
			}else{
				tempStr = tempStr.replace(/`/g,"<font color='#c7c7c7'>  / </font>");	
				
				tempStr = tempStr.replace(/\r\n/g,"<br>");
				tempStr = tempStr.replace(/,\s/g,",     ");
				tempStr = tempStr.replace(/\.\s/g,".     ");
				tempStr = tempStr.replace(/\"\s/g,"\"     ");
				tempStr = tempStr.replace(/?\s/g,"?     ");
				tempStr = tempStr.replace(/!\s/g,"!     ");
				tempStr = tempStr.replace(/;\s/g,";     ");
			}
									
			tempStr = tempStr.replace(/\r/g,"<br>");
			contentTxt.htmlText = tempStr+"\n\n\n\n\n";
			contentGpu.textField = contentTxt;			
		}
		override public function onRemove():void
		{
			if(facade.hasMediator(EduAlertMediator.NAME)){
				sendNotification(WorldConst.REMOVE_POPUP_SCREEN,(facade.retrieveMediator(EduAlertMediator.NAME) as EduAlertMediator));
			}
			quiteSuccess = true;
			TweenLite.killDelayedCallsTo(AeertQuit);
			TweenLite.killDelayedCallsTo(quit);	
			TweenLite.killDelayedCallsTo(quitSuccessHandler);
			Global.stage.removeEventListener(MouseEvent.MOUSE_DOWN,stageMouseDownHandler);
			TweenLite.killDelayedCallsTo(startTime);
			Starling.current.nativeOverlay.removeChild(timeTxt);
			super.onRemove();
		}
		protected function startTime():void{
			timeTxt.text = getTimeUsed(TOTALTIMES);
			if(TOTALTIMES==0){	
				readCompleteBtn = new starling.display.Button(Assets.getEgAtlasTexture("word/readCompleteBtn"));
				readCompleteBtn.x = 1038;
				readCompleteBtn.y = 678;
				view.addChild(readCompleteBtn);				
				TweenLite.from(readCompleteBtn,1,{y:768});	
				readCompleteBtn.addEventListener(Event.TRIGGERED,readCompleteHandler);
				
				TweenLite.delayedCall(delayTimeQuit,AeertQuit);//三分钟后退出
				Global.stage.addEventListener(MouseEvent.MOUSE_DOWN,stageMouseDownHandler);
				return;
			}
			TOTALTIMES--;
			TweenLite.delayedCall(1,startTime);
		}
		/**--------三分钟未输入则弹出窗口---------------*/
		private function AeertQuit():void{
			sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n您长时间未进行任何操作，\n系统即将退出该界面。\n点击确定则继续任务。",false,yesHandler));
			TweenLite.delayedCall(10,quit);		
		}
		private function quit():void{
			sendNotification(WorldConst.POP_SCREEN);
			
			TweenLite.delayedCall(2,quitSuccessHandler);
			
		}
		private function quitSuccessHandler():void{
			if(!quiteSuccess){//退出失败则反复继续退出。知道彻底退出为之
				quit();
			}
		}
		private function stageMouseDownHandler(event:MouseEvent):void
		{
			TweenLite.killDelayedCallsTo(AeertQuit);
			TweenLite.delayedCall(delayTimeQuit,AeertQuit);//三分钟后退出
			
		}
		
		
		private function readCompleteHandler():void//完成阅读
		{
			view.removeChild(readCompleteBtn);
			adultGradeBtn = new starling.display.Button(Assets.getEgAtlasTexture("word/adultGradeBtn"));
			adultGradeBtn.x = 1174;
			adultGradeBtn.y = 453;
			view.addChild(adultGradeBtn);				
			TweenLite.from(adultGradeBtn,1,{x:1280});	
			adultGradeBtn.addEventListener(Event.TRIGGERED,gradeBtnHandler);
			
		}
		
		private function gradeBtnHandler(e:Event):void{//弹出奖励框
			view.removeChild(adultGradeBtn);
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SpokenSubAlertMediator,null,SwitchScreenType.SHOW,view,236,71)]);//家长评分
		}
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				case GET_READ_INFO:
					if(PackData.app.CmdOStr[0] == "000"){//第一步获取阅读id
						WNum = PackData.app.CmdOStr[4];
						TOTALTIMES = int(WNum)/2;
						if(TOTALTIMES<10) TOTALTIMES = 10;
						title = StringUtil.trim(PackData.app.CmdOStr[3]);
						textType = PackData.app.CmdOStr[5];
						content = PackData.app.CmdOStr[6];
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,prepareVO);
					}
					break;
				case GRADE_SPOKEN://评分完毕
					endTime = getTimeFormat();
					learnTime = int((getTimer() - startSS)*0.001);					
					gradeStr = notification.getBody() as String;//分数
					sendinServerInofFunc(CmdStr.SUBMIT_TASK_YYORAL,SUBMIT_TASK_RETURN,[rrl,oralid,String(learnTime),WNum,"0",WNum,gradeStr,beginTime,endTime,""])					
					break;
				case SUBMIT_TASK_RETURN:
					/*trace("0： "+PackData.app.CmdOStr[0]);
					trace("1： "+PackData.app.CmdOStr[1]);
					trace("2： "+PackData.app.CmdOStr[2]);
					trace("3： "+PackData.app.CmdOStr[3]);
					trace("4： "+PackData.app.CmdOStr[4]);*/
					if(PackData.app.CmdOStr[0] == "000"){
						//view.mouseEnabled = false;
						var _rrl:String = PackData.app.CmdOStr[1]
						if(_rrl)	rrl=StringUtil.trim(_rrl);
						else	rrl="";
						trace("任务rrl "+rrl);
						rewardData = {right:-1,wrong:0,time:String(learnTime)};
						rewardData.rrl = PackData.app.CmdOStr[1];
					
						trace("oralid = "+PackData.app.CmdOStr[2] );
						rewardData.gold = PackData.app.CmdOStr[3];
						rewardData.oralid = PackData.app.CmdOStr[2];
						rewardData.right = gradeStr;
						sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(RewardViewMediator,rewardData),new SwitchScreenVO(CleanCpuMediator)]);//奖励界面
					}
					if((PackData.app.CmdOStr[0] as String).charAt(0)=="M"){//出错退出
						sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n抱歉，提交结果失败.请退出该界面\n",false));//提交订单
					}
					break;
				case yesHandler:
					TweenLite.killDelayedCallsTo(quit);	
					break;
				case WorldConst.GET_SCREEN_FAQ:
					var str1:String = "口语界面/ 口语id:"+ oralid;
					sendNotification(WorldConst.SET_SCREENT_FAQ,str1);
					break;
				case CoreConst.DEACTIVATE:
					duration = getTimer();
					break;
				case CoreConst.ACTIVATE:
					if((getTimer() - duration)*0.001>180){
						TweenLite.killDelayedCallsTo(quit);
						quit();
					}
					break;
			}					
		}
		private var duration:int = 0;
		override public function listNotificationInterests():Array{
			return [CoreConst.DEACTIVATE,CoreConst.ACTIVATE,WorldConst.GET_SCREEN_FAQ,GET_READ_INFO,GRADE_SPOKEN,SUBMIT_TASK_RETURN,yesHandler];
		}
		
		override public function get viewClass():Class{
			return starling.display.Sprite;
		}
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		private function sendinServerInofFunc(command:String,reveive:String,infoArr:Array):void{
			PackData.app.CmdIStr[0] = command;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			for(var i:int=0;i<infoArr.length;i++){
				PackData.app.CmdIStr[i+2] = infoArr[i]
			}
			PackData.app.CmdInCnt = i+2;	
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(reveive));	//派发调用绘本列表参数，调用后台
		}
		private function getTimeFormat():String {						
			var dateFormatter:DateTimeFormatter = new DateTimeFormatter("en-US");			
			dateFormatter.setDateTimePattern("yyyyMMdd-HHmmss");
			return dateFormatter.format(Global.nowDate);		
			
			
		}
		private function getTimeUsed(time:int):String {
			var hour:int = time/3600;
			var minute:int = (time%3600)/60;
			var second:int = (time%3600)%60;
			var dateFormatter:DateTimeFormatter = new DateTimeFormatter("en-US");			
			dateFormatter.setDateTimePattern("HH   mm   ss");
			var date:Date = new Date(null,null,null,hour,minute,second);//这里不要修改。有用的
//			var str:String = "00"+minute+second;
			return dateFormatter.format(date); 
		}
		override public function prepare(vo:SwitchScreenVO):void{
			prepareVO = vo;
			oralid = vo.data.oralid;
			rrl = vo.data.rrl;
			sendinServerInofFunc(CmdStr.GET_YYOralById,GET_READ_INFO,["@y.O",oralid]);
		}
		
	}
}