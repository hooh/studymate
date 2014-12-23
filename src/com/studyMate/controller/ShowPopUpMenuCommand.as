package com.studyMate.controller
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.PushViewType;
	import com.studyMate.model.vo.PopUpMenuVO;
	import com.studyMate.model.vo.PushViewVO;
	
	import flash.display.DisplayObjectContainer;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	
	public class ShowPopUpMenuCommand extends SimpleCommand implements ICommand
	{
		public function ShowPopUpMenuCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var vo:PopUpMenuVO = notification.getBody() as PopUpMenuVO;
			var word:String = vo.word;
			var holder:DisplayObjectContainer = vo.holder;
			var x:Number = vo.x;
			var y:Number = vo.y;
			
//			sendNotification(ApplicationFacade.PUSH_VIEW,new PushViewVO(PopMenuView,word,null,null,null,null,PopMenuView.NAME,PushViewType.SHOW,holder,x,y));
		}
		
	}
}