package com.mylib.framework
{
	import com.mylib.framework.controller.StartupBackgroundWorkCommand;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class BackgroundFacade extends Facade
	{
		protected static var _instance:BackgroundFacade;
		
		public function BackgroundFacade(key:String)
		{
			super(key);
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			
			registerCommand(CoreConst.STARTUP, StartupBackgroundWorkCommand);
			
			
		}
		
		public function startup():void
		{
			sendNotification(CoreConst.STARTUP);
		}
		
		public static function getInstance():BackgroundFacade{
			
			
			if(!_instance){
				return _instance = new BackgroundFacade(CoreConst.BACKGROUND);
			}else{
				return _instance;
			}
			
			
		}
		
	}
}