package com.mylib.framework.controller
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.AssetLibProxy;
	import com.studyMate.model.vo.IFileVO;
	import com.studyMate.model.vo.LocalFilesLoadCommandVO;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.module.ModuleConst;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class LocalFilesLoadUpdateCompleteCommand extends SimpleCommand implements ICommand
	{
		public function LocalFilesLoadUpdateCompleteCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var vo:LocalFilesLoadCommandVO = notification.getBody() as LocalFilesLoadCommandVO;
			var assetsProxy:AssetLibProxy = facade.retrieveProxy(ModuleConst.ASSET_LIB_PROXY) as AssetLibProxy;
			assetsProxy.completeNotice = vo.completeNotice;
			assetsProxy.completeNoticePara = vo.completeNoticeParameters;
			
			
			var arr:Array = [];
			
			for each (var i:UpdateListItemVO in vo.files) 
			{
				
				if(i.type=="swf"){
					arr.push(i)
					
				}
				
				
			}
			
			if(arr.length>0){
				assetsProxy.loadLibs(arr);
			}else{
				sendNotification(assetsProxy.completeNotice,assetsProxy.completeNoticePara);
			}
			
		}
		
	}
}