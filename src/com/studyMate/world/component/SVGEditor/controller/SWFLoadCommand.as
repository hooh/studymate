package com.studyMate.world.component.SVGEditor.controller
{
	import com.studyMate.world.component.SVGEditor.SVGConst;
	import com.studyMate.world.component.SVGEditor.model.SWFLoadProxy;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class SWFLoadCommand extends SimpleCommand
	{
		public function SWFLoadCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var url:String = notification.getBody() as String;
			
			var swfProxy:SWFLoadProxy = facade.retrieveProxy(SWFLoadProxy.NAME) as SWFLoadProxy;
			switch(notification.getName()){
				case SVGConst.UPDATE_SWF_LIBRARY:
					swfProxy.update();
					break;
				case SVGConst.LOAD_SWF:
					swfProxy.loadURL(url);					
					break;
			}
		}
		
	}
}