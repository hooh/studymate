package com.studyMate.module.engLearn
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.engLearn.ui.AlertShowExerciseTipMediator;
	import com.studyMate.module.engLearn.ui.ExamQuestionUI;
	import com.studyMate.module.engLearn.vo.ExercisesVO;
	import com.studyMate.module.engLearn.vo.JudgeExercise;
	import com.studyMate.utils.MyUtils;
	import myLib.myTextBase.utils.SoftKeyBoardConst;
	import com.studyMate.world.controller.vo.UpdateTaskDataVO;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.model.vo.LoadSoundEffectVO;
	import com.studyMate.world.model.vo.PlaySoundEffectVO;
	import com.studyMate.world.screens.CleanCpuMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	import mx.utils.StringUtil;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.events.Event;
	
	
	internal class ExercisesLearnMediator extends EgLearnBaseMediator
	{
		
		public static const NAME:String = 'ExercisesLearnMediator';
		private var prepareVO:SwitchScreenVO;
		private const GET_ID_Arr:String = NAME + "getIdArr";//获取id串
		private const GET_INFO_Arr:String = NAME + "getInfoArr";
		private const SUBMIT_TASK:String = NAME + "submit";
		private const YES_QUIT:String = NAME + "yesquit";
		private const Abandon_Exercice:String = NAME + "Abandon_Exercice";
		
		private var isFirst:Boolean;		
		private var idStr:String;
		private var infoVec:Vector.<ExercisesVO>;//所有习题基本信息
		private var errorVec:Vector.<ExercisesVO>;//习题错题
		private var rrl:String;
		
		private var curExerciseVo:ExercisesVO;
		private var questionNum:int=0; 			//题号
		private var total:int;					//总题数量
		private var count:int = 0; 				//答题次数	
		private var errorTotal:int;				//错题总数
		private var errorQuestionNum:int = 0;	//错题序号
		
				
		private var startTime:String;
		private var startSS:Number;		
		private var right:int;
		private var wrong:int;
		private var costTime:String;
		
		private var isStartWrong:Boolean;//开始了并且有错题。则放弃要扣除金币
		
		private var examQuestionUI:ExamQuestionUI;
		
		
		public function ExercisesLearnMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRemove():void
		{
			sendNotification(CoreConst.REMOVE_EFFECT_SOUND,'wordRight');
			sendNotification(CoreConst.REMOVE_EFFECT_SOUND,'wordError');
			TweenLite.killDelayedCallsTo(nextQuestion);
			TweenLite.killDelayedCallsTo(quit);
			TweenMax.killTweensOf(view.yesRightImg);
			view.input.removeEventListener(KeyboardEvent.KEY_DOWN,inputKeyDownHandler);
			view.input.removeEventListener(FocusEvent.FOCUS_IN,fosInHandler);
			if(examQuestionUI){
				examQuestionUI.dispose();
				examQuestionUI = null;
			}
			errorVec.length = 0;
			errorVec = null;
			infoVec.length = 0;
			infoVec = null;
			super.onRemove();
		}
		override public function onRegister():void
		{			
			super.onRegister();
			view.init();
			startTime = MyUtils.getTimeFormat();
			startSS = getTimer();
			errorVec = new Vector.<ExercisesVO>();
			
			sendNotification(CoreConst.LOAD_EFFECT_SOUND,new LoadSoundEffectVO(MyUtils.getSoundPath("wordRight.mp3"),"wordRight"));
			sendNotification(CoreConst.LOAD_EFFECT_SOUND,new LoadSoundEffectVO(MyUtils.getSoundPath("Errortip.mp3"),"wordError"));

			view.unknownBtn.addEventListener(Event.TRIGGERED,unkonwHandler);
			nextQuestion();
			this.backHandle = function():void{
				if(isStartWrong ){			
					sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n要放弃该阶段任务吗？\n\n放弃会根据错题数扣除金币。",true,Abandon_Exercice));//提交订单
				}else{
					sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n确定退出习题任务吗？",true,YES_QUIT));//提交订单
				}
			};
			
			view.input.addEventListener(FocusEvent.FOCUS_IN,fosInHandler);
		}
		
		protected function fosInHandler(event:FocusEvent):void
		{
			if(curExerciseVo){				
				selectKeyboard(curExerciseVo.answer);
			}
		}		

		protected function inputKeyDownHandler(event:KeyboardEvent):void{			
			if(event.keyCode == Keyboard.ENTER && view.input.text!=''){
				checkAnswer();				
			}
		}		
		
		private function checkAnswer():void{
			var userAnswer:String = view.input.text.replace(/\s/g,'');
			if(userAnswer == '') return;
			
			var resultBoo:Boolean = JudgeExercise.checkAnswer(userAnswer,curExerciseVo.answer);
			userAnswer = StringUtil.trim(view.input.text);
			if(resultBoo){
				checkRight(userAnswer);
			}else{		
				isStartWrong = true;
				checkWrong(userAnswer);
				view.input.selectTextRange(0,view.input.text.length);
			}			
		}
		//答对流程 一
		private function checkRight(userAnswer:String):void{
			view.touchable = false;
			if(!curExerciseVo.isChecked){						
				curExerciseVo.isChecked = true;
				curExerciseVo.ROE = 'R';
				curExerciseVo.userAnswer = userAnswer;
			}
			sendNotification(CoreConst.PLAY_EFFECT_SOUND,new PlaySoundEffectVO("wordRight",0.7));
			view.input.removeEventListener(KeyboardEvent.KEY_DOWN,inputKeyDownHandler);//暂时禁止用户回答，直到下一题出现才恢复输入
			TweenLite.killDelayedCallsTo(nextQuestion);
			TweenLite.delayedCall(0.6,nextQuestion);
			TweenMax.killTweensOf(view.yesRightImg);
			view.yesRightImg.alpha = 0;
			TweenMax.to(view.yesRightImg,0.5,{alpha:1,yoyo:true,repeat:1,ease:Quint.easeOut});
		}
		//答错流程 二
		private var errorStr:String = '';
		private function checkWrong(userAnswer:String):void{
			if(errorStr == userAnswer) return;			
			errorStr = userAnswer;
			count++;
			if(!curExerciseVo.isChecked){						
				curExerciseVo.isChecked = true;
				curExerciseVo.ROE = 'E';								
				curExerciseVo.userAnswer = userAnswer;
			}
			switch(count){
				case 1:
//					trace('提示1');
					if(errorQuestionNum==0){
						errorVec.push(curExerciseVo);						
					}
					if(curExerciseVo.help_1 != ''){
						view.showTip();							
						view.tipTxt.text = curExerciseVo.help_1;																
					}
					sendNotification(CoreConst.PLAY_EFFECT_SOUND,new PlaySoundEffectVO("wordError",0.7));
					break;
				case 2:
//					trace('提示2');
					view.showTip();
					if(curExerciseVo.help_2 != ''){
						view.tipTxt.text = '正确答案: [' + curExerciseVo.answer + ']\n' + curExerciseVo.help_2;
					}else{
						view.tipTxt.text = '正确答案: [' + curExerciseVo.answer + ']'
					}
					sendNotification(CoreConst.PLAY_EFFECT_SOUND,new PlaySoundEffectVO("wordError",0.7));
					break;
				case 3:
//					trace("提示3");
					sendNotification(CoreConst.PLAY_EFFECT_SOUND,new PlaySoundEffectVO("wordError",0.7));
					break;
				case 4:
//					trace("提示4");
					nextQuestion();
					break;
			}
		}
		//放弃流程 三
		private function unkonwHandler():void{
			view.hideTip();
			if(facade.hasMediator(AlertShowExerciseTipMediator.NAME)) return;
			view.input.mouseEnabled = false;
			sendNotification(SoftKeyBoardConst.HIDE_SOFTKEYBOARD);
			var str:String ='';
			if(curExerciseVo.detail!=''){
				str = '正确答案: [' + curExerciseVo.answer + ']\n' + curExerciseVo.detail;				
			}else{
				str ='正确答案: [' + curExerciseVo.answer + ']'+ '\n抱歉,该题暂时没有详解。\n系统将通知相关专家尽快完成该详解。'
			}
			
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(AlertShowExerciseTipMediator,str,SwitchScreenType.SHOW,null)]);

		}
						
		//跳入下一题流程		
		private function nextQuestion():void{
			view.input.text = '';
			count = 0;
			if(questionNum<infoVec.length){				
				questionNum++;
				curExerciseVo = infoVec[questionNum-1];
				view.titleNumTxt0.text = questionNum+' /';
				view.titleNumTxt.text = String(total);
				this.readingQuestion();
				
			}else if( errorQuestionNum <errorVec.length){
				if(errorQuestionNum == 0){
					sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n下面是错题温习，请继续答题!",false));//提交订单
				}
				errorQuestionNum++;
				curExerciseVo = errorVec[errorQuestionNum-1];
				view.titleNumTxt0.text = errorQuestionNum+' /'
//				view.titleNumTxt.text = errorQuestionNum+'/'+errorVec.length;
				this.readingQuestion();				
			}else{
				if(!isSubmit){
					isSubmit = true;
					submit();
				}
			}
		}
		//准备题目
		private function readingQuestion():void{
			view.touchable = true;
			if(examQuestionUI){
				examQuestionUI.removeFromParent(true);
			}
			view.hideTip();//隐藏提示框
			view.tipTxt.text = '';			
			examQuestionUI = new ExamQuestionUI(curExerciseVo.question,curExerciseVo.items);
			view.addChild(examQuestionUI);
			view.idTxt.text = 'id:'+curExerciseVo.id;			
			selectKeyboard(curExerciseVo.answer);	
			view.unknownBtn.addEventListener(Event.TRIGGERED,unkonwHandler);
			view.input.addEventListener(KeyboardEvent.KEY_DOWN,inputKeyDownHandler); // 下一题出现的时候 恢复单击事件
			view.input.setFocus();
		}
		
		//提交结果
		private function submit():void{
			view.input.removeEventListener(KeyboardEvent.KEY_DOWN,inputKeyDownHandler);//暂时禁止用户回答
			right = 0;	
			wrong = 0;
			var wrongVec:Vector.<String> = new Vector.<String>;
			var rightVec:Vector.<String> = new Vector.<String>;
			var infoVec:Vector.<ExercisesVO> = this.infoVec.concat();
			var result:String=' ';
			for(var i:int=0;i<infoVec.length;i++){
				if(infoVec[i].ROE == 'R'){
					right++;
					rightVec.push(infoVec[i].id);
				}else if(infoVec[i].ROE == 'E'){
					wrong++
					wrongVec.push(infoVec[i].id);
				}else if((infoVec[i].ROE == 'N')){
					wrongVec.push(infoVec[i].id);
				}
				result += "IDS`"+i+"`"+infoVec[i].ROE+"`"+infoVec[i].userAnswer+"`"+infoVec[i].answer+'`'+infoVec[i].id+"\n";
			}
			costTime = String(int((getTimer() - startSS)*0.001));
			var  rate:String = String(int((right/total)*100));
			PackData.app.CmdIStr[0] = CmdStr.SUBMIT_PRACTICE_TASK;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = rrl;
			PackData.app.CmdIStr[3] = idStr;
			PackData.app.CmdIStr[4] = costTime;//#学习时长(秒数)
			PackData.app.CmdIStr[5] = right.toString();//学习正确数
			PackData.app.CmdIStr[6] = wrong.toString();//学习错误数
			PackData.app.CmdIStr[7] = total.toString();//学习总数
			PackData.app.CmdIStr[8] = rate;//#学习结果正确率，取值0-100
			PackData.app.CmdIStr[9] = startTime;//开始学习时间(YYYYMMDD-hhnnss)；20120316-155822
			PackData.app.CmdIStr[10] = MyUtils.getTimeFormat();//结束学习时间(YYYYMMDD-hhnnss)；20120316-160045
			PackData.app.CmdIStr[11] = wrongVec.join(",");//出错题目id串','分隔
			PackData.app.CmdIStr[12] = rightVec.join(",");//正确题目id串','分隔
			PackData.app.CmdIStr[13] = result;
			PackData.app.CmdInCnt =14;			
			sendNotification(CoreConst.SEND_11,new SendCommandVO(SUBMIT_TASK));
			
			sendNotification(WorldConst.UPDATE_TASK_DATA,new UpdateTaskDataVO('yy.E',rrl,'Z',int(right/total*100).toString()));
		}
		
		private function abandomSubmit():void{
			view.input.removeEventListener(KeyboardEvent.KEY_DOWN,inputKeyDownHandler);//暂时禁止用户回答
			right = 0;	
			wrong = 0;
			var wrongVec:Vector.<String> = new Vector.<String>;
			var rightVec:Vector.<String> = new Vector.<String>;
			var infoVec:Vector.<ExercisesVO> = this.infoVec.concat();
			var result:String='';
			for(var i:int=0;i<infoVec.length;i++){
				if(infoVec[i].ROE == 'R'){
					right++;
					rightVec.push(infoVec[i].id);
				}else if(infoVec[i].ROE == 'E'){
					wrong++
						wrongVec.push(infoVec[i].id);
				}else if((infoVec[i].ROE == 'N')){
					wrongVec.push(infoVec[i].id);
				}
				result += "IDS`"+i+"`"+infoVec[i].ROE+"`"+infoVec[i].userAnswer+"`"+infoVec[i].answer+'`'+infoVec[i].id+"\n";
			}
			costTime = String(int((getTimer() - startSS)*0.001));
			var  rate:String = String(int((right/total)*100));
			PackData.app.CmdIStr[0] = CmdStr.AbandomExam;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = rrl;
			PackData.app.CmdIStr[3] = idStr;
			PackData.app.CmdIStr[4] = costTime;//#学习时长(秒数)
			PackData.app.CmdIStr[5] = right.toString();//学习正确数
			PackData.app.CmdIStr[6] = wrong.toString();//学习错误数
			PackData.app.CmdIStr[7] = total.toString();//学习总数
			PackData.app.CmdIStr[8] = rate;//#学习结果正确率，取值0-100
			PackData.app.CmdIStr[9] = startTime;//开始学习时间(YYYYMMDD-hhnnss)；20120316-155822
			PackData.app.CmdIStr[10] = MyUtils.getTimeFormat();//结束学习时间(YYYYMMDD-hhnnss)；20120316-160045
			PackData.app.CmdIStr[11] = wrongVec.join(",");//出错题目id串','分隔
			PackData.app.CmdIStr[12] = rightVec.join(",");//正确题目id串','分隔
			PackData.app.CmdIStr[13] = result;
			PackData.app.CmdInCnt =14;
			
			sendNotification(CoreConst.SEND_11,new SendCommandVO(YES_QUIT));
		}
		
		
		//选择键盘
		private function selectKeyboard(answer:String):void{
			if(answer.search(/^[A-Da-d0-9\s\/.]+$/g) == 0){//只局限于a-d,A-D,0-9,/, .的可以使用小键盘
				sendNotification(SoftKeyBoardConst.USE_SIMPLE_KEYBOARD,true);//简单键盘	(a,b,c);	
			}else{
				sendNotification(SoftKeyBoardConst.USE_SIMPLE_KEYBOARD,false);//使用完整键盘"				
			}
		}
		
		//1.自身插入法 
		private function randomArr(arr:Vector.<ExercisesVO>):Vector.<ExercisesVO>
		{
			var outputArr:Vector.<ExercisesVO> = arr.slice();
			var i:int = outputArr.length;
			while (i)
			{
				outputArr.push(outputArr.splice(int(Math.random() * i--), 1)[0]);
			}
			return outputArr;
		}
		
		override public function handleNotification(notification:INotification):void
		{
//			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("handleNotification"+notification.getName(),"ExerciseLearnMediator",0));

			var result:DataResultVO = notification.getBody() as DataResultVO;
			super.handleNotification(notification);
			switch(notification.getName()){
				case GET_ID_Arr:
					if(!result.isErr){
						idStr = PackData.app.CmdOStr[3];
						sendinServerInfo(CmdStr.GET_READING_INFO,GET_INFO_Arr,[idStr]);
					}else{
						Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.TOAST,new ToastVO("抱歉！后台习题数据有误！请退出."));
					}
					break;
				case GET_INFO_Arr:
					if(!result.isEnd){//接收
						var exercisesVO:ExercisesVO = new ExercisesVO(PackData.app.CmdOStr[2]);
						exercisesVO.id = PackData.app.CmdOStr[1];
						infoVec.push(exercisesVO);
					}else{
						if(!isFirst){
							isFirst = true;
							total = infoVec.length;
							infoVec = randomArr(infoVec);
							Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,prepareVO);							
						}
					}
					break;
				case SUBMIT_TASK:
					if(!result.isErr){
						var rewardData:Object={};
						var _rrl:String = PackData.app.CmdOStr[1]
						if(_rrl)	_rrl=StringUtil.trim(_rrl);
						else	_rrl="";
						rewardData = {right:right,wrong:wrong,time:costTime};
						var script:String = PackData.app.CmdOStr[3];
						rewardData.rrl = _rrl;						
						rewardData.gold = script;
						rewardData.oralid = PackData.app.CmdOStr[2];
						sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(RewardViewMediator,rewardData),new SwitchScreenVO(CleanCpuMediator)]);//奖励界面
					}else if(PackData.app.CmdOStr[0] == "EEE"){
						sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n抱歉，习题提交失败。\n点击确定退出界面!",false,YES_QUIT));//提交订单
					}else if((PackData.app.CmdOStr[0] as String).charAt(0)=="M"){
						sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n抱歉，返回数据出错。\n点击确定退出界面!",false,YES_QUIT));//提交订单
					}
					break;
				case Abandon_Exercice:
					if(!isSubmit){
						isSubmit = true;						
						abandomSubmit();
					}
					break;
				case YES_QUIT:
					view.touchable = false;
					view.input.removeEventListener(KeyboardEvent.KEY_DOWN,inputKeyDownHandler);//暂时禁止用户回答
					isSubmit = false;
					quit();
					break;
				case WorldConst.GET_SCREEN_FAQ:
					if(curExerciseVo){						
						var str:String = "习题界面/"+"当前习题id:"+curExerciseVo.id;
						sendNotification(WorldConst.SET_SCREENT_FAQ,str);
					}
					break;
				case AlertShowExerciseTipMediator.HIDE_EXERCISE_TIP://提示框关闭
					view.input.mouseEnabled = true;
					view.input.setFocus();
					if(!curExerciseVo.isChecked){	
						curExerciseVo.isChecked = true;
						curExerciseVo.ROE = 'N';	
						curExerciseVo.userAnswer = '';
						
						view.hideTip();
//						TweenLite.killDelayedCallsTo(nextQuestion);
//						TweenLite.delayedCall(0.6,nextQuestion);
					}
					break;
			}	
			
			
//			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("end","ExerciseLearnMediator",0));

		}
		
		override public function listNotificationInterests():Array
		{
			var arr:Array = super.listNotificationInterests();
			return arr.concat([
					AlertShowExerciseTipMediator.HIDE_EXERCISE_TIP,
					GET_ID_Arr,
					GET_INFO_Arr,SUBMIT_TASK,
					YES_QUIT,
					Abandon_Exercice,
					WorldConst.GET_SCREEN_FAQ]);
		}						
		public function get view():ExerciseLearnView{
			return viewComponent as ExerciseLearnView;
		}		
		override public function get viewClass():Class{
			return ExerciseLearnView;
		}		
		override public function prepare(vo:SwitchScreenVO):void
		{
			prepareVO = vo;
			rrl = prepareVO.data.rrl;
			infoVec = new Vector.<ExercisesVO>;
			sendinServerInfo(CmdStr.GET_READING_TASK_ID,GET_ID_Arr,[rrl]);		
		}
	}
}