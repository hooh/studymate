package com.mylib.api
{
	import flash.display.Sprite;
	
	import starling.display.Sprite;

	public interface IMainView
	{
		function get gpuLayer():starling.display.Sprite;
		function get cpuLayer():flash.display.Sprite;
		function get uiLayer():starling.display.Sprite;
		function get gpuPopUpLayer():starling.display.Sprite;
		
	}
}