package com.studyMate.controller
{
	import com.mylib.framework.model.ScriptEngineProxy;
	import com.studyMate.model.vo.ScriptVO;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class EvalCommand extends SimpleCommand implements ICommand
	{
		public function EvalCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var vo:ScriptVO = notification.getBody() as ScriptVO;
			
			var engine:ScriptEngineProxy = facade.retrieveProxy(ScriptEngineProxy.NAME) as ScriptEngineProxy;
			engine.logDisplayer = vo.logDisplayer;
			
			
			if(vo.isMyScript){
				engine.evalScript(vo.script);
			}else{
				engine.eval(vo.script);
			}
			
			
		}
		
	}
}