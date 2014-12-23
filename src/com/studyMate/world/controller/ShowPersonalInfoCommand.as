package com.studyMate.world.controller
{
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.world.screens.CleanCpuMediator;
	import com.studyMate.world.screens.PersonalInfoMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	
	public class ShowPersonalInfoCommand extends SimpleCommand implements ICommand
	{
		
		public function ShowPersonalInfoCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
			if(!facade.hasMediator(PersonalInfoMediator.NAME)){			
				sendNotification(WorldConst.HIDE_MAIN_MENU);
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(PersonalInfoMediator,[notification.getBody()]),new SwitchScreenVO(CleanCpuMediator)]);
				
				
			}
		}
	}
}