package com.mylib.framework.controller
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.AssetLibProxy;
	import com.studyMate.module.ModuleConst;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class LoadInitLibCommand extends SimpleCommand
	{
		public function LoadInitLibCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
			Assets.clean();
			var assetsProxy:AssetLibProxy = facade.retrieveProxy(ModuleConst.ASSET_LIB_PROXY) as AssetLibProxy;
			assetsProxy.completeNotice = CoreConst.LIB_INITIALIZED;
			assetsProxy.loadLibByViewId("init");
			
			
		}
		
	}
}