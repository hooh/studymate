package com.mylib.framework.controller
{
	import com.mylib.api.IFileLoadProxy;
	import com.mylib.framework.model.FileLoadProxy;
	import com.studyMate.module.ModuleConst;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class FileLoadCommand extends SimpleCommand implements ICommand
	{
		public function FileLoadCommand()
		{
		}
		
		override public function execute(notification:INotification):void
		{
			var proxy:IFileLoadProxy = facade.retrieveProxy(ModuleConst.FILE_LOAD_PROXY) as IFileLoadProxy;
			proxy.setData(notification.getBody());
			proxy.load();
		}
		
	}
}