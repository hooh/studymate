package com.studyMate.module.engLearn
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.view.EduAlertMediator;
	
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	//该类主要作为学习的基类，处理超时退出的通用问题
	public class EgLearnBaseMediator extends ScreenBaseMediator
	{
		private const delayTimeQuit:int = 180;//超时则退出
		private var quiteSuccess:Boolean;
		protected var isSubmit:Boolean;
		
		public function EgLearnBaseMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
		override public function onRemove():void{
			if(facade.hasMediator(EduAlertMediator.NAME)){
				sendNotification(WorldConst.REMOVE_POPUP_SCREEN,(facade.retrieveMediator(EduAlertMediator.NAME) as EduAlertMediator));
			}
			quiteSuccess = true;
			TweenLite.killDelayedCallsTo(AeertQuit);
			TweenLite.killDelayedCallsTo(quit);	
//			TweenLite.killDelayedCallsTo(quitSuccessHandler);
			Global.stage.removeEventListener(MouseEvent.MOUSE_DOWN,stageMouseDownHandler);
			super.onRemove();
		}
		override public function onRegister():void{
			TweenLite.delayedCall(delayTimeQuit,AeertQuit);//三分钟后退出
			Global.stage.addEventListener(MouseEvent.MOUSE_DOWN,stageMouseDownHandler);
		}
		
		private function stageMouseDownHandler(event:MouseEvent):void
		{
			TweenLite.killDelayedCallsTo(AeertQuit);
			TweenLite.delayedCall(delayTimeQuit,AeertQuit);//三分钟后退出
			
		}
		
		/**--------三分钟未输入则弹出窗口---------------*/
		private function AeertQuit():void{
			TweenLite.delayedCall(10,quit);		
			sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n您长时间未进行任何操作，\n系统即将退出该界面。\n点击确定则继续任务。",
				false,'EgLearnBaseMediator','EgLearnBaseMediator',false,null,stopTimeQuit));
		}
		protected function quit():void{
			if(!Global.isLoading && !isSubmit){				
				sendNotification(WorldConst.POP_SCREEN);			
//				TweenLite.delayedCall(2,quitSuccessHandler);
			}else{
				if(!isSubmit){					
					TweenLite.delayedCall(10,quit);	
				}
			}
			
		}
		/*private function quitSuccessHandler():void{
			if(!quiteSuccess){//退出失败则反复继续退出。知道彻底退出为之
				quit();
			}
		}*/
		private function stopTimeQuit():void{
			TweenLite.killDelayedCallsTo(quit);	
		}
		
		private var duration:int = 0;
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				case CoreConst.DEACTIVATE:
					duration = getTimer();
					break;
				case CoreConst.ACTIVATE:
					if(duration==0) return;
					if((getTimer() - duration)*0.001>delayTimeQuit && !isSubmit){
						TweenLite.killDelayedCallsTo(quit);
						quit();
					}
					break;
			}
		}
		override public function listNotificationInterests():Array{
			return [CoreConst.DEACTIVATE,CoreConst.ACTIVATE];
		}
		
		/**
		 * 后台信息派发函数
		 * @param command		命令字
		 * @param reveive		接收字符
		 * @param info			参数数组
		 */		
		public function sendinServerInfo(command:String,reveive:String,infoArr:Array):void{
			PackData.app.CmdIStr[0] = command;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			for(var i:int=0;i<infoArr.length;i++){
				PackData.app.CmdIStr[i+2] = infoArr[i]
			}
			PackData.app.CmdInCnt = i+2;	
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(reveive));	//派发调用绘本列表参数，调用后台
		}
	}
}