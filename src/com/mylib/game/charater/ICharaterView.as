package com.mylib.game.charater
{
	import starling.display.Sprite;

	public interface ICharaterView
	{
		//角色的容器
		function get view():Sprite;
		function set scale(_s:Number):void;
		function get scale():Number;
		
		function set dirX(_d:int):void;
		function get dirX():int;
	}
}