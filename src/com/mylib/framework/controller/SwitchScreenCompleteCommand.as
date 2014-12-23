package com.mylib.framework.controller
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class SwitchScreenCompleteCommand extends SimpleCommand
	{
		public function SwitchScreenCompleteCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeCommand(WorldConst.SWITCH_SCREEN_COMPLETE);
			
			TweenLite.killTweensOf(deplaySendNotification);
			TweenLite.delayedCall(0.5,deplaySendNotification);
			Global.isFirstSwitch = true;
			
			if(!Global.isLoading||Global.isBeating){
				trace("switch complete");
				sendNotification(WorldConst.SET_MODAL,false);
			}
		}
		
		private function deplaySendNotification():void{
			
			sendNotification(CoreConst.HIDE_STARTUP_LOADING);
			
			//sendNotification(WorldConst.PICK_UP_BACKGROUND_MUSIC);
			
		}
		
	}
}