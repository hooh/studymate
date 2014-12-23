package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Microphone;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.Responder;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	public class TestP2P extends ScreenBaseMediator
	{
		public static const NAME:String = "";
		
		private var connects:Dictionary;
		
		
		
		private var clientName:TextField;
		private var otherClientName:TextField;
		
		
		
		private var inforText:TextField;
		
		
		
		public function TestP2P(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			
			
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function onRegister():void
		{
			// TODO Auto Generated method stub
			super.onRegister();
			
			
			
			connects = new Dictionary;
			
			var btn:Sprite = new Sprite();
			btn.graphics.beginFill(0x00ff00);
			btn.graphics.drawRect(0,0,50,50);
			btn.graphics.endFill();
			btn.x = 100;
			btn.y = 100;
			btn.addEventListener(MouseEvent.CLICK,newClientHandle);
			view.addChild(btn);
			
			btn = new Sprite();
			btn.graphics.beginFill(0xff0000);
			btn.graphics.drawRect(0,0,50,50);
			btn.graphics.endFill();
			btn.x = 200;
			btn.y = 100;
			btn.addEventListener(MouseEvent.CLICK,publicHandle);
//			view.addChild(btn);
			
			btn = new Sprite();
			btn.graphics.beginFill(0x0000ff);
			btn.graphics.drawRect(0,0,50,50);
			btn.graphics.endFill();
			btn.x = 300;
			btn.y = 100;
			btn.addEventListener(MouseEvent.CLICK,subscribeHandle);
			view.addChild(btn);
			
			
			
			clientName = new TextField();
			clientName.width = 60;
			clientName.height = 24;
			clientName.x = clientName.y = 20;
			clientName.border = true;
			clientName.type = TextFieldType.INPUT;
			clientName.text = "cc";
			view.addChild(clientName);
			
			
			
			otherClientName = new TextField();
			otherClientName.width = 60;
			otherClientName.height = 24;
			otherClientName.x = 100; 
			otherClientName.y = 20;
			otherClientName.border = true;
			otherClientName.visible = false;
			otherClientName.type = TextFieldType.INPUT;
			view.addChild(otherClientName);
			
			
			inforText = new TextField();
			inforText.width = 200;
			inforText.height = 200;
			inforText.x = 20;
			inforText.y = 200;
			inforText.border = true;
			inforText.multiline = true;
			view.addChild(inforText);
			
			
			sendNotification(CoreConst.HIDE_STARUP_INFOR);
			
		}
		
		
		protected function subscribeHandle(event:MouseEvent):void
		{
			subscribeClient(otherClientName.text);
		}
		
		protected function publicHandle(event:MouseEvent):void
		{
			multiPublish();
		}
		
		
		private var outgoingStreamDirect:NetStream = null;
		private var outgoingStreamFms:NetStream = null;
		
		private function multiPublish():void
		{
			outgoingStreamDirect = new NetStream(connects[clientName.text], NetStream.DIRECT_CONNECTIONS);
			outgoingStreamDirect.attachAudio(Microphone.getMicrophone());
			outgoingStreamFms = new NetStream(connects[clientName.text]);
			
			outgoingStreamDirect.publish("streamDirect_"+clientName.text);
			
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
			
			
			outgoingStreamFms.publish("streamFms_"+clientName.text)
		}
		
		private function refreshLog(_log:String):void{
			
			inforText.text = _log;
			
		}
		
		
		private function subscribeClient(_clientName:String):void{
			
			var responder:Responder = new Responder(onGetClientId,errGetClientId);
			connects[clientName.text].call("getClientId", responder,otherClientName.text);
			
		}
		
		private function onGetClientId(nearId:String):void{
			
			multiSubscribe(nearId);
			
			trace("去到了");
		}
		
		private function errGetClientId(msg:Object):void{
			trace(msg);
			
			trace("未登录");
		}
		
		
		
		
		
		private var incomingStreamDirect:NetStream = null;
		private var incomingStreamFms:NetStream = null;
		
		private function multiSubscribe(_nearId:String):void
		{
			incomingStreamFms = new NetStream(connects[clientName.text]);
			incomingStreamDirect = new NetStream(connects[clientName.text], _nearId);
			incomingStreamDirect.addEventListener(NetStatusEvent.NET_STATUS, streamHandler);
			
			incomingStreamFms.play("streamFms_"+otherClientName.text);
			incomingStreamDirect.play("streamDirect_"+otherClientName.text);
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
		
		
		
		protected function newClientHandle(event:MouseEvent):void
		{
			
			
			var nc:NetConnection = new NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS,
				netConnectionHandler);
			
			
//			nc.connect("rtmfp://54.68.25.225/app?name="+clientName.text);
			nc.connect("rtmfp://192.168.8.195/app?name="+clientName.text);
			
			nc.client = {log:refreshLog};
			
			
			connects[clientName.text] = nc;
			
			
		}
		
		protected function netConnectionHandler(event:NetStatusEvent):void
		{
			
			if(event.info.code=="NetConnection.Connect.Success"){
			
//				clientName.type = TextFieldType.DYNAMIC;
				otherClientName.visible = true;
				multiPublish();
			
			}
			
			
			
		}
		
		
	}
}