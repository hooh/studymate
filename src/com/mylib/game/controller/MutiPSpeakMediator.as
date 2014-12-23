package com.mylib.game.controller
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.game.controller.vo.PChatInfoVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.screens.ChatViewMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class MutiPSpeakMediator extends Mediator implements IMediator, IMutiOLManager
	{
		public static const NAME:String = "MutiPSpeakMediator";
		
		private static const QRYUR_INS_MESS_COMPLETE:String = NAME + "QryurInsMessComplete";
		
		private var pchatList:Vector.<PChatInfoVO> = new Vector.<PChatInfoVO>;
		
		
		
		public function MutiPSpeakMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName())
			{
				case QRYUR_INS_MESS_COMPLETE:
					//接收私信
					if(!result.isEnd){
						
						
						var pchatVO:PChatInfoVO = new PChatInfoVO(PackData.app.CmdOStr[1],PackData.app.CmdOStr[2],
							PackData.app.CmdOStr[3],PackData.app.CmdOStr[4],
							PackData.app.CmdOStr[5],PackData.app.CmdOStr[6],
							PackData.app.CmdOStr[7],PackData.app.CmdOStr[8]);
						
						pchatList.push(pchatVO);
						
					
						
					}else{
//						addWCRecord(wchatList);
						addPCRecord(pchatList);
						
						sendNotification(WorldConst.MUTICONTROL_READY);
						
						
					}
					
					
					break;
				
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [QRYUR_INS_MESS_COMPLETE];
		}
		
		
		
		
		
		
		public function setData(_mutiData:String):void
		{
			chatNum = Number(_mutiData);
			
			getPCRecord();
			
			
		}
		
		private function getPCRecord():void{
			TweenLite.killTweensOf(getPCRecord);
			if(Global.isLoading){
				TweenLite.delayedCall(2,getPCRecord);
				return;
			}
			
			pchatList.splice(0,pchatList.length);
			
			PackData.app.CmdIStr[0] = CmdStr.QRYUR_INS_MESS;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 2;
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(QRYUR_INS_MESS_COMPLETE));
			
			
			
			
		}
		
		//本地聊天记录缓存
		private var locChatList:Vector.<PChatInfoVO> = new Vector.<PChatInfoVO>;
		
		private function addPCRecord(_pchatList:Vector.<PChatInfoVO>):void{
			
			
			var chatView:ChatViewMediator = facade.retrieveMediator(ChatViewMediator.NAME) as ChatViewMediator;
			
			for(var i:int=0;i<_pchatList.length;i++){
				//过滤重复取回的聊天记录
				if(hasRecord(_pchatList[i]))
					continue;
				
				
				chatView.setFriListRemind(_pchatList[i]);
				
				
				locChatList.push(_pchatList[i]);
			}
			chatView.freshFriList();
			chatView.setLocChat(locChatList);
			
			
		}
		
		private function hasRecord(_pchat:PChatInfoVO):Boolean{
			var isHas:Boolean;
			
			for(var i:int=0;i<locChatList.length;i++){
				if(locChatList[i].id == _pchat.id){
					isHas = true;
					break;
				}
			}
			
			if(isHas)
				return true;
			else
				return false;
			
		}
		
		
		
		
		private var chatNum:Number = 0;
		public function isReady(_param:*):Boolean
		{
			trace("长度："+locChatList.length);
			//数量不等，则往后台取
			if(locChatList.length != _param)
				return true;
			else
				return false;
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			TweenLite.killTweensOf(getPCRecord);
		}
	}
}