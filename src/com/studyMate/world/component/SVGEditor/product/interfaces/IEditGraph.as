package com.studyMate.world.component.SVGEditor.product.interfaces
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public interface IEditGraph extends IEditBase
	{
		function begin(xx:Number, yy:Number):void;
		function draw(xx:Number, yy:Number):void;
		
		function get graphicSP():DisplayObject;
		function set graphicSP(value:DisplayObject):void;
	}
}