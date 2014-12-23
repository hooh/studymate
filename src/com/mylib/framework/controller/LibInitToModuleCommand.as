package com.mylib.framework.controller
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.screens.CleanCpuMediator;
	import com.studyMate.world.screens.CleanGpuMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class LibInitToModuleCommand extends SimpleCommand
	{
		public function LibInitToModuleCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			sendNotification(CoreConst.SWITCH_MODULE,[new SwitchScreenVO(ModuleConst.OFF_BOOKSHELF_NEWVIEW2_MEDIATOR),new SwitchScreenVO(CleanCpuMediator)]);
		}
		
	}
}