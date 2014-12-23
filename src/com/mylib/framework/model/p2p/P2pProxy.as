package com.mylib.framework.model.p2p
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.world.screens.LsjTestMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.events.NetStatusEvent;
	import flash.media.Microphone;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.Responder;
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class P2pProxy extends Proxy implements IProxy
	{
		public static var NAME:String = "P2pProxy";
		
		private var myName:String = "student1";
		private var otherName:String = "hh";
		
		
		private var outgoingStreamDirect:NetStream = null;
		private var outgoingStreamFms:NetStream = null;
		
		private var incomingStreamDirect:NetStream = null;
		private var incomingStreamFms:NetStream = null;
		
		public function P2pProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			
			
			
			
			
		}
		
		private var connects:Dictionary;
		private var nc:NetConnection;
		public function doConnect(_myName:String, _otherName:String):void{
			
			myName = _myName;
			otherName = _otherName;
			
			connects = new Dictionary;
			
			nc = new NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS,netConnectionHandler);
			
			
			nc.connect("rtmfp://54.68.25.225/app?name="+myName);//1935
//			nc.connect("rtmfp://192.168.8.195/app?name="+myName);
			
			nc.client = {log:refreshLog, askConnect:askConnect, doClose:doClose};
			
			
			connects[myName] = nc;
		}
		
		protected function netConnectionHandler(event:NetStatusEvent):void
		{
			
			if(event.info.code=="NetConnection.Connect.Success"){
				
//				clientName.type = TextFieldType.DYNAMIC;
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.P2P_CONENCT);
				multiPublish();
				
			}
			
			
			
		}
		
		
		
		
		
		//发布流
		private function multiPublish():void
		{
			if(outgoingStreamDirect){
				outgoingStreamDirect.close();
				outgoingStreamDirect = null;
			}
			if(outgoingStreamFms){
				outgoingStreamFms.close();
				outgoingStreamFms = null;
			}
			
			outgoingStreamDirect = new NetStream(connects[myName], NetStream.DIRECT_CONNECTIONS);
			outgoingStreamDirect.attachAudio(Microphone.getMicrophone());
			outgoingStreamFms = new NetStream(connects[myName]);
			outgoingStreamFms.attachAudio(Microphone.getMicrophone());
			
			outgoingStreamDirect.publish("streamDirect_"+myName);
			
			var c:Object = new Object();
			c.onPeerConnect = function(peer:NetStream):Boolean
			{
				// if we receive onPeerConnect, it means that direct connection succeeded
				if (outgoingStreamFms)
				{
					outgoingStreamFms.close();
					outgoingStreamFms = null;
				}
				return true;
			}
			
			
			outgoingStreamDirect.client = c;
			
			
			outgoingStreamFms.publish("streamFms_"+myName);
			
			
			//连接成功，自动调用订阅流
			subClient();
		}
		
		//订阅流
		public function subClient():void{
			
			var responder:Responder = new Responder(onGetClientId,errGetClientId);
			connects[myName].call("getClientId", responder,otherName);
			
		}
		
		//被请求订阅流
		public function askConnect(_otherName:String):void{
			if(_otherName == otherName){
				trace("名字一样："+_otherName);
				var responder:Responder = new Responder(onGetClientId,errGetClientId);
				connects[myName].call("askClientId", responder,otherName);
				
				
			}else{
				
				trace("名字不一样："+_otherName);
				//名字不一样，断开请求方
				connects[myName].call("closeOther", new Responder(onCloseOther,errCloseOther),_otherName);
				
			}
			
			
		}
		
		
		
		private function onGetClientId(nearId:String):void{

			
			multiSubscribe(nearId);
			//订阅成功，通知另一方订阅
			
			mytrace("去到了");
			trace("去到了");
			
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.P2P_CONNECT_ON);
		}
		
		private function errGetClientId(msg:Object):void{
			trace(msg);
			//订阅失败，等待
			
			mytrace("未登录");
			trace("未登录");
		}
		
		private function multiSubscribe(_nearId:String):void
		{
			if(incomingStreamDirect){
				incomingStreamDirect.close();
				incomingStreamDirect = null;
			}
			if(incomingStreamFms){
				incomingStreamFms.close();
				incomingStreamFms = null;
			}
			
			incomingStreamFms = new NetStream(connects[myName]);
			incomingStreamDirect = new NetStream(connects[myName], _nearId);
			incomingStreamDirect.addEventListener(NetStatusEvent.NET_STATUS, streamHandler);
			
			incomingStreamFms.play("streamFms_"+otherName);
			incomingStreamDirect.play("streamDirect_"+otherName);
		}
		
		private function streamHandler(e:NetStatusEvent):void
		{
			// if Play.Start event received on direct connection, it means that direct communications is possible
			if ("NetStream.Play.Start" == e.info.code)
			{
				if (incomingStreamFms)
				{
					incomingStreamFms.close();
					incomingStreamFms = null;
				}
				
				incomingStreamDirect.soundTransform.volume = 1;
			}
		}
		
		
		
		
		//刷新日志
		private function refreshLog(_log:String):void{
			
//			trace(_log);
			
			logtrace(_log);
		}
		
		
		
		private function logtrace(_log:String):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(LsjTestMediator.TEST_TEXT, _log);
		}
		
		private function mytrace(str:String):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(LsjTestMediator.TEST_TRACE, str);
		}
		
		
		
		
		
		
		
		//关闭自己，同时关闭对方
		public function close():void{
			
			if(connects && connects[myName])
				connects[myName].call("closeOther", new Responder(onCloseOther,errCloseOther),otherName);
			
			doClose();
		}
		private function onCloseOther(msg:String):void{
			
			mytrace("关闭对方");
			trace("关闭对方");
		}
		
		private function errCloseOther(msg:Object):void{
			trace(msg);
			
			mytrace("关闭对方失败");
			trace("关闭对方失败");
		}
		public function doClose():void{
			if(nc){
				trace("请求断开！！！！！！！！！！！！！！！！");
//				hadCollected = false;
				
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.P2P_CONNECT_OFF);
				
				if(outgoingStreamDirect){
					outgoingStreamDirect.close();
					outgoingStreamDirect = null;
				}
				if(outgoingStreamFms){
					outgoingStreamFms.close();
					outgoingStreamFms = null;
				}
				if(incomingStreamDirect){
					incomingStreamDirect.close();
					incomingStreamDirect = null;
				}
				if(incomingStreamFms){
					incomingStreamFms.close();
					incomingStreamFms = null;
					
				}
				
				nc.close();
			}
		}
		
		
		override public function onRemove():void
		{
			super.onRemove();
			
			close();
			
			
			
			
			
			
		}
		
		
		
	}
}