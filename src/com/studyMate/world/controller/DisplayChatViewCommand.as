package com.studyMate.world.controller
{
	import com.studyMate.world.controller.vo.DisplayChatViewCommandVO;
	import com.studyMate.world.screens.ChatViewMediator;
	import com.studyMate.world.screens.ui.ChatPanelMediator;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	
	public class DisplayChatViewCommand extends SimpleCommand implements ICommand
	{
		private var talkingBox:ChatPanelMediator;
		
		public function DisplayChatViewCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
			var vo:DisplayChatViewCommandVO = notification.getBody() as DisplayChatViewCommandVO;
			
			var chatView:ChatViewMediator = facade.retrieveMediator(ChatViewMediator.NAME) as ChatViewMediator;
			if(chatView){
				
				chatView.showMainChat(vo.visible,vo.chanel,vo.friId);
				
				
			}
			
			
		}

	}
}