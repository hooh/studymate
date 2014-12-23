package com.mylib.game.charater.fightState
{
	import com.mylib.game.charater.logic.FighterControllerMediator;
	
	import flash.utils.getTimer;
	
	
	public class BaseFightState implements IFightState
	{
		private var _enterTime:int;
		private var _lastTime:Number;
		private var _type:uint;
		private var fighter:FighterControllerMediator;
		
		public function get type():uint
		{
			return _type;
		}
		
		public function set type(_t:uint):void
		{
			_type = _t;
		}
		
		
		
		
		public function BaseFightState(charaterState:FighterControllerMediator,casterState:FighterControllerMediator,skill:uint)
		{
			this.charaterState = charaterState;
			this.casterState = casterState;
			this.skill = skill;
		}
		
		
		
		public function enter():void
		{
			enterTime = getTimer();
		}
		
		public function exit():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function tick():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function set charaterState(_c:FighterControllerMediator):void
		{
			// TODO Auto Generated method stub
			fighter = _c;
		}
		
		public function get charaterState():FighterControllerMediator
		{
			return fighter;
		}

		public function get enterTime():int
		{
			return _enterTime;
		}

		public function set enterTime(value:int):void
		{
			_enterTime = value;
		}

		public function get lastTime():int
		{
			return _lastTime;
		}

		public function set lastTime(value:int):void
		{
			_lastTime = value;
		}
		
		
		public function set casterState(_c:FighterControllerMediator):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get casterState():FighterControllerMediator
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function get skill():uint
		{
			// TODO Auto Generated method stub
			return 0;
		}
		
		public function set skill(_t:uint):void
		{
			// TODO Auto Generated method stub
			
		}
		
	}
}