package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.drawing.DrawingBoard;
	import com.mylib.game.drawing.DrawingColorPicker;
	import com.mylib.game.drawing.PictureBoard;
	import com.studyMate.controller.ToastCommand;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.utils.ByteArray;
	import flash.utils.CompressionAlgorithm;
	
	import feathers.controls.Alert;
	import feathers.controls.Button;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	import stateMachine.StateMachine;
	import stateMachine.StateMachineEvent;

	public class TestDrawingBoardMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "DrawingBoardMediator";
		
		private var board:DrawingBoard;
		private var picker:DrawingColorPicker;
		private var picture:PictureBoard;
		
		private var jungle:Juggler;
		
		private var timeText:TextField;
		
		private var _fsm:StateMachine;
		
		private static const END:String = "END";
		private static const DRAW:String = "draw";
		
		private var startBtn:Button;
		private var saveBtn:Button;
		private static const START_DRAW_REC:String = NAME+"startDrawRec";
		private static const SUBMIT_DATA_REC:String = NAME+"submitDataRec";
		
		
		
		public function TestDrawingBoardMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class
		{
			return starling.display.Sprite;
		}
		
		public function get view():starling.display.Sprite{
			return getViewComponent() as starling.display.Sprite;
		}
		
		override public function onRegister():void
		{
			
			sendNotification(CoreConst.HIDE_STARUP_INFOR);
			
			board = new DrawingBoard;
			
			board.x = 700;
			board.y = 60;
			
			AppLayoutUtils.cpuLayer.addChild(board);
			
			
			picker = new DrawingColorPicker;
			
			
			picker.x = 730;
			picker.y = 500;
			
			view.addChild(picker);
			
			picture = new PictureBoard;
			
			picture.x = 100;
			picture.y = 60;
			
			view.addChild(picture);
			
			
			
			
			startBtn = new Button();
			startBtn.label = "start";
			startBtn.x = 550;
			startBtn.y = 100;
			
			view.addChild(startBtn);
			
			timeText = new TextField(100,40,"","HeiT",30,0xffffff);
			timeText.x = 550;
			timeText.y = 140;
			
			view.addChild(timeText);
			
			
			startBtn.addEventListener(Event.TRIGGERED,startBtnHandle);
			
			
			saveBtn = new Button();
			saveBtn.label = "save";
			
			saveBtn.x = 550;
			saveBtn.y = 200;
			
			
			jungle = new Juggler();
			Starling.juggler.add(jungle);
			_fsm = new StateMachine;
			_fsm.addState(END,{enter:enterEnd,exit:exitEnd,from:["*"]});
			_fsm.addState(DRAW,{enter:enterDraw,exit:exitDraw,from:[END]});
			_fsm.initialState = END;
			
		}
		
		private function enterEnd(e:StateMachineEvent):void{
			startBtn.visible = true;
			saveBtn.visible = true;
			timeText.visible = false;
			board.enable = false;
			jungle.purge();
		}
		
		private function exitEnd(e:StateMachineEvent):void{
			startBtn.visible = false;
			saveBtn.visible = false;
			timeText.visible = true;
			board.clean();
		}
		
		private function submit():void{
			
			PackData.app.CmdIStr[0] = CmdStr.INS_DRAW_DATA;
			
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = Global.player.name;
			PackData.app.CmdIStr[3] = picture.picID;
			
			var byte:ByteArray = new ByteArray;
			
			byte.writeObject(board.data);
			byte.compress();
			
			PackData.app.CmdIStr[4] = byte;
			PackData.app.CmdInCnt = 5;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(SUBMIT_DATA_REC));
		}
		
		private function timeReduce():void{
			
			if(timeText.text=="0"){
				_fsm.changeState(END);
				submit();
				return;
			}
			
			
			timeText.text = String(int(timeText.text)-1);
		}
		
		private function enterDraw(e:StateMachineEvent):void{
			timeText.text = "45";
			jungle.purge();
			jungle.repeatCall(timeReduce,1,46);
			picture.randomShow();
			board.enable = true;
			
		}
		
		private function exitDraw(e:StateMachineEvent):void{
			
		}
		
		private function startBtnHandle():void
		{
			
			
			PackData.app.CmdIStr[0] = CmdStr.START_DRAW;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 2;
			
			sendNotification(CoreConst.SEND_11,new SendCommandVO(START_DRAW_REC));
		}
		
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
			
			Starling.juggler.remove(jungle);
		}
		
		
		override public function handleNotification(notification:INotification):void
		{
			var vo:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName())
			{
				case DrawingColorPicker.SELECT_COLOR:
				{
					board.color = notification.getBody() as uint;
					break;
				}
				case START_DRAW_REC:{
					
					if(!vo.isErr){
						_fsm.changeState(DRAW);
					}
					
					break;
				}
				case SUBMIT_DATA_REC:{
					
					if(!vo.isErr){
						//sendNotification(CoreConst.TOAST,new ToastVO("提交成功"));
					}
					
					
					break;
				}
					
				default:
				{
					break;
				}
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [DrawingColorPicker.SELECT_COLOR,START_DRAW_REC,SUBMIT_DATA_REC];
		}
		
		
		
	}
}