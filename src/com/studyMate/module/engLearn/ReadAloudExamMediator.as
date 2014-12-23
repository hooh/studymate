package com.studyMate.module.engLearn
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.SoundGroup2Proxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.SoundVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.engLearn.api.LearnConst;
	import com.studyMate.module.engLearn.ui.LinkMatchUI;
	import com.studyMate.module.engLearn.vo.ReadAloudVO;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.controller.vo.UpdateTaskDataVO;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.model.vo.LoadSoundEffectVO;
	import com.studyMate.world.model.vo.PlaySoundEffectVO;
	import com.studyMate.world.screens.CleanCpuMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import mx.utils.StringUtil;
	
	import myLib.myTextBase.utils.SoftKeyBoardConst;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.text.TextField;
	
	import stateMachine.StateMachine;
	import stateMachine.StateMachineEvent;
	
	
	/**
	 * 考核阶段
	 * 2014-10-20上午11:59:13
	 * Author wt
	 *
	 */	
	
	public class ReadAloudExamMediator extends EgLearnBaseMediator
	{
		public const NAME:String = 'ReadAloudExamMediator';
		
		private const Abandon_QUIT:String = NAME + "Abandon_QUIT"
		public const SUBMIT_TASK_COMPLETE:String = NAME + 'submit';
		private const ABANDON_TASK_COMPLETE:String = NAME+ "AbandonTask";
		
		private var index:int=0;
		private var dataVec:Vector.<ReadAloudVO>;
		private var prepareVO:SwitchScreenVO;	
		
		private var isPlaying:Boolean;
		private var soundGroup:SoundGroup2Proxy;
		
		private var _fsm:StateMachine;
		private const listenTapeState:String = 'listenTapeState';
		private const fillBlanksState:String = 'fillBlanksState';
		private const judgefillResult:String = 'auditionCompleteState';
		private const connectionState:String = 'evaluateState';
		private const submitState:String = 'submitState';
		private const abandonState:String = 'abandonState';
		
		private var right:int;
		private var wrong:int;
		private var total:int;
		private var startTime:String;
		private var startSS:Number;
		private var costTime:String;
		private var result:String = ' ';
		private var notesVec:Vector.<String>;
		
		public function ReadAloudExamMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
				
		override public function onRemove():void
		{
			Global.stage.removeEventListener(MouseEvent.CLICK,clickHandler);
			sendNotification(CoreConst.REMOVE_EFFECT_SOUND,'wordRight');
			sendNotification(CoreConst.REMOVE_EFFECT_SOUND,'wordError');
			facade.removeProxy(SoundGroup2Proxy.NAME);
			TweenLite.killDelayedCallsTo(soundHandler);
			super.onRemove();
		}
		override public function onRegister():void
		{
			super.onRegister();
			notesVec = new Vector.<String>;
			soundGroup = new SoundGroup2Proxy();
			facade.registerProxy(soundGroup);
			sendNotification(CoreConst.LOAD_EFFECT_SOUND,new LoadSoundEffectVO(MyUtils.getSoundPath("wordRight.mp3"),"wordRight"));
			sendNotification(CoreConst.LOAD_EFFECT_SOUND,new LoadSoundEffectVO(MyUtils.getSoundPath("Errortip.mp3"),"wordError"));
			
//			view.soundBtn.addEventListener(Event.TRIGGERED,soundHandler);
			Global.stage.addEventListener(MouseEvent.CLICK,clickHandler);

			
			startTime = MyUtils.getTimeFormat();
			startSS = getTimer();
			
			(facade.retrieveMediator(ReadAloudBGMediator.NAME) as ReadAloudBGMediator).backHandle = function():void{
				Facade.getInstance(CoreConst.CORE).sendNotification(SoftKeyBoardConst.HIDE_SOFTKEYBOARD);
				sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n要放弃该阶段任务吗？",true,Abandon_QUIT));//提交订单

			};
			
			_fsm = new StateMachine();
			_fsm.addState(listenTapeState,{enter:listenTapeStateHandler,from:[fillBlanksState]});
			_fsm.addState(fillBlanksState,{enter:fillBlanksStateHandler, from:[listenTapeState]});
			_fsm.addState(connectionState,{enter:connectionStateHandler, from:[fillBlanksState]});
			_fsm.addState(submitState,{enter:submitStateHandler, from:[connectionState]});
			_fsm.addState(abandonState,{enter:abandonStateHandler, from:["*"]});
			_fsm.initialState = listenTapeState;
		}
		
		protected function clickHandler(event:MouseEvent):void
		{
			if(checkTouch(view.soundBtn,event.stageX,event.stageY/Global.heightScale)){
				event.stopImmediatePropagation();
				soundHandler();
			}
		}
		private var resultPoint:Point=new Point;
		private function checkTouch(displayObject:DisplayObject,globalX:Number,globalY:Number):Boolean{
			if(displayObject &&　displayObject.stage){
				displayObject.globalToLocal(new Point(globalX,globalY),resultPoint);
				if( displayObject.hitTest(resultPoint)){
					return true;
				}else{
					return false;
				}
			}else{
				return false;
			}
		}
		
		private function soundHandler(e:Event=null):void
		{
			isPlaying = true;
			soundGroup.stop();
			var aloudVO:ReadAloudVO = dataVec[index];
			var soundVO:SoundVO = new SoundVO(aloudVO.soundPath,aloudVO.starttime,aloudVO.durtime);
			soundGroup.play(soundVO);
			
		}
		
		
		
		
		
		
		
		/************************** 状态机**************************************************/
		
		//听录音状态
		private function listenTapeStateHandler(event:StateMachineEvent):void{
			view.container.visible = false;
			view.fillUI.visible = false;
			view.listenTip.visible = true;
			view.bgImg.visible = false;
//			soundHandler();
			TweenLite.delayedCall(1,soundHandler);
		}

		//填空状态
		private function fillBlanksStateHandler(event:StateMachineEvent):void{
			view.container.visible = true;
			view.fillUI.visible = true;
			view.listenTip.visible = false;
			view.bgImg.visible = true;
			view.fillUI.updateTitle(dataVec[index]);
		}

		//连线状态
		private function connectionStateHandler(event:StateMachineEvent):void{
			view.container.removeChildren(0,-1,true);
			view.listenTip.removeFromParent(true);
			view.bgImg.width = 1246;
			view.bgImg.height = 696;
			view.bgImg.x = 23;
			view.bgImg.y = 12;
			var linkUI:LinkMatchUI = new LinkMatchUI();
			linkUI.dataProvid(dataVec);
			linkUI.x = 118;
			linkUI.y = 131;
			var txtTip:TextField = new TextField(328,30,'将下面的英文连接到正确的中文','HeiTi',22,0xCCCCCC,true);
			txtTip.x = 180;
			txtTip.y = 73;
			view.addChild(txtTip);
			view.addChild(linkUI);
		}
		//提交结果状态
		private function submitStateHandler(event:StateMachineEvent):void{
			if(!isSubmit){		
				view.touchable = false;	
				isSubmit = true;
				submit(CmdStr.SUBMIT_YYDaily,SUBMIT_TASK_COMPLETE);
			}
		}
		private function abandonStateHandler(event:StateMachineEvent):void{
			if(!isSubmit){				
				view.touchable = false;	
				isSubmit = true;
				submit(CmdStr.ANDON_YYDaily,ABANDON_TASK_COMPLETE);
			}
		}
		
		private function submit(cmd:String,recive:String):void{
			costTime = String(int((getTimer() - startSS)*0.001));
			for(var i:int=0;i<notesVec.length;i++){
				result += 'IDS`'+i+notesVec[i]+'\n';
			}
			var idArr:Array = [];
			for(i=0;i<dataVec.length;i++){
				idArr.push(dataVec[i].rankid);
			}
			if(dataVec.length<5){
				total = right+wrong;
			}else{				
				total = dataVec.length+5;
			}
			var  rate:String = String(int((right/total)*100));
			PackData.app.CmdIStr[0] = cmd;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = prepareVO.data.rrl;
			PackData.app.CmdIStr[3] = prepareVO.data.topic;
			PackData.app.CmdIStr[4] = costTime;//#学习时长(秒数)
			PackData.app.CmdIStr[5] = rate;///#学习结果正确率，取值0-100
			PackData.app.CmdIStr[6] = right.toString();//学习正确数
			PackData.app.CmdIStr[7] = wrong.toString();//学习错误数
			PackData.app.CmdIStr[8] = total.toString();//学习总数
			PackData.app.CmdIStr[9] = startTime;//开始学习时间(YYYYMMDD-hhnnss)；20120316-155822
			PackData.app.CmdIStr[10] = MyUtils.getTimeFormat();//结束学习时间(YYYYMMDD-hhnnss)；20120316-160045
			PackData.app.CmdIStr[11] = result;
			PackData.app.CmdInCnt =12;			
			sendNotification(CoreConst.SEND_11,new SendCommandVO(recive));
		}
		
		
		
		override public function handleNotification(notification:INotification):void
		{
			super.handleNotification(notification);
			switch(notification.getName()){
				case LearnConst.SOUND_COMPLETE:
					isPlaying = false;
					_fsm.changeState(fillBlanksState);
					break;
				case LearnConst.NEXT_ALOUD:
					index++;
					if(index==dataVec.length){
						_fsm.changeState(connectionState);
					}else{						
						_fsm.changeState(listenTapeState);
					}
					break;
				case LearnConst.ANSWER_RIGHT:
					right++;
					notesVec.push(notification.getBody());
					break;
				case LearnConst.ANSWER_WRONG:
					wrong++;
					notesVec.push(notification.getBody());
			
					break;
				case LearnConst.LINK_COMPLETE:
					var linkTotl:String = notification.getBody() as String;
					notesVec.push(linkTotl);
					_fsm.changeState(submitState);
					break;
				case SUBMIT_TASK_COMPLETE:
					trace(PackData.app.CmdOStr[0]);
					trace(PackData.app.CmdOStr[1]);					
					trace(PackData.app.CmdOStr[2]);
					trace(PackData.app.CmdOStr[3]);
					trace(PackData.app.CmdOStr[4]);
					sendNotification(WorldConst.UPDATE_TASK_DATA,new UpdateTaskDataVO('yy.D',prepareVO.data.rrl,'Z',int(right/total*100).toString()));

					var result:DataResultVO = notification.getBody() as DataResultVO;
					if(!result.isErr){
						var rewardData:Object={};
						var _rrl:String = PackData.app.CmdOStr[1]
						if(_rrl)	_rrl=StringUtil.trim(_rrl);
						else	_rrl="";
						rewardData = {right:dataVec.length+1,wrong:0,time:costTime};
						var script:String = PackData.app.CmdOStr[3];
						rewardData.rrl = _rrl;						
						rewardData.gold = script;
						rewardData.oralid = PackData.app.CmdOStr[2];
						sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(RewardViewMediator,rewardData),new SwitchScreenVO(CleanCpuMediator)]);//奖励界面
					}else if(PackData.app.CmdOStr[0] == "EEE"){
						sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n抱歉，朗读提交失败。请通过faq反馈我们.",false));//提交订单
					}else if((PackData.app.CmdOStr[0] as String).charAt(0)=="M"){
						sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n抱歉，返回数据出错。请通过faq反馈我们.",false));//提交订单
					}
					break;
				case WorldConst.GET_SCREEN_FAQ:
					if(index<=dataVec.length){						
						var str1:String = "朗读界面/LEA:"+prepareVO.data.LEA+",topic:"+prepareVO.data.topic+",id:"+dataVec[index].rankid;
					}else{
						var idArr:Array = [];
						for(var i:int=0;i<dataVec.length;i++){
							idArr.push(dataVec[i].rankid);
						}
						str1 = "朗读界面/LEA:"+prepareVO.data.LEA+",topic:"+prepareVO.data.topic+",连线题:"+idArr.join(',');
					}
					sendNotification(WorldConst.SET_SCREENT_FAQ,str1);
					break;
				case Abandon_QUIT:
					_fsm.changeState(abandonState);
					break;
				case ABANDON_TASK_COMPLETE:
					sendNotification(WorldConst.POP_SCREEN);	
					break;
				case LearnConst.RESET_SOUND://回答错误重新听录音
					if(_fsm.state == fillBlanksState && !isPlaying){
						soundHandler();
					}					
					break;
				case CoreConst.DEACTIVATE:
					soundGroup.stop();
					isPlaying = false;
					break;
			}
		}
		override public function listNotificationInterests():Array
		{
			return [
				LearnConst.SOUND_COMPLETE,LearnConst.NEXT_ALOUD,LearnConst.ANSWER_RIGHT,LearnConst.ANSWER_WRONG,LearnConst.LINK_COMPLETE,
				SUBMIT_TASK_COMPLETE,Abandon_QUIT,WorldConst.GET_SCREEN_FAQ,ABANDON_TASK_COMPLETE,LearnConst.RESET_SOUND,CoreConst.DEACTIVATE
			];
		}
		override public function get viewClass():Class
		{
			return ReadAloudExamView;
		}
		
		public function get view():ReadAloudExamView{
			return getViewComponent() as ReadAloudExamView;
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			prepareVO = vo;
			dataVec = prepareVO.data.dataVec;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,prepareVO);
		}
	}
}