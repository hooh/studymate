package com.mylib.game.fishGame.ai
{
	import flash.geom.Vector3D;

	public interface IBoid
	{
		function update():void;
		function get position():Vector3D;
		function set position(value:Vector3D):void;
		function getAngle(vector :Vector3D) :Number;
		function get velocity():Vector3D;
		function set velocity(value:Vector3D):void;
	}
}