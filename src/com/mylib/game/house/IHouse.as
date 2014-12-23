package com.mylib.game.house
{
	import starling.display.Sprite;

	public interface IHouse
	{
		function set houseInfo(houseInfo:HouseInfoVO):void;
		function get houseInfo():HouseInfoVO;

		
		function get view():Sprite;
		
		
		function set touchable(val:Boolean):void;
		
		
	}
}