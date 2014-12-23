package com.mylib.framework.controller
{
	import com.mylib.framework.model.AssetLibProxy;
	import com.studyMate.model.vo.AssetsLoadVO;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class AssetsLoadCommand extends SimpleCommand implements ICommand
	{
		public function AssetsLoadCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
			var vo:AssetsLoadVO = notification.getBody() as AssetsLoadVO;
			
			var proxy:AssetLibProxy = facade.retrieveProxy(ModuleConst.ASSET_LIB_PROXY) as AssetLibProxy;
			
			proxy.completeNotice = vo.completeNotice;
			proxy.completeNoticePara = vo.completeNoticePara;
			sendNotification(WorldConst.SET_MODAL,true,"a");
			proxy.loadLibs(vo.assets);
			
			
		}
		
	}
}