package com.studyMate.controller
{
	import com.mylib.framework.model.SoundProxy;
	import com.studyMate.model.vo.SoundVO;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class SoundPlayCommand extends SimpleCommand implements ICommand
	{
		public function SoundPlayCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var sound:SoundProxy = facade.retrieveProxy(SoundProxy.NAME) as SoundProxy;
			sound.setData(notification.getBody());
			sound.play(notification.getBody() as SoundVO);
			
		}
		
	}
}