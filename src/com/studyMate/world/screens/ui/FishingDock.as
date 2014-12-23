package com.studyMate.world.screens.ui
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.ICharater;
	import com.mylib.game.charater.IHuman;
	import com.studyMate.world.controller.vo.LetCharaterWalkToCommandVO;
	import com.studyMate.world.screens.WorldConst;
	
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class FishingDock extends CharaterPlace
	{
		
		private var fishman:IHuman;
		
		public function FishingDock(displayObj:DisplayObject, charater:ICharater=null)
		{
			super(displayObj, charater);
			enterPoint.setTo(220,0);
			exitPoint.setTo(180,30);
			
		}
		
		override protected function touchHandle(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.target as DisplayObject,TouchPhase.ENDED);
			
			if(touch){
				
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.STOP_PLAYER_ACTION);
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.STOP_PLAYER_TALKING);
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.STOP_PLAYER_MOVE);
				
				
				takeAction(charater);
			}
		}
		
		
		override protected function enterHandle(charater:ICharater):void
		{
			fishman = charater as IHuman;
			TweenLite.delayedCall(5,finish,[charater]);
			
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.LET_CHARATER_WALK_TO,new LetCharaterWalkToCommandVO(charater,display.x+exitPoint.x,display.y+exitPoint.y+50,1,startFish));
		}
		
		private function startFish():void{
			if(fishman)
				fishman.sit();
			
		}
		
		override protected function finish(charater:ICharater):void
		{
			// TODO Auto Generated method stub
			super.finish(charater);
			fishman = null;
		}
		
		
	}
}