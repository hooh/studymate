package com.studyMate.module.engLearn
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.SimpleScriptNewProxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.framework.utils.AssetTool;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.ExerciseLogicProxy;
	import com.studyMate.model.vo.ExerciseFlowVO;
	import com.studyMate.model.vo.ItemVO;
	import com.studyMate.model.vo.ScriptExecuseVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.utils.LayoutToolUtils;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.view.component.myScroll.Scroll;
	import myLib.myTextBase.TextFieldHasKeyboard;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.screens.CleanCpuMediator;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.script.LayoutTool;
	import com.studyMate.world.script.TypeTool;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import mx.utils.StringUtil;
	
	import fl.controls.Label;
	import fl.controls.TextInput;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import utils.FunctionQueueEvent;

	internal class PracticeComponentViewMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "PracticeComponentViewMediator";
		
		private const GET_PRACTICE:String =NAME+ "componentGetPractice";
		
		public const SUBMIT_TASK:String = NAME+"SubmitTask";
		
		public const BEGIN_PRACTICE_TASK:String = NAME+"BeginPracticeTask";
		
		//public static const BEGIN_WORD_LEARNING_TASK:String = NAME+"BeginWordLearningTask";
		
		//public static const BEGIN_KNOWLEDGE_POINT_TASK:String = NAME+"BeginKnowledgePointTask";
		
		public const GET_PRACTICE_TASK:String = NAME+"GetPracticeTask";
		public const FIRST_GET_PRACTICE_TASK:String = NAME + "FIRST_GET_PRACTICE_TASK";
		
		//public static const GET_KNOWLEDGE_POINT_ID:String = NAME+"GetKnowledgePoint";
		private var subMitSucced:Boolean;
		private var prepareVO:SwitchScreenVO;
		private var rrl:String;
		private var practiceId:String;
		private var status:String;
		private var isSubmit:Boolean = false;
		
		private var longText:String;
		private var logic:ExerciseLogicProxy;
		
		private var totalPage:uint = 0;
		private var currentIndex:int=1;
		
		private var startTime:String = "";
		private var endTime:String = "";
//		private var studyTime:uint = 0;
		private var startSSS:Number;//开始秒数，为了求总时间
		
		private var itemArray:Vector.<ItemVO> = Vector.<ItemVO>([]);
		
		private var parentMediator:PracticeViewMediator;
		
		public function PracticeComponentViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function onRemove():void
		{
			answer.removeEventListener(KeyboardEvent.KEY_DOWN,enterAnswer);
			reason.removeEventListener(KeyboardEvent.KEY_DOWN,enterReason);
			
			answer.removeEventListener(FocusEvent.FOCUS_IN,getFocusHandler);
			reason.removeEventListener(FocusEvent.FOCUS_IN,getFocusHandler);
			
			answer.removeEventListener(Event.CHANGE,changedHandler);
			reason.removeEventListener(Event.CHANGE,changedHandler);
			
			browse.removeEventListener(KeyboardEvent.KEY_DOWN,browseHandler);
			itemArray.length = 0;
			itemArray = null;
			TweenLite.killDelayedCallsTo(nextHandler);
			//			MyUtils.view.removeEventListener(BonusViewMediator.CLICK_POP_UP_CONFIRM,clickConfirmHandler);
			LayoutToolUtils.pageQueue.dispatcher.removeEventListener(FunctionQueueEvent.FUNCTION_COMPLETE,functionHandle);
			LayoutToolUtils.removeAll();
			LayoutToolUtils.holder = null;
			/*while(view.numChildren){
				view.removeChildAt(0);
			}*/
			view.removeChildren();
			facade.removeProxy(ExerciseLogicProxy.NAME);
			logic = null;
			prepareVO = null;
			super.onRemove();
		}
		private var rewardData:Object={};
		override public function handleNotification(notification:INotification):void
		{
			var name:String = notification.getName();
			switch(name){
				case GET_PRACTICE:
					if(PackData.app.CmdOStr[0] == "000"){
						var ss1:String = PackData.app.CmdOStr[1];
						longText = PackData.app.CmdOStr[2];
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,prepareVO);
					}
					break;
				case TypeTool.EXECUTE_SHOW_QUESTION_FUNCTION:
					setReasonTA();
					//sendNotification(WorldConst.USE_SIMPLE_KEYBOARD,false);
					answer.setFocus();
					answer.selectTextRange(0,answer.text.length);
					break;
				case SUBMIT_TASK:
					/*if(PackData.app.CmdOStr[0] == "000"){
						isSubmit = true;
						var _rrl:String = PackData.app.CmdOStr[1]
						_rrl = StringUtil.trim(_rrl);
						if(_rrl){
							rrl=_rrl;
						}else{
							rrl="";
						}
						var sss:String = PackData.app.CmdOStr[3];
						sendNotification(ApplicationFacade.SHOW_BONUS);
						LayoutToolUtils.script = Vector.<String>(MyUtils.strLineToArray(PackData.app.CmdOStr[3]));
						sendNotification(ApplicationFacade.EXECUSE_SCRIPT_NEW,new ScriptExecuseVO(1));
					}*/
					trace("0： "+PackData.app.CmdOStr[0]);
					trace("1： "+PackData.app.CmdOStr[1]);
					trace("2： "+PackData.app.CmdOStr[2]);
					trace("3： "+PackData.app.CmdOStr[3]);
					trace("4： "+PackData.app.CmdOStr[4]);
					trace("5： "+PackData.app.CmdOStr[5]);
					trace("6： "+PackData.app.CmdOStr[6]);
					if(PackData.app.CmdOStr[0] == "000"){
						//trace("提交成功！！！");
						view.mouseEnabled = false;
						var _rrl:String = PackData.app.CmdOStr[1]
						if(_rrl)	rrl=StringUtil.trim(_rrl);
						else	rrl="";
						trace("任务rrl "+rrl);
						rewardData = {right:RNum,wrong:WNum,time:time};
						var script:String = PackData.app.CmdOStr[3];
						trace("谚语："+script);
						rewardData.rrl = PackData.app.CmdOStr[1];
						/*var m:int = script.indexOf("<PAGE1"+">");
						var temp:int = script.indexOf("advancedPrint:",m);
						var j:int = script.indexOf("\n",temp);			
						var textArr:Array = script.substring(temp+14,j).split("`");//目标文本包含设置、答案提示
						trace("金币数 = "+String(textArr[10]).match(/\d+/));
						rewardData.gold = String(textArr[10]).match(/\d+/);		*/
						
						rewardData.gold = script;
						sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(RewardViewMediator,rewardData),new SwitchScreenVO(CleanCpuMediator)]);//奖励界面
					}
					break;
				case BEGIN_PRACTICE_TASK:
					if(PackData.app.CmdOStr[0] == "000"){
						PackData.app.CmdIStr[0] = CmdStr.GET_READING_TASK_ID;
						PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
						PackData.app.CmdIStr[2] = rrl;
						PackData.app.CmdInCnt =3;
						sendNotification(CoreConst.SEND_1N,new SendCommandVO(GET_PRACTICE_TASK));
					}
					break;
				case GET_PRACTICE_TASK:
					if(PackData.app.CmdOStr[0] == "000"){
						practiceId = PackData.app.CmdOStr[3];
						sendNotification(PracticeViewMediator.BEGIN_NEXT_PRACTICE,[rrl,practiceId,"R"]);
					}
					break;
				case FIRST_GET_PRACTICE_TASK : 
					if(PackData.app.CmdOStr[0] == "000"){
						practiceId = PackData.app.CmdOStr[3];
						status = "yy.E.";
						sendForQuestion(practiceId);
					}
					break;
			}
		}
		
		override public function listNotificationInterests():Array{
			return [GET_PRACTICE,TypeTool.EXECUTE_SHOW_QUESTION_FUNCTION,SUBMIT_TASK,BEGIN_PRACTICE_TASK,GET_PRACTICE_TASK,FIRST_GET_PRACTICE_TASK];
		}
		
		override public function onRegister():void
		{
			parentMediator = facade.retrieveMediator(PracticeViewMediator.NAME) as PracticeViewMediator;
			startSSS = getTimer();
			setUpVisualElement();
			
			browse.text = practiceId;
			
			setUpEventListener();
			
			
			init();
			
//			MyUtils.view.addEventListener(BonusViewMediator.CLICK_POP_UP_CONFIRM,clickConfirmHandler);
			
		}
		
		
		private function functionHandle(e:Event):void
		{
//			updateHolderHeight(LayoutToolUtils.holder as Sprite);
			if(isCheckRight){
				TweenLite.delayedCall(2,nextHandler,[null]);
			}
		}
		
		private function setUpEventListener():void{
			answer.addEventListener(KeyboardEvent.KEY_DOWN,enterAnswer);
			reason.addEventListener(KeyboardEvent.KEY_DOWN,enterReason);
			
			answer.addEventListener(FocusEvent.FOCUS_IN,getFocusHandler);
			reason.addEventListener(FocusEvent.FOCUS_IN,getFocusHandler);
			
			answer.addEventListener(Event.CHANGE,changedHandler);
			reason.addEventListener(Event.CHANGE,changedHandler);
			
			browse.addEventListener(KeyboardEvent.KEY_DOWN,browseHandler);
			
		}
		
		private var isChanged:Boolean = true;
		protected function changedHandler(event:Event):void
		{
			isChanged = true;
		}
		
		protected function confirmHandler(event:MouseEvent):void
		{
			checkInput();
		}
		
		protected function helpHandler(event:MouseEvent):void
		{
			trace("click help!");
			
		}
		private function getFocusHandler(event:FocusEvent):void{
			//sendNotification(WorldConst.USE_SIMPLE_KEYBOARD,false);
		}
		
		protected function browseHandler(event:KeyboardEvent):void
		{
			if(event.keyCode==10||event.keyCode==13){
				parentMediator.isBrowse = true;
				var mediator:PracticeViewMediator = facade.retrieveMediator(PracticeViewMediator.NAME) as PracticeViewMediator;
				mediator.initializeComponent(browse.text);
			}
			
		}
		private function getTimeFormat():String{
			
			var startTime:Date = Global.nowDate;
			
			var monthStr:String = String(startTime.month+1);
			monthStr = monthStr.length<2 ? "0"+monthStr:monthStr;
			
			var dateStr:String = startTime.date.toString();
			dateStr = dateStr.length<2 ? "0"+dateStr:dateStr;
			
			var hourStr:String = startTime.hours.toString();
			hourStr = hourStr.length<2 ? "0"+hourStr:hourStr;
			
			var minuteStr:String = startTime.minutes.toString();
			minuteStr = minuteStr.length<2 ? "0"+minuteStr:minuteStr;
			
			var secondStr:String = startTime.seconds.toString();
			secondStr = secondStr.length<2 ? "0"+secondStr:secondStr;
			
			var startTimeStr:String = startTime.fullYear.toString()+monthStr+dateStr+"-"+hourStr+minuteStr+secondStr;
			
			return startTimeStr;
		}
		/*protected function clickConfirmHandler(event:Event):void
		{
			sendNotification(ApplicationFacade.CLOSE_BONUS);
			beginNextTask()
		}*/
		private function checkReasonEmpty():Boolean{
			var reason:String = logic.getAnswer()[1];
			if(reason==""){
				return true;
			}else{
				return false;
			}
		}
		private function setReasonTA():void{
			if(checkReasonEmpty()){
				reason.text = "不用输入理由";
				reason.mouseEnabled = false;
				reason.selectable = false;
			}else{
				reason.mouseEnabled = true;
				reason.selectable = true;
				reason.prompt="请输入理由";
			}
		}
		protected function enterAnswer(event:KeyboardEvent):void
		{
			LayoutTool.clearSubHolder();
			isChanged = true;
			if(event.keyCode==10||event.keyCode==13){
				event.preventDefault();
				if(reason.mouseEnabled){
					reason.selectTextRange(0,reason.text.length);
				}else{
					checkInput();
				}
			}
		}
		
		protected function enterReason(event:KeyboardEvent):void
		{
			LayoutTool.clearSubHolder();
			isChanged = true;
			if(event.keyCode==10||event.keyCode==13){
				event.preventDefault();
				checkInput();
			}
		}
		private function checkInput():void{
			var _answer:String = answer.text;
			_answer = StringUtil.trim(_answer);
			_answer = _answer.replace(/\/+/g,"");
			if(reason.mouseEnabled){
				var _reason:String = reason.text;
				_reason = _reason.replace(/\/+/g,"");
			}else{
				_reason="";
			}
			if(_answer&&isChanged){
				check(_answer+"/"+_reason);
			}
		}
		private var isCheckRight:Boolean = false;
		private function check(_str:String):void{
			isChanged = false;
			var evo:ExerciseFlowVO = logic.checkAnswer(_str);
			if(!evo){
				return;
			}
			for(var i:int=0;i<itemArray.length;i++){
				if(currentIndex==itemArray[i].id){
					var item:ItemVO = itemArray[i] as ItemVO;
					if(!item.isCheck){
						item.isCheck = true;
						item.ANR = evo.ANR;
						item.userAnswer = _str;
						item.standardAnswer = evo.answer;
						if(evo.result){
							item.ROE="R";
						}else{
							item.ROE="E";
						}
					}
					item.isComplete = evo.result;
					if(evo.result){
						isCheckRight = true;
					}
				}
			}
			LayoutToolUtils.holder = tipHolder;
			LayoutTool.executeCustomTag(evo.tag);
			
			checkFinish();
			tipForUncomplete();
			focusOnWrong(evo);
			showResult(evo);
		}
		private function showResult(evo:ExerciseFlowVO):void{
			if(evo.ANR[0]){
				showIcon(answerSp,"check")
			}else{
				showIcon(answerSp,"cross")
			}
			if(reason.mouseEnabled){
				if(evo.ANR[1]){
					showIcon(reasonSp,"check")
				}else{
					showIcon(reasonSp,"cross")
				}
			}
		}
		private function showIcon(_parent:Sprite,icon:String):void{
			
			removeIcon(_parent);
			
			if(icon=="check"){
				var checkClass:Class = AssetTool.getCurrentLibClass("check");
			}else if(icon=="cross"){
				checkClass = AssetTool.getCurrentLibClass("cross");
			}
			
			var checkIcon:Sprite = new checkClass;
			_parent.addChild(checkIcon);
		}
		private function removeIcon(_group:Sprite):void{
			for(var i:int=0;i<_group.numChildren;i++){
				if(_group.getChildAt(i) is Sprite){
					_group.removeChildAt(i);
				}
			}
		}
//		private var wrongTA:TextArea;
		private function focusOnWrong(evo:ExerciseFlowVO):void{
			if(evo.ANR[0]){
				if(!evo.ANR[1]){
					reason.setFocus();
					reason.selectTextRange(0,reason.text.length);
				}else{
//					wrongTA = null;
				}
			}else{
				answer.setFocus();
				answer.selectTextRange(0,answer.text.length);
			}
		}
		private function checkFinish():void{
			var isFinish:Boolean = true;
			for(var i:int=0;i<itemArray.length;i++){
				if(itemArray[i].isComplete==false){
					isFinish = false;
					break;
				}
			}
			if(isFinish){
				submit();
			}
		}
		protected function nextHandler(event:MouseEvent):void
		{
			if(event)
				event.stopImmediatePropagation();
			view.stage.focus = null;
			isChanged = true;
			isCheckRight = false;
			TweenLite.killDelayedCallsTo(nextHandler);
			
			clearAnswerHolder();
			clearQuestionHolder();
			LayoutTool.clearSubHolder();
			
			removeIcon(answerSp);
			removeIcon(reasonSp);
			
			currentIndex++;
			if(currentIndex>totalPage){
				currentIndex=totalPage;
				checkFinish();
				if(unComplete.length>0){
					view.stage.focus = null;
					var str:String = "\n第"+unComplete.toString()+"题还没有答对,\n请根据提示输入正确答案并回车.";
					sendNotification(WorldConst.ALERT_SHOW,new AlertVo(str,false));
				}
			}
			LayoutToolUtils.holder = questionHolder;
			sendNotification(CoreConst.EXECUSE_SCRIPT_NEW,new ScriptExecuseVO(currentIndex));
			count.text = "第"+(currentIndex)+"题"+"/"+"共"+totalPage+"题";
			
			getInputString();
			tipForId();
			//answer.setFocus();
			//answer.selectRange(0,answer.text.length);
		}
		
		protected function prevHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			view.stage.focus = null;
			isChanged = true;
			isCheckRight = false;
			TweenLite.killDelayedCallsTo(nextHandler);
			
			clearAnswerHolder();
			clearQuestionHolder();
			LayoutTool.clearSubHolder();
			
			removeIcon(answerSp);
			removeIcon(reasonSp);
			
			currentIndex--;	
			if(currentIndex<1){
				currentIndex=1;
			}
			LayoutToolUtils.holder = questionHolder;
			sendNotification(CoreConst.EXECUSE_SCRIPT_NEW,new ScriptExecuseVO(currentIndex));
			
			count.text = "第"+(currentIndex)+"题"+"/"+"共"+totalPage+"题";
			
			getInputString();
			tipForId();
			answer.setFocus();
			answer.selectTextRange(0,answer.text.length);
		}
		private function clearQuestionHolder():void{
			while(questionHolder.numChildren>0){
				questionHolder.removeChildAt(0);
			}
		}
		private function getInputString():void{
			for(var i:int=0;i<itemArray.length;i++){
				if(currentIndex==itemArray[i].id){
					if(itemArray[i].userAnswer){
						var str:String = itemArray[i].userAnswer;
						var arr:Array = str.split("/");
						answer.text = String(arr[0]);
						reason.text = String(arr[1]);
					}
				}
			}
		}
		
		private var unComplete:Array;
		
		private function tipForUncomplete():void{
			unComplete = [];
			for(var i:int=0;i<itemArray.length;i++){
				if(!itemArray[i].isComplete){
					unComplete.push(itemArray[i].id);
				}
			}
			if(unComplete.length>0){
				uncomplete.text = "第"+unComplete.toString()+"题还没有答对";
			}else{
				uncomplete.text = "";
			}
		}
		
		private function tipForId():void{
			var id:String;
			var ids:Array = practiceId.split(",");
			for(var i:int=0;i<ids.length;i++){
				if(i==currentIndex-1){
					id = String(ids[i]);
				}
			}
			idIndicator.text = "当前id:  "+id;
		}
		private function clearAnswerHolder():void{
			answer.text = "";
			reason.text = "";
		}
		private function sendForQuestion(_id:String):void{
			PackData.app.CmdIStr[0] = CmdStr.GET_PRACTICE;
			PackData.app.CmdIStr[1] = _id;
			PackData.app.CmdInCnt =2;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(GET_PRACTICE));
		}
		
		/*private function updateHolderHeight(_holder:Sprite):void{
			var maxH:Number=0;
			var hh:Number;
			var item:DisplayObject;
			for (var i:int = 0; i < _holder.numChildren; i++) 
			{
				item = _holder.getChildAt(i);
				hh = item.height+item.y;
				if(maxH<hh){
					maxH=hh;
				}
			}
			_holder.height = maxH;
			var ss:Sprite = questionHolder;
		}*/
		
		private function init():void{
			isSubmit = false;
			unComplete = new Array;
			logic = new ExerciseLogicProxy();
			facade.registerProxy(logic);
			LayoutToolUtils.script = Vector.<String>(MyUtils.strLineToArray(longText));
			LayoutToolUtils.holder = questionHolder;
			LayoutToolUtils.pageQueue.dispatcher.addEventListener(FunctionQueueEvent.FUNCTION_COMPLETE,functionHandle);
			totalPage = SimpleScriptNewProxy.getTotalPage();
			count.text = "第"+(currentIndex)+"题"+"/"+"共"+totalPage+"题";
			sendNotification(CoreConst.EXECUSE_SCRIPT_NEW,new ScriptExecuseVO(currentIndex));
			
//			LayoutToolUtils.holder.graphics.beginFill(0xff0000);
//			LayoutToolUtils.holder.graphics.drawRect(0,0,500,400);
			
			for(var i:int=1;i<=totalPage;i++){
				itemArray.push(new ItemVO(i));
			}
			
			tipForUncomplete();
			tipForId();
			startTime = getTimeFormat();
			/*var d:Date = Global.nowDate;
			studyTime = d.valueOf();*/
		}
		
		private var count:Label;
		private var uncomplete:Label;
		private var idIndicator:Label;
		private var browse:TextInput;
		private var answer:TextFieldHasKeyboard;
		private var reason:TextFieldHasKeyboard;
		
		private var questionHolder:Sprite;
		private var questionScroll:Scroll;
		private var tipHolder:Sprite;
		
		private var answerSp:Sprite;
		private var reasonSp:Sprite;
		
		private function setUpVisualElement():void{
			var qbg:Class = AssetTool.getCurrentLibClass("questionBg");
			var questionBg:Sprite = new qbg;
			questionBg.x = 100; questionBg.y = 80;
			questionBg.height -= 50;
			view.addChild(questionBg);
			
			var tip:Class = AssetTool.getCurrentLibClass("tipBg");
			var tipBg:Sprite = new tip;
			tipBg.x = 190; tipBg.y = 505;
			view.addChild(tipBg);
			
			var confirmClass:Class = AssetTool.getCurrentLibClass("confirmBtn");
			var confirm:Sprite = new confirmClass;
			confirm.x = 600; confirm.y = 460;
			confirm.addEventListener(MouseEvent.CLICK,confirmHandler);
			view.addChild(confirm);
//			view.confirm.init(confirmClass,confirmClass)
			
			var helpClass:Class = AssetTool.getCurrentLibClass("helpBtn");
			var helpClassDown:Class = AssetTool.getCurrentLibClass("helpBtn_down");
			var help:Sprite = new helpClass;
			help.x = 960; help.y = 440;
			help.addEventListener(MouseEvent.CLICK,helpHandler);
			view.addChild(help);
//			view.help.init(helpClass,helpClassDown);
			
			var prevClass:Class = AssetTool.getCurrentLibClass("prevBtn");
			var prevClassDown:Class = AssetTool.getCurrentLibClass("prevBtn_down");
			var prev:Sprite = new prevClass;
			prev.x = 800; prev.y = 440;
			prev.addEventListener(MouseEvent.CLICK,prevHandler,false,1);
			view.addChild(prev);
//			view.prev.init(prevClass,prevClassDown);
			
			var nextClass:Class = AssetTool.getCurrentLibClass("nextBtn");
			var nextClassDown:Class = AssetTool.getCurrentLibClass("nextBtn_down");
			var next:Sprite = new nextClass;
			next.x = 880; next.y = 440;
			next.addEventListener(MouseEvent.CLICK,nextHandler,false,1);
			view.addChild(next);
//			view.next.init(nextClass,nextClassDown);
			
			var closeClass:Class = AssetTool.getCurrentLibClass("closeBtn");
			var close:Sprite = new closeClass;
			close.x = 1190;
//			close.addEventListener(MouseEvent.CLICK,exitHandler);
//			view.addChild(close);
//			view.close.init(closeClass,closeClass);
			
			var bgClass:Class = AssetTool.getCurrentLibClass("bg");
			view.addChildAt(new bgClass, 0);
			
			count = new Label();
			count.x = 100; count.y = 450;
			view.addChild(count);
			
			uncomplete = new Label();
			uncomplete.x = 100; uncomplete.y = 470;
			view.addChild(uncomplete);
			
			idIndicator = new Label();
			idIndicator.x = 100; idIndicator.y = 490;
			view.addChild(idIndicator);
			 
			browse = new TextInput();
			browse.x = 600;
			browse.addEventListener(KeyboardEvent.KEY_DOWN,browseHandler);
			view.addChild(browse);
			
			var textFieldBg:Sprite = new Sprite();
			textFieldBg.graphics.lineStyle(1);
			textFieldBg.graphics.beginFill(0xFFFFFF);
			textFieldBg.graphics.drawRect(100, 335, 1069, 45);
			textFieldBg.graphics.endFill();
			view.addChild(textFieldBg);
			answer = new TextFieldHasKeyboard();
			answer.width = 1069; answer.height = 45;
			answer.x = 100; answer.y = 340;
			answer.defaultTextFormat = new TextFormat("HeiTi",25);
			answer.prompt = "请输入答案";
			view.addChild(answer);
			
			textFieldBg = new Sprite();
			textFieldBg.graphics.lineStyle(1);
			textFieldBg.graphics.beginFill(0xFFFFFF);
			textFieldBg.graphics.drawRect(100, 385, 1069, 45);
			textFieldBg.graphics.endFill();
			view.addChild(textFieldBg);
			reason = new TextFieldHasKeyboard();
			reason.width = 1069; reason.height = 45;
			reason.x = 100; reason.y = 390;
			reason.defaultTextFormat = new TextFormat("HeiTi",25);
			reason.prompt = "请输入理由";
			view.addChild(reason);
			
			questionHolder = new Sprite();
			/*questionHolder.x = 110; questionHolder.y = 90;
			view.addChild(questionHolder);*/
			
			questionScroll = new Scroll();
			questionScroll.x = 110; questionScroll.y = 90;
			questionScroll.width = 1057;
			questionScroll.height = 239;
			questionScroll.viewPort = questionHolder;
			view.addChild(questionScroll);
			
			tipHolder = new Sprite();
			tipHolder.x = 210; tipHolder.y = 525;
			view.addChild(tipHolder);
			
			answerSp = new Sprite();
			answerSp.x = 1189; answerSp.y = 335;
			view.addChild(answerSp);
			
			reasonSp = new Sprite();
			reasonSp.x = 1189; reasonSp.y = 385;
			view.addChild(reasonSp);
		}
		
		private function countRightList():Array{
			var rightArray:Array = [];
			var ids:Array = practiceId.split(",");
			for(var i:int=0;i<itemArray.length;i++){
				if(itemArray[i].ROE=="R"){
					rightArray.push(ids[i]);
					itemArray[i].wordId = ids[i];
				}
			}
			return rightArray;
		}
		private function countWrongList():Array{
			var wrongArray:Array = [];
			var ids:Array = practiceId.split(",");
			for(var i:int=0;i<itemArray.length;i++){
				if(itemArray[i].ROE=="E"){
					wrongArray.push(ids[i]);
					itemArray[i].wordId = ids[i];
				}
			}
			return wrongArray;
		}
		
		private var RNum:int;
		private var WNum:int;
		private var time:int;
		private function submit():void{
			TweenLite.killDelayedCallsTo(nextHandler);
			if(!subMitSucced){
				subMitSucced = true;
				
				endTime = getTimeFormat();
				/*var d:Date = Global.nowDate;
				var v:int = d.valueOf();
				var t:int = (v-studyTime)/1000;*/
				
				
				var rightList:Array = countRightList();
				var wrongList:Array = countWrongList();
				
				var s1:String = String(rightList.length);
				var s2:String = String(wrongList.length);
				var result:String = combineAnswerResult();
				var rate:String = String(int((rightList.length/totalPage)*100));
				
				RNum = rightList.length;
				WNum = wrongList.length;
//				time = t;
				
				time = (getTimer()-startSSS)*0.001;
				PackData.app.CmdIStr[0] = CmdStr.SUBMIT_PRACTICE_TASK;
				PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
				PackData.app.CmdIStr[2] = rrl;
				PackData.app.CmdIStr[3] = practiceId;
				PackData.app.CmdIStr[4] = String(time);//#学习时长(秒数)
				PackData.app.CmdIStr[5] = s1;//学习正确数
				PackData.app.CmdIStr[6] = s2;//学习错误数
				PackData.app.CmdIStr[7] = String(totalPage);//学习总数
				PackData.app.CmdIStr[8] = rate;//#学习结果正确率，取值0-100
				PackData.app.CmdIStr[9] = startTime;//开始学习时间(YYYYMMDD-hhnnss)；20120316-155822
				PackData.app.CmdIStr[10] = endTime;//结束学习时间(YYYYMMDD-hhnnss)；20120316-160045
				PackData.app.CmdIStr[11] = wrongList.join(",");//出错题目id串','分隔
				PackData.app.CmdIStr[12] = rightList.join(",");//正确题目id串','分隔
				PackData.app.CmdIStr[13] = result;
				PackData.app.CmdInCnt =14;
				
				sendNotification(CoreConst.SEND_11,new SendCommandVO(SUBMIT_TASK));
			}			
			
		}
		/*protected function beginNextTask():void
		{
			if(rrl){
				if(rrl.indexOf("yy.E.")!=-1){
					PackData.app.CmdIStr[0] = CmdStr.BEGIN_ONE_TASK;
					PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
					PackData.app.CmdIStr[2] = rrl;
					PackData.app.CmdInCnt = 3;
					sendNotification(ApplicationFacade.SEND_1N,new SendCommandVO(BEGIN_PRACTICE_TASK));
				}else{
					sendNotification(ApplicationFacade.BEGIN_NEXT_TASK,rrl);
				}
			}else{
				LayoutToolUtils.killLayoutScript();
				sendNotification(WorldConst.POP_SCREEN);
			}
		}*/
		private function combineAnswerResult():String{
			var result:String="";
			var item:ItemVO;
			for(var i:int=0;i<itemArray.length;i++){
				item = itemArray[i] as ItemVO;
				result += "IDS`"+item.id+"`"+item.ROE+"`"+item.userAnswer+"`"+item.standardAnswer+'`'+item.wordId+"\n";
			}
			return result;
		}
		/*protected function exitHandler(event:MouseEvent):void
		{
			if(Global.OS!=OSType.WIN){
//				SkinnableAlert.show("确定要退出吗？","Tips",SkinnableAlert.YES|SkinnableAlert.NO,null,alertTips);
			}else{
				LayoutToolUtils.killLayoutScript();
				sendNotification(ApplicationFacade.POP_VIEW);
			}
		}*/		
		/*private function alertTips(e:CloseEvent):void
		{
			if(e.detail == SkinnableAlert.YES){
				LayoutToolUtils.killLayoutScript();
				sendNotification(ApplicationFacade.POP_VIEW);
			}
		}*/
		public function get view():Sprite{
			return viewComponent as Sprite;
		}
		
		override public function get viewClass():Class{
			return Sprite;
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			prepareVO = vo;
			rrl = prepareVO.data.rrl;
			practiceId = prepareVO.data.practiceId;
			status = prepareVO.data.status;
			if(practiceId != null){
				sendForQuestion(practiceId);
			}else{
				PackData.app.CmdIStr[0] = CmdStr.GET_READING_TASK_ID;
				PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
				PackData.app.CmdIStr[2] = rrl;
				PackData.app.CmdInCnt =3;
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(FIRST_GET_PRACTICE_TASK));
			}
		}
		
	}
}