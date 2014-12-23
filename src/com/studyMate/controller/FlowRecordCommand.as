package com.studyMate.controller
{
	import com.mylib.framework.model.FlowRecordProxy;
	import com.studyMate.model.vo.RecordVO;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class FlowRecordCommand extends SimpleCommand implements ICommand
	{
		public function FlowRecordCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var proxy:FlowRecordProxy = facade.retrieveProxy(FlowRecordProxy.NAME) as FlowRecordProxy;
			
			proxy.record(notification.getBody() as RecordVO);
			
			
		}
		
	}
}