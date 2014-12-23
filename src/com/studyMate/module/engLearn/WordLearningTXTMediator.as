package com.studyMate.module.engLearn
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.ItemVO;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.SoundVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.WordVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.utils.LayoutToolUtils;
	import com.studyMate.utils.MyUtils;
	import myLib.myTextBase.utils.SoftKeyBoardConst;
	import com.studyMate.world.component.EnglishAnalyze;
	import com.studyMate.world.controller.vo.UpdateTaskDataVO;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.model.vo.LoadSoundEffectVO;
	import com.studyMate.world.model.vo.PlaySoundEffectVO;
	import com.studyMate.world.screens.CleanCpuMediator;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.view.EduAlertMediator;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.globalization.DateTimeFormatter;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	import mx.utils.StringUtil;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	internal class WordLearningTXTMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "WordLearningTXTMediator";
		protected const yesHandler:String = NAME + "yesHandler";
		protected const sendStudyState:String = NAME + "sendStudyState";
		
		public static const yesAbandonHandler:String = NAME + "yesAbandonHandler";
		private const QUIT_POP:String = NAME+"QUIT_POP";//出错跳出
		
		private var prepareVO:SwitchScreenVO;	
		
		private var wordSoundVO:SoundVO;
		protected var itemArray:Vector.<ItemVO> = new Vector.<ItemVO>;//用于标记答对和答错单词等相关信息					
		protected var dataSetArr:Array=[];
		private var currentIndex:int = 0;
		private var totalItems:int = 0;
		public var currentWordVO:WordVO;
		private var appleEnable:Boolean;//是否掉落苹果		
		private const study_delayTime:int = 3;
		
		protected var startTime:String;
		protected var startSSS:Number;//开始秒数，为了求总时间
		protected var rightNum:int;//答对个数
		//private var errorNum:int;//打错个数
		protected var totalNum:int;//总数
		private var totlaTime:Number;
		private var appleNum:int;
		
		private var currentWord:String="";//当前单词,需要提示的单词
		private var times:int = 1;//第几次,次数
		private var state:int = 0;//0表示正常状态，1表示错题状态
		private var CompleteWrong:Boolean = false;//完成错题集
		
		private var dataArr:Array;//提交任务后返回的奖励信息数组
		
		public var isStart:Boolean;//是否开始答题
		private const delayTime:int = 180;
		
		private var quiteSuccess:Boolean;
		public static var soundVolume:Number = 0.8;
		
		public function WordLearningTXTMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}
		override public function onRemove():void{
			Global.stage.removeEventListener(MouseEvent.MOUSE_DOWN,stageMouseDownHandler);
			if(dataArr){
				dataArr.length = 0;
				dataArr = null;				
			}
			TweenLite.killDelayedCallsTo(changeFocus);
			quiteSuccess = true;
//			TweenLite.killDelayedCallsTo(quitSuccessHandler);
			TweenLite.killDelayedCallsTo(quitPopScreen);
			dataSetArr.length = 0;
			dataSetArr = null;
			itemArray.length = 0;
			itemArray = null;
//			SoundAS.removeSound("wordRight");
			sendNotification(CoreConst.REMOVE_EFFECT_SOUND,'wordRight');
			
			TweenLite.killTweensOf(DealNextData);
			TweenLite.killDelayedCallsTo(insertChinese);
			TweenLite.killDelayedCallsTo(quit);
			view.inputTXT.removeEventListener(KeyboardEvent.KEY_DOWN,inputTXTKeyDownHandler);
			LayoutToolUtils.holder = null;
			prepareVO = null;
				
			sendNotification(CoreConst.SOUND_STOP);
			view.removeChildren();
			if(facade.hasMediator(EduAlertMediator.NAME)){
				sendNotification(WorldConst.REMOVE_POPUP_SCREEN,(facade.retrieveMediator(EduAlertMediator.NAME) as EduAlertMediator));
			}
			super.onRemove();			
		}
		
		override public function onRegister():void{	
//			SoundAS.loadSound(MyUtils.getSoundPath("wordRight.mp3"),"wordRight");	
			sendNotification(CoreConst.LOAD_EFFECT_SOUND,new LoadSoundEffectVO(MyUtils.getSoundPath("wordRight.mp3"),"wordRight"));

			
			view.appleTXT.text = String(totalNum);			
			view.inputTXT.setFocus();
			view.inputTXT.addEventListener(KeyboardEvent.KEY_DOWN,inputTXTKeyDownHandler);
			
			DealNextData();
			
			startTime = getTimeFormat();
			startSSS = getTimer();
			
			TweenLite.delayedCall(delayTime,quit);//三分钟后退出			
			Global.stage.addEventListener(MouseEvent.MOUSE_DOWN,stageMouseDownHandler);
			
		}
		
		private function stageMouseDownHandler(event:MouseEvent):void
		{
			sendNotification(CoreConst.FLOW_RECORD,new RecordVO("stageMouseDownHandler","WordLearningTxtMediator",0));

			TweenLite.killDelayedCallsTo(quit);
			TweenLite.delayedCall(delayTime,quit);//三分钟后退出
			
		}
		
		private function changInputHandler():void{
//			sendNotification(CoreConst.FLOW_RECORD,new RecordVO("changInputHandler","WordLearningTxtMediator",0));

			if(view.inputTXT.useKeyboard){
				view.inputTXT.useKeyboard = false;
				view.inputTXT.needsSoftKeyboard = true;
				view.inputTXT.requestSoftKeyboard();
				//view.changeInput.label = "切换两侧键盘";
				view.inputTXT.setFocus();;
			}else{
				view.inputTXT.useKeyboard = true;
				view.inputTXT.needsSoftKeyboard = false;
				//view.changeInput.label = "切换系统键盘";
				TweenLite.killDelayedCallsTo(changeFocus);
				TweenLite.delayedCall(0.5,changeFocus);			
			}
			
		}
		
		private function changeFocus():void
		{
			view.inputTXT.setFocus();
		}

		
		/**--------三分钟未输入则退出---------------*/
		protected function quit():void{
			view.inputTXT.removeEventListener(KeyboardEvent.KEY_DOWN,inputTXTKeyDownHandler);
			if(isStart && !subMitSucced){
				sendNotification(WordLearningTXTMediator.yesAbandonHandler);
			}else{		
				if(!subMitSucced){					
					quitPopScreen();
				}
			}
		}
		
		protected function quitPopScreen():void{			
			TweenLite.killDelayedCallsTo(quitPopScreen);
			if(!Global.isLoading){			
				sendNotification(WorldConst.POP_SCREEN);			
			}else{
				TweenLite.delayedCall(1,quitPopScreen);
			}
//			TweenLite.delayedCall(2,quitSuccessHandler);
		}
		
//		private function quitSuccessHandler():void{
//			if(!quiteSuccess){//退出失败则反复继续退出。知道彻底退出为之
//				quitPopScreen();
//			}
//		}
		
		private function getTimeFormat():String {			
			var dateFormatter:DateTimeFormatter = new DateTimeFormatter("en-US");			
			dateFormatter.setDateTimePattern("yyyyMMdd-HHmmss");
			return dateFormatter.format(Global.nowDate);		
			
			
		}
		
		/**--------------------------------执行逻辑-------------------------------------------*/
		//初始单词，只有进入和答对的状态下才进入
		private function DealNextData():void {
//			sendNotification(CoreConst.FLOW_RECORD,new RecordVO("DealNextData","WordLearningTxtMediator",0));

			view.inputTXT.addEventListener(KeyboardEvent.KEY_DOWN,inputTXTKeyDownHandler);
			if(currentIndex < 0) {
				currentIndex = 0;
			} else if(currentIndex > totalItems) {
				currentIndex = totalItems;
			}		
			if(dataSetArr && dataSetArr.length>0 && dataSetArr[currentIndex]){
				currentWordVO = dataSetArr[currentIndex];
				
				view.wrongTXT.text = "";
				view.wordTXT.text = "";
				view.symbolTXT.text = "";
				view.chineseTXT.text = "";
				selectMode(currentWordVO.grpcode);//执行类型
				appleEnable = true;	
			}
					
		}
		protected function selectMode(lw:String):void {	
//			sendNotification(CoreConst.FLOW_RECORD,new RecordVO("selectMode "+lw,"WordLearningTxtMediator",0));

			switch(lw) {
				case "LEA01":	//后台提示语言
					//sendNotification(WorldConst.WL_LEFT_TOP_MESG_TIP,currentWordVO.wordstr);//告示牌提示
					if(currentWordVO.wordstr.indexOf("中")!=-1){
						view.ZHONG_TIP.visible = true;
						view.EN_TIP.visible = false;
						sendNotification(WorldConst.SHOW_CHANGEINPUTBUTTON);
						sendNotification(SoftKeyBoardConst.USE_KEYBOARD_CHINESE);//切换中文键盘
					}else{
						view.ZHONG_TIP.visible = false;
						view.EN_TIP.visible = true;
					}
					//appleNum++;
					currentIndex++;
					DealNextData();
					break;
				case "LE001"://初始学习
					currentWord = currentWordVO.wordstr
					controlTxtShow("学习单词阶段",currentWordVO.wordstr,currentWordVO.soundmark,currentWordVO.meanbasic);
					break;
				case "LE002"://回忆英文,英文延迟显示
					currentWord = currentWordVO.wordstr;
					controlTxtShow("回忆英文阶段","",currentWordVO.soundmark,currentWordVO.meanbasic);
					break;
				case "LE003"://回忆中文，中文延迟显示
					currentWord = "";
					controlTxtShow("回忆中文阶段",currentWordVO.wordstr,currentWordVO.soundmark,"");
					TweenLite.delayedCall(0.5,insertChinese,[currentWordVO.mean]);
					break;
				case "LE004"://复习状态，输入错误才显示英文
					currentWord = currentWordVO.wordstr;
					controlTxtShow("复习英文阶段","",currentWordVO.soundmark,currentWordVO.meanbasic);
					break;
				case "LE005"://复习状态，输入错误才显示中文
					currentWord = "";
					controlTxtShow("复习中文阶段",currentWordVO.wordstr,currentWordVO.soundmark,"");
					TweenLite.delayedCall(0.5,insertChinese,[currentWordVO.mean]);
					break;
				case "LE006"://考核状态，输入错误才显示英文
					currentWord = currentWordVO.wordstr;
					view.symbolTXT.visible = false;
					controlTxtShow("考核英文阶段","",currentWordVO.soundmark,currentWordVO.meanbasic);
					break;
				case "LE007"://考核状态，输入错误才显示中文
					currentWord = "";
					controlTxtShow("考核中文阶段",currentWordVO.wordstr,currentWordVO.soundmark,"");
					TweenLite.delayedCall(0.5,insertChinese,[currentWordVO.mean]);
					break;
				case "LE000"://浏览单词,"非任务学习！！！"
					controlTxtShow("非任务学习！！！",currentWordVO.wordstr,currentWordVO.soundmark,currentWordVO.meanbasic);
					break;				
				case "LE101"://浏览英文
					controlTxtShow("浏览状态",currentWordVO.wordstr,currentWordVO.soundmark,currentWordVO.meanbasic);
					break;
				case "LE102"://浏览中文.
					controlTxtShow("浏览状态",currentWordVO.wordstr,currentWordVO.soundmark,currentWordVO.meanbasic);
					break;
				case "FINW"://完成学习	
					if(state==1 && !CompleteWrong){//有错题并且没有完成
						dataSetArr.push(currentWordVO);//错题集整合起来
						var items:ItemVO = itemArray[currentIndex] as ItemVO;
						itemArray.push(items);					
						sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n下面是错题温习，请继续答题!",false,yesHandler));//提交订单
					}else{
						sendNotification(SoftKeyBoardConst.HIDE_SOFTKEYBOARD);
						sendNotification(yesHandler);
					}
					/**---------错题收集---------*/					
					break;
			}			
		}
		/**---------------------插入中文模糊匹配-------------------*/
		private function insertChinese(chinese:String):void{
			var str:String = StringUtil.trim(chinese);
			if(str.length>=3){				
				var arr:Array = str.substr(1,str.length-2).split("][");
				var rArr:Array = arr.filter(doEach);
				function doEach(obj:String,idx:int,ownarr:Array):Boolean{
					if(obj.length>6 || obj.length<1) return false;						
					else return true;				
				}
				sendNotification(SoftKeyBoardConst.INSERT_CHINESE,rArr);//传入键盘中文输入
			}			
		}
		/**
		 *文本处理,显示下方单词的提示 
		 * @param title			标题
		 * @param word			单词,
		 * @param symbol		音标
		 * @param chinese		汉意
		 */		
		protected function controlTxtShow(title:String,word:*,symbol:String,chinese:*):void{		
			view.BOTTOM_TIP.text = title;
			view.wordTXT.text = word;
			view.symbolTXT.text = MyUtils.toSpell(symbol);
			view.chineseTXT.text = chinese.replace(/\^+/g,"\n");		
			Facade.getInstance(CoreConst.CORE).sendNotification(AppleTreeMediator.SHAKE_LAST_ONE);//摇苹果
			playWordSound();
		}
		
		/**--------------------------------键盘事件 1-------------------------------------------*/
		private function inputTXTKeyDownHandler(e:KeyboardEvent):void {

			TweenLite.killDelayedCallsTo(quit);
			TweenLite.delayedCall(delayTime,quit);//三分钟后退出
			if(e.keyCode == 13) {//回车				
//				sendNotification(CoreConst.FLOW_RECORD,new RecordVO("inputTXTKeyDownHandler enter","WordLearningTxtMediator",0));
				e.preventDefault();
				e.stopImmediatePropagation();
				if(currentIndex < totalItems) {
//					trace("回车进入",currentIndex);
					if(currentWordVO) {												
						var str:String = view.inputTXT.text;
						str = StringUtil.trim(str).toLowerCase();//去除单词前后的空格,并减小
						//str = str.replace(/\./g,"");
						str = str.replace(/。/g,"");
						str = str.replace(/\s/g,"");
						str = str.replace(/…/g,"");
						str = str.replace(/\([^\)]+\)/g,'');
						str = str.replace(/-/g,"");
						if(str == "") {//如果是空												
							return;
						}
						if(view.BOTTOM_TIP.text=="回忆中文阶段" || view.BOTTOM_TIP.text=="复习中文阶段" || view.BOTTOM_TIP.text=="考核中文阶段"){
							var reg:RegExp = /[a-z]/;
							if(reg.test(str)){
								view.inputTXT.text="";
								//trace("包含英文");
								sendNotification(WorldConst.ZHONGWEN_TIP);
								return;
							}
						}else{
							reg =  /[\一-\龥]/;
							if(reg.test(str)){
								view.inputTXT.text="";
								//trace("包含中文");
								sendNotification(WorldConst.YINGWEN_TIP);
								return;
							}
						}
						//str = str.replace(/\s+/g," ");//把连续两个以上的空格变成一个空格
																		
						checkingWord(str);
					
					}
				}else{
//					trace("回车进下一题入",currentIndex);
					DealNextData();
				}
				
				
			}			
		}
		
		
		/**-------------------------------检查单词对错，根据对错掉落苹果-------------------------------------------*/
		private var flagWhole:int=0;//标记，该单词是否已提示过（0为没提示过）
		private function checkingWord(str:String):void {	
//			sendNotification(CoreConst.FLOW_RECORD,new RecordVO("checkingWord","WordLearningTxtMediator",0));

			
			isStart = true;
			
			var item:ItemVO = itemArray[currentIndex] as ItemVO;			
			var returnV:int;
			if(currentWordVO.grpcode != "LE003" && currentWordVO.grpcode != "LE005" && currentWordVO.grpcode != "LE007" && currentWordVO.grpcode != "LE102") {
				var standardStr:String = StringUtil.trim(currentWordVO.wordstr);//英文
				standardStr = standardStr.toLocaleLowerCase().replace(/\s/g,"");
				standardStr = standardStr.replace(/-/g,"");
//				returnV = standardStr==str ? 0 : -1;
				if(standardStr==str || EnglishAnalyze.check(str,standardStr)){//判定英式或美式都算对
					returnV = 0;
				}else{
					returnV = -1;
				}
				//做判断，当最后一个字母漏到输入的时候
				if(returnV==-1){
					if(str.length == standardStr.length-1 && standardStr.length>0){
						if(str == standardStr.substring(0,standardStr.length-1)){
							if(flagWhole==0){	
								flagWhole = 1;
								sendNotification(CoreConst.TOAST,new ToastVO("请注意单词完整性"));
								return;
							}							
						}
					}
				}
				temStr = str;
				flagWhole = 0;
			}else{//中文
				var temStr:String = str.replace(/\./g,"");
				var mean:String = currentWordVO.mean;
				/*if(mean.indexOf('的]')!=-1){
					mean = mean.replace(/的]/g,']');
				}else if(mean.indexOf('地]')!=-1){
					mean = mean.replace(/地]/g,']');
				}*/
				returnV = mean.indexOf("[" + temStr + "]");//of 的意思就是的
				if(returnV != -1 && temStr.length>0){
					
				}else{					
					mean = mean.replace(/([的]]|[地]])/g,']');
	
					returnV = mean.indexOf("[" + temStr + "]");
					if(returnV == -1){
						if(temStr.length > 1) {//去除中文"的”、"地“
							if(temStr.charAt(temStr.length - 1) == "的" || temStr.charAt(temStr.length - 1) == "地") {
								temStr = temStr.substr(0,temStr.length - 1);
								returnV = mean.indexOf("[" + temStr + "]");
							}
						}					
					}
				}
			}
			if(returnV!=-1 && temStr.length>0){//如果正确
//				SoundAS.play("wordRight",0.3);
				sendNotification(CoreConst.PLAY_EFFECT_SOUND,new PlaySoundEffectVO("wordRight",0.3));

				
				sendNotification(WorldConst.WL_YESRIGHT);
				//appleNum = appleNum-currentIndex-1;
				appleNum -= 1;
				if(appleNum<0) appleNum = 0;
				view.appleTXT.text = String(appleNum);
				if(!item.isCheck) {					
					item.isCheck = true;
					item.userAnswer =str;
					item.standardAnswer = currentWordVO.wordstr;
					item.ROE = "R";						
				}					
				currentIndex++;
				TweenLite.killTweensOf(DealNextData);
				TweenLite.delayedCall(0.3,DealNextData);
				view.inputTXT.removeEventListener(KeyboardEvent.KEY_DOWN,inputTXTKeyDownHandler);
//				trace('回答正确');
			}else{//错误
				if(!item.isCheck) {
					item.isCheck = true;
					item.userAnswer = str;
					item.standardAnswer = currentWordVO.wordstr;
					item.ROE = "E";
					
					/**---------错题收集---------*/
					state = 1;//有错题任务
					dataSetArr.push(currentWordVO);//错题集整合起来
					var items:ItemVO = itemArray[currentIndex] as ItemVO;
					itemArray.push(items);
				}
				view.wrongTXT.text = view.inputTXT.text;
				view.inputTXT.text = "";
				if(view.wordTXT.text==""){//如果第一次打错则显示答案
					view.wordTXT.text = currentWordVO.wordstr;
				}else if(view.chineseTXT.text==""){
					view.chineseTXT.text = currentWordVO.meanbasic.replace(/\^+/g,"\n");
				}
				
			}
			if(appleEnable){
				appleEnable = false;
				if(!CompleteWrong){//如果开始错题CompleteWrong==true，则不执行算术判断
					if(returnV!=-1){//正确
						//rightNum++;//答对加一个
						//view.appleTXT.text = String(rightNum);
						sendNotification(AppleTreeMediator.DROP_CURRENT,false);			
					}else{
						//errorNum++;
						sendNotification(AppleTreeMediator.DROP_CURRENT,true);		
					}
				}
									
			}
			
			times = 1;//回复
			view.inputTXT.text = "";
			
			
			
//			sendNotification(CoreConst.FLOW_RECORD,new RecordVO("checkingWord end","WordLearningTxtMediator",0));

		}		
		/**-------------------------------播放单词三遍----------------------------------*/
		private function playWordSound(e:MouseEvent = null):void {
			var fileName:String = "edu/mp3/ESOUND_" + currentWordVO.fileLetter + ".mp3"
			var wordSoundVO:SoundVO = new SoundVO(fileName,currentWordVO.starttime,currentWordVO.durtime,3,null,soundVolume);
//			if(!wordSoundVO) {
//			} else {				
//				wordSoundVO.curLoopTime = 0;
//				wordSoundVO.loop = 3;
//				wordSoundVO.url = fileName;
//				wordSoundVO.position = currentWordVO.starttime;
//				wordSoundVO.duration = currentWordVO.durtime;	
//				wordSoundVO.initVolume = soundVolume;
//				
//			}
			sendNotification(CoreConst.SOUND_PLAY,wordSoundVO);
		}
				
		public function get wrongNum():int{
			var wrongNum:int = 0;
			var arr:Array = [];
			var item:ItemVO;
			for(var i:int = 0;i < itemArray.length;i++) {
				item = itemArray[i];
				if(item){					
					if(item.isWord && item.ROE == "E" && item.isCheck) {
						if(arr.indexOf(item.wordId) == -1) {
							arr.push(item.wordId);
						}
					}							
				}
			}
			wrongNum = arr.length;
			return wrongNum;
		}
		
		/**------------------------------------数据反馈与读取--------------------------------------------------*/
		protected var item:ItemVO;
		private var subMitSucced:Boolean;
		override public function handleNotification(notification:INotification):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("handleNotification "+notification.getName(),"WordLearningTxtMediator",0));

			switch(notification.getName()) {
				case WorldConst.CHANGE_INPUT:
					changInputHandler();
					break;
				case yesAbandonHandler:
					if(!Global.isLoading && isStart && !subMitSucced){
						view.inputTXT.removeEventListener(KeyboardEvent.KEY_DOWN,inputTXTKeyDownHandler);
						totlaTime = (getTimer()-startSSS)*0.001;		
						var wrongNum:int = this.wrongNum;
						rightNum = totalNum- appleNum - wrongNum;
						if(rightNum<0) rightNum=0;
						subMitSucced = true;
						PackData.app.CmdIStr[0] = CmdStr.Abandon_Task_YYWord;
						PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
						PackData.app.CmdIStr[2] = dataSetArr[0].rrl;
						PackData.app.CmdIStr[3] =String(int(totlaTime));
						PackData.app.CmdIStr[4] = String(rightNum); //学习正确数
						PackData.app.CmdIStr[5] = String(wrongNum); //学习错误数
						PackData.app.CmdIStr[6] = String(totalNum); //学习总数
						PackData.app.CmdIStr[7] = countNum(false).toString(); //错误单词
						PackData.app.CmdIStr[8] = countNum(true).toString(); //正确单词
						PackData.app.CmdIStr[9] = startTime; //开始学习时间(YYYYMMDD-hhnnss)；
						PackData.app.CmdIStr[10] = getTimeFormat(); //结束学习时间(YYYYMMDD-hhnnss)；
						PackData.app.CmdIStr[11] = AbandonGetStatistics(); //放弃统计结果
						PackData.app.CmdInCnt = 12;	
						sendNotification(CoreConst.SEND_11,new SendCommandVO(QUIT_POP));
						TweenLite.killDelayedCallsTo(quit);
						TweenLite.killTweensOf(DealNextData);
					}else{
						if(!isStart){
							quit();
						}
					}
					break;
				
				case WorldConst.WL_PLAYSOUND:
					this.playWordSound();
					break;
				case yesHandler:	
					if((CompleteWrong || state==0) && !subMitSucced){//如果完成错题集或者没有错题
//						trace("提交结果");
						subMitSucced = true;
						view.inputTXT.removeEventListener(KeyboardEvent.KEY_DOWN,inputTXTKeyDownHandler);
						totlaTime = (getTimer()-startSSS)*0.001;	
						rightNum = 0;
						for(var i:int=0;i < itemArray.length;i++) {	
							item = itemArray[i] as ItemVO;
							if(item){								
								if(item.isWord && item.ROE == "R") rightNum++;																								
							}
						}						
						isStart = false;
						PackData.app.CmdIStr[0] = CmdStr.SUBMIT_ONE_TASK;
						PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
						PackData.app.CmdIStr[2] = dataSetArr[0].rrl;
						PackData.app.CmdIStr[3] =String(int(totlaTime));
						PackData.app.CmdIStr[4] = String(rightNum); //学习正确数
						PackData.app.CmdIStr[5] = String(totalNum-rightNum); //学习错误数
						PackData.app.CmdIStr[6] = String(totalNum); //学习总数
						PackData.app.CmdIStr[7] = countNum(false).toString(); //错误单词
						PackData.app.CmdIStr[8] = countNum(true).toString(); //正确单词
						PackData.app.CmdIStr[9] = startTime; //开始学习时间(YYYYMMDD-hhnnss)；
						PackData.app.CmdIStr[10] = getTimeFormat(); //结束学习时间(YYYYMMDD-hhnnss)；
						PackData.app.CmdIStr[11] = getStatistics(); //统计结果
						PackData.app.CmdInCnt = 12;												
						//}					
						sendNotification(CoreConst.SEND_11,new SendCommandVO(sendStudyState));
						sendNotification(WorldConst.UPDATE_TASK_DATA,new UpdateTaskDataVO('yy.W',dataSetArr[0].rrl,'Z',int(rightNum/totalNum*100).toString()));
						TweenLite.killDelayedCallsTo(quit);
						TweenLite.killTweensOf(DealNextData);
					}else{//有错题则继续
//						trace("继续下一题");
						if(!subMitSucced){							
							CompleteWrong = true;
							totalItems = dataSetArr.length-1;
							currentIndex++;
							view.inputTXT.setFocus();
							DealNextData();
						}
					}							
					break;
				case QUIT_POP:
					quitPopScreen();
					break;
				case sendStudyState:					
					if((PackData.app.CmdOStr[0] as String)=="000"){
						dataArr = PackData.app.CmdOStr.concat();				
						intoRewardView();
					}else if((PackData.app.CmdOStr[0] as String).charAt(0)=="M"){//出错退出
						sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n抱歉,提交结果失败!\n请按确定退出!",false,QUIT_POP));//提交订单
					}
								
					break;	
				case WorldConst.WL_QUESTION_TIP://给出单词部分提示
					if(view.BOTTOM_TIP.text != "学习单词阶段" && view.BOTTOM_TIP.text != "回忆英文阶段" && view.BOTTOM_TIP.text != "回忆中文阶段"){
						item = itemArray[currentIndex] as ItemVO;
						item.isCheck = true;
						item.userAnswer = "";
						item.standardAnswer = currentWordVO.wordstr;
						item.ROE = "E";						
					}
					if(times<=3){						
						this.showTips(view.wrongTXT,currentWord,times);
						times++;
					}else{
						times = 3;
					}
					break;
				case WorldConst.GET_SCREEN_FAQ:
					var str:String = "学单词界面/"+"当前单词:"+currentWordVO.wordstr;
					sendNotification(WorldConst.SET_SCREENT_FAQ,str);
					break;
				case CoreConst.DEACTIVATE:
					duration = getTimer();
					break;
				case CoreConst.ACTIVATE:
					if(duration==0) return;
					if((getTimer() - duration)*0.001>delayTime && !subMitSucced){
						TweenLite.killDelayedCallsTo(quit);
						quit();
					}
					break;
				
				

			}					
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("handleNotification end","WordLearningTxtMediator",0));
		}
		private var duration:int = 0;
		
		
		override public function listNotificationInterests():Array{
			return [CoreConst.ACTIVATE,CoreConst.DEACTIVATE,WorldConst.GET_SCREEN_FAQ,WorldConst.CHANGE_INPUT,yesHandler,yesAbandonHandler,sendStudyState,WorldConst.WL_QUESTION_TIP,WorldConst.WL_PLAYSOUND,QUIT_POP];
		}
		private function countNum(b:Boolean):Array {
			var arr:Array = [];
			var item:ItemVO;
			for(var i:int = 0;i < itemArray.length;i++) {
				item = itemArray[i] as ItemVO;
				if(b) {
					if(item.isWord && item.ROE == "R") {
						if(arr.indexOf(item.wordId) == -1) {
							arr.push(item.wordId);
						}
					}
				} else {
					if(item.isWord && item.ROE == "E") {
						if(arr.indexOf(item.wordId) == -1) {
							arr.push(item.wordId);
						}
					}
				}
			}
			return arr;
		}
		private function getStatistics():String {	
			var item:ItemVO, str:String = "", arr:Array = [];
			for(var i:int = 0;i < itemArray.length;i++) {
				item = itemArray[i] as ItemVO;
				if(item.isWord) {
					if(arr.indexOf(item.wordId) == -1) {
						arr.push(item.wordId);
						str += "IDS`" + item.wordId + "`" + item.ROE + "`" + item.userAnswer + "`" + item.standardAnswer + "\n";
					}
				}
			}
			for(i = 0;i < dataSetArr.length;i++) {
				var word:WordVO = dataSetArr[i] as WordVO;
				if(word) {
					if(word.grpcode == "LE001" || word.grpcode == "LE002" || word.grpcode == "LE003") {
						return "";
					}
				}
			}
			return str;
		}
		
		private function AbandonGetStatistics():String {	
			var item:ItemVO, str:String = "", arr:Array = [];
			for(var i:int = 0;i < itemArray.length;i++) {
				item = itemArray[i] as ItemVO;
				if(item.isWord) {
					if(arr.indexOf(item.wordId) == -1) {
						arr.push(item.wordId);
						str += "IDS`" + item.wordId + "`" + item.ROE + "`" + item.userAnswer + "`" + item.standardAnswer + "\n";
					}
				}
			}
			return str;
		}
		
		private function intoRewardView():void{
			var initialTxt:String = dataArr[3];
			var m:int = initialTxt.indexOf("<PAGE1"+">");
			var temp:int = initialTxt.indexOf("advancedPrint:",m);
			var j:int = initialTxt.indexOf("\n",temp);			
			var textArr:Array = initialTxt.substring(temp+14,j).split("`");//目标文本包含设置、答案提示
			//trace("金币数 = "+String(textArr[10]).match(/\d+/));
			var data:Object = {right:String(rightNum),wrong:String(totalNum-rightNum),gold:String(textArr[10]).match(/\d+/),time:String(int(totlaTime)),rrl:dataArr[1],oralid:dataArr[2]};
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(RewardViewMediator,data),new SwitchScreenVO(CleanCpuMediator)]);//奖励界面
		}
		
		/**
		 *给提示，每次提示一点，三次之后给出完整答案
		 * @param str	 文本框
		 * @param delay	 第几次提示	
		 * 
		 */		
		public function showTips(textfield:TextField,str:String,delay:int):void{
			if(str=="") return;
			var len:int = str.length;
			var tlen:int = int(len/3);
			if(tlen==0) textfield.text = str;//如果少于3个字母直接给提示好了
			var mode:int = len%3;//商
			var _str:String="";			
			if(delay<3){
				for(var i:int=0;i<len;i++){
					_str+="_";
				}
				textfield.text = _str;
				textfield.replaceText(0,delay*tlen ,str.substr(0,delay*tlen));
			}else{
				textfield.text = str;
			}						
		}		
				
		public function get view():WordLearningTXTView{
			return getViewComponent() as WordLearningTXTView;
		}
		override public function get viewClass():Class{
			return WordLearningTXTView;
		}
		override public function prepare(vo:SwitchScreenVO):void{
			prepareVO = vo;

			dataSetArr = vo.data as Array;
			dataSetArr = dataSetArr.slice();
			var item:ItemVO;
			var word:WordVO;
			for(var i:int = 0;i < dataSetArr.length;i++) {
				item = new ItemVO(i);
				word = dataSetArr[i] as WordVO;
				if(word.grpcode == "LEA01" || word.grpcode == "FINW") {
					item.isWord = false;
				} else {
					totalNum++;
					item.isWord = true;
					if(word.grpcode == "LE001" || word.grpcode == "LE002" || word.grpcode == "LE003") {
						item.isCheck = true;
						item.ROE = "R";
						item.userAnswer = "";
					} else {
						item.ROE = "E";
					}
					item.standardAnswer = word.wordstr;//这个新加。测试通过后可以删除其他命令
				}							
				item.wordId = String(word.wordid);
				itemArray.push(item);							
			}	
			appleNum = totalNum;
			totalItems = dataSetArr.length - 1;
			Facade.getInstance(CoreConst.CORE).sendNotification(WordLearningBGMediator.APPLE_EVENT,totalNum);
			//第以前进来过页面
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,prepareVO);
		}
	}
}