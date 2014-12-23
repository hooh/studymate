package com.studyMate.world.component.SVGEditor.controller
{
	import com.studyMate.world.component.SVGEditor.model.MoveStageProxy;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class MoveHandCommand extends SimpleCommand
	{
		public function MoveHandCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			(facade.retrieveProxy(MoveStageProxy.NAME) as MoveStageProxy).startMove();
		}
		
	}
}