package com.mylib.api
{
	import flash.system.ApplicationDomain;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;

	public interface IFileLoadProxy extends IProxy
	{
		function get childDomain():ApplicationDomain;
		function get appDomain():ApplicationDomain;
		function getLibClass(cname:String):Class;
		function getAppClass(cname:String):Class;
		function resetChildDomain():void;
		function resetAppDomain():void;
		function disposeLibsDomain():void;
		function load():void;
	}
}