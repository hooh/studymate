package com.mylib.framework.model
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.BeatVO;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.screens.Const;
	
	import flash.utils.getTimer;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class BeatMediator extends Mediator
	{
		public static const NAME:String = "BeatMediator";
		private var dur:Number = Const.DEFAULT_BEAT_DUR;
		private var startBeatTime:int;
		
		public function BeatMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case CoreConst.BEAT_REC:
				{
					var dvo:DataResultVO = notification.getBody() as DataResultVO;
					if(!dvo.isErr){
						var beatVO:BeatVO = new BeatVO();
						
						for (var i:int = 1; i < PackData.app.CmdOutCnt; i++) 
						{
							beatVO.addData(PackData.app.CmdOStr[i]);
						}
						sendNotification(CoreConst.UPDATE_NETWORK_SPEED,getTimer()-startBeatTime);
						sendNotification(CoreConst.BROADCAST,beatVO);
						
					}
					
					break;
				}
				case CoreConst.START_BEAT:{
					start();
					break;
				}
				case CoreConst.STOP_BEAT:{
					stop();
					break;
				}
				case CoreConst.SET_BEAT_DUR:{
					
					dur = notification.getBody() as Number;
					
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
			return [CoreConst.BEAT_REC,CoreConst.START_BEAT,CoreConst.STOP_BEAT,CoreConst.SET_BEAT_DUR];
		}
		
		override public function onRegister():void
		{
			
			
			
		}
		
		public function start():void{
			stop();
			beat();
		}
		
		public function stop():void{
			TweenLite.killDelayedCallsTo(beat);
		}
		
		private function beat():void{
			if(dur>10){//加判断是为了防止辅导教室打印过多信息
				sendNotification(CoreConst.FLOW_RECORD,new RecordVO("beat start","BeatMediator",0));

			}
			
			if(!Global.isBusy){
				startBeatTime = getTimer();
				sendNotification(CoreConst.BEAT);
			}
			TweenLite.delayedCall(dur,beat);
			
		}
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
		}
		
		
		
	}
}