package com.mylib.game.charater
{
	import flash.geom.Rectangle;
	
	
	

	public interface ICharater extends ICharaterView
	{
		//木偶模型
		function get actor():IActor;
		
		function walk():void;
		function idle():void;
		function run():void;
		
		function dispose():void;
		
		function get charaterName():String;
		function set charaterName(value:String):void;
		
		function get sex():String;
		function set sex(value:String):void;
		
		
		function action(...parameters):void;
		
		function get currentAction():String;
		
		function set velocity(num:Number):void;
		function get velocity():Number;
		
		function get range():Rectangle;
		function set range(_r:Rectangle):void;
		
	}
}