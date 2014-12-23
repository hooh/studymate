package com.studyMate.world.component.AndroidGame
{
	import com.edu.EduAllExtension;
	import com.greensock.TweenLite;
	import com.mylib.api.IConfigProxy;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.UpdateGameServiceCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.desktop.NativeApplication;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class GamePlayMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "GamePlayMediator";
		public static const START_PLAY_GAME:String = NAME + "StartPlayGame";
		
		private static const PLAY_TIME:String = NAME + "PlayTime";
		
		
		
		private var playItem:MyGameItem;
		
		public function GamePlayMediator(viewComponent:Object=null)
		{
			
			super(NAME, viewComponent);
		}
		override public function onRegister():void
		{
			super.onRegister();
			
			
			
			
		}
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName())
			{
				case START_PLAY_GAME:
					
					//这里需要加入停止下载申请.
					
					
					playItem = notification.getBody() as MyGameItem;
					
					//是应有
					if(playItem.gameVo.type == "APP" || playItem.gameVo.type == "SYS")
						lauchApp(playItem.gameVo.gid);
					else if(playItem.gameVo.type == "GAME"){
						sendNotification(CoreConst.MANUAL_LOADING,true);
						sendNotification(WorldConst.SET_MODAL,true);
						
						//游戏
						getPlayTime(playItem.gameVo.gid);
					
					
					}
					break;
				case PLAY_TIME:
					
					if((PackData.app.CmdOStr[0] as String)=="000"){
						var applyTime:int = int(PackData.app.CmdOStr[1]);
						
//						sendNotification(CoreConst.UPDATE_GAME_SERVICE,new UpdateGameServiceCommandVO(packName,applyTime,"playGame"));
						
						
						if(applyTime <= 0){
//							//时间不足以启动应用，取消禁屏
							sendNotification(WorldConst.SET_MODAL,false);
							sendNotification(CoreConst.MANUAL_LOADING,false);
							
							//后台提示信息
							sendNotification(WorldConst.DIALOGBOX_SHOW,
								new DialogBoxShowCommandVO(playItem.stage,640,381,null,"温馨提示："+PackData.app.CmdOStr[2]));
						}else{
							sendNotification(CoreConst.UPDATE_GAME_SERVICE,new UpdateGameServiceCommandVO(playItem.gameVo.gid,applyTime,"playGame"));
							
							//禁屏
							sendNotification(WorldConst.SET_MODAL,true);
							
							gotoPlayGame(playItem.gameVo.gid);
						}
					}
					
					
					break;
				
					
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [START_PLAY_GAME,PLAY_TIME];
		}
		
		
		private function getPlayTime(_gid:String):void{
				
			PackData.app.CmdIStr[0] = CmdStr.Play_Game_Time;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = _gid;
			PackData.app.CmdIStr[3] = "840";
			PackData.app.CmdInCnt = 4;	
			sendNotification(CoreConst.SEND_11,new SendCommandVO(PLAY_TIME,null,'cn-gb',null,SendCommandVO.QUEUE|SendCommandVO.UNIQUE));	//派发调用绘本列表参数，调用后台	
			
		}
		
		private function gotoPlayGame(_gid:String):void{
			
			sendNotification(WorldConst.DIALOGBOX_SHOW,
				new DialogBoxShowCommandVO(playItem.stage,640,381,null,"你有 "+900/60+" 分钟的游戏时间。"));
			
			TweenLite.delayedCall(0.5,edableApp,[_gid]);
			
			TweenLite.delayedCall(2,playGame,[_gid]);
		}
		
		private function edableApp(_gid:String):void{
			
			EduAllExtension.getInstance().rootExecuteExtension("pm enable "+ _gid);
			
		}
		private function playGame(_gid:String):void {
			lauchApp(_gid);
			Global.isUserExit = true;
			NativeApplication.nativeApplication.exit();
		}
		
		private function lauchApp(_gid:String):void {
			EduAllExtension.getInstance().launchAppExtension(_gid,"call");
		}
		
		
		
		
		
		
		override public function onRemove():void
		{
			super.onRemove();
			
			TweenLite.killTweensOf(edableApp);
			TweenLite.killTweensOf(lauchApp);
			
		}
		
		
		
		
		
	}
}