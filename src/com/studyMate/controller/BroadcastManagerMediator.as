package com.studyMate.controller
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.SwitchScreenProxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.world.screens.CleanGpuMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.chatroom.ChatRoomMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class BroadcastManagerMediator extends Mediator
	{
		public static const NAME:String = "BroadcastManagerMediator";
		private static const DEFAULT_BROADCAST:Array = [
			WorldConst.BROADCAST_FAQ,
			WorldConst.BROADCAST_MAIL,
			WorldConst.BROADCAST_CHAT,
			WorldConst.BROADCAST_SYS,
			WorldConst.BROADCAST_CMD,
			WorldConst.BROADCAST_CMD,
			WorldConst.BROADCAST_CMD,
			WorldConst.BROADCAST_CMD
		];
		
		private static const LEARN_BROADCAST:Array = [
			WorldConst.BROADCAST_FAQ
		];
		
		private static const CLASSROOM_BROADCAST:Array = [
			WorldConst.BROADCAST_CLASS
		];
		
		private static const CHATROOM_BROADCAST:Array = [
			WorldConst.BROADCAST_CHATROOM
		];
		
		private static const ONLINE_BROADCAST:Array = [
			WorldConst.BROADCAST_ONLINE
		];
		
		private static const ISLAND_BROADCAST:Array = [
			WorldConst.BROADCAST_ISLAND
		];
		
		public function BroadcastManagerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case CoreConst.BEATING:
				{
					
					var screenName:String = (notification.getBody() as Array)[0];
					
					if(screenName=="com.studyMate.module.engLearn.TaskListMediator"){
						Global.msgMap = LEARN_BROADCAST;
					}else if(screenName.indexOf('ClassroomMediator')!=-1){//房间是带id号的
						Global.msgMap = CLASSROOM_BROADCAST;
					}else if(screenName.indexOf("ChatRoomMediator") != -1){
						Global.msgMap = CHATROOM_BROADCAST;
					}else if(screenName.indexOf("OnlineControlMediator") != -1){
						Global.msgMap = ONLINE_BROADCAST;
					}else if(screenName.indexOf("OnlineLocationMediator") != -1){
						Global.msgMap = ISLAND_BROADCAST;
					}else{
						Global.msgMap = DEFAULT_BROADCAST;
					}
					break;
				}
					
				default:
				{
					break;
				}
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [CoreConst.BEATING];
		}
		
		override public function onRegister():void
		{
			// TODO Auto Generated method stub
			super.onRegister();
		}
		
	}
}