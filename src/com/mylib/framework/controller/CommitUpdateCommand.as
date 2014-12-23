package com.mylib.framework.controller
{
	import com.mylib.api.IConfigProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.UpdateGlobal;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.UpdateListVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class CommitUpdateCommand extends SimpleCommand
	{
		public function CommitUpdateCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
			var updateListVO:UpdateListVO = notification.getBody() as UpdateListVO
			var config:IConfigProxy = facade.retrieveProxy(ModuleConst.CONFIGPROXY) as IConfigProxy;
			if(updateListVO&&config.getValue(UpdateGlobal.CONFIG_KEY)==UpdateGlobal.COMMIT){
				PackData.app.CmdIStr[0] = CmdStr.SIGN_DOWN_HOST_FILE;
				PackData.app.CmdIStr[1] = Global.license.macid;
				PackData.app.CmdIStr[2] = PackData.app.head.dwOperID.toString();
				
				var str:String = "";
				
				for (var i:int = 0; i < updateListVO.list.length; i++) 
				{
					str += updateListVO.list[i].wbid+","+updateListVO.list[i].version+","+updateListVO.list[i].wfname+";";
				}
				
				PackData.app.CmdIStr[3] = str;
				
				PackData.app.CmdInCnt = 4;
				
				
				
				sendNotification(CoreConst.SEND_11,new SendCommandVO(CoreConst.COMMIT_UPDATE_COMPLETE));
				
			}else{
				
				
				sendNotification(CoreConst.COMMIT_UPDATE_COMPLETE);
				
			}
		}
		
	}
}