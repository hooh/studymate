package com.studyMate.world.events
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 *该类主要为绘本通知换位特效类
	 * @author 王途
	 * 
	 */	
	public class NoticeEffectEvent extends Event
	{
		//通知开始特效移动
		public static const MOVE_EFFECT_START:String = "MoveEffectStart";
		
		//通知返回起始状态
		public static const RESET_STATE:String = "ResetState";
		private var _startNum:int;//开始第几个
		private var _endNum:int;//结束第几个
		private var _special:String;//传入左，或者右
		private var _currentUI:Sprite;//当前拖动的原件
		
		public function NoticeEffectEvent(type:String)
		{
			super(type);
		}

		public function get startNum():int
		{
			return _startNum;
		}

		public function set startNum(value:int):void
		{
			_startNum = value;
		}

		public function get endNum():int
		{
			return _endNum;
		}

		public function set endNum(value:int):void
		{
			_endNum = value;
		}

		public function get special():String
		{
			return _special;
		}

		public function set special(value:String):void
		{
			_special = value;
		}

		public function get currentUI():Sprite
		{
			return _currentUI;
		}

		public function set currentUI(value:Sprite):void
		{
			_currentUI = value;
		}


	}
}