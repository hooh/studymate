package com.mylib.framework.model
{
	
	import com.mylib.api.ICacheProxy;
	import com.mylib.framework.utils.CacheTool;
	
	import de.polygonal.ds.HashMap;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public final class CacheProxy extends Proxy implements IProxy,ICacheProxy
	{
		public static const NAME:String = "CacheProxy";
		private var _viewCache:HashMap;
		public var script:Vector.<String>;
		
		override public function onRegister():void
		{
			viewCache = new HashMap();
			script = new Vector.<String>;
			
			CacheTool.cacheProxy = this;
			
		}
		
		public function CacheProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		override public function onRemove():void
		{
			CacheTool.cacheProxy = null;
		}
		
		
		public function setCache(viewName:String,cacheId:String,value:*):void{
			var key:String = getCacheName(viewName,cacheId);
			if(viewCache.containsKey(key)){
				viewCache.remove(key);
			}
			
			viewCache.insert(key,value);
			
			
		}
		
		public function hasCache(viewName:String,cacheId:String):Boolean{
			return viewCache.remove(getCacheName(viewName,cacheId));
		}
		
		public function getCacheName(viewName:String,cacheId:String):String{
			return viewName+"#"+cacheId;
		}

		public function get viewCache():HashMap
		{
			return _viewCache;
		}

		public function set viewCache(value:HashMap):void
		{
			_viewCache = value;
		}
		
		
		
	}
}