package com.mylib.framework.controller
{
	import com.edu.EduAllExtension;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.BackgroundWorkerMediator;
	import com.mylib.framework.model.InstallerMedaitor;
	import com.mylib.framework.model.SoundProxy;
	import com.mylib.framework.model.VersionManagerMediator;
	import com.studyMate.controller.ConfigProxy;
	import com.studyMate.controller.InstallAppCommand;
	import com.studyMate.controller.ModelPrepCommand;
	import com.studyMate.controller.NotificationPrepCommand;
	import com.studyMate.controller.SoundPlayCommand;
	import com.studyMate.controller.SoundStopCommand;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class StartupCommand extends SimpleCommand
	{
		
		
		override public function execute(notification:INotification):void
		{
			facade.registerProxy(new ConfigProxy());
			facade.registerMediator(new InstallerMedaitor);
			sendNotification(CoreConst.INSTALL_UPDATE);
			facade.removeMediator(InstallerMedaitor.NAME);
			
			
			
			facade.registerCommand(CoreConst.INSTALL_APP_COMMAND,InstallAppCommand);
			facade.registerMediator(new VersionManagerMediator);
			sendNotification(CoreConst.CHECK_APP_VERSION);
			
			facade.registerCommand(CoreConst.NOTIFICATION_PREP,NotificationPrepCommand);
			sendNotification(CoreConst.NOTIFICATION_PREP);
			facade.removeCommand(CoreConst.NOTIFICATION_PREP);
			facade.registerMediator(new BackgroundWorkerMediator());
//			facade.registerMediator(new BackgroundWorkerThreadMediator());
			facade.registerCommand(CoreConst.WORKER_RUNNING,ModelPrepCommand);
			sendNotification(CoreConst.SETUP_DATA_WORKER);
			
//			EduAllExtension.getInstance().runANRWatchDog();
		}
		
	}
}