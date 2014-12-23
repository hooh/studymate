package com.studyMate.world.controller
{
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.world.screens.ui.ChatPanelMediator;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	
	public class DestroyTalkingBoxCommand extends SimpleCommand implements ICommand
	{
		private var talkingBox:ChatPanelMediator;
		
		public function DestroyTalkingBoxCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			if(facade.retrieveMediator(ChatPanelMediator.NAME)){
				var talkingBox:ChatPanelMediator = facade.retrieveMediator(ChatPanelMediator.NAME) as ChatPanelMediator;
				AppLayoutUtils.uiLayer.removeChild(talkingBox.view,true);
				facade.removeMediator(ChatPanelMediator.NAME);
			}	
		}
	}
}