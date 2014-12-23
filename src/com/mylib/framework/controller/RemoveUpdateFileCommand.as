package com.mylib.framework.controller
{
	import com.mylib.api.IConfigProxy;
	import com.mylib.framework.UpdateGlobal;
	import com.studyMate.global.Global;
	import com.studyMate.module.ModuleConst;
	
	import flash.filesystem.File;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class RemoveUpdateFileCommand extends SimpleCommand
	{
		public function RemoveUpdateFileCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var f:File = Global.document.resolvePath(UpdateGlobal.UPDATE_FILE_PATH);
			f = Global.document.resolvePath("tmpEDU/");
			if(f.exists){
				f.deleteDirectory(true);
			}
			
			
			
			var config:IConfigProxy = facade.retrieveProxy(ModuleConst.CONFIGPROXY) as IConfigProxy;
			config.updateValue(UpdateGlobal.CONFIG_KEY,UpdateGlobal.LATEST);
				
			
		}
		
	}
}