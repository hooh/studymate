package com.studyMate.world.model
{
	import com.studyMate.world.screens.WorldConst;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class SimSimiProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "SimSimiProxy";
		private var loader:URLLoader;
		private var request:URLRequest;
		private var vars:URLVariables;
		
		override public function onRegister():void
		{
			loader = new URLLoader();
			request = new URLRequest("http://app.simsimi.com/app/aicr/request.p");
			vars = new URLVariables();
			vars.tz="Asia Shanghai";
			vars.ft=0;
			vars.os="a";
			vars.av="6.5";
			vars.lc = "ch";
			vars.vkey="bbfbcb0e5385407caa3d457538fd8126";
			vars.uid=int(Math.random()*999999);
			request.method = URLRequestMethod.GET;
			request.data = vars;
			
			loader.addEventListener(Event.COMPLETE,receiveHandle);
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			
		}
		
		protected function errorHandler(event:IOErrorEvent):void
		{
			// TODO Auto-generated method stub
			trace("小鸡对话错误!");
		}
		
		public function sendMessage(msg:String,lc:String="ch"):void{
			
			vars.req = msg;
			vars.lc = lc;
			
			loader.load(request);
		}
		
		
		
		protected function receiveHandle(event:Event):void
		{
			var result:Object = JSON.parse(loader.data as String);
			
			if(result.result==200){
				sendNotification(WorldConst.REC_SIMSIMI_MSG,result.sentence_resp);
			}
			
		}
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
		}
		
		
		public function SimSimiProxy(data:Object=null)
		{
			super(NAME, data);
		}
	}
}