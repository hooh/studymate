package com.studyMate.module.engLearn
{
	import com.studyMate.model.vo.ItemVO;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.INotification;

	internal class RATE_ReadCPUMediator extends ReadCPUMediator
	{
		public static const NAME:String = "RATE_ReadCPUMediator"; 
		private const YES_QUIT:String = NAME+"YES_QUIT";
		
		
		public function RATE_ReadCPUMediator(viewComponent:Object=null)
		{
			super(viewComponent);
			super.mediatorName = NAME;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()) {
				case YES_QUIT:
					quitPopScreen();
					break;
				case yesAbandonHandler:
					var rightNum:int = countNum(rightArray);
					var rate:String = Math.floor(rightNum/totalPage*100)+'%';
					var str:String = "\n学习统计结果.\n答对："+rightNum+" | 总题数:"+totalPage+".\n正确率:"+rate;
					sendNotification(WorldConst.ALERT_SHOW,new AlertVo(str,true,YES_QUIT));//提交订单
					
					sendNotification(RATE_ReadBGMediator.QUIT,rate);
					return;
					break;
				
			}
			
			super.handleNotification(notification);
		}
		
		override protected function submit():void
		{
			sendNotification(yesAbandonHandler);
		}
		
		
		override public function listNotificationInterests():Array
		{
			return super.listNotificationInterests().concat(YES_QUIT);;
		}
		
	}
}