package com.studyMate.world.controller
{
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.world.screens.LeftButtonMenuMediator;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class HideLeftButtonCommand extends SimpleCommand implements ICommand
	{
		public function HideLeftButtonCommand(){
			super();
		}
		
		override public function execute(notification:INotification):void{
			if(facade.retrieveMediator(LeftButtonMenuMediator.NAME)){
				var leftMenu:LeftButtonMenuMediator = facade.retrieveMediator(LeftButtonMenuMediator.NAME) as LeftButtonMenuMediator;
				AppLayoutUtils.uiLayer.removeChild(leftMenu.view,true);
				facade.removeMediator(LeftButtonMenuMediator.NAME);
			}
		}
	}
}