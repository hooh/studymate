package com.mylib.framework.controller
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.UploadProxy;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.UpLoadCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class UploadSegmentCompleteCommand extends SimpleCommand implements ICommand
	{
		public function UploadSegmentCompleteCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			
			var proxy:UploadProxy = facade.retrieveProxy(UploadProxy.NAME) as UploadProxy;
			
			if(!result.isErr){
				if(result.para[0] is UpLoadCommandVO){					
					var vo:UpLoadCommandVO = result.para[0];
					
					vo.process = parseInt(PackData.app.CmdOStr[2]);
					
					
					proxy.keepUpload(vo);
				}
				
			}
			
			
			
		}
		
	}
}