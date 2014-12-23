package com.studyMate.world.screens
{
	import flash.display.Sprite;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class LoginHistoryMediator extends Mediator
	{
		
		private const NAME:String = "LoginHistoryMediator";
		
		public function LoginHistoryMediator(viewComponent:Object = null)
		{
			super(NAME,viewComponent)
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			
		}
		
		override public function listNotificationInterests():Array
		{
			return[]
		}
		
		override public function onRegister():void
		{
			
		}
		
		override public function onRemove():void
		{
			
		}
	}
}