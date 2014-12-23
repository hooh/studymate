package com.studyMate.module
{
	import com.mylib.api.IFileLoadProxy;
	import com.mylib.framework.CoreConst;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	public class ModuleUtils
	{
		public static function getModuleClass(classPath:String):Class{
			
			return (Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.FILE_LOAD_PROXY) as IFileLoadProxy).getLibClass(classPath);
			
			
		}
		
	}
}