package com.studyMate.world.controller
{
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.world.screens.ui.ChatPanelMediator;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	
	public class CreateTalkingBoxCommand extends SimpleCommand implements ICommand
	{
		private var talkingBox:ChatPanelMediator;
		
		public function CreateTalkingBoxCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			if(!facade.retrieveMediator(ChatPanelMediator.NAME)){
				talkingBox = new ChatPanelMediator();
				
				
				
				facade.registerMediator(talkingBox);
				talkingBox.view.x = 190;
				talkingBox.view.y = -450;
//				talkingBox.view.alpha = 0.8;
				
				AppLayoutUtils.uiLayer.addChild(talkingBox.view);
				
			}
		}
	}
}