package com.mylib.game.controller
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.utils.CacheTool;
	import com.studyMate.global.CmdStr;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.model.MyCharaterInforMediator;
	import com.studyMate.world.screens.HappyIslandMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import starling.display.Sprite;
	
	public class IslandBeatCommand extends SimpleCommand
	{
		public function IslandBeatCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var screenName:String = CacheTool.getByKey(OnlineLocationMediator.NAME,'map') as String;
			CacheTool.put(OnlineLocationMediator.NAME,'map',"OnlineLocationMediator");
			
			PackData.app.CmdIStr[0] = CmdStr.QRY_REALTIMEINFV2;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = screenName;
			
			if(screenName == HappyIslandMediator.NAME)
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