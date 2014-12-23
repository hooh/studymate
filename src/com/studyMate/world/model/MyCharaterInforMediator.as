package com.studyMate.world.model
{
	import com.mylib.game.charater.ICharater;
	import com.studyMate.world.controller.vo.LetCharaterWalkToCommandVO;
	import com.studyMate.world.model.vo.CharaterSuitsVO;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.geom.Point;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class MyCharaterInforMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MyCharaterInforMediator";
		
		public var playerCharater:ICharater;
		public var map:String;
		
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case WorldConst.UPDATE_PLAYER_CHARATER:
				{
					
					playerCharater = notification.getBody() as ICharater;
					
					if(playerCharater){
						sendNotification(WorldConst.MARK_MY_CHARATER,playerCharater);
					}
					
					
					break;
				}
				case WorldConst.UPDATE_PLAYER_MAP:{
					map = notification.getBody() as String;
					break;
				}
				case WorldConst.UPDATE_PLAYER_CHARATER_POSITION:{
					var p:Point = notification.getBody() as Point;
					playerCharater.walk();
					sendNotification(WorldConst.LET_CHARATER_WALK_TO,new LetCharaterWalkToCommandVO(playerCharater,p.x,p.y,playerCharater.velocity,walkCompleteHandle,[playerCharater]));
					
					break;
				}
				default:
				{
					break;
				}
			}
		}
		
		private function walkCompleteHandle(charater:ICharater):void
		{
			charater.idle();
		}
		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.UPDATE_PLAYER_CHARATER,WorldConst.UPDATE_PLAYER_CHARATER_POSITION,WorldConst.UPDATE_PLAYER_MAP];
		}
		
		override public function onRegister():void
		{
			// TODO Auto Generated method stub
			super.onRegister();
		}
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
		}
		
		
		public function MyCharaterInforMediator()
		{
			super(NAME, null);
		}
	}
}