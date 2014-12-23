package com.mylib.framework.utils
{
	import com.mylib.api.IFileLoadProxy;
	import com.studyMate.model.vo.IFileVO;
	
	import de.polygonal.ds.HashMap;
	import de.polygonal.ds.Iterator;

	public final class AssetTool
	{
		public static var fileLoadProxy:IFileLoadProxy;
		
		
		/**
		 *记录素材目录 key:view id value: 
		 */		
		public static var assetsMap:HashMap = new HashMap();
		public static var assets:Array = [];
		
		
		public function AssetTool()
		{
		}
		
		public static function getCurrentLibClass(cname:String):Class{
			return fileLoadProxy.getLibClass(cname);
		}
		
		public static function getAppClass(cname:String):Class{
			return fileLoadProxy.getAppClass(cname);
		}
		
		public static function hasLibClass(cname:String):Boolean{
			
			if(!fileLoadProxy){
				return false;
			}
			
			if(fileLoadProxy.childDomain.hasDefinition(cname)){
				return true;
			}
			
			if(fileLoadProxy.appDomain.hasDefinition(cname)){
				return true;
			}
			
			return false;
		}
		
		public static function findLibByPath(path:String):IFileVO{
			
			
			var it:Iterator = assetsMap.getIterator();
			
			while(it.hasNext()){
				
				var array:Array = it.next() as Array;
				
				for each (var i:IFileVO in array) 
				{
					if(i.path==path){
						
						return i as IFileVO;
					}
					
				}
				
				
				
			}
			
			
			
			
			return null;
		}
		
		
		
	}
}