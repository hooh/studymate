package com.mylib.game.controller
{
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	
	public class SortContainerMediator extends Mediator
	{
		public static const NAME:String = "SortContainerMediator";
		public function SortContainerMediator()
		{
			super(NAME);
		}
		
		
		
		private function compareY(item1:DisplayObject,item2:DisplayObject):Number{
			
			if(item1.y>item2.y){
				return 1;
			}else if(item1.y<item2.y){
				return -1;
			}else{
				return 0;
			}
			
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case WorldConst.SORT_CONTAINER:
				{
					(notification.getBody() as DisplayObjectContainer).sortChildren(compareY);
					break;
				}
					
				default:
				{
					break;
				}
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.SORT_CONTAINER];
		}
		
	}
}