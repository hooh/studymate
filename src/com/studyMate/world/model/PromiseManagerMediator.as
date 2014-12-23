package com.studyMate.world.model
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.model.vo.PromiseInf;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.vo.ButtonTipsVO;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PromiseManagerMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PromiseManagerMediator";
		public static const CHECK_PROMISE:String = NAME + "CheckPromise";
		
		public function PromiseManagerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void{
			super.onRegister();
		}
		
		override public function onRemove():void{
			super.onRemove();
		}
		
		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case WorldConst.CHECK_PROMISE :
					checkPromise();
					break;
				case CHECK_PROMISE :
					updateProInfo(result);
					sendNotification(WorldConst.CHECK_PROMISE_OVER);
					break;
				default :
					break;
			}
		}
		
		override public function listNotificationInterests():Array{
			return [CHECK_PROMISE, WorldConst.CHECK_PROMISE];
		}
		
		private function checkPromise():void{
			PackData.app.CmdIStr[0] = CmdStr.CHECK_PROMISES;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 2;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(CHECK_PROMISE,null,"cn-gb",null,SendCommandVO.QUEUE));
		}
		
		private function updateProInfo(result:DataResultVO):void{
			if(result.isErr)
				return;
			
			var promiseInf:PromiseInf = new PromiseInf();
			promiseInf.unFinishCount = parseInt(PackData.app.CmdOStr[2]);
			promiseInf.minTarget = parseInt(PackData.app.CmdOStr[3]);
			promiseInf.newFinishCount = parseInt(PackData.app.CmdOStr[4]);
			Global.myPromiseInf = promiseInf;
			sendNotification(WorldConst.CHANGE_BUTTON_TIPS, new ButtonTipsVO("PromiseBtn", Global.myPromiseInf.unFinishCount));
		}
	}
}