package com.studyMate.world.controller
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import com.studyMate.world.controller.vo.LetCharaterWalkToCommandVO;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class LetCharaterWalkToCommand extends SimpleCommand
	{
		public function LetCharaterWalkToCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var vo:LetCharaterWalkToCommandVO = notification.getBody() as LetCharaterWalkToCommandVO;
			
			if(vo.targetX>vo.target.view.x){
				vo.target.dirX = 1;
			}else{
				vo.target.dirX = -1;
			}
			
			
			TweenLite.killTweensOf(vo.target.view);
			
			if(vo.targetY!=vo.targetY){
				vo.targetY = vo.target.view.y;
			}
			
			var diffx:int = vo.targetX-vo.target.view.x;
			var diffy:int = vo.targetY-vo.target.view.y;
			var dis:int = Math.pow(diffx*diffx+diffy*diffy,0.5);
			
			TweenLite.to(vo.target.view,dis/(vo.speed*100),{x:vo.targetX,y:vo.targetY,onComplete:vo.completeFun,onCompleteParams:vo.completeFunParams,ease:Linear.easeNone});	
			
			
		}
		
	}
}