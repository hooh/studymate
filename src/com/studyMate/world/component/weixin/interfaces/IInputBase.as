package com.studyMate.world.component.weixin.interfaces
{
	import starling.display.DisplayObject;

	public interface IInputBase
	{
		function  set core(value:String):void;
		function get core():String;
		//打开下拉菜单按钮
		function get addDropdownDisplayobject():DisplayObject;
		//下拉界面
		function set dropDownViewDisplayobject(value:DisplayObject):void;
		//下拉后的状态
		function dropdownState():void;
		function defaultState():void;//默认状态
	}
}