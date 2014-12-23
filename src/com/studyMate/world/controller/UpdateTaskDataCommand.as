package com.studyMate.world.controller
{
	import com.studyMate.world.controller.vo.UpdateTaskDataVO;
	import com.studyMate.world.model.TaskListManagementMediator;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class UpdateTaskDataCommand extends SimpleCommand implements ICommand
	{
		public function UpdateTaskDataCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var vo:UpdateTaskDataVO = notification.getBody() as UpdateTaskDataVO;
			
			var taskListManagementMediator:TaskListManagementMediator = facade.retrieveMediator(TaskListManagementMediator.NAME) as TaskListManagementMediator;
			taskListManagementMediator.updateTaskData(vo);
		}
		
	}
}