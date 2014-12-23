package com.mylib.framework.controller
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.UpdateProxy;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.IFileVO;
	import com.studyMate.model.vo.UpdateListItemVO;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class UpdateSingleFileCompleteCommand extends SimpleCommand implements ICommand
	{
		public function UpdateSingleFileCompleteCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var lib:IFileVO = notification.getBody() as IFileVO;
			var type:String = lib.type;
			var updateProxy:UpdateProxy = facade.retrieveProxy(UpdateProxy.NAME) as UpdateProxy;
			
			if(lib is UpdateListItemVO){
				
				for (var i:int = 0; i < updateProxy.fileSets.length; i++) 
				{
					if(lib.path==updateProxy.fileSets[i].path){
						updateProxy.fileSets[i].hasLoaded = true;
						break;
					}
				}
				
				
			}
			
			sendNotification(CoreConst.LOADING,false)
			updateProxy.updateNext();
			
			
		}
		
	}
}