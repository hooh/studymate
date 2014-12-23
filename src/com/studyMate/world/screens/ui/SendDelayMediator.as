package com.studyMate.world.screens.ui
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class SendDelayMediator extends Mediator
	{
		
		public static const NAME:String="SendDelayMediator";
		
		private var cancelAction:Function;
		private var cancelActionParameters:Array;
		
		public function SendDelayMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		

		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case CoreConst.DOWNLOAD_CANCELED:	
					if(cancelAction)
						cancelAction.apply(null,cancelActionParameters);
					cancelAction = null;
					cancelActionParameters = null;
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [CoreConst.DOWNLOAD_CANCELED];
		}
		
		
		
		public function execute(action:Function,parameters:Array):void{
			if(Global.isLoading && !Global.isSwitching){
				sendNotification(CoreConst.CANCEL_DOWNLOAD);
				cancelAction = action;
				cancelActionParameters = parameters;
			}else{
				action.apply(null,parameters);
			}
		}
		
		
		/**
		 * 后台信息派发函数
		 * @param command		命令字
		 * @param reveive		接收字符
		 * @param info			参数数组
		 */		
		public function sendinServerInfo(command:String,reveive:String,infoArr:Array,type=SendCommandVO.NORMAL):void{
			if(Global.isLoading && !Global.isSwitching){
				sendNotification(CoreConst.CANCEL_DOWNLOAD);
				cancelAction = sendinServerInofFunc;
				cancelActionParameters = [command,reveive,infoArr,type];
			}else{
				sendinServerInofFunc(command,reveive,infoArr,type);
			}
		}		
		private function sendinServerInofFunc(command:String,reveive:String,infoArr:Array,type=(SendCommandVO.QUEUE|SendCommandVO.UNIQUE)):void{
			PackData.app.CmdIStr[0] = command;
			for(var i:int=0;i<infoArr.length;i++){
				PackData.app.CmdIStr[i+1] = infoArr[i]
			}
			PackData.app.CmdInCnt = i+1;	
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(reveive,null,'cn-gb',null,type));	//派发调用绘本列表参数，调用后台
		}
		
				
		
		override public function onRemove():void
		{
			cancelAction = null;
			cancelActionParameters = null;
			super.onRemove();
		}


	}
}