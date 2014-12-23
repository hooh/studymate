package com.mylib.api
{
	import de.polygonal.ds.HashMap;

	public interface ICacheProxy
	{
		function setCache(viewName:String,cacheId:String,value:*):void;
		function hasCache(viewName:String,cacheId:String):Boolean;
		function getCacheName(viewName:String,cacheId:String):String;
		function get viewCache():HashMap;
	}
}