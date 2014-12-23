package com.studyMate.model
{
	
	import com.edu.EduAllExtension;
	import com.studyMate.global.Global;
	
	import flash.desktop.NativeApplication;
	import flash.utils.Timer;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class GameServiceProxy extends Proxy implements IProxy
	{
		public static var NAME:String = "GameServiceProxy";

		public var time:int;
		private var appId:String;
		private var playingGame:String;
		
		private var timer:Timer;
		private var preTimer:uint;
		private var preFrame:uint;
		public function GameServiceProxy()
		{
			super(NAME);
		}
		
		override public function onRegister():void
		{
			
			var appXml:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace=appXml.namespace();
			appId="air."+appXml.ns::id;
			
			
			
			
		}
		
		
		override public function onRemove():void
		{
			
		}


		
		/**
		 *更新android端的service 
		 * @param gameList 游戏列表
		 * @param time 剩余游戏时间
		 * 
		 */		
		public function update(gameList:String,time:int,opertation:String):void{
			var userName:String;
			if(Global.player){
				userName = Global.player.userName;
			}else{
				userName = "temp";
			}
			
			//launcher.execute("com.eduonline.service",opertation,[gameList,time.toString(),appId,userName]);
			EduAllExtension.getInstance().launchAppExtension("com.eduonline.service",opertation,[gameList,time.toString()]);
		}
		
		public function execute(commands:String,opertation:String):void{
			EduAllExtension.getInstance().launchAppExtension("com.eduonline.service",opertation,[commands]);
		}
		
		private function callApp(appName:String):void{
			EduAllExtension.getInstance().launchAppExtension(appName,"call");
			Global.isUserExit = true;
			NativeApplication.nativeApplication.exit();
		}
		
		
	}
}