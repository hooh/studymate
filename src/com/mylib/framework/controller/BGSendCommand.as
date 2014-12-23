package com.mylib.framework.controller
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.tcp.SocketProxy;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class BGSendCommand extends SimpleCommand
	{
		public function BGSendCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
			var proxy:SocketProxy = facade.retrieveProxy(SocketProxy.NAME) as SocketProxy;
			if(notification.getBody() is Array){
				var paras:Array = notification.getBody() as Array;
				
				
				if(proxy.isConnecting||!Global.hasLogin||proxy.isError){
					var recEncode:String = paras.shift();
					var byteIdx:Vector.<int> = paras.shift();
					sendNotification(CoreConst.FLOW_RECORD,new RecordVO("connecting cache1",paras.length.toString(),0));
					proxy.cacheRequest(CoreConst.BG_SEND_COMPLETE,null,paras,paras.length,recEncode,byteIdx);
				}else{
					proxy.receiveEncode = paras.shift();
					proxy.byteIdx = paras.shift();
					
					for (var i:int = 0; i < paras.length; i++) 
					{
						proxy.CmdIStr[i] = paras[i];
					}
					proxy.CmdInCnt = paras.length;
					proxy.setReceiveNotification(CoreConst.BG_SEND_COMPLETE);
					proxy.receiveNotificationPara = null;
					proxy.sendHostCmd1N();
				}
				
			}else{
				
				var sendCommandVO:SendCommandVO = notification.getBody() as SendCommandVO;
				
				if(proxy.isConnecting||!Global.hasLogin||proxy.isError){
					sendNotification(CoreConst.FLOW_RECORD,new RecordVO("connecting cache2",proxy.CmdInCnt.toString(),proxy.CmdIStr[0]));
					proxy.cacheRequest(sendCommandVO.receiveNotification,sendCommandVO.para,proxy.CmdIStr,proxy.CmdInCnt,sendCommandVO.encode,sendCommandVO.byteIdx);
				}else{
					proxy.setReceiveNotification(sendCommandVO.receiveNotification);
					proxy.receiveNotificationPara = sendCommandVO.para;
					proxy.receiveEncode = sendCommandVO.encode;
					proxy.byteIdx = sendCommandVO.byteIdx;
					proxy.sendHostCmd1N();
				}
				
				
				
			}
			
			
			
		}
		
	}
}