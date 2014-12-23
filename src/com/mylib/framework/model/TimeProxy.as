package com.mylib.framework.model
{
	import com.greensock.TweenLite;
	import com.studyMate.global.Global;
	
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public final class TimeProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "TimeProxy";
		public var nowDate:Date;
		
		private var intervalId:int;
		
		private var startCountTime:int;
		
		public function TimeProxy()
		{
			super(NAME);
		}
		
		override public function onRegister():void
		{
			// TODO Auto Generated method stub
			super.onRegister();
		}
		
		public function setTimeByMS(ms:Number):void{
			
			nowDate = new Date(ms);
			Global.nowSec = Math.floor(ms*0.001);
			Global.nowDate = nowDate;
			
			startTime();
		}
		
		public function setDate(d:Date):void{
			nowDate = d;
			Global.nowSec = Math.floor(nowDate.time*0.001);
			Global.nowDate = nowDate;
			
			startCountTime = getTimer();
			
			startTime();
		}
		
		
		private function startTime():void{
//			TweenLite.killTweensOf(updateTime);
//			TweenLite.delayedCall(1,updateTime);
			
//			intervalId = setInterval(updateTime,1000);
		}
		
		override public function onRemove():void
		{
//			TweenLite.killTweensOf(updateTime);
//			clearInterval(intervalId);
		}
		
		
		private function updateTime():void{
			nowDate.seconds++;
			Global.nowSec++;
//			TweenLite.delayedCall(1,updateTime);
		}
		
		
	}
}