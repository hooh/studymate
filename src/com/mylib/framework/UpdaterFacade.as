package com.mylib.framework
{
	import com.mylib.framework.controller.StartupUpdaterCommand;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class UpdaterFacade extends Facade
	{
		protected static var _instance:UpdaterFacade;
		
		public function UpdaterFacade(key:String)
		{
			super(key);
		}
		
		override protected function initializeController():void
		{
			// TODO Auto Generated method stub
			super.initializeController();
			registerCommand(CoreConst.STARTUP,StartupUpdaterCommand);
		}
		
		public function startup():void
		{
			sendNotification(CoreConst.STARTUP);
		}
		
		public static function getInstance():UpdaterFacade{
			
			if(!_instance){
				return _instance = new UpdaterFacade(CoreConst.CORE);
			}else{
				return _instance;
			}
			
			
		}
		
		
		
	}
}