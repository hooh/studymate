package com.mylib.framework.controller
{
	import com.mylib.framework.model.AssetLibProxy;
	import com.studyMate.module.ModuleConst;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class LoadNextLibCommand extends SimpleCommand implements ICommand
	{
		public function LoadNextLibCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
			var proxy:AssetLibProxy = facade.retrieveProxy(ModuleConst.ASSET_LIB_PROXY) as AssetLibProxy;
			proxy.loadNextLib();
		}
		
	}
}