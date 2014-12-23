package com.mylib.framework.model
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import so.ane.tts.event.TTSEvent;
	import so.ane.tts.extension.TTSExtension;
	
	public class TTSProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "TTSProxy";
		private var tts:TTSExtension;
		public var completeNotification:String = "playComplete";
		public var completeNotificationParameters:Object;
		
		public function TTSProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		override public function onRegister():void
		{
			tts = new TTSExtension();
			
			tts.addEventListener(TTSEvent.CREATE_ERROR, onError);
			tts.addEventListener(TTSEvent.PLAY_COMPLETED, playCompleteHandle);
			tts.create();
			
		}
		
		protected function onError(event:Event):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected function playCompleteHandle(event:Event):void
		{
			// TODO Auto-generated method stub
			sendNotification(completeNotification,completeNotificationParameters);
			
		}
		
		public function speak(text:String,pitch:Number=1,speechRate:Number=1):void{
			tts.speak(text,pitch,speechRate);
			
		}
		
		
		
		
	}
}