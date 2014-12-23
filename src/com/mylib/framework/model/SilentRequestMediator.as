package com.mylib.framework.model
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SilentQequestVO;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class SilentRequestMediator extends Mediator
	{
		public static const NAME:String = "SilentRequestMediator";
		private var requests:Vector.<SilentQequestVO>;
		private var isStart:Boolean;
		private static const SILENT_REQUEST_REC:String = "silentRequestRec";
		private var sendingRequest:SilentQequestVO;
		
		public function SilentRequestMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case CoreConst.SILENT_SEND:
				{
					var sendVO:SendCommandVO = notification.getBody() as SendCommandVO;
					
					if(sendVO.type&SendCommandVO.UNIQUE){
						
						for (var i:int = 0; i < requests.length; i++) 
						{
							if(requests[i].completeNotice==sendVO.receiveNotification){
								return;
							}
						}
					}
					
					
					
					
					var qvo:SilentQequestVO = new SilentQequestVO;
					qvo.sendVO = sendVO;
					qvo.parameters = new Array(PackData.app.CmdInCnt);
					for (var j:int = 0; j < PackData.app.CmdInCnt; j++) 
					{
						qvo.parameters[j]=PackData.app.CmdIStr[j];
					}
					qvo.completeNotice = sendVO.receiveNotification;
					qvo.type = sendVO.type;
					requests.push(qvo);
					start();
					break;
				}
				case SILENT_REQUEST_REC:{
					var dataResult:DataResultVO = notification.getBody() as DataResultVO;
					
					
					//请求已发送
					if(dataResult.isEnd&&(!dataResult.isErr||(dataResult.isErr&&dataResult.type!="busy"))){
						sendingRequest.sendVO.receiveNotification = sendingRequest.completeNotice;
						sendNotification(CoreConst.SILENT_SENDED,sendingRequest.sendVO);
						
						requests.shift();
						
						if(sendingRequest.type&SendCommandVO.SCREEN){
							
							var k:int;
							var len:int = requests.length;
							while(k<len){
								
								if(requests[k].type&(SendCommandVO.SCREEN)){
									requests.splice(k,1);
									k--;
									len--;
								}
								
								k++;
							}
						}
						
						sendNotification(sendingRequest.completeNotice,notification.getBody());
						
						sendRequest();
					}else if(dataResult.isErr&&dataResult.type=="busy"){
						//线路忙，重发当前请求
						delaySendRequest();
					}else{
						sendNotification(sendingRequest.completeNotice,notification.getBody());
					}
					break;
				}
				case CoreConst.CLEAN_SILENT_REQUESTS:{
					requests.length = 0;
					
					break;
				}
					
				default:
				{
					break;
				}
			}
		}
		
		private function start():void{
			
			if(isStart){
				return;
			}
			
			isStart = true;
			
			sendRequest();
			
		}
		
		private function sendRequest():void{
			
			
			if(!Global.isBusy&&requests.length){
				sendingRequest = requests[0];
				var sendVO:SendCommandVO = sendingRequest.sendVO;
				sendVO.receiveNotification = SILENT_REQUEST_REC;
				sendVO.type = SendCommandVO.SILENT;
				
				for (var i:int = 0; i < sendingRequest.parameters.length; i++) 
				{
					PackData.app.CmdIStr[i] = sendingRequest.parameters[i];
				}
				
				PackData.app.CmdInCnt = sendingRequest.parameters.length;
				
				
				sendNotification(CoreConst.SEND_1N,sendVO);
			}else if(!requests.length){
				isStart = false;
			}else if(requests.length&&Global.isBusy){
				delaySendRequest();
			}
			
			
		}
		
		private function delaySendRequest():void{
			TweenLite.killTweensOf(sendRequest);
			TweenLite.delayedCall(0.5,sendRequest);
		}
		
		
		override public function onRemove():void
		{
			TweenLite.killTweensOf(sendRequest);
		}
		
		
		
		override public function listNotificationInterests():Array
		{
			return [CoreConst.SILENT_SEND,SILENT_REQUEST_REC,CoreConst.CLEAN_SILENT_REQUESTS];
		}
		
		override public function onRegister():void
		{
			requests = new Vector.<SilentQequestVO>;
		}
		
	}
}