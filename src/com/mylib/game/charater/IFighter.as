package com.mylib.game.charater
{
	import com.mylib.game.charater.fightState.IFightState;
	import com.mylib.game.charater.skill.ISkill;
	import com.mylib.game.charater.weapon.WeaponInfor;

	public interface IFighter extends ICharater
	{
		function attackAction(_speed:Number):void;
		function defenseAction():void;
		function hitAction():void;
		function die():void;
		function fallDown():void;
		function get hp():int;
		function set hp(_int:int):void;
		function set attackRange(_int:int):void;
		function get attackRange():int;
		function set minAttackRange(_int:int):void;
		function get minAttackRange():int;
		function get attackRate():Number;
		function set attackRate(_value:Number):void;
		function set attackInterval(_value:Number):void;
		function get attackInterval():Number;
		function get breakChance():Number;
		function set breakChance(_num:Number):void;
		function get lucky():Number;
		function set luck(_num:Number):void;
		function get attack():int;
		function set attack(_int:int):void;
		function get defense():int;
		function set defense(_int:int):void;
		function set hpMax(_int:int):void;
		function get hpMax():int;
		function set dodge(_num:Number):void;
		function get dodge():Number;
		function get level():int;
		function set level(_lv:int):void;
		function get skills():Vector.<ISkill>;
		function addSkill(_skill:ISkill):void;
		function get fightStates():Vector.<IFightState>;
		function addState(_fs:IFightState):void;
		function set weapon(_w:WeaponInfor):void;
		function get weapon():WeaponInfor;
		
	}
}