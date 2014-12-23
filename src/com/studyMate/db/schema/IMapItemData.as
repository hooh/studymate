package com.studyMate.db.schema
{
	public interface IMapItemData
	{
		function get item():Item;
		
		function set item(value:Item):void;
		
		function get x():int;
		
		function set x(value:int):void;
		
		function get y():int;
		
		function set y(value:int):void;
		
		function get z():int;
		
		function set z(value:int):void;
		
		function get w():int;
		
		function set w(value:int):void;
		
		function get h():int;
		
		function set h(value:int):void;
		
		function get rotation():int;
		
		function set rotation(value:int):void;
		
		function get type():String;
		
		function set type(value:String):void;
		
		function get walkable():Boolean;
		
		function set walkable(value:Boolean):void;
		
		/**
		 *点击后的动作脚本 
		 */
		function get clickAction():String;
		
		/**
		 * @private
		 */
		function set clickAction(value:String):void;
		
		function get actualW():int;
		
		function get actualH():int;
	}
}