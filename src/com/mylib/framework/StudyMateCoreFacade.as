package com.mylib.framework
{
	import com.mylib.framework.controller.StartupCommand;
	
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class StudyMateCoreFacade extends Facade
	{
		protected static var _instance:IFacade;
		
		public function StudyMateCoreFacade(key:String)
		{
			super(key);
			
			
		}
		
		
		
		override protected function initializeController():void
		{
			super.initializeController();
			
			registerCommand(CoreConst.STARTUP, StartupCommand);
			
			
		}
		
		
		
		public static function getInstance():IFacade{
			
			
			if(!_instance){
				
				if(Facade.hasCore(CoreConst.CORE)){
					_instance = Facade.getInstance(CoreConst.CORE)
					_instance.registerCommand(CoreConst.STARTUP, StartupCommand);
					return _instance;
				}
				
				return _instance = new StudyMateCoreFacade(CoreConst.CORE);
			}else{
				return _instance;
			}
			
			
		}
		
		
	}
}