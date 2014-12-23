package com.studyMate.module.classroom
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.classroom.ui.ExQuestionUIExtend;
	import com.studyMate.module.engLearn.vo.ExercisesVO;
	import com.studyMate.world.component.weixin.VoicechatComponent;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	/**
	 * 教室辅导界面的。左侧题目界面
	 * 控制习题题目切换和显示
	 * @author wt
	 * 
	 */	
	internal class ExercisesLeftMediator extends ScreenBaseMediator
	{
		public static const NAME:String = 'ExercisesLeftMediator';
		
		private const GET_EX_INFO:String = NAME+'GetExInfo';//查询习题内容
		private const CHAGE_RESULT:String = NAME + 'changeResult';
		
		private var exVec:Vector.<ExercisesVO>;
		private var croomVO:CroomVO;
		
		private var examQuestionUI:ExQuestionUIExtend;
		private var titleTxt:TextField;
		private var preBtn:Button;
		private var nextBtn:Button;
		private var tipBtn:Button;
		private var completeBtn:Button;//辅导完毕
				
		public var current_Qid:String=''; //当前题目id号
		private var beat_qid:String;		//心跳返回的题目id号
		private var index:int;				//题目数组索引
		private var tempChange:Boolean;//零时改变序号
		
		public function ExercisesLeftMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function onRemove():void{
			Global.stage.removeEventListener(MouseEvent.CLICK,stageClickHandler);
			if(examQuestionUI){
				examQuestionUI.removeFromParent(true);
				examQuestionUI = null;
			}
			croomVO = null;
			TweenLite.killDelayedCallsTo(cmdUpCurrentQid);
			exVec = null;			
			super.onRemove();
		}
		override public function onRegister():void{
			exVec = new Vector.<ExercisesVO>;
			
			cmdGetExInfo();//获取习题题目
			
			preBtn = new Button(Assets.getCnClassroomTexture('preBtn'));
			preBtn.x = 24;
			preBtn.y = 684;
			view.addChild(preBtn);
			
			nextBtn = new Button(Assets.getCnClassroomTexture('nextBtn'));
			nextBtn.x = 108;
			nextBtn.y = 684;
			view.addChild(nextBtn);
			
			tipBtn = new Button(Assets.getCnClassroomTexture('logBtn'));
			tipBtn.x = 24;
			tipBtn.y = 15;
			view.addChild(tipBtn);
//			tipBtn.addEventListener(Event.TRIGGERED,tipHandler);			
			preBtn.addEventListener(Event.TRIGGERED,preHandler);
			nextBtn.addEventListener(Event.TRIGGERED,nextHandler);
			

			
			if(PackData.app.head.dwOperID.toString() == croomVO.tid){
				if(!CRoomConst.isComplete){
					completeBtn = new Button(Assets.getCnClassroomTexture('completeBtn'));
					completeBtn.x = 535;
					completeBtn.y = 683;
					view.addChild(completeBtn);
					completeBtn.addEventListener(Event.TRIGGERED,explainedHandler);
				}
			}
			
			titleTxt = new TextField(434,38,'习题','HeiTi',27,0x7f2d00,true);
			titleTxt.hAlign = HAlign.LEFT;
			titleTxt.autoScale = true;
			titleTxt.x = 93;
			titleTxt.y = 30;
			titleTxt.touchable = false;
			view.addChild(titleTxt);
			
			
			Global.stage.addEventListener(MouseEvent.CLICK,stageClickHandler,false,5);
		}
		
		public function stageClickHandler(event:MouseEvent):void
		{
			if(tipBtn.getBounds(Starling.current.stage).contains(event.stageX,event.stageY)){
				event.stopImmediatePropagation();
				tipHandler();
			}
				
		}
		
		private function tipHandler():void
		{
			if(exVec[index]){
				var explainVO:ExplainVO = new ExplainVO();
				explainVO.questionId = exVec[index].id;
				explainVO.standard = '正确答案:'+exVec[index].answer + '\nTip1: '+exVec[index].help_1+'\nTip2: '+exVec[index].help_2;
				explainVO.studentId = croomVO.sid;
				explainVO.title = titleTxt.text;
				explainVO.detailed = exVec[index].detail;
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ExplanationMediator,explainVO,SwitchScreenType.SHOW)]);
			}			
		}
		
		private function sendCxHistory():void{
			if(exVec[index]){
				var explainVO:ExplainVO = new ExplainVO();
				explainVO.questionId = exVec[index].id;
				explainVO.standard = '正确答案:'+exVec[index].answer + '\nTip1: '+exVec[index].help_1+'\nTip2: '+exVec[index].help_2;
				explainVO.studentId = croomVO.sid;
				explainVO.title = titleTxt.text;
				explainVO.detailed = exVec[index].detail;
				sendNotification(CRoomConst.USERCX_HISTORY,explainVO);
			}	
		}
		
		private function explainedHandler():void
		{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(AlertCompleteMediator,null,SwitchScreenType.SHOW)]);

		}
		
		private function nextHandler():void
		{		
			if(index<exVec.length-1){
				index++;
				indexReadQuestion();
			}
		}
		
		private function preHandler():void
		{
			if(index>0){
				index--;
				indexReadQuestion();
			}
		}
		
		
		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()) {
				case GET_EX_INFO://获取习题内容
					if(!result.isEnd){
						var exercisesVO:ExercisesVO = new ExercisesVO(PackData.app.CmdOStr[2]);
						exercisesVO.id = PackData.app.CmdOStr[1];
						exVec.push(exercisesVO);
					}else if(result.isEnd){
						sendNotification(CoreConst.SET_BEAT_DUR,2);
						Facade.getInstance(CoreConst.CORE).registerCommand(CoreConst.BEAT,ClassBeatCommand);
						sendNotification(CoreConst.START_BEAT);	
						if(exVec.length<=1){
							preBtn.visible = false;
							nextBtn.visible = false;
						}
					}else if(result.isErr){
						sendNotification(CoreConst.TOAST,new ToastVO('获取习题错误'))
					}
					break;
				case WorldConst.BROADCAST_CLASS:
					if((PackData.app.CmdOStr[0] as String)=="000"){
						beat_qid = PackData.app.CmdOStr[1];//题目id号
						
						viewUpdate();
					}
					break;
				case CHAGE_RESULT:
					tempChange = false;
					if(!result.isErr){
//						trace('修改房间号 成功',PackData.app.CmdOStr[2]);
						current_Qid = PackData.app.CmdOStr[2];
					}else{	
						sendNotification(CoreConst.TOAST,new ToastVO('更新失败，无法同步对方的平板'));
					}
					break;
				case CRoomConst.MARK_RW_COMPLETE:
					if(!result.isErr){
						sendNotification(CoreConst.TOAST,new ToastVO('后台已确认,该任务已辅导！'));
					}else{
						sendNotification(CoreConst.TOAST,new ToastVO('辅导标记返回错误！'));
					}
					if(completeBtn){
						completeBtn.visible = false;
					}
					break;
				
			}
		}
		override public function listNotificationInterests():Array{
			return [GET_EX_INFO,WorldConst.BROADCAST_CLASS,CHAGE_RESULT,CRoomConst.MARK_RW_COMPLETE];
		}
		
		//根据心跳数据,判断界面变更
		private function viewUpdate():void{
			if(tempChange) return;//如果是零时改变则不变动
			if(beat_qid =='0' && current_Qid ==''){//初次进入
				if(exVec.length>0){								
					current_Qid = exVec[0].id;
					beatReadyQuestion();
				}else{
					sendNotification(CoreConst.TOAST,new ToastVO('没有安排题目'));
//					trace('没有安排题目');
				}
			}else if(beat_qid != current_Qid){//题号有变更
				current_Qid = beat_qid;
				beatReadyQuestion();
			}				
		}
		
		//心跳准备当前id号的题目
		private function beatReadyQuestion():void{	
//			trace('刷新界面');
			for(var i:int=0;i<exVec.length;i++){
				if(exVec[i].id == current_Qid){
					index = i;
					if(examQuestionUI){
						examQuestionUI.removeFromParent(true);
						examQuestionUI = null;
					}
					examQuestionUI = new ExQuestionUIExtend(exVec[i].question,exVec[i].items);
					view.addChildAt(examQuestionUI,1);
					titleTxt.text = '('+(index+1)+'/'+exVec.length+')'+'习题ID:'+ current_Qid;
					enableBtnHandler();					
					sendCxHistory();//查询历史记录
					
//					if(CRoomConst.isComplete){//如果没完成则可以传题号	
//						VoicechatComponent.owner.searchMsg('qid',current_Qid);
//					}
					break;
				}
			}					
		}
		//索引,显示当前索引的题目,零时改变的
		private function indexReadQuestion():void{
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("indexReadQuestion s","ExerciseLeft",0));

			tempChange = true;
//			trace('刷新界面');
			if(examQuestionUI){
				examQuestionUI.removeFromParent(true);
				examQuestionUI = null;
			}
			examQuestionUI = new ExQuestionUIExtend(exVec[index].question,exVec[index].items);
			view.addChildAt(examQuestionUI,1);			
			titleTxt.text = '('+(index+1)+'/'+exVec.length+')'+'习题ID:'+ exVec[index].id;			
			enableBtnHandler();
			sendCxHistory();//查询历史记录
			
			if(!CRoomConst.isComplete){//如果没完成则可以传题号			
				TweenLite.killDelayedCallsTo(cmdUpCurrentQid);
				TweenLite.delayedCall(0.5,cmdUpCurrentQid,[exVec[index].id]);
			}else{//完成则更新聊天滚动
//				VoicechatComponent.owner.searchMsg('qid',exVec[index].id);
				(facade.retrieveMediator(ExerciseRightMediator.NAME) as ExerciseRightMediator).chatAndVoice.searchMsg('qid',exVec[index].id);
			}
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("indexReadQuestion e","ExerciseLeft",0));

		}
		
		private function enableBtnHandler():void{
			if(exVec.length>1){
				if(index==0){
					preBtn.enabled = false;
					nextBtn.enabled = true;
				}else if(index == exVec.length-1){
					preBtn.enabled = true;
					nextBtn.enabled = false;
				}else{
					preBtn.enabled = true;
					nextBtn.enabled = true;
				}
			}			
		}
		
		
		//根据id串查询习题
		private function cmdGetExInfo():void{
			PackData.app.CmdIStr[0] = CmdStr.GET_READING_INFO;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = croomVO.qids;
			PackData.app.CmdInCnt = 3;
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(GET_EX_INFO));
		}
		
		//上传当前题号,不用返回
		private function cmdUpCurrentQid(current_Qid:String):void{
			PackData.app.CmdIStr[0] = CmdStr.UP_CR_CURRENTQID;
			PackData.app.CmdIStr[1] = croomVO.crid; //教室标识
			PackData.app.CmdIStr[2] = croomVO.tid;  //老师标识
			PackData.app.CmdIStr[3] = current_Qid;	//当前题目的标识
			PackData.app.CmdInCnt = 4;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(CHAGE_RESULT,null,'cn-gb',null,SendCommandVO.QUEUE|SendCommandVO.UNIQUE));
			
		}	
		
		override public function get viewClass():Class{
			return Sprite;
		}		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function prepare(vo:SwitchScreenVO):void{	
			croomVO = vo.data as CroomVO;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}		
		
	}
}