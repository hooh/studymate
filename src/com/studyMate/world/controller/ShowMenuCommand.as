package com.studyMate.world.controller
{
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.world.screens.CalloutMenuMediator;
	import com.studyMate.world.screens.CalloutMenuMediator2;
	import com.studyMate.world.screens.menu.ShowMenuViewMediator;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	
	public class ShowMenuCommand extends SimpleCommand implements ICommand
	{
		
		public function ShowMenuCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
			var menu:CalloutMenuMediator2;
			menu = facade.retrieveMediator(CalloutMenuMediator2.NAME) as CalloutMenuMediator2;
			if(menu){				
				AppLayoutUtils.uiLayer.addChild(menu.view);
			}
		}
	}
}