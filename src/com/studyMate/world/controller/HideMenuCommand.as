package com.studyMate.world.controller
{
//	import com.studyMate.world.screens.MainMenuMediator;
	
	import com.studyMate.world.screens.CalloutMenuMediator;
	import com.studyMate.world.screens.CalloutMenuMediator2;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	
	public class HideMenuCommand extends SimpleCommand implements ICommand
	{
		public function HideMenuCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
	/*		if(facade.hasMediator(MainMenuMediator.NAME)){
				var menu:MainMenuMediator = facade.retrieveMediator(MainMenuMediator.NAME) as MainMenuMediator;
				menu.view.removeFromParent();
				
			}*/
			
				if(facade.hasMediator(CalloutMenuMediator2.NAME)){
				var menu:CalloutMenuMediator2 = facade.retrieveMediator(CalloutMenuMediator2.NAME) as CalloutMenuMediator2;
				if(menu){					
					menu.view.removeFromParent();
				}
			}
			
/*			if(facade.hasMediator(ShowMenuViewMediator.NAME)){
				var menu:ShowMenuViewMediator = facade.retrieveMediator(ShowMenuViewMediator.NAME) as ShowMenuViewMediator;
				if(menu){
					menu.view.removeFromParent();
				}
			}*/
		}
	}
}