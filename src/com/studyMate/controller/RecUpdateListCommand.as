package com.studyMate.controller
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.db.schema.AssetsLib;
	import com.studyMate.model.vo.DataRequestVO;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.model.vo.UpdateListVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public final class RecUpdateListCommand extends SimpleCommand implements ICommand
	{
		public function RecUpdateListCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var vo:DataResultVO = notification.getBody() as DataResultVO
			var uvo:UpdateListVO = vo.para[0];
			
			if(vo.isErr){
				sendNotification(CoreConst.TOAST,new ToastVO("更新数据有错"));
			}else if(!vo.isEnd){
				var updateItem:UpdateListItemVO =  new UpdateListItemVO(PackData.app.CmdOStr[1],PackData.app.CmdOStr[2],PackData.app.CmdOStr[3],PackData.app.CmdOStr[4]);
				updateItem.size = parseInt(PackData.app.CmdOStr[6]);
				if(PackData.app.CmdOutCnt>7){
					updateItem.crc = String(PackData.app.CmdOStr[7]);
				}
				uvo.list.push(updateItem);
			}else{
				sendNotification(CoreConst.UPDATE_READY,uvo);
			}
			
			
			
			
			
			
			
		}
		
	}
}