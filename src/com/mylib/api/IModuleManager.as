package com.mylib.api
{
	import flash.system.ApplicationDomain;

	public interface IModuleManager
	{
		function get domain():ApplicationDomain;
	}
}