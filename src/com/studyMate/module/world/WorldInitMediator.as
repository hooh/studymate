package com.studyMate.module.world
{
	import com.mylib.framework.CoreConst;
	import myLib.myTextBase.MyKeyboardComponentMediator;
	import com.studyMate.world.screens.CalloutMenuMediator;
	import com.studyMate.world.screens.CalloutMenuMediator2;
	import com.studyMate.world.screens.MenuMainViewMediator;
	import com.studyMate.world.screens.NetworkStateMediator;
	import com.studyMate.world.screens.NoticeBoardMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.menu.ShowMenuViewMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class WorldInitMediator extends Mediator
	{
		public static const NAME:String = "WorldInitMediator";
		public function WorldInitMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case CoreConst.CORE_READY:
				{
					init();
					break;
				}
				default:
				{
					break;
				}
			}
		}
		
		private function init():void{
			
			facade.registerMediator(new CalloutMenuMediator2());
//			facade.registerMediator(new ShowMenuViewMediator());
			facade.registerMediator(new NetworkStateMediator());
			facade.registerMediator(new MyKeyboardComponentMediator());
			facade.registerMediator(new NoticeBoardMediator());
			facade.registerMediator(new MenuMainViewMediator);
			
			sendNotification(WorldConst.STARTUP_APP);
			
			
			
			
			
			
		}
		
		
		
		
		override public function listNotificationInterests():Array
		{
			return [CoreConst.CORE_READY];
		}
		
		
		
		
		
	}
}