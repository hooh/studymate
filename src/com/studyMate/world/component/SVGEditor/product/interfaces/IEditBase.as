package com.studyMate.world.component.SVGEditor.product.interfaces
{
	public interface IEditBase
	{
		function get id():String;
		function set id(value:String):void;
		function set type(value:String):void
		function get type():String
		function get x():Number;
		function set x(value:Number):void;
		function get y():Number;
		function set y(value:Number):void;
		function getElementXML():XML;
		function getAttribute(name:String):Object;
		function setAttribute(name:String, value:Object):void;
		function removeAttribute(name:String):void;
		function hasAttribute(name:String):Boolean;
		function getAllAttribute():Vector.<String>;
		
	}
}