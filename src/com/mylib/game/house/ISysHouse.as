package com.mylib.game.house
{
	import starling.extensions.PixelHitArea;

	public interface ISysHouse extends IHouse
	{
		function set hitArea(hitArea:PixelHitArea):void;
		function get hitArea():PixelHitArea;
		
		
		
		function set taskNum(value:int):void;
		function get taskNum():int;
		
	}
}