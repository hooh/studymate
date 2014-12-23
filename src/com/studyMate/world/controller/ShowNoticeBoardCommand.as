package com.studyMate.world.controller
{
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.world.screens.NoticeBoardMediator;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ShowNoticeBoardCommand extends SimpleCommand implements ICommand
	{
		
		public function ShowNoticeBoardCommand(){
			super();
		}
		
		override public function execute(notification:INotification):void{
			
			/*if(!facade.retrieveMediator(NoticeBoardMediator.NAME)){
				var noticeBoard:NoticeBoardMediator = new NoticeBoardMediator();
				facade.registerMediator(noticeBoard);
				AppLayoutUtils.uiLayer.addChild(noticeBoard.view);
			}*/
			
			var noticeBoard:NoticeBoardMediator;
			noticeBoard = facade.retrieveMediator(NoticeBoardMediator.NAME) as NoticeBoardMediator;
			if(noticeBoard){				
				AppLayoutUtils.uiLayer.addChild(noticeBoard.view);
				noticeBoard.startPlay();
			}
			
		}
	}
}