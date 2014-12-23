package com.studyMate.world.controller.vo
{
	import com.mylib.game.charater.logic.FighterControllerMediator;
	
	import flash.geom.Point;

	public class AttackCharaterVO
	{
		public var attacker:FighterControllerMediator;
		public var target:FighterControllerMediator;
		public var position:Point;
		public var radius:int;
		public var skill:uint;
		
		public function AttackCharaterVO(attacker:FighterControllerMediator,target:FighterControllerMediator,skill:uint,position:Point=null,radius:int=0)
		{
			this.attacker = attacker;
			this.target = target;
			this.position = position;
			this.radius = radius;
			this.skill = skill;
		}
	}
}