package com.studyMate.world.controller
{
	import com.studyMate.world.screens.NoticeBoardMediator;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class HideNoticeBoardCommand extends SimpleCommand implements ICommand
	{
		public function HideNoticeBoardCommand(){
			super();
		}
		
		override public function execute(notification:INotification):void{
			/*if(facade.retrieveMediator(NoticeBoardMediator.NAME)){
				var noticeBoard:NoticeBoardMediator = facade.retrieveMediator(NoticeBoardMediator.NAME) as NoticeBoardMediator;
				AppLayoutUtils.uiLayer.removeChild(noticeBoard.view,true);
				facade.removeMediator(NoticeBoardMediator.NAME);
			}*/
			
			
			if(facade.hasMediator(NoticeBoardMediator.NAME)){
				var noticeBoard:NoticeBoardMediator = facade.retrieveMediator(NoticeBoardMediator.NAME) as NoticeBoardMediator;
				if(noticeBoard){
					noticeBoard.stopPlay();
					noticeBoard.view.removeFromParent();
				}
			}
		}
	}
}