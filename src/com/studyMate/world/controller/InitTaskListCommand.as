package com.studyMate.world.controller
{
	import com.studyMate.world.model.TaskListManagementMediator;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class InitTaskListCommand extends SimpleCommand implements ICommand
	{
		public function InitTaskListCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var taskListManagementMediator:TaskListManagementMediator = facade.retrieveMediator(TaskListManagementMediator.NAME) as TaskListManagementMediator;
			taskListManagementMediator.getTaskList();
		}
		
	}
}