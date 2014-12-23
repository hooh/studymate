package com.studyMate.world.controller
{
	import com.mylib.api.ISwitchScreenProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.utils.CacheTool;
	import com.studyMate.global.CmdStr;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.model.MyCharaterInforMediator;
	import com.studyMate.world.screens.HappyIslandMediator;
	import com.studyMate.world.screens.chatroom.ChatRoomMediator;
	import com.studyMate.world.screens.chatroom.ChatRoomOLProxy;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import starling.display.Sprite;
	
	public class ChatBeatCommand extends SimpleCommand
	{
		public function ChatBeatCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var screenName:String = CacheTool.getByKey(ChatRoomOLProxy.NAME,'map') as String;
			/*CacheTool.put(ChatRoomOLProxy.NAME,'map',ChatRoomMediator.NAME);*/
			//如果是娱乐岛，则使用标记OnlineLocationMediator，否则使用ChatRoomMediator
			var switchProxy:ISwitchScreenProxy = facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy;
			if(switchProxy.currentGpuScreen is HappyIslandMediator){
				CacheTool.put(ChatRoomOLProxy.NAME,'map',"OnlineLocationMediator");
				
			}else{
				CacheTool.put(ChatRoomOLProxy.NAME,'map',ChatRoomMediator.NAME);
				
			}
			
			PackData.app.CmdIStr[0] = CmdStr.QRY_REALTIMEINFV2;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = screenName;
			
			if(screenName == ChatRoomMediator.NAME || screenName == "OnlineControlMediator")
			{
				PackData.app.CmdInCnt = 3;
				
			}else{
				var playerCharaterManagement:MyCharaterInforMediator = facade.retrieveMediator(MyCharaterInforMediator.NAME) as MyCharaterInforMediator;
				var playerView:Sprite = playerCharaterManagement.playerCharater.view;
				PackData.app.CmdIStr[3] = (int(playerView.x)).toString();
				PackData.app.CmdIStr[4] = (int(playerView.y)).toString();
				
				PackData.app.CmdInCnt = 5;
				
			}
			
			
			sendNotification(CoreConst.BEATING,[screenName]);
			sendNotification(CoreConst.SEND_11,new SendCommandVO(CoreConst.BEAT_REC,null,"cn-gb",null,SendCommandVO.SILENT));
			
		}
	}
}