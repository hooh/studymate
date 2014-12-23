package com.studyMate.controller
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.mylib.framework.model.DataBaseProxy;
	import com.studyMate.world.screens.FixMaterialMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class FixCommand extends SimpleCommand
	{
		public function FixCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			try
			{
				sendNotification(WorldConst.CLEAN_SCREEN,WorldConst.GPU|WorldConst.CPU);
				
				sendNotification(WorldConst.HIDE_MAIN_MENU);
				sendNotification(WorldConst.HIDE_LEFT_MENU);
				
				
				var db:DataBaseProxy = facade.retrieveProxy(DataBaseProxy.NAME) as DataBaseProxy;
				db.close();
				
				sendNotification(CoreConst.HIDE_ALERT_WINDOW);
				
			} 
			catch(error:Error) 
			{
				trace("FixCommand Error");
			}
			facade.registerMediator(new FixMaterialMediator());
			Global.stage.addChild(facade.retrieveMediator(FixMaterialMediator.NAME).getViewComponent() as DisplayObject);
		}
		
	}
}