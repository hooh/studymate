package com.mylib.game.charater.logic
{
	import flash.geom.Vector3D;

	public interface IBoid
	{
		function getVelocity():Vector3D;
		function getMaxVelocity():Number;
		function getPosition():Vector3D;
		function getMass():Number;
	}
}