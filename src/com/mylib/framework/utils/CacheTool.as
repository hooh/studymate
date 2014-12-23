package com.mylib.framework.utils
{
	import com.mylib.api.ICacheProxy;
	
	import de.polygonal.ds.HashMap;
	import de.polygonal.ds.Iterator;

	public final class CacheTool
	{
		public static var cacheProxy:ICacheProxy;
		public static var viewData:HashMap = new HashMap();
		
		public function CacheTool()
		{
		}
		
		public static function put(viewName:String,cacheId:String,value:*):void{
			cacheProxy.setCache(viewName,cacheId,value);
		}
		
		/**
		 *往已有数组添加记录 
		 * @param viewName
		 * @param cacheId
		 * @param value
		 * 
		 */		
		public static function add(viewName:String,cacheId:String,value:*):void{
			var oarray:Array = cacheProxy.viewCache.find(cacheProxy.getCacheName(viewName,cacheId)) as Array;
			oarray.push(value);
		}
		
		public static function clr(viewName:String,cacheId:String):void{
			cacheProxy.viewCache.remove(cacheProxy.getCacheName(viewName,cacheId));
		}
		
		/**
		 *清除视图的缓存数据 
		 * @param viewName
		 * @param force 是否强制清除
		 * 
		 */		
		public static function clrView(viewName:String,force:Boolean= false):void{
			
			
			var it:Iterator = cacheProxy.viewCache.getIterator();
			var key:String;
			var item:Object;
			while(it.hasNext()){
				key = it.next() as String;
				if(key&&key.search(viewName)>=0){
					item = cacheProxy.viewCache.find(key);
					
					cacheProxy.viewCache.remove(key);
					
					
					/*if(item!=null){
						var arr:Array = key.split("#");
						if(viewData.hasKey(arr[0])){
							
							var requests:Array = viewData.get(arr[0]) as Array;
							
							for each (var i:ViewDataRequest in requests) 
							{
								if(i.cacheId==arr[1]){
									if(i.autoUpdate){
										cacheProxy.viewCache.clr(key);
									}
									break;
								}
							}
							
							
							
							
						}
						
					}*/
					
				}
			}
			
			
			
			//cacheProxy.viewCache.clr(cacheProxy.getCacheName(viewName,cacheId));
		}
		
		
		
		public static function has(viewName:String,cacheId:String):Boolean{
			return cacheProxy.viewCache.containsKey(cacheProxy.getCacheName(viewName,cacheId));
		}
		
		
		
		
		
		
		public static function getByKey(viewName:String,cacheId:String):Object{
			return cacheProxy.viewCache.find(cacheProxy.getCacheName(viewName,cacheId));
		}
		
		
		public static function clrAll():void{
			cacheProxy.viewCache.clear();
		}
		
		
		
	}
}