package com.studyMate.world.controller
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.ui.MusicSoundMediator;
	
	import flash.display.Sprite;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class ShowMusicPlayerCommand extends SimpleCommand implements ICommand
	{
		public function ShowMusicPlayerCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			if(Facade.getInstance(CoreConst.CORE).hasMediator(MusicSoundMediator.NAME)){
//				(Facade.getInstance(CoreConst.CORE).retrieveMediator(MusicSoundMediator.NAME) as MusicSoundMediator).showMusic();	
				sendNotification(MusicSoundMediator.SHOW_MUSIC);
			}else{
				var musicMediator:MusicSoundMediator = new MusicSoundMediator(new Sprite);
				Facade.getInstance(CoreConst.CORE).registerMediator(musicMediator);		
			}
			
			/*if(notification.getBody()){
				(facade.retrieveMediator(MusicSoundMediator.NAME) as MusicSoundMediator).playSelectMusic(String(notification.getBody()));
			}*/
		}
	}
}