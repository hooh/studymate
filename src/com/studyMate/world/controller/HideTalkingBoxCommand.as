package com.studyMate.world.controller
{
	import com.studyMate.world.screens.ui.ChatPanelMediator;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	
	public class HideTalkingBoxCommand extends SimpleCommand implements ICommand
	{
		private var talkingBox:ChatPanelMediator;
		
		public function HideTalkingBoxCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			if(facade.retrieveMediator(ChatPanelMediator.NAME)){
				var talkingBox:ChatPanelMediator = facade.retrieveMediator(ChatPanelMediator.NAME) as ChatPanelMediator;
				talkingBox.closeBtnHandle(null);
			}	
		}
	}
}