package com.mylib.game.controller
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.utils.CacheTool;
	import com.mylib.game.controller.vo.WChatInfoVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.controller.DefaultBeatCommand;
	import com.studyMate.world.controller.vo.CharaterStateVO;
	import com.studyMate.world.screens.ChatViewMediator;
	import com.studyMate.world.screens.Const;
	import com.studyMate.world.screens.HappyIslandMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.chatroom.WCHolderMediator;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class OnlineLocationMediator extends Mediator implements IMediator
	{
		public static const NAME :String = "OnlineLocationMediator";
		
		private static const GET_WC_MESS_COMPLETE:String = NAME + "getWCMessComplete";
		
		
		private var wchatList:Array = [];
		private var currentIdx:int = 0;
		
		private var wcholderMediator:WCHolderMediator;
		private var mutilocation:MutiLocationMediator;
		
		
		public function OnlineLocationMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		
		override public function onRegister():void
		{
			super.onRegister();
			
			mutilocation = new MutiLocationMediator();
			facade.registerMediator(mutilocation);
			
			wcholderMediator = facade.retrieveMediator(WCHolderMediator.NAME) as WCHolderMediator;
			
			CacheTool.put(NAME,'map',"OnlineLocationMediator");
			TweenLite.delayedCall(2,swapMap);
			
			//处理聊天心跳
			sendNotification(CoreConst.SET_BEAT_DUR,5);
			Facade.getInstance(CoreConst.CORE).registerCommand(CoreConst.BEAT,IslandBeatCommand);
			sendNotification(CoreConst.START_BEAT);	
			
		}
		
		private function swapMap():void{
			TweenLite.killDelayedCallsTo(swapMap);
			TweenLite.delayedCall(30,swapMap);
			
			CacheTool.put(NAME,'map',HappyIslandMediator.NAME);
			
		}
		
		
		private function dealWCData(_data:int):void{
			//本地没有聊天记录，idx为0；
			if(currentIdx == 0){
				
				//向后台取聊天记录
				
				getWCRecord("0");
				
			}else if(_data != currentIdx){
				
				getWCRecord(currentIdx.toString());
			}
			
			
		}
		
		//取世界聊天
		private function getWCRecord(_id:String):void{
			
			wchatList = [];
			
			PackData.app.CmdIStr[0] = CmdStr.QRY_WORLD_MESS_AFID;
			PackData.app.CmdIStr[1] = _id;
			PackData.app.CmdInCnt = 2;
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(GET_WC_MESS_COMPLETE,null,"cn-gb",null,SendCommandVO.QUEUE));
		}
		
		
		private function addWCRecord(_wcList:Array):void{
			if(!wcholderMediator)
			{
				return;
			}
			
			
			for(var i:int=0;i<_wcList.length;i++){
				
				if(Global.player.realName == _wcList[i].name){
					wcholderMediator.setWChatText("我 ： "+_wcList[i].content);
					
					
				}else if(Global.player.realName != _wcList[i].name){
					
					wcholderMediator.setWChatText(_wcList[i].name+" ： "+_wcList[i].content);
					sendNotification(WorldConst.UPDATE_CHARATER_STATE,
						new CharaterStateVO(_wcList[i].sendId,"",null,_wcList[i].content,"","set5,face_face1"));
					
				}
			}
		}
		
		
		
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName())
			{
				case WorldConst.BROADCAST_ISLAND:
					
					var data:String = PackData.app.CmdOStr[3] != 0 ? PackData.app.CmdOStr[3] : "";
					mutilocation.setData(data);
					
					dealWCData(PackData.app.CmdOStr[2]);
					
					break;
				case GET_WC_MESS_COMPLETE:
					
					//取回聊天记录
					if(!result.isEnd){
						var messId:int = PackData.app.CmdOStr[1];
						
						var wchatVO:WChatInfoVO = new WChatInfoVO(messId,PackData.app.CmdOStr[2],PackData.app.CmdOStr[3],PackData.app.CmdOStr[5],PackData.app.CmdOStr[4]);
						wchatList.push(wchatVO);
						
						if(messId > currentIdx)
						{
							currentIdx = messId;
						}
						
					}else{
						
						addWCRecord(wchatList);
						
						
						
					}
					break;
				
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.BROADCAST_ISLAND,GET_WC_MESS_COMPLETE];
		}
		
		
		
		override public function onRemove():void
		{
			super.onRemove();
			
			TweenLite.killDelayedCallsTo(swapMap);
			
			sendNotification(CoreConst.SET_BEAT_DUR, Const.DEFAULT_BEAT_DUR);
			Facade.getInstance(CoreConst.CORE).registerCommand(CoreConst.BEAT,DefaultBeatCommand);//恢复默认心跳
//			sendNotification(CoreConst.START_BEAT);
			
			facade.removeMediator(MutiLocationMediator.NAME);
			
			CacheTool.clr(NAME,'map');
			
		}
	}
}