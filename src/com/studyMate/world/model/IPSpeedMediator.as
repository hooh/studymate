package com.studyMate.world.model
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.controller.IPReaderProxy;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.IPSpeedVO;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.events.StatusEvent;
	import flash.utils.getTimer;
	
	import air.net.SocketMonitor;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class IPSpeedMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "IPSpeedMediator";
		private var ipFile:String = Global.localPath + "ipconfig.dat"
		private var ipVOArray:Array;
//		private var sockets:Array;
		private var sockets:Vector.<SocketMonitor>;
		private var begtime:int;
		private var hasFoundFastest:Boolean = false;
		
		public function IPSpeedMediator(mediatorName:String=null, viewComponent:Object=null){
			super(NAME, viewComponent);
			readIp();
		}
		
		override public function onRegister():void{
			super.onRegister();
		}
		
		override public function onRemove():void{
			for each (var i:SocketMonitor in sockets) {
				i.removeEventListener(StatusEvent.STATUS, getFastestHandler);
				i.removeEventListener(StatusEvent.STATUS, cmpSpeedHandler);
				i.stop();
			}
			super.onRemove();
		}
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				case WorldConst.IP_GET_FASTED: {
					getFastest();
					break;
				}
				case WorldConst.IP_CMP_SPEED: {
					cmpSpeed();
					break;
				}
				default: {
					break;
				}
			}
		}
		
		override public function listNotificationInterests():Array{
			return [WorldConst.IP_GET_FASTED, WorldConst.IP_CMP_SPEED];
		}
		
		private function readIp():void{
			ipVOArray = [];
			var ipReader:IPReaderProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(IPReaderProxy.NAME) as IPReaderProxy;
			var ipList:XML = ipReader.getIpList();
			if(ipList == null) return;
			var ips:XMLList = ipList.ip;
			for each (var ip:XML in ips) {
				var ipvo:IPSpeedVO = new IPSpeedVO(ip["name"], ip["host"], parseInt(ip["port"]));
				ipVOArray.push(ipvo);
			}
		}
		
		private function startSockets():void{
			begtime = getTimer();
			for each (var i:SocketMonitor in sockets) {
				i.start();
			}
		}
		
		private function stopSockets():void{
			for each (var i:SocketMonitor in sockets) {
				i.removeEventListener(StatusEvent.STATUS, getFastestHandler);
				i.removeEventListener(StatusEvent.STATUS, cmpSpeedHandler);
				i.stop();
				i = null;
			}
			sockets = null;
		}
		
		private function getFastest():void {
			if(sockets != null)	stopSockets();
			sockets = new Vector.<SocketMonitor>();
			for each (var ip:IPSpeedVO in ipVOArray) {
				var socket:SocketMonitor = new SocketMonitor(ip.host, ip.port);
				socket.addEventListener(StatusEvent.STATUS, getFastestHandler);
				sockets.push(socket);
			}
			startSockets();
		}
		
		private function getFastestHandler(e:StatusEvent):void{
			var socket:SocketMonitor = e.target as SocketMonitor;
			socket.removeEventListener(StatusEvent.STATUS, getFastestHandler);
			socket.stop();
			if(e.code == "Service.available"){
				foundSocket(socket);
			}
		}
		
		private function foundSocket(socket:SocketMonitor):void{
			if(hasFoundFastest) return;
//			hasFoundFastest = true;
			var ipvo:IPSpeedVO;
			for each (var i:IPSpeedVO in ipVOArray) {
				if(i.host != socket.host) continue;
				ipvo = i;
				break;
			}
			if(ipvo == null) return;
			var endtime:int = getTimer();
			ipvo.timeout = endtime - begtime;
			stopSockets();
			sendNotification(WorldConst.IP_SPEED_FASTEST, ipvo);
		}
		
		private function cmpSpeed():void{
			if(sockets != null)	stopSockets();
			sockets = new Vector.<SocketMonitor>();
			for each (var i:IPSpeedVO in ipVOArray) {
				var socket:SocketMonitor = new SocketMonitor(i.host, i.port);
				socket.addEventListener(StatusEvent.STATUS, cmpSpeedHandler);
				sockets.push(socket);
			}
			startSockets();
		}
		
		private function cmpSpeedHandler(e:StatusEvent):void{
			var socket:SocketMonitor = e.target as SocketMonitor;
			socket.removeEventListener(StatusEvent.STATUS, cmpSpeedHandler);
			socket.stop();
			if(e.code == "Service.available"){
				startNext(socket, true);
			}else if(e.code == "Service.unavailable"){
				startNext(socket, false);
			}
		}
		
		private function startNext(socket:SocketMonitor, con:Boolean):void{
			var ipvo:IPSpeedVO;
			for each (var i:IPSpeedVO in ipVOArray) {
				if(i.host != socket.host) continue;
				ipvo = i; break;
			}
			var pos:int = sockets.indexOf(socket);
			sockets.splice(pos, 1);
			if(ipvo == null) return;
			if(con == false){
				ipvo.failCount += 1;
			}
			ipvo.conCount += 1;
			if(ipvo.conCount >= 1){
				var endtime:int = getTimer();
				ipvo.timeout = (endtime - begtime + ipvo.failCount * 80000) / ipvo.conCount;
				sendNotification(WorldConst.IP_SPEED_RESULT, ipvo);
			}else{
				socket = new SocketMonitor(ipvo.host, ipvo.port);
				socket.addEventListener(StatusEvent.STATUS, cmpSpeedHandler);
				socket.start();
				sockets.push(socket);
			}
		}
		
	}
}