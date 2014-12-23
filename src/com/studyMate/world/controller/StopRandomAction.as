package com.studyMate.world.controller
{
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class StopRandomAction extends SimpleCommand implements ICommand
	{
		public function StopRandomAction()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
			//清楚randomActionProxy
			var num:int = RandomActionCommand.RAProxy.length;
			for(var j:int = 0;j<num;j++){	
				RandomActionCommand.RAProxy[j].onRemove();
			}
			RandomActionCommand.RAProxy.splice(0,num); //清空
		}
		
	}
}