package com.mylib.game.fishGame
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	public class Obstacle extends Vector3D
	{
		public var center :Vector3D;
		public function Obstacle(x:Number=0, y:Number=0)
		{
			center = new Vector3D();
			super(x, y);
		}
	}
}