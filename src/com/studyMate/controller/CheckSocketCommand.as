package com.studyMate.controller
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.StatusEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getTimer;
	
	import air.net.SocketMonitor;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class CheckSocketCommand extends SimpleCommand implements ICommand
	{
		private var socket:SocketMonitor;
		private var connectIdx:int = 0;
		private var xmlReader:IPReaderProxy;
		
		public function CheckSocketCommand()
		{
			super();
		}
		private var testS:Socket;
		override public function execute(notification:INotification):void
		{
			
			
			
			xmlReader = facade.retrieveProxy(IPReaderProxy.NAME) as IPReaderProxy;
			
			
			/*checkConnect(1);
			

			
			
			if(testS&&testS.connected){
				testS.removeEventListener(Event.CLOSE,closeHandle,false);
				testS.close();
			}
			testS.connect("210.21.65.71",80);*/
			
			
			
			
		}
		
		/**
		 * 测试连接<br><br>
		 * idx = 网络接入口<br>
		 * 1 : 电信<br>
		 * 2 : 联通 <br>
		 * @param idx
		 * 
		 */		
		private function checkConnect(idx:int):void{
			connectIdx = idx;
			var ipArr:Array = idx == 1 ? xmlReader.getIpInf("telecom") : xmlReader.getIpInf("unicom");
			
			if(socket){
				socket.removeEventListener(StatusEvent.STATUS, socketMonitorHandler);
				socket.stop();
				socket = null;
			}
			
			socket = new SocketMonitor(ipArr[0],ipArr[1]);
			socket.addEventListener(StatusEvent.STATUS, socketMonitorHandler);  
			socket.start();
			
		}
		
		private function socketMonitorHandler(e:StatusEvent):void  
		{
			//连上了
			if(e.code == "Service.available"){
				
				sendNotification(WorldConst.CHECK_SOCKET_RESULT,true);
		
			}else if(e.code == "Service.unavailable"){
				//未连上电信，则测试联通
				if(connectIdx == 1){
					checkConnect(2);
					return;
				}
				
				
				sendNotification(WorldConst.CHECK_SOCKET_RESULT,false);
			}
			
			socket.removeEventListener(StatusEvent.STATUS, socketMonitorHandler);
			socket.stop();
		}
		
		
		
		
		
		
		
	}
}