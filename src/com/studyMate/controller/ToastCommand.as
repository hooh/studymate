package com.studyMate.controller
{
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.view.component.ToastComponent;
	
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	
	
	public final class ToastCommand extends SimpleCommand implements ICommand
	{
		
		public function ToastCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
			var vo:ToastVO = notification.getBody() as ToastVO;						
			ToastComponent.getInstance().show(vo);
			
			
		}
		
	}
}