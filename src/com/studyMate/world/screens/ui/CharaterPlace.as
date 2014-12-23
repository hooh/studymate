package com.studyMate.world.screens.ui
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.ICharater;
	import com.mylib.game.charater.IHuman;
	import com.studyMate.world.controller.vo.LetCharaterWalkToCommandVO;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	
	import starling.display.DisplayObject;
	
	public class CharaterPlace extends CharaterInterativeObject
	{
		protected var queue:Vector.<ICharater>;
		
		public var enterPoint:Point;
		
		public var exitPoint:Point;
		
		protected var user:ICharater;
		
		public function CharaterPlace(displayObj:DisplayObject,charater:ICharater=null)
		{
			super(displayObj,charater);
			queue = new Vector.<ICharater>;
			enterPoint = new Point;
			exitPoint = new Point;
		}
		
		override public function registerCharater(charater:ICharater):void
		{
			if(!(charater is IHuman)){
				throw new IllegalOperationError("here must be registered with human");
			}
			
			
			super.registerCharater(charater);
		}
		
		
		override public function takeAction(charater:ICharater):void
		{
			var idx:int = queue.indexOf(charater);
			if(idx>=0||user==charater||!display){
				return;
			}
			
			charater.walk();
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.LET_CHARATER_WALK_TO,new LetCharaterWalkToCommandVO(charater,display.x+enterPoint.x+(queue.length-1)*40,display.y+enterPoint.y,1,arrivedHandle,[charater]));
		}
		
		override public function stopAction(charater:ICharater):void
		{
			var idx:int = queue.indexOf(charater);
			if(user==charater){
				TweenLite.killTweensOf(charater.view);
				TweenLite.killTweensOf(finish,true);
				user = null;
				isBusy = false;
				pushQueue();
			}
			if(idx>=0){
				queue.splice(idx,1);
				sortQueue();
				pushQueue();
			}
			
			
			
		}
		
		/**
		 *到达门口 
		 * @param charater
		 * 
		 */		
		protected function arrivedHandle(charater:ICharater):void{
			
			if(!display){
				return;
			}
			
			
			queue.push(charater);
			charater.idle();
			charater.dirX = -1;
			sortQueue();
			pushQueue();
		}
		
		protected function pushQueue():void{
			if(!isBusy&&queue.length>0){
				var charater:ICharater = queue.shift();
				user = charater;
				isBusy = true;
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.LET_CHARATER_WALK_TO,new LetCharaterWalkToCommandVO(charater,display.x+exitPoint.x,display.y+exitPoint.y,1,enterHandle,[charater]));
				(charater as IHuman).walk();
				
				sortQueue();
			}
			
		}
		
		/**
		 *这里可以控制每次使用的人数 
		 * 
		 */		
		protected function sortQueue():void{
			var charater:ICharater;
			for (var i:int = 0; i < queue.length; i++) 
			{
				charater = queue[i];
				(charater as IHuman).walk();
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.LET_CHARATER_WALK_TO,new LetCharaterWalkToCommandVO(charater,display.x+enterPoint.x+i*40,display.y+enterPoint.y,1,waitHandle,[charater]));
			}
			
		}
		
		
		protected function waitHandle(charater:ICharater):void{
			if(!display){
				return;
			}
			
			
			charater.idle();
			charater.dirX = -1;
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			super.dispose();
			
			TweenLite.killTweensOf(finish);
		}
		
		
		
		/**
		 *进入建筑 
		 * @param charater
		 * 
		 */		
		protected function enterHandle(charater:ICharater):void{
			TweenLite.delayedCall(4,finish,[charater]);
			(charater as IHuman).sit();
		}
		
		protected function finish(charater:ICharater):void{
			isBusy = false;
			user = null;
			pushQueue();
			getOut(charater);
		}
		
		protected function getOut(charater:ICharater):void{
			charater.walk();
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.LET_CHARATER_WALK_TO,new LetCharaterWalkToCommandVO(charater,display.x+exitPoint.x,display.y+exitPoint.y,1,waitHandle,[charater]));
			
			
			
		}
		
		
		
		
	}
}