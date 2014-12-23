package com.studyMate.module.classroom
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.framework.utils.CacheTool;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.component.weixin.SpeechConst;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.module.classroom.view.CRExplantionView;
	
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.events.Event;
	
	
	/**
	 * 答题解析与答题情况
	 * 2014-6-6下午12:01:48
	 * Author wt
	 *
	 */	
	
	public class ExplanationMediator extends ScreenBaseMediator
	{
		private const NAME:String = 'ExplanationMediator';
		private var pareVO:SwitchScreenVO;
		
		private var vec:Vector.<ExamHistVO>;
		private const HISTORY_LIST:String = 'examhistoryList';
		private var explainVO:ExplainVO ;
		private var rect:Rectangle;
		private var isEnd:Boolean;
		private var sendBtn:Button;
		
		public function ExplanationMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function onRemove():void{
			super.onRemove();
			TweenLite.killTweensOf(view);
//			AppLayoutUtils.cpuLayer.visible = true;
			sendNotification(SpeechConst.HIDE_EXPLAINATION);
			
			Global.stage.removeEventListener(MouseEvent.CLICK,stageClickHandler);

		}
		
		override public function onRegister():void{
//			AppLayoutUtils.cpuLayer.visible = false;
			sendNotification(SpeechConst.SHOW_EXPLAINATION);
			view.titleTxt.text =explainVO.title;
			
			rect = new Rectangle(0,0,1280,762);
			rect.x = -1280;
			runEnterFrames = true;
			
			
			var tid:String = CacheTool.getByKey(ClassroomMediator.NAME,'tid') as String; //老师标识
			if(!CRoomConst.isComplete && PackData.app.head.dwOperID.toString() == tid){
				sendBtn = new Button(Assets.getCnClassroomTexture('sendDetailedBtn'));
				sendBtn.x = 1040;
				sendBtn.y = 690;
				view.addChild(sendBtn);
				sendBtn.addEventListener(Event.TRIGGERED,sendHandler);
			}
		}
		
		private function sendHandler():void
		{
			if(view.analysisText!=''){
				sendNotification(CRoomConst.INSERT_TEXT,view.analysisText);
				closeHandler();
			}
		}
		
		private var ease:int;
		override public function advanceTime(time:Number):void
		{
			if(isEnd){
				ease+=5;
				rect.x -= ease;
				if(rect.x <= - 1280){
					runEnterFrames = false;
					pareVO.type = SwitchScreenType.HIDE;
					sendNotification(WorldConst.SWITCH_SCREEN,[pareVO]);
				}
			}else{				
				ease+=5;
				rect.x += ease;
				if(rect.x >=0){
					rect.x = 0;
					ease = 0;
					runEnterFrames = false;
//					view.closeBtn.addEventListener(Event.TRIGGERED,closeHandler);
					Global.stage.addEventListener(MouseEvent.CLICK,stageClickHandler,false,6);
					showAnalysis();
					view.tabs.addEventListener(Event.CHANGE, tabs_changeHandler );
				}
			}
			view.clipRect = rect;
		}
		
		public function stageClickHandler(event:MouseEvent):void
		{
			if(view.closeBtn.getBounds(Starling.current.stage).contains(event.stageX,event.stageY)){
				event.stopImmediatePropagation();
				closeHandler();
			}
			
		}
		
		private function tabs_changeHandler( event:Event ):void{
			switch(view.tabs.selectedIndex){
				case 0:
					showAnalysis();
					break;
				case 1:
//					trace(' explainVO.questionId', explainVO.questionId);
					vec = new Vector.<ExamHistVO>;
					PackData.app.CmdIStr[0] = CmdStr.USERCX_EXAM_HIST;
					PackData.app.CmdIStr[1] = explainVO.studentId;
					PackData.app.CmdIStr[2] = explainVO.questionId;
					PackData.app.CmdInCnt = 3;
					sendNotification(CoreConst.SEND_1N,new SendCommandVO(HISTORY_LIST,null,"cn-gb",null,SendCommandVO.NORMAL));
					break;
			}
		}
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()) {
				case HISTORY_LIST:
					var result:DataResultVO = notification.getBody() as DataResultVO;
					if(!result.isEnd){
						vec.push(new ExamHistVO(PackData.app.CmdOStr));
					}else{
						if(!result.isErr){
							view.showHistory = vec;
						}else{
							sendNotification(CoreConst.TOAST,new ToastVO("抱歉,习题答题记录返回错误",2));
						}
					}					
					break;
				case CRoomConst.USERCX_HISTORY:
					explainVO = notification.getBody() as ExplainVO;
					view.titleTxt.text = explainVO.title;
					showAnalysis();
					view.tabs.removeEventListener(Event.CHANGE, tabs_changeHandler );			
					view.tabs.selectedIndex = 0;
					view.tabs.addEventListener(Event.CHANGE, tabs_changeHandler );			
					break;
			}
		}
		override public function listNotificationInterests():Array{
			return [
				HISTORY_LIST,CRoomConst.USERCX_HISTORY
			];
		}
		
		
		private function showAnalysis():void{
			if(explainVO.detailed!='' && ( CRoomConst.isComplete ||  sendBtn)){						
				view.showAnalysis = explainVO.standard+"\n\n<font color='#066908' face='HeiTi'>-------------------------------------------------- \n完整解析:\n"+explainVO.detailed+"</font>";
			}else{
				view.showAnalysis = explainVO.standard;
			}
		}
		
		private function closeHandler():void
		{
			isEnd = true;
			view.showAnalysis = '';
			runEnterFrames = true;
		}
		override public function get viewClass():Class{
			return CRExplantionView;
		}
		public function get view():CRExplantionView{
			return getViewComponent() as CRExplantionView;
		}
		override public function prepare(vo:SwitchScreenVO):void{	
			pareVO = vo;
			explainVO = vo.data as ExplainVO;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		
	}
}