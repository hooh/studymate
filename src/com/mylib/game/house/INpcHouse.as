package com.mylib.game.house
{
	import starling.extensions.PixelHitArea;

	public interface INpcHouse extends IHouse
	{
		function set hitArea(hitArea:PixelHitArea):void;
		function get hitArea():PixelHitArea;
		
		
		
	}
}