package com.mylib.game.controller
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.game.controller.vo.WChatInfoVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.controller.vo.CharaterStateVO;
	import com.studyMate.world.screens.ChatViewMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.geom.Point;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class MutiWSpeakMediator extends Mediator implements IMediator, IMutiOLManager
	{
		public static const NAME:String = "MutiWSpeakMediator";
		public static const GET_WC_HISTORY:String = NAME + "GetWCHistory";
		
		private static const QRY_WORLD_MESS_AFID_COMPLETE:String = NAME + "QryWorldMessAfidComplete";
		private static const QRY_WC_HISTORY_COMPLETE:String = NAME + "QryWCHistoryComplete";
		
		private var wchatList:Vector.<WChatInfoVO> = new Vector.<WChatInfoVO>;
		
		public function MutiWSpeakMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function onRegister():void
		{
			
		}
		
		
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName())
			{
				case QRY_WORLD_MESS_AFID_COMPLETE:
					
					//取回聊天记录
					if(!result.isEnd){
						var messId:int = PackData.app.CmdOStr[1];
						
						var wchatVO:WChatInfoVO = new WChatInfoVO(messId,PackData.app.CmdOStr[2],PackData.app.CmdOStr[3],PackData.app.CmdOStr[5],PackData.app.CmdOStr[4]);
						
						wchatList.push(wchatVO);
						
						if(messId > currentIdx){
							currentIdx = messId;
							wcHisId = currentIdx;
						}
						
					}else{
						isHisReady = true;
						
						addWCRecord(wchatList);
						
						sendNotification(WorldConst.MUTICONTROL_READY);
						
						
					}
					break;
				case QRY_WC_HISTORY_COMPLETE:
					//取回历史记录
					if(!result.isEnd){
						messId = PackData.app.CmdOStr[1];
						
						wchatVO = new WChatInfoVO(messId,PackData.app.CmdOStr[2],PackData.app.CmdOStr[3],PackData.app.CmdOStr[5],PackData.app.CmdOStr[4]);
						
						hisWCList.push(wchatVO);
						
						
					}else{
						refreshWCScroll(hisWCList);
						
						
					}
					break;
				case GET_WC_HISTORY:
					var _hisId:String = notification.getBody() as String;
					
					getWCHistory(_hisId);
					
					
					break;
				
				
			}
		}
		override public function listNotificationInterests():Array
		{
			return [QRY_WORLD_MESS_AFID_COMPLETE,QRY_WC_HISTORY_COMPLETE,GET_WC_HISTORY];
		}
		
		
		private var currentIdx:int = 0;
		private var mutiData:String;
		private var getFirstTime:Boolean;	//第一次取广播记录
		public function setData(_mutiData:String):void
		{
			mutiData = _mutiData;
			
			//本地没有聊天记录，idx为0；
			if(currentIdx == 0){
				
				getFirstTime = true;
				
				//向后台取聊天记录
				
				getWCRecord("0");
				
			}else{
				trace("消息ID："+currentIdx.toString());
				getFirstTime = false;
				
				getWCRecord(currentIdx.toString());
			}
		}
		
		private function getWCRecord(_id:String):void{
			TweenLite.killTweensOf(getWCRecord);
			if(Global.isLoading){
				TweenLite.delayedCall(2,getWCRecord,[_id]);
				return;
			}
			
			wchatList.splice(0,wchatList.length);
			
			PackData.app.CmdIStr[0] = CmdStr.QRY_WORLD_MESS_AFID;
			PackData.app.CmdIStr[1] = _id;
			PackData.app.CmdInCnt = 2;
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(QRY_WORLD_MESS_AFID_COMPLETE));
		}
		
		private var isHisReady:Boolean = false;
		private var wcHisId:int = 0;
		private var getTimes:int = 1;
		private var hisWCList:Vector.<WChatInfoVO> = new Vector.<WChatInfoVO>;
		private function getWCHistory(_id:String):void{
			if(!isHisReady)
				return;
			
			TweenLite.killTweensOf(getWCHistory);
			if(Global.isLoading){
				TweenLite.delayedCall(2,getWCHistory,[_id]);
				return;
			}
			
			wcHisId -= 50*getTimes;
			getTimes++;
			
			if(wcHisId > 0 && getTimes <= 5){
				hisWCList.splice(0,hisWCList.length);
				
				PackData.app.CmdIStr[0] = CmdStr.QRY_WORLD_MESS_AFID;
				PackData.app.CmdIStr[1] = wcHisId.toString();
				PackData.app.CmdInCnt = 2;
				sendNotification(CoreConst.SEND_1N,new SendCommandVO(QRY_WC_HISTORY_COMPLETE));
			}
		}
		
		
		
		
		
		
		private function addWCRecord(_wcList:Vector.<WChatInfoVO>):void{
			var chatView:ChatViewMediator = facade.retrieveMediator(ChatViewMediator.NAME) as ChatViewMediator;
			
			var isColor:Boolean;
			for(var i:int=0;i<_wcList.length;i++){
				isColor = false;
				
				if(Global.player.realName == _wcList[i].name && getFirstTime){
					chatView.setWChatText("我 ： "+_wcList[i].content);
					
//					chatView.mainChatScroller.setMyChat(_wcList[i].time,_wcList[i].content);
					chatView.getChatScroll("WC").setMyChat(_wcList[i].time,_wcList[i].content);
				}else if(Global.player.realName != _wcList[i].name){
					
					chatView.setWChatText(_wcList[i].name+" ： "+_wcList[i].content);
					
					if(_wcList[i].name == "系统公告" && _wcList[i].sendId == "150")	isColor = true;
					chatView.getChatScroll("WC").setOtherChat(_wcList[i].name,_wcList[i].time,_wcList[i].content,isColor);
					
					sendNotification(WorldConst.UPDATE_CHARATER_STATE,
						new CharaterStateVO(_wcList[i].sendId,"",null,_wcList[i].content,"","set5,face_face1"));
					
				}
			}
		}
		
		private function refreshWCScroll(_wcList:Vector.<WChatInfoVO>):void{
			var chatView:ChatViewMediator = facade.retrieveMediator(ChatViewMediator.NAME) as ChatViewMediator;
			
			chatView.getChatScroll("WC").removeUI();
			var isColor:Boolean;
			
			for(var i:int=0;i<_wcList.length;i++){
				isColor = false;
				
				if(Global.player.realName == _wcList[i].name){
					
					chatView.getChatScroll("WC").setMyChat(_wcList[i].time,_wcList[i].content);
				}else if(Global.player.realName != _wcList[i].name){
					
					if(_wcList[i].name == "系统公告" && _wcList[i].sendId == "150")	isColor = true;
					chatView.getChatScroll("WC").setOtherChat(_wcList[i].name,_wcList[i].time,_wcList[i].content,isColor);
					
				
				}
			}
			chatView.getChatScroll("WC").resetPos();
			
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		public function isReady(_param:*):Boolean
		{
			//本地id不同于后台 id，则执行广播模块
			if(currentIdx.toString() != _param)
				return true;
			else
				return false;
		}
		
		

		
		
		
		
		override public function onRemove():void
		{
			super.onRemove();
			
			TweenLite.killTweensOf(getWCRecord);
			TweenLite.killTweensOf(getWCHistory);
		}
		
		
		
		
	}
}