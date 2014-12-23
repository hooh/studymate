package com.studyMate.module.engLearn
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.SimpleScriptNewProxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.ExerciseLogicProxy;
	import com.studyMate.model.vo.ExerciseFlowVO;
	import com.studyMate.model.vo.QuestionVO;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.model.vo.ScriptExecuseVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.utils.LayoutToolUtils;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.view.component.ReadingTextField;
	import com.studyMate.view.component.myDrawing.helpFile.RegisterModelChange;
	import myLib.myTextBase.TextFieldHasKeyboard;
	import myLib.myTextBase.utils.SoftKeyBoardConst;
	import com.studyMate.world.component.MydragMethod.MyDragEvent;
	import com.studyMate.world.component.MydragMethod.MyDragFunc;
	import com.studyMate.world.controller.vo.UpdateTaskDataVO;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.screens.CleanCpuMediator;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.view.EduAlertMediator;
	import com.studyMate.world.script.LayoutTool;
	import com.studyMate.world.script.TypeTool;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.globalization.DateTimeFormatter;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import mx.utils.StringUtil;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import utils.FunctionQueueEvent;
	
	/**
	 * 阅读界面基本逻辑和大部分代码继承自早期代码，
	 * 为保证稳定性，只增加不修改的原则，导致代码冗余很多，或者规划不合理的情况，请凑活着先看吧。以后再改
	 * cpu层的阅读文本显示。接收rrl参数。 
	 * @author wangtu
	 * 
	 */	
	internal class ReadCPUMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "ReadCPUMediator";
		private var prepareVO:SwitchScreenVO;
		
		//private const GET_READ_CONTENT:String = "GET_READ_Content";
		//private const GET_READ_ID:String = "GET_READ_ID";
		private const SUBMIT_TASK:String = "submitTask";
		private const ERROR_POP:String = "error_pop";//出错跳出
		public static const yesAbandonHandler:String = NAME + "yesAbandonHandler";
		private const SubAbandonTask:String = NAME+ "AbandonTask";
		
		private var dictionaryNum:int;//查单词数
		
		private var subMitSucced:Boolean;
				
		private var logic:ExerciseLogicProxy;
		
		private var readingText:String;//文章
		private var annotationText:String;//翻译提示
		private var translationText:String;//翻译
		
		private var startTime:String = "";
		private var endTime:String = "";
		private var studyTime:int;
		
		protected var rightArray:Array = [];//第一次答对的
		protected var wrongArray:Array = [];
		private var modifiedRightArray:Array = [];//修改对的
		private var inputAnswerArr:Array = [];
		private var inputReasonArr:Array = [];
		private var leaveOutQuestionArr:Array=[];
		protected var totalPage:int = 0;
		private var pageIndex:int=1;
		private var isAnswerTAChanged:Boolean;
		private var isReasonTAChanged:Boolean;
		//private var isSubmitted:Boolean;
		private var wrongTA:Object=null;		
		private var isCheckRight:Boolean = false;//答对后2秒自动下一题
		
		private var isClicked:Boolean = false;
		
		private var rrl:String;
		private var readId:String;
		private var initialTxt:String;//后台反馈的原始文本
		//private var dataObj:Object={};//接收到的数据
		private var isRight:Boolean;
		private var rewardData:Object={};
		private var dic:Dictionary = new Dictionary();
		private var num:int=1;
		private var readingComp:TextField;
		private var registerModelChange:RegisterModelChange;
		
		private var quiteSuccess:Boolean;
		
		public var isStart:Boolean;//是否开始答题
		
		public function ReadCPUMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}
		override public function onRegister():void{		
			sendNotification(SoftKeyBoardConst.KEYBOARD_HASBG,0xF3E8C7);//键盘带背景
			//view.stage.focus = view.answerTA;
			//文章	
			LayoutToolUtils.holder = view.readingHolder;
			LayoutToolUtils.script = Vector.<String>(MyUtils.strLineToArray(initialTxt));
			sendNotification(CoreConst.EXECUSE_SCRIPT_NEW,new ScriptExecuseVO("TEXT1",-1,false,true));
			
			//___________测试滚动______________
			view.readScroller.viewPort = view.readingHolder;
			view.addChild(view.readScroller);
			//view.readScroller.update();
			
			readingComp = findItem(view.readingHolder);
			readingComp.htmlText += "\n\n\n\n\n\n\n";
			readingComp.cacheAsBitmap = true;//解决文字转位图抖动的问题
			registerModelChange = new RegisterModelChange(readingComp);
			registerModelChange.toImage(imageCompleteHandler);
			
			var bg:Shape = new Shape();
			bg.graphics.beginFill(0,0);
			bg.graphics.drawRect(0,0,664,view.readingHolder.height);
			bg.graphics.endFill();
			bg.x = -40;
			view.readingHolder.addChildAt(bg,0);
			view.readScroller.update();
			
			view.answerTA.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);//侦听回车事件
			view.reasonTA.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			view.answerTA.addEventListener(FocusEvent.FOCUS_IN,answerFocusHandler);
			view.reasonTA.addEventListener(FocusEvent.FOCUS_IN,reasonFocusHandler);
			view.answerTA.addEventListener(MouseEvent.CLICK,clickHandler);
			view.reasonTA.addEventListener(MouseEvent.CLICK,clickHandler);
			view.answerTA.addEventListener(Event.CHANGE,textChangedHandler);
			view.reasonTA.addEventListener(Event.CHANGE,textChangedHandler);
			view.tipsScroll.addEventListener(MouseEvent.CLICK,tipScrollClickHandler);
			view.questionScroller.addEventListener(MouseEvent.CLICK,tipScrollClickHandler);
			LayoutToolUtils.pageQueue.dispatcher.addEventListener(FunctionQueueEvent.FUNCTION_COMPLETE,functionHandle);
			
			//题目
			LayoutToolUtils.holder = view.questionHolder;
			LayoutToolUtils.removeAll();			
			logic = new ExerciseLogicProxy();
			facade.registerProxy(logic);
			LayoutToolUtils.script = Vector.<String>(MyUtils.strLineToArray(initialTxt));
			sendNotification(CoreConst.EXECUSE_SCRIPT_NEW,new ScriptExecuseVO(1));
												
			//页码
			totalPage = SimpleScriptNewProxy.getTotalPage();
			for(var i:int=1;i<=totalPage;i++){
				modifiedRightArray[i]=0;
			}
			view.questionCount.text = "1/"+totalPage;
						
			//view.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyboardHandler,false,1);
			
			startTime = getTimeFormat();			
			studyTime = getTimer();
			
			
			view.questionScroller.viewPort = view.questionHolder;
			view.addChildAt(view.questionScroller,0);
			
			TweenLite.delayedCall(180,quit);//三分钟后退出
			Global.stage.addEventListener(MouseEvent.MOUSE_DOWN,stageMouseDownHandler,true);
		}
		
		private function stageMouseDownHandler(event:MouseEvent):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("stageMouseDownHandler","ReadCPUMediator",0));

			TweenLite.killDelayedCallsTo(quit);
			TweenLite.delayedCall(180,quit);//三分钟后退出
			
		}
		private function tipScrollClickHandler(e:MouseEvent):void{
			view.tipsScroll.visible = false;
		}
		
		/**--------三分钟未输入则退出---------------*/
		protected function quit():void{
			if(isStart && !subMitSucced){
				sendNotification(ReadCPUMediator.yesAbandonHandler);
			}else{
				if(!subMitSucced){
					quitPopScreen();					
				}
			}
		}
		protected function quitPopScreen():void{
			sendNotification(WorldConst.POP_SCREEN);			
//			TweenLite.delayedCall(2,quitSuccessHandler);
		}
		/*private function quitSuccessHandler():void{
			if(!quiteSuccess){//退出失败则反复继续退出。知道彻底退出为之
				quitPopScreen();
			}
		}*/
		override public function onRemove():void{
			quiteSuccess = true;
//			TweenLite.killDelayedCallsTo(quitSuccessHandler);
			view.removeChildren();
			LayoutToolUtils.removeAll();
			LayoutToolUtils.holder = null;
			Global.stage.removeEventListener(MouseEvent.MOUSE_DOWN,stageMouseDownHandler,true);
			view.answerTA.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);//侦听回车事件
			view.reasonTA.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			view.answerTA.removeEventListener(FocusEvent.FOCUS_IN,answerFocusHandler);
			view.reasonTA.removeEventListener(FocusEvent.FOCUS_IN,reasonFocusHandler);

			view.answerTA.removeEventListener(MouseEvent.CLICK,clickHandler);
			view.reasonTA.removeEventListener(MouseEvent.CLICK,clickHandler);
			view.answerTA.removeEventListener(Event.CHANGE,textChangedHandler);
			view.reasonTA.removeEventListener(Event.CHANGE,textChangedHandler);
			//view.stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyboardHandler);	
			view.tipsScroll.removeEventListener(MouseEvent.CLICK,tipScrollClickHandler);
			LayoutToolUtils.pageQueue.dispatcher.removeEventListener(FunctionQueueEvent.FUNCTION_COMPLETE,functionHandle);
			TweenLite.killDelayedCallsTo(sendNotification);
			TweenLite.killDelayedCallsTo(quit);
			TweenLite.killDelayedCallsTo(updateQuestion);
			facade.removeProxy(ExerciseLogicProxy.NAME);
			logic = null;
			if(registerModelChange) registerModelChange.dispose();
			if(facade.hasMediator(EduAlertMediator.NAME)){
				sendNotification(WorldConst.REMOVE_POPUP_SCREEN,(facade.retrieveMediator(EduAlertMediator.NAME) as EduAlertMediator));
			}
			super.onRemove();
		}
		
		/**----------------------------------查找textfiled函数-------------------------------------------*/
		private function findItem(_holder:DisplayObjectContainer):TextField{
			var textChild:TextField;
			for(var i:int = 0;i < _holder.numChildren;i++) {
				var displayObject:DisplayObject = _holder.getChildAt(i);
				if(displayObject is Sprite) {
					for(var j:int = 0;j < (displayObject as Sprite).numChildren;j++) {
						var child:DisplayObject = (displayObject as Sprite).getChildAt(j);
						if(child is TextField) {
							textChild = child as TextField;
							_holder.width = textChild.width;
							_holder.height = textChild.height;
							break;
						}
					}
				}
			}
			return textChild;
		}
		/**----------------------------------文本、图片转化功能群-------------------------------------------*/
		private function imageCompleteHandler():void{
			var UIDrag:MyDragFunc = new MyDragFunc(view.readingHolder,0.5);
			UIDrag.addEventListener(MyDragEvent.START_EFFECT,StartEffectHandler);
			UIDrag.addEventListener(MyDragEvent.END_EFFECT,EndEffectHandler);
		}		
		private function StartEffectHandler(e:MyDragEvent):void{
			//trace("开始特效");
			registerModelChange.toComponent();
			(readingComp as ReadingTextField).show(e.localX,e.localY);
		}
		private function EndEffectHandler(e:MyDragEvent):void{
			//trace("结束特效");
			Global.stage.focus=readingComp;
			readingComp.setSelection(0,0);
			registerModelChange.toImage();
		}
		
		/*private function keyboardHandler(e:KeyboardEvent):void{					
			if(e.keyCode == Keyboard.BACK)	{
				e.preventDefault();	
				e.stopImmediatePropagation();
			}						
		}*/
		private function functionHandle(e:Event):void{						
			if(isCheckRight && pageIndex<totalPage){
				view.answerTA.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);//侦听回车事件
				view.reasonTA.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
				TweenLite.delayedCall(2,sendNotification,["nextTouchHandler"]);	
				view.mouseChildren = false;
				view.mouseEnabled = false;
			}
		}
						
		override public function handleNotification(notification:INotification):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("s "+notification.getName(),"ReadCPUMediator",0));

			switch(notification.getName()) {
				/*case GET_READ_ID:
					if(PackData.app.CmdOStr[0] == "000"){//第一步获取阅读id
						rrl = PackData.app.CmdOStr[2];
						readId = PackData.app.CmdOStr[3];
						this.sendinServerInfo(CmdStr.GET_READING_TEXT,GET_READ_CONTENT,[readId]);//根据id获取文章
					}
					break;
				case GET_READ_CONTENT://第二部获取阅读文本
				if(PackData.app.CmdOStr[0] == "000"){
						initialTxt = PackData.app.CmdOStr[3];
//						var arr2:Array = this.getTextArrFun("outHTML",initialTxt);//解析脚本
//						readingText = arr2[0];
//						annotationText = arr2[1];
//						translationText = arr2[2];
						Facade.getInstance(ApplicationFacade.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,prepareVO);
					}
					break;*/
				case yesAbandonHandler:
					if(!subMitSucced && isStart){
						subMitSucced = true;
						var t:int = (getTimer()-studyTime)*0.001;
						var s1:String = countNum(rightArray).toString();
						var s2:String = countNum(wrongArray).toString();
						if(s1=="0" && s2=="0"){
							result = "IDS````"
						}else{
							var allArray:Array = rightArray.concat(wrongArray);
							
							allArray.sortOn('id');
							var result:String = combineAnswerResult(allArray);
//							var result:String = combineAnswerResult(rightArray);
//							result += combineAnswerResult(wrongArray);
						}
						
						
						var rate:String = String(dictionaryNum*1000+int((countNum(rightArray)/totalPage)*100));
						PackData.app.CmdIStr[0] = CmdStr.Abandon_Task_YYRead;
						PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
						PackData.app.CmdIStr[2] = rrl;
						PackData.app.CmdIStr[3] = readId;
						PackData.app.CmdIStr[4] = String(t);//#学习时长(秒数)
						PackData.app.CmdIStr[5] = s1;//学习正确数
						PackData.app.CmdIStr[6] = s2;//学习错误数
						PackData.app.CmdIStr[7] = String(totalPage);//学习总数
						PackData.app.CmdIStr[8] = rate;//#学习结果正确率，取值0-100 + 查单词个数*1000
						PackData.app.CmdIStr[9] = startTime;//开始学习时间(YYYYMMDD-hhnnss)；20120316-155822
						PackData.app.CmdIStr[10] = getTimeFormat();//结束学习时间(YYYYMMDD-hhnnss)；20120316-160045
						PackData.app.CmdIStr[11] = result;				
						PackData.app.CmdInCnt =12;											
						sendNotification(CoreConst.SEND_11,new SendCommandVO(SubAbandonTask));

					}else if(!isStart){
						sendNotification(WorldConst.POP_SCREEN);
					}
					
					break;
				case SubAbandonTask:
					sendNotification(WorldConst.POP_SCREEN);	
					break;
				case TypeTool.EXECUTE_SHOW_QUESTION_FUNCTION:					
					/*var answerStr:String = logic.getAnswer()[0];
					var reasonStr:String = logic.getAnswer()[1];
					var boo:Boolean = /[0-9]/.test(reasonStr.charAt(0));
					//sendNotification(WorldConst.KEYBOARD_HASBG,0xF3E8C7);//键盘带背景
					if(answerStr.length<2 && (reasonStr=="" || boo)){
						//trace("使用简单键盘");
						sendNotification(WorldConst.USE_SIMPLE_KEYBOARD,true);						
					}else{
						//trace("使用完整键盘");
						sendNotification(WorldConst.USE_SIMPLE_KEYBOARD,false);
					}
					*/
					sendNotification(SoftKeyBoardConst.KEYBOARD_HASBG,0xF3E8C7);//键盘带背景
					view.answerTA.setFocus();
					if(logic.getAnswer()[1]==""){
						view.reasonTA.mouseEnabled = false;
						view.reasonTA.text = "不需要输入理由";
						inputReasonArr[pageIndex]=" ";
					}else{
						view.reasonTA.mouseEnabled = true;						
						//view.reasonTA.text = "";
					}
					/*if(pageIndex>totalPage){
						view.reasonTA.mouseEnabled = false;
					}*/
					TweenLite.killDelayedCallsTo(updateQuestion);
					TweenLite.delayedCall(0.3,updateQuestion);
					break;
				case "preTouchHandler"://ReadBGMediator发送的消息，点击上一题	
					view.mouseChildren = true;
					view.mouseEnabled = true;
					view.answerTA.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);//侦听回车事件
					view.reasonTA.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
					pageIndex--;
					isCheckRight = false;
					isRight = false;
					view.reasonTA.text = "";
					view.answerTA.text = "";
					LayoutTool.clearSubHolder();
					if(pageIndex<1){
						pageIndex = 1;
					}
					if(inputAnswerArr[pageIndex]){
						view.answerTA.text = String(inputAnswerArr[pageIndex]); 
						view.answerTA.selectTextRange(0,view.answerTA.text.length);
					}
					if(inputReasonArr[pageIndex]){
						view.reasonTA.text = String(inputReasonArr[pageIndex]);
					}
					sendNotification(ReadBGMediator.TIP_HOLDER,false);
					//sendNotification(ReadBGMediator.TIP_INFORMATION,"");
					sendNotification(ReadBGMediator.SHOW_ICON,"");
					view.questionHolder.removeChildren();
					view.answerTA.mouseEnabled = true;
					view.reasonTA.mouseEnabled = true;
					LayoutToolUtils.holder = view.questionHolder;
					sendNotification(CoreConst.EXECUSE_SCRIPT_NEW,new ScriptExecuseVO(pageIndex));						
						
					//view.stage.focus =  view.answerTA;
					view.answerTA.setFocus();
					view.questionCount.text = pageIndex+"/"+totalPage;
					break;
				case "nextTouchHandler"://点击下一题	
					view.mouseChildren = true;
					view.mouseEnabled = true;
					view.answerTA.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);//侦听回车事件
					view.reasonTA.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
					pageIndex++;
					isCheckRight = false;
					isRight = false;
					view.reasonTA.text = "";
					view.answerTA.text = "";
					sendNotification(ReadBGMediator.SHOW_ICON,"");
					LayoutTool.clearSubHolder();
					if(pageIndex>totalPage){
						pageIndex = totalPage;
						checkFinish();
						if(leaveOutQuestionArr.length>0){
							//view.answerTA.mouseEnabled = false;
							//view.reasonTA.mouseEnabled = false;
							view.stage.focus = null;
							var str:String = "\n第"+leaveOutQuestionArr.toString()+"题还没有答对,\n请根据提示输入正确答案并回车.";
							sendNotification(WorldConst.ALERT_SHOW,new AlertVo(str,false));
						}else{				
							view.answerTA.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);//侦听回车事件
							view.reasonTA.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
							submit();							
						}
						view.questionCount.text = totalPage+"/"+totalPage;
					}else{
						//view.stage.focus = view.answerTA;
						sendNotification(ReadBGMediator.TIP_HOLDER,false);
						//sendNotification(ReadBGMediator.TIP_INFORMATION,"");
						if(inputAnswerArr[pageIndex]){
							view.answerTA.text = String(inputAnswerArr[pageIndex]); 
							view.answerTA.selectTextRange(0,view.answerTA.text.length);
						}
						if(inputReasonArr[pageIndex]){
							view.reasonTA.text = String(inputReasonArr[pageIndex]);
						}
						view.answerTA.mouseEnabled = true;
						view.reasonTA.mouseEnabled = true;
						view.questionCount.text = pageIndex+"/"+totalPage;
//						while(view.questionHolder.numChildren>0){
//							view.questionHolder.removeChildAt(0);
//						}
						view.questionHolder.removeChildren();
						LayoutToolUtils.holder = view.questionHolder;
						sendNotification(CoreConst.EXECUSE_SCRIPT_NEW,new ScriptExecuseVO(pageIndex));
						view.answerTA.setFocus();
					}							
					break;
				case SUBMIT_TASK:
					if(PackData.app.CmdOStr[0] == "000"){
						//trace("提交成功！！！");
						view.mouseEnabled = false;
						var _rrl:String = PackData.app.CmdOStr[1]
						if(_rrl)	rrl=StringUtil.trim(_rrl);
						else	rrl="";
						var script:String = PackData.app.CmdOStr[3];
						rewardData.rrl = PackData.app.CmdOStr[1];
						var m:int = script.indexOf("<PAGE1"+">");
						var temp:int = script.indexOf("advancedPrint:",m);
						var j:int = script.indexOf("\n",temp);			
						var textArr:Array = script.substring(temp+14,j).split("`");//目标文本包含设置、答案提示
						//trace("金币数 = "+String(textArr[10]).match(/\d+/));
						rewardData.gold = String(textArr[10]).match(/\d+/);
						rewardData.oralid = PackData.app.CmdOStr[2];
						sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(RewardViewMediator,rewardData),new SwitchScreenVO(CleanCpuMediator)]);//奖励界面
					}/*else{
						subMitSucced = false;//提交失败则可以继续提交,防止反复提交结果
					}*/
					if((PackData.app.CmdOStr[0] as String).charAt(0)=="M"){//出错退出
						sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n抱歉，提交结果失败。\n请按确定退出.\n",false,ERROR_POP));//提交订单
					}
					break;
				case ERROR_POP:
					sendNotification(WorldConst.POP_SCREEN);
					break;
				case ReadBGMediator.TIP_HOLDER:
					view.tipsScroll.update();
					view.tipsScroll.visible = notification.getBody() as Boolean;//提示文本内容
					break;
				case WorldConst.DICTIONARY_SHOW:
					dictionaryNum++;
					break;
				
				/*case FAQChatMediator.HASFAQ:
					if(notification.getBody()){
						TweenLite.killDelayedCallsTo(quit);
						//TweenLite.delayedCall(180,quit);//三分钟后退出
						trace("结束计算时间");
					}else{
						TweenLite.killDelayedCallsTo(quit);
						TweenLite.delayedCall(180,quit);//三分钟后退出
						trace("开始计算时间");
					}
					break;*/
				case WorldConst.GET_SCREEN_FAQ:
					var str1:String = "阅读界面/"+rrl+"/第"+pageIndex+"题,id="+readId;
					sendNotification(WorldConst.SET_SCREENT_FAQ,str1);
					break;
				case CoreConst.DEACTIVATE:
					duration = getTimer();
					break;
				case CoreConst.ACTIVATE:
					if(duration==0) return;
					if((getTimer() - duration)*0.001>180 && !subMitSucced){
						TweenLite.killDelayedCallsTo(quit);
						quit();
					}
					break;
			}					
			
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("e ","ReadCPUMediator",0));

		}
		private var duration:int = 0;
		private function updateQuestion():void{
			view.questionScroller.verticalScrollPosition = 0;
			view.questionScroller.update();
		}
		
		override public function listNotificationInterests():Array{
			return [CoreConst.DEACTIVATE,CoreConst.ACTIVATE,WorldConst.GET_SCREEN_FAQ,SubAbandonTask,yesAbandonHandler,WorldConst.DICTIONARY_SHOW,"preTouchHandler","nextTouchHandler",ERROR_POP,SUBMIT_TASK,ReadBGMediator.TIP_HOLDER,TypeTool.EXECUTE_SHOW_QUESTION_FUNCTION];
		}
		protected function submit():void{
			TweenLite.killDelayedCallsTo(quit);
			if(!subMitSucced){
				view.answerTA.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);//侦听回车事件
				view.reasonTA.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
				sendNotification(SoftKeyBoardConst.HIDE_SOFTKEYBOARD);
				subMitSucced = true;			
			
				endTime = getTimeFormat();
				var t:int = (getTimer()-studyTime)*0.001;
				var s1:String = countNum(rightArray).toString();
				var s2:String = countNum(wrongArray).toString();
				
				var allArray:Array = rightArray.concat(wrongArray);				
				allArray.sortOn('id');
				var result:String = combineAnswerResult(allArray);
//				result += combineAnswerResult(wrongArray);
				var rate:String = String(dictionaryNum*1000+int((countNum(rightArray)/totalPage)*100));
				PackData.app.CmdIStr[0] = CmdStr.SUBMIT_READING_TASK;
				PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
				PackData.app.CmdIStr[2] = rrl;
				PackData.app.CmdIStr[3] = readId;
				PackData.app.CmdIStr[4] = String(t);//#学习时长(秒数)
				PackData.app.CmdIStr[5] = s1;//学习正确数
				PackData.app.CmdIStr[6] = s2;//学习错误数
				PackData.app.CmdIStr[7] = String(totalPage);//学习总数
				PackData.app.CmdIStr[8] = rate;//#学习结果正确率，取值0-100 + 查单词个数*1000
				PackData.app.CmdIStr[9] = startTime;//开始学习时间(YYYYMMDD-hhnnss)；20120316-155822
				PackData.app.CmdIStr[10] = endTime;//结束学习时间(YYYYMMDD-hhnnss)；20120316-160045
				PackData.app.CmdIStr[11] = result;				
				PackData.app.CmdInCnt =12;						
				
				rewardData = {right:s1,wrong:s2,time:String(t)};
				sendNotification(CoreConst.SEND_11,new SendCommandVO(SUBMIT_TASK));
				
				sendNotification(WorldConst.UPDATE_TASK_DATA,new UpdateTaskDataVO('yy.R',rrl,'Z',int(int(s1)/totalPage*100).toString()));

			}
		}
		protected function reasonFocusHandler(event:FocusEvent):void{
			var reasonStr:String = logic.getAnswer()[1];
			selectKeyboard(reasonStr);			
		}
		
		protected function answerFocusHandler(event:FocusEvent):void{
			var answerStr:String = logic.getAnswer()[0];
			selectKeyboard(answerStr);			
		}
		private function selectKeyboard(str:String):void{
			isClicked = false;
			if(str.search(/[a-zA-Z']/)!=-1){//如果检索到英文	
				if(str.length>1){
					sendNotification(SoftKeyBoardConst.USE_SIMPLE_KEYBOARD,false);//trace("使用完整键盘");					
				}else{
					sendNotification(SoftKeyBoardConst.USE_SIMPLE_KEYBOARD,true);//简单键盘	(a,b,c)	
				}
				
			}else if(/[\一-\龥]/.test(str)){
				sendNotification(SoftKeyBoardConst.USE_KEYBOARD_CHINESE);
			}
			else{
				sendNotification(SoftKeyBoardConst.USE_SIMPLE_KEYBOARD,true);//trace("使用完整键盘");
			}
		}
		

		protected function clickHandler(e:MouseEvent):void
		{
			var ta:TextFieldHasKeyboard = e.currentTarget as TextFieldHasKeyboard;
			if(!isClicked){
				isClicked = true;
				ta.selectTextRange(0,ta.text.length);
			}
		}
		protected function textChangedHandler(event:Event):void
		{
			if(event.currentTarget==view.answerTA){
				inputAnswerArr[pageIndex]= view.answerTA.text;
			}else if(event.currentTarget==view.reasonTA){
				inputReasonArr[pageIndex] =  view.reasonTA.text;
			}
		}
		
		//a输入框为答案，b输入框为理由。逻辑采用状态转移图
		private var flagWhole:int=0;//标记，该单词是否已提示过（0为没提示过）
		private function keyDownHandler(e:KeyboardEvent):void{
			TweenLite.killDelayedCallsTo(quit);
			TweenLite.delayedCall(180,quit);//三分钟后退出
			//LayoutTool.clearSubHolder();
			if(e.keyCode==13 || e.keyCode == 10){//回车侦听
				e.preventDefault();
				e.stopImmediatePropagation();
				if(flagWhole==0){
					if(view.reasonTA.text!='' && view.reasonTA.text.split('.').length>2){
						if(view.reasonTA.text.indexOf('/')==-1){
							sendNotification(CoreConst.TOAST,new ToastVO('格式错误,多个理由请用/区分'));
							flagWhole = 1;
							return;
						}
						if(view.reasonTA.text.split('/').length>2){
							sendNotification(CoreConst.TOAST,new ToastVO('理由最多只允许输入两个.'));
							return;
						}
					}
				}
				flagWhole = 0;
				var _answerStr:String = StringUtil.trim(view.answerTA.text.replace(/\/+/g,""));
				var _reasonStr:String = StringUtil.trim(view.reasonTA.text.replace(/\/+/g,"&"));
				if(e.currentTarget == view.answerTA){	//在答案输入框回车，状态有三种情况，1：不动，2：下一题，3，焦点进入b输入框				
					if(_answerStr==""){//答案空，则 1：不动
						return;
					}else {//答案不空，2：下一题，3，焦点进入b输入框
						if(_reasonStr!="" && view.reasonTA.mouseEnabled){//有答案有理由，则 2：下一题							
							checkInputAnswer(_answerStr+"/"+_reasonStr);//trace("处理下一题");							
						}else{
							if(view.reasonTA.mouseEnabled==false)	checkInputAnswer(_answerStr+"/");
							else	view.reasonTA.setFocus();														
						}
					}
				}else if(e.currentTarget == view.reasonTA){//在理由输入框按回车，状态有两种情况,1:不动,2：跳转下一题
					if(_answerStr=="" || _reasonStr=="")	return;
					else	checkInputAnswer(_answerStr+"/"+_reasonStr);//trace("处理下一题");						
				}
			}else{
				sendNotification(ReadBGMediator.TIP_HOLDER,false);
				if(e.currentTarget==view.answerTA){
					isAnswerTAChanged = true;
					isRight = false;
				}else if(e.currentTarget==view.reasonTA){
					isReasonTAChanged = true;
					isRight = false;
				}
			}
		}
				
		private function checkInputAnswer(_str:String):void{
			isStart = true;
			if(wrongTA){
				if(wrongTA==view.answerTA){
					if(!isAnswerTAChanged){
						//view.stage.focus = view.answerTA;
						view.answerTA.setFocus();
						view.answerTA.selectTextRange(0,view.answerTA.text.length);
						return;
					}else if(!isReasonTAChanged && view.reasonTA.mouseEnabled){
						//view.stage.focus = view.reasonTA;
						view.reasonTA.setFocus();
						view.reasonTA.selectTextRange(0,view.reasonTA.text.length);
						return;
					}
				}else if(wrongTA == view.reasonTA){
					if(!isReasonTAChanged&&!isAnswerTAChanged){
						//view.stage.focus = view.reasonTA;
						view.reasonTA.setFocus();
						view.reasonTA.selectTextRange(0,view.reasonTA.text.length);
						return;
					}
				}
			}
			LayoutTool.clearSubHolder();
			var evo:ExerciseFlowVO =  check(_str);
			if(!evo)	return;

			//记住那个输入框答错了
			if(evo.ANR[0]){
				if(!evo.ANR[1]){
					isReasonTAChanged = false;
					wrongTA = view.reasonTA;
					//view.stage.focus = view.reasonTA;
					view.reasonTA.setFocus();
					view.reasonTA.selectTextRange(0,view.reasonTA.text.length);
				}else{
					wrongTA = null;
				}
			}else{
				isAnswerTAChanged = false;
				if(!evo.ANR[1]){
					isReasonTAChanged = false;
				}
				wrongTA = view.answerTA;
				//view.stage.focus = view.answerTA;
				view.answerTA.setFocus();
				view.answerTA.selectTextRange(0,view.answerTA.text.length);
			}
						
			
			if(evo.ANR[0]){
				sendNotification(ReadBGMediator.SHOW_ICON,"answerR");
			}else{
				sendNotification(ReadBGMediator.SHOW_ICON,"answerW")
			}
			if(view.reasonTA.mouseEnabled){
				if(evo.ANR[1]){
					sendNotification(ReadBGMediator.SHOW_ICON,"reasonR");
				}else{
					sendNotification(ReadBGMediator.SHOW_ICON,"reasonW");
				}
			}
			checkFinish();			
			if(leaveOutQuestionArr.length==0){
				submit();
				return;				
			}
			
			LayoutToolUtils.holder = view.tipHolder;
			//修改答对后连续按回车键会一直播放声音的bug
			if(evo.ANR[0]){
				if(!isRight){
					LayoutTool.executeCustomTag(evo.tag);
					sendNotification(ReadBGMediator.TIP_HOLDER,true);
					isRight = true;
					
					if(pageIndex>=totalPage){
						var str:String = "\n第"+leaveOutQuestionArr.toString()+"题还没有答对,\n请跳转到相关题目并输入答案.";
						sendNotification(WorldConst.ALERT_SHOW,new AlertVo(str,false));
					}
				}
			}else{
				LayoutTool.executeCustomTag(evo.tag);
				sendNotification(ReadBGMediator.TIP_HOLDER,true);
				//打错三次直接跳过到下一题
				if(dic[pageIndex]==null){	
					num = 1;
					dic[pageIndex] = num;
				}else{
					num ++;
					if(num==4){
						if(pageIndex<=totalPage){
							modifiedRightArray[pageIndex]=1;
							//TweenLite.delayedCall(2,sendNotification,["nextTouchHandler"]);
							sendNotification("nextTouchHandler");
							wrongTA = null;
						}
						dic[pageIndex]==null
					}
				}
			}						
		}

		private function check(_str:String):ExerciseFlowVO{
			var evo:ExerciseFlowVO = logic.checkAnswer(_str);
			if(evo.result){
				view.answerTA.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);//侦听回车事件
				view.reasonTA.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
				isCheckRight = true;
				modifiedRightArray[pageIndex]=1;
				if(!rightArray[pageIndex-1]){
					var isInWrongArray:Boolean = false;
					for(var i:int=0;i<wrongArray.length;i++){
						if(wrongArray[i]&&wrongArray[i].id==pageIndex){
							isInWrongArray=true;
							break;
						}
					}
					if(!isInWrongArray){
						var qvo:QuestionVO = new QuestionVO(pageIndex,_str,evo.answer,true);
						rightArray[pageIndex-1] = qvo;
					}
				}
			}else{
				modifiedRightArray[pageIndex]=0;
				if(!wrongArray[pageIndex-1]){
					qvo = new QuestionVO(pageIndex,_str,evo.answer,false);
					wrongArray[pageIndex-1] = qvo;
				}
			}
			return evo;
		}
		
		/**
		 * 提示信息，并播放相应的声音
		 * @param tag	提示标签名
		 * @return 提示信息
		 */		
		/*private function getTipStr(tag:String):String{
			tag = StringUtil.trim(tag);
			var i:int = initialTxt.indexOf("<"+tag+">");
			var temp:int = initialTxt.indexOf("printText:",i);
			var j:int = initialTxt.indexOf("\n",temp);			
			var textArr:Array = initialTxt.substring(temp+10,j).split("`");//目标文本包含设置、答案提示	
			
			var temp2:int = initialTxt.indexOf("playTipSound:",i);
			var m:int = initialTxt.indexOf("\n",temp2);
			var soundStr:String = initialTxt.substring(temp2+13,m);//声音名
			var sc:Class = getDefinitionByName(soundStr) as Class;
			if(sc){
				var sound:Sound = new sc;
				sound.play();
			}
			if(textArr[4])	return textArr[4];
			else 			return "暂无提示信息";
		}*/
		
		private function combineAnswerResult(_arr1:Array):String{
			var result:String="";
			if(_arr1.length==0)	return result;			
			for(var i:int=0;i<_arr1.length;i++){
				if(_arr1[i]){
					result += "IDS`"+QuestionVO(_arr1[i]).id+"`"+QuestionVO(_arr1[i]).myJudge+"`"+QuestionVO(_arr1[i]).userAnswer+"`"+QuestionVO(_arr1[i]).standardAnswer+"\n";
				}
			}
			return result;
		}
		
		protected function countNum(_arr:Array):int{
			var num:int=0;
			for(var i:int=0;i<_arr.length;i++){
				if(_arr[i])	num++;
			}
			return num;
		}
		private function getTimeFormat():String{
			var dateFormatter:DateTimeFormatter = new DateTimeFormatter("en-US");			
			dateFormatter.setDateTimePattern("yyyyMMdd-HHmmss");
			return dateFormatter.format(Global.nowDate);			
		}
						
		private function checkFinish():void{
			leaveOutQuestionArr = [];
			for(var k:int=1;k<=totalPage;k++){
				if(modifiedRightArray[k]!=1)	leaveOutQuestionArr.push(k);				
			}
		}
		
		/**
		 * 取得左侧界面所有html文本内容
		 * @param notation	
		 * @param _src
		 * @return 	返回原文和翻译
		 */		
		/*private function getTextArrFun(notation:String,_src:String):Array{
			var arr:Array = _src.split("\n")
			var arr2:Array = [];
			var total:int = arr.length
			for(var i:int = 0;i < total;i++) {
				if(arr[i].indexOf(notation) != -1) {
					var s:int = arr[i].lastIndexOf("`");
					var str:String = arr[i].toString().substring(s + 1);
					arr2.push(str);
					if(arr2.length == 3)	break;
				}
			}
			return arr2;
		}*/
		
		/**
		 * 显示右侧题目的html文本内容
		 * @param pageIndex	页码
		 * @return	String 返回文本
		 */		
		/*private function getThemeStr(pageIndex:int):String{
			var i:int = initialTxt.indexOf("<PAGE"+pageIndex+">");
			var temp:int = initialTxt.indexOf("showQuestion:",i);
			var j:int = initialTxt.indexOf("<ENDPAGE>",temp);			
			var textArr:Array = initialTxt.substring(temp+13,j).split("`");//目标文本包含设置、答案提示	
			
			var exerciseFlowVO:Vector.<ExerciseFlowVO> = new Vector.<ExerciseFlowVO>;
			for(i=7;i<=textArr.length;i++){//7及以上为正确和错误提示
				var evo:ExerciseFlowVO = new ExerciseFlowVO("",false,textArr[i]);
				exerciseFlowVO.push(evo);
			}
			var exerciseVO:ExerciseVO = new ExerciseVO(textArr[6],exerciseFlowVO);//6为正确答案
			(Facade.getInstance(ApplicationFacade.CORE).retrieveProxy(ExerciseLogicProxy.NAME) as ExerciseLogicProxy).init(exerciseVO);			
			
			return	String(textArr[5]).replace(/<br>/g,"\n");//5为题目
		}*/
		
		/**
		 * 后台信息派发函数
		 * @param command		命令字
		 * @param reveive		接收字符
		 * @param info			参数数组
		 */		
		private function sendinServerInfo(command:String,reveive:String,infoArr:Array):void{
			PackData.app.CmdIStr[0] = command;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			for(var i:int=0;i<infoArr.length;i++){
				PackData.app.CmdIStr[i+2] = infoArr[i]
			}
			PackData.app.CmdInCnt = i+2;	
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(reveive));	//派发调用绘本列表参数，调用后台
		}
		
		private function get view():ReadCPUView{
			return getViewComponent() as ReadCPUView;
		}
		override public function get viewClass():Class{
			return ReadCPUView;
		}
		override public function prepare(vo:SwitchScreenVO):void{
			prepareVO = vo;	
			rrl = prepareVO.data.data.rrl;
			readId = prepareVO.data.data.readId;
			initialTxt = prepareVO.data.data.initialTxt;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,prepareVO);
			/*if(prepareVO.data.data.rrl.indexOf("yy.R")!=-1){
				rrl = prepareVO.data.data.rrl;	
				trace("阅读 rrl = "+rrl);
				this.sendinServerInfo(CmdStr.GET_READING_TASK_ID,GET_READ_ID,[rrl]);//获取阅读任务id				
			}*/
		}
	}
}