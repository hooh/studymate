package com.mylib.api
{
	public interface IAssetLibProxy
	{
		function get libs():Vector.<String>;
		function getLibByViewId(vid:String):Array;
		function get newDomainLibs():Vector.<String>;
	}
}