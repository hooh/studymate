package com.studyMate.module.classroom
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.PopUpCommandVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.events.MouseEvent;
	
	import feathers.controls.Scroller;
	import feathers.controls.supportClasses.LayoutViewPort;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;

	/**
	 *  查看用户答题记录
	 * @author wt
	 * 
	 */	
	internal class ExamHistoryMediator extends ScreenBaseMediator
	{
		private var pareVO:SwitchScreenVO;
		
		private const HISTORY_LIST:String = 'examhistoryList';
		private var questionId:String;
		private var studentId:String;
		private var standard:String;
		private var vec:Vector.<ExamHistVO>;
		
		private var holder:Sprite;
		private var standardTxt:TextField;
		
		public function ExamHistoryMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super('ExamHistoryMediator', viewComponent);
		}
		override public function onRemove():void{
			Global.stage.removeEventListener(MouseEvent.CLICK,(facade.retrieveMediator(ExercisesLeftMediator.NAME) as ExercisesLeftMediator).clickHandler);
			sendNotification(WorldConst.REMOVE_POPUP_SCREEN,this);
		}
		override public function onRegister():void{
			Global.stage.addEventListener(MouseEvent.CLICK,(facade.retrieveMediator(ExercisesLeftMediator.NAME) as ExercisesLeftMediator).clickHandler);
			sendNotification(WorldConst.POPUP_SCREEN,(new PopUpCommandVO(this)));
			var bg:Image = new Image(Assets.getCnClassroomTexture('answerResultBg'));
			bg.x = 498;
			bg.y = 10;
			view.addChild(bg);
			
			holder = new Sprite();
			holder.touchable = false;
			view.addChild(holder);
			
			standardTxt = new TextField(569,178,standard,'HeiTi',21,0x85562D);
			standardTxt.hAlign = HAlign.LEFT;
			standardTxt.autoSize = TextFieldAutoSize.VERTICAL;
			
			var scroll:Scroller = new Scroller();
			scroll.x = 528;
			scroll.y = 536;
			scroll.width = 570;
			scroll.height = 178;
			var viewPort:LayoutViewPort = new LayoutViewPort();
			viewPort.addChild(standardTxt);
			scroll.viewPort = viewPort;
			view.addChild(scroll);
			
			var closeBtn:Button = new Button(Assets.getCnClassroomTexture('cancelEndBtn'));
			closeBtn.x = 1079;
			closeBtn.y = 33;
			view.addChild(closeBtn);
			closeBtn.addEventListener(Event.TRIGGERED,closeHandler);
			
			
			vec = new Vector.<ExamHistVO>;
			PackData.app.CmdIStr[0] = CmdStr.USERCX_EXAM_HIST;
			PackData.app.CmdIStr[1] = studentId;
			PackData.app.CmdIStr[2] = questionId;
			PackData.app.CmdInCnt = 3;
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(HISTORY_LIST,null,"cn-gb",null,SendCommandVO.NORMAL));
		}
		
		private function sendServer():void{
			PackData.app.CmdIStr[0] = CmdStr.USERCX_EXAM_HIST;
			PackData.app.CmdIStr[1] = studentId;
			PackData.app.CmdIStr[2] = questionId;
			PackData.app.CmdInCnt = 3;
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(HISTORY_LIST,null,"cn-gb",null,SendCommandVO.NORMAL));		
		}
		
		private function closeHandler():void
		{
			pareVO.type = SwitchScreenType.HIDE;
			sendNotification(WorldConst.SWITCH_SCREEN,[pareVO]);
		}
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()) {
				case HISTORY_LIST:
					var result:DataResultVO = notification.getBody() as DataResultVO;
					if(!result.isEnd){
						vec.push(new ExamHistVO(PackData.app.CmdOStr));
					}else{
						if(!result.isErr){
							showExam();
						}else{
							sendNotification(CoreConst.TOAST,new ToastVO("抱歉,习题答题记录返回错误",2));
						}
					}					
					break;
				case CRoomConst.USERCX_HISTORY:
					questionId = notification.getBody().questionId as String;
					studentId = notification.getBody().studentId as String;
					standard = notification.getBody().standard as String;
					vec.length = 0;
					holder.removeChildren(0,-1,true);
					standardTxt.text = standard;
					sendServer();
					break;
			}
		}
		override public function listNotificationInterests():Array{
			return [
				HISTORY_LIST,CRoomConst.USERCX_HISTORY
				];
		}
		
		
		private function showExam():void{
			/*var vo:ExamHistVO = new ExamHistVO();
			vo.answer = 'B';
			vo.mark = 'E';
			vo.time = '20140414-131520';
			vec.push(vo);
			for(var i:int=0;i<10;i++){
				var vo:ExamHistVO = new ExamHistVO();
				vo.answer = 'B';
				vo.mark = 'R';
				vo.time = '20140414-131520';
				vec.push(vo);
			}*/
			
			if(vec.length == 0){
				sendNotification(CoreConst.TOAST,new ToastVO("用户没有做过该题",1));
				return;
			}
			for(var i:int=0;i<vec.length;i++){
				if(i>6) break;
				var sp:Sprite = creatUI(vec[i]);
				sp.x = 526;
				sp.y = 156 + 52*i;
				holder.addChild(sp);
			}
		}
		
		private function creatUI(histVO:ExamHistVO):Sprite{
			var holder:Sprite = new Sprite();
			holder.touchable = false;
			var time:TextField = new TextField(194,24,histVO.time,'HeiTi',19,0x874D34);
			holder.addChild(time);
			
			if(histVO.mark=='R'){
				var hisTxt:TextField = new TextField(300,25,histVO.answer,'HeiTi',20,0x1F6A12);				
				var markIcon:Image = new Image(Assets.getCnClassroomTexture('rightIcon'));
				markIcon.x = 537;
				holder.addChild(markIcon);
			}else{
				hisTxt = new TextField(300,25,histVO.answer,'HeiTi',19,0xDD3900);	
			}
			hisTxt.autoScale = true;
			hisTxt.hAlign = HAlign.LEFT;
			hisTxt.x = 240;
			holder.addChild(hisTxt);						
			return holder;
		}
		
		override public function get viewClass():Class{
			return Sprite;
		}
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function prepare(vo:SwitchScreenVO):void{	
			pareVO = vo;
			questionId = pareVO.data.questionId as String;
			studentId = pareVO.data.studentId as String;
			standard = pareVO.data.standard as String;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
	}
}