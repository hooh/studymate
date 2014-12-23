package com.studyMate.module.classroom
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.utils.CacheTool;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.component.weixin.SpeechConst;
	import com.studyMate.world.component.weixin.vo.WeixinVO;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.module.classroom.view.DrawingBoardView;
	
	import flash.display.GraphicsPath;
	import flash.display.GraphicsSolidFill;
	import flash.display.GraphicsStroke;
	import flash.display.IGraphicsData;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	
	/**
	 * 画图板功能
	 * 增加 			A
	 * 回退上一步	L
	 * 恢复上一步	R
	 * 清理			C
	 * 2014-6-3下午2:23:00
	 * Author wt
	 *
	 */	
	
	public class DrawBoardMediator extends DrawBaseMediator
	{
		public static const NAME:String = 'DrawBoardMediator';
		public static const HIDE_DRAWBOARD:String = NAME+'HideDrawBoard';
		private const INSERT_MSG_COMPLETE:String = 'INSERT_DrawMSG_COMPLETE';
		
	
		private var blockCommands:Vector.<IGraphicsData>;//区块发送画图数据(减少通信，合并局部画图数据)
		private const timeout:int = 3500;//延迟发送时长,为了减少通信数据量
		private var overtime:int;

		public function DrawBoardMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRemove():void
		{			
			view.panel.removeEventListener(TouchEvent.TOUCH,panelTouchHandler);
			CRoomConst.hasDrawBoard = false;
			DustbinManage.hasSelfData = false;
			TweenLite.killDelayedCallsTo(sendDrawDate);
			if(blockCommands.length>0){
				sendDrawDate();
			}
			super.onRemove();
		}
		override public function onRegister():void
		{
			super.onRegister();
			CRoomConst.hasDrawBoard = true;
			blockCommands = new Vector.<IGraphicsData>;
			
			view.panel.addEventListener(TouchEvent.TOUCH,panelTouchHandler);
			view.preBtn.addEventListener(Event.TRIGGERED,preHandler);
			view.nextBtn.addEventListener(Event.TRIGGERED,nextHandler);
			view.quitBtn.addEventListener(Event.TRIGGERED,quitHandler);//退出分享，只删除自己个人的画图数据
		}
		
		override public function addDraw():void
		{
			DustbinManage.hasSelfData = true;
		}
		
		
		private function quitHandler():void
		{
			if(_commands.length>0){//本地有画图数据则还要通知对方清理数据
				clearHandler();
			}
			pareVO.type = SwitchScreenType.HIDE;
			sendNotification(WorldConst.SWITCH_SCREEN,[pareVO]);
		}
		
		private var _lineStyle:GraphicsStroke;
		private var _path:GraphicsPath;
		private	var isDraw:Boolean;
		private function panelTouchHandler(event:TouchEvent):void
		{
			var touchPoint:Touch = event.getTouch(event.target as DisplayObject);
			if(touchPoint){
				
				if(touchPoint.phase==TouchPhase.BEGAN){
					isDraw = false;
					//设置笔触
					_lineStyle = new GraphicsStroke(view.thickness);
					_lineStyle.fill = new GraphicsSolidFill(view.color);
					//记录笔触的样式
					
					//记录笔触移动的轨迹
					_path = new GraphicsPath();
					_path.moveTo(touchPoint.globalX, touchPoint.globalY);
					
					canvas.graphics.lineStyle(view.thickness,view.color);					
					canvas.graphics.moveTo(touchPoint.globalX, touchPoint.globalY);
					
					view.setHolder.visible = false;
					view.penBgImg.visible = false;
					
				}else if(touchPoint.phase == TouchPhase.MOVED){
					isDraw = true;
					_path.lineTo(touchPoint.globalX, touchPoint.globalY);
					canvas.graphics.lineTo(touchPoint.globalX, touchPoint.globalY);
				}else if(touchPoint.phase==TouchPhase.ENDED){
					if(tempCommands.length > 0){
						tempCommands.length = 0;
					}
															
					if(isDraw){//如果有滑动则追加
						_commands.push(_lineStyle);
						_commands.push(_path);
						blockCommands.push(_lineStyle);
						blockCommands.push(_path);
						if(getTimer()-overtime<timeout){//不到3秒的话则等待（第一笔直接发送）		
							TweenLite.killDelayedCallsTo(sendDrawDate);
							TweenLite.delayedCall((getTimer()-overtime)/1000,sendDrawDate);
						}else{
							sendDrawDate();
						}
						
						DustbinManage.hasSelfData = true;
						
					}
				}				
			}
		}
		//发送画图数据
		private function sendDrawDate():void{
			sendService('A',writeByte(blockCommands));			
			blockCommands.length = 0;
		}
		
		private function preHandler():void
		{
			if(_commands.length>1){
				tempCommands.push(_commands.pop());
				tempCommands.push(_commands.pop());
				canvas.graphics.clear();
				canvas.graphics.drawGraphicsData(_commands);				
				sendService('L');
			}
		}
		
		private function nextHandler():void
		{
			if(tempCommands.length>1){
				_commands.push(tempCommands.pop());
				_commands.push(tempCommands.pop());
				canvas.graphics.clear();
				canvas.graphics.drawGraphicsData(_commands);				
				sendService('R');
			}
		}
		
		private function clearHandler():void
		{
			if(_commands.length>0){				
				canvas.graphics.clear();
				_commands.length = 0;
				tempCommands.length = 0;				
				sendService('C','self');//退出分享，只删除自己个人的画图数据
			}

		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case SpeechConst.SHOW_EXPLAINATION:
					AppLayoutUtils.gpuLayer.setChildIndex(view,view.numChildren-1);
					break;
				case CRoomConst.EVENT_SELF_DRAWBOARD:
					var weixinVO:WeixinVO = notification.getBody() as WeixinVO;
					drawBoardHander(weixinVO);
					break;
				case CRoomConst.CLEAR_DRAWBOARD:
					clearAllDraw();
					break;
				case HIDE_DRAWBOARD:
					quitHandler();
					break;
				case INSERT_MSG_COMPLETE:
					if((PackData.app.CmdOStr[0] as String)=="000"){
						trace('成功');
					}else{
						trace('失败');
					}
					break;
			}
		}
		
		override public function clearAllDraw():void
		{
			canvas.graphics.clear();
			_commands.length = 0;
			tempCommands.length = 0;
			DustbinManage.hasSelfData = false;
		}
		
		
		
		
		
		override public function listNotificationInterests():Array
		{
			return [
					SpeechConst.SHOW_EXPLAINATION,
					CRoomConst.EVENT_SELF_DRAWBOARD,
					CRoomConst.CLEAR_DRAWBOARD,
					HIDE_DRAWBOARD,INSERT_MSG_COMPLETE
					
			];
		}
		
		public function sendService(flag:String,ba:*=null):void{
			overtime = getTimer();
			PackData.app.CmdIStr[0] = CmdStr.IN_CLASSROOM_MESSAGE;
			PackData.app.CmdIStr[1] =  CacheTool.getByKey(ClassroomMediator.NAME,'crid') as String;
			PackData.app.CmdIStr[2] = (facade.retrieveMediator(ExercisesLeftMediator.NAME) as ExercisesLeftMediator).current_Qid;//题目标识
			PackData.app.CmdIStr[3] = PackData.app.head.dwOperID;
			PackData.app.CmdIStr[4] = Global.player.realName;
			PackData.app.CmdIStr[5] = 'write';
			PackData.app.CmdIStr[6] = flag; 
			if(ba){					
				if(ba.length < 7*1024){						
					PackData.app.CmdIStr[7] = ba;
				}else{
					sendNotification(CoreConst.TOAST,new ToastVO("数据太大导致同步失败,画图笔画请不要太复杂"));
					return;
				}
			}
			else
				PackData.app.CmdIStr[7] = '';
			PackData.app.CmdInCnt = 8;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(INSERT_MSG_COMPLETE,null,'cn-gb',null,SendCommandVO.QUEUE));
			
		}
		
		override public function get viewClass():Class{
			return DrawingBoardView
		}
		public function get view():DrawingBoardView{
			return getViewComponent() as DrawingBoardView;
		}
		
		public function writeByte(command:Vector.<IGraphicsData>):ByteArray{
			var copier:ByteArray = new ByteArray();
			copier.writeObject(command);
			copier.position = 0;
			copier.compress();
			return copier;
		}	
		


	}
}