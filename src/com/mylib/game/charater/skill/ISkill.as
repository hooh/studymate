package com.mylib.game.charater.skill
{
	import com.studyMate.world.controller.vo.AttackCharaterVO;

	public interface ISkill
	{
		function get type():uint;
		function set type(_uint:uint):void;
		function get lastLaunchTime():int;
		function get coolDown():uint;
		function set coolDown(_uint:uint):void;
		function get rate():Number;
		function set rate(_num:Number):void;
		function get interval():Number;
		function set interval(_num:Number):void;
		function set level(_level:int):void;
		function get level():int;
		function launch(acvo:AttackCharaterVO):void;
	}
}