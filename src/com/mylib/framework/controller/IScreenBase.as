package com.mylib.framework.controller
{
	import starling.animation.IAnimatable;

	public interface IScreenBase extends IAnimatable
	{
		
		function activate():void;
		function deactivate():void;
		
		function get viewClass():Class;
	}
}