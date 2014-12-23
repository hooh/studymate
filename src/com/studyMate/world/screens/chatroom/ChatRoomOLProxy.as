package com.studyMate.world.screens.chatroom
{
	import com.greensock.TweenLite;
	import com.mylib.api.ISwitchScreenProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.utils.CacheTool;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.controller.ChatBeatCommand;
	import com.studyMate.world.controller.DefaultBeatCommand;
	import com.studyMate.world.screens.Const;
	import com.studyMate.world.screens.HappyIslandMediator;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class ChatRoomOLProxy extends Proxy implements IProxy
	{
		public static const NAME :String = "ChatRoomOLProxy";
		
		public function ChatRoomOLProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			
			/*CacheTool.put(NAME,'map',ChatRoomMediator.NAME);*/
			//如果是娱乐岛，则使用标记OnlineLocationMediator，否则使用ChatRoomMediator
			var switchProxy:ISwitchScreenProxy = facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy;
			if(switchProxy.currentGpuScreen is HappyIslandMediator){
				CacheTool.put(ChatRoomOLProxy.NAME,'map',"OnlineLocationMediator");
				
			}else{
				CacheTool.put(ChatRoomOLProxy.NAME,'map',ChatRoomMediator.NAME);
				
			}
			
			TweenLite.delayedCall(2,swapMap);
			
			//处理聊天心跳
			sendNotification(CoreConst.SET_BEAT_DUR,5);
			Facade.getInstance(CoreConst.CORE).registerCommand(CoreConst.BEAT,ChatBeatCommand);
			sendNotification(CoreConst.START_BEAT);	
			
		}
		
		private function swapMap():void{
			TweenLite.killDelayedCallsTo(swapMap);
			TweenLite.delayedCall(30,swapMap);
			
			CacheTool.put(NAME,'map',"OnlineControlMediator");
			
		}
		
		
		override public function onRemove():void
		{
			super.onRemove();
			
			TweenLite.killDelayedCallsTo(swapMap);
			
			sendNotification(CoreConst.SET_BEAT_DUR, Const.DEFAULT_BEAT_DUR);
			Facade.getInstance(CoreConst.CORE).registerCommand(CoreConst.BEAT,DefaultBeatCommand);//恢复默认心跳
//			sendNotification(CoreConst.START_BEAT);
			
			CacheTool.clr(NAME,'recId');
		}
		
		
	}
}