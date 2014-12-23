package com.studyMate.controller
{
	import com.mylib.framework.model.SimpleScriptNewProxy;
	import com.studyMate.model.vo.ScriptExecuseVO;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class ExecuseScriptNewCommand extends SimpleCommand implements ICommand
	{
		public function ExecuseScriptNewCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var proxy:SimpleScriptNewProxy = facade.retrieveProxy(SimpleScriptNewProxy.NAME) as SimpleScriptNewProxy;
			
			proxy.execusePage(notification.getBody() as ScriptExecuseVO);
		}
		
	}
}