package com.studyMate.model.vo
{
	import com.greensock.TweenLite;
	
	import flash.media.Sound;
	import flash.media.SoundChannel;

	public final class SoundVO
	{
		public var url:String;
		public var position:uint;
		public var duration:uint;
		
		public var initVolume:Number;
		
		//标志文件有没有被改变
		public var isChanged:Boolean;
		
		/**
		 *要循环的次数 
		 */		
		public var loop:uint;
		/**
		 *当前循环次数 
		 */		
		public var curLoopTime:uint;
		
//		public var soundChannel:SoundChannel;
//		public var sound:Sound;
		
		public var completeNotice:String;
		
		
		
		public function SoundVO(url:String='',position:uint=0,duration:uint=0,loop:uint=0,completeNotice:String=null,initVolume:Number=1)
		{
			this.url = url;
			this.position = position;
			this.duration = duration;
			this.loop = loop;
			curLoopTime = 0;
			this.completeNotice = completeNotice;
			this.initVolume = initVolume;
		}
		
		
//		public function get initVolume():Number
//		{
//			return _initVolume;
//		}
//
//		public function set initVolume(value:Number):void
//		{
//			_initVolume = value;
//		}
//
//		public function get position():uint
//		{
//			return _position;
//		}
//
//		public function set position(value:uint):void
//		{
//			if(_position!=value)
//				isChanged = true;
//			_position = value;
//		}
//
//		public function get duration():uint
//		{
//			return _duration;
//		}
//
//		public function set duration(value:uint):void
//		{
//			if(_duration!=value)
//				isChanged = true;
//			_duration = value;
//		}
//
//		public function get url():String
//		{
//			return _url;
//		}
//
//		public function set url(value:String):void
//		{
//			if(_url!=value)
//				isChanged = true;
//			_url = value;
//		}
		
		
		

	}
}