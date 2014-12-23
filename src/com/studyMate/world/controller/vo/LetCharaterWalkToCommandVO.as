package com.studyMate.world.controller.vo
{
	import com.mylib.game.charater.ICharater;

	public class LetCharaterWalkToCommandVO
	{
		public var target:ICharater;
		public var speed:Number;
		public var completeFun:Function;
		public var completeFunParams:Array;
		
		public var targetX:Number;
		public var targetY:Number;
		
		public function LetCharaterWalkToCommandVO(target:ICharater,targetX:Number,targetY:Number,speed:Number,completeFun:Function=null,completeFunParams:Array=null)
		{
			this.target = target;
			this.targetX = targetX;
			this.targetY = targetY;
			this.speed = speed;
			this.completeFun = completeFun;
			this.completeFunParams = completeFunParams;
		}
	}
}