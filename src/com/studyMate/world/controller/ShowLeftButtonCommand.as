package com.studyMate.world.controller
{
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.world.screens.LeftButtonMenuMediator;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ShowLeftButtonCommand extends SimpleCommand implements ICommand
	{
		
		public function ShowLeftButtonCommand(){
			super();
		}
		
		override public function execute(notification:INotification):void{
			
			if(!facade.retrieveMediator(LeftButtonMenuMediator.NAME)){
				var leftMenu:LeftButtonMenuMediator = new LeftButtonMenuMediator();
				facade.registerMediator(leftMenu);
				AppLayoutUtils.uiLayer.addChildAt(leftMenu.view,0);
			}
			
		}
	}
}