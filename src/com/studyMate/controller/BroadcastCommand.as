package com.studyMate.controller
{
	import com.mylib.framework.model.vo.BeatVO;
	import com.studyMate.global.Global;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class BroadcastCommand extends SimpleCommand
	{
		
		public function BroadcastCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var msg:BeatVO = notification.getBody() as BeatVO;
			
			for (var i:int = 0; i < msg.data.length; i++) 
			{
				if(msg.data[i]){
					sendNotification(Global.msgMap[i],msg.data[i]);
				}
				
			}
		}
		
	}
}