package com.mylib.api
{
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.ScreenStack;

	public interface ISwitchScreenProxy
	{
		function get currentCpuScreen():ScreenBaseMediator;
		function get currentGpuScreen():ScreenBaseMediator;
		function get gpuStack():ScreenStack;
		function get cpuStack():ScreenStack;
		function set currentCpuScreen(value:ScreenBaseMediator):void;
		function set currentGpuScreen(value:ScreenBaseMediator):void;
		function get gpuMediators():Vector.<String>;
		function get cpuMediators():Vector.<String>;
		function set cpuMediators(value:Vector.<String>):void;
		function set gpuMediators(value:Vector.<String>):void;
		function get gpuFloatScreens():Vector.<SwitchScreenVO>;
		function set gpuFloatScreens(value:Vector.<SwitchScreenVO>):void;
		
		function get cpuFloatScreens():Vector.<SwitchScreenVO>;
		
		function set cpuFloatScreens(value:Vector.<SwitchScreenVO>):void;
		function switchViews(_views:Vector.<SwitchScreenVO>):void;
		function initScreen(_views:Vector.<SwitchScreenVO>):void;
		
		function get pushStackType():uint;
		
		function set pushStackType(value:uint):void;
	}
}