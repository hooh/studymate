package com.mylib.framework.controller
{
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class UpdateLibCommand extends SimpleCommand implements ICommand
	{
		
		private static var cache:ByteArray = new ByteArray();
		
		public function UpdateLibCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
			var data:DataResultVO = notification.getBody() as DataResultVO;
			
			var result:ByteArray = PackData.app.CmdOStr[2];
			
			if(data.isEnd){
				
				cache.clear();
			}else{
				cache.writeBytes(result);
				
			}
			
			
			
			
		}
		
	}
}