package com.studyMate.controller
{
	import com.mylib.framework.model.FlowRecordProxy;
	import com.mylib.framework.model.OperRecordProxy;
	import com.studyMate.model.vo.RecordVO;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class OperRecordCommand extends SimpleCommand implements ICommand
	{
		public function OperRecordCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var proxy:OperRecordProxy = facade.retrieveProxy(OperRecordProxy.NAME) as OperRecordProxy;
			
			proxy.record(notification.getBody() as RecordVO);
			
			
		}
		
	}
}