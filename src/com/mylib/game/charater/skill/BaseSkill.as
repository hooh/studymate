package com.mylib.game.charater.skill
{
	import com.studyMate.world.controller.vo.AttackCharaterVO;
	
	import flash.utils.getTimer;

	public class BaseSkill implements ISkill
	{
		protected var _lastLaunchTime:int;
		protected var _type:uint;
		
		public function BaseSkill()
		{
		}
		
		public function get type():uint
		{
			return _type;
		}
		
		public function set type(_uint:uint):void
		{
			_type = _uint;
		}
		
		public function get lastLaunchTime():int
		{
			return _lastLaunchTime;
		}
		
		public function get coolDown():uint
		{
			return 0;
		}
		
		public function set coolDown(_uint:uint):void
		{
		}
		
		public function get rate():Number
		{
			return 0;
		}
		
		public function set rate(_num:Number):void
		{
		}
		
		public function get interval():Number
		{
			return 0;
		}
		
		public function set interval(_num:Number):void
		{
		}
		
		public function set level(_level:int):void
		{
		}
		
		public function get level():int
		{
			return 0;
		}
		
		public function launch(acvo:AttackCharaterVO):void
		{
			_lastLaunchTime = getTimer();
		}
	}
}