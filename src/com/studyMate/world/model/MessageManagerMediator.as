package com.studyMate.world.model
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.model.vo.MessageVO;
	import com.studyMate.world.screens.HappyIslandMediator;
	import com.studyMate.world.screens.ShowMessageMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.WorldMediator;
	import com.studyMate.world.vo.ButtonTipsVO;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class MessageManagerMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MessageManagerMediator";
		public static const QUERYALLMESSAGE:String = NAME + "QueryAllMessage";
		public static const READ_MESSAGE:String = NAME + "ReadMessage";
		public static const GET_UNREAD_MESSAGE:String = NAME + "GetUnreadMessage";
		public static const GET_NEW_MESSAGE:String = NAME + "GetNewMessage";
		public static const CHANGE_READ_FLAG:String = NAME + "ChangeReadFlag";
		
		private var messages:Vector.<MessageVO>;
		private var message:MessageVO;
		private var stage:*;
		
		public function MessageManagerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void{
			super.onRegister();
		}
		
		override public function onRemove():void{
			super.onRemove();
		}
		
		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			var msg:MessageVO;
			switch(notification.getName()){
				case GET_UNREAD_MESSAGE :
					if(!result.isEnd){
						messages.push(new MessageVO(PackData.app.CmdOStr[1], null, 
							PackData.app.CmdOStr[2], PackData.app.CmdOStr[3], null, 
							PackData.app.CmdOStr[4], null, null, PackData.app.CmdOStr[5], 
							null, PackData.app.CmdOStr[6], null, PackData.app.CmdOStr[7]));
					}else{
//						if(messages.length > 0){
							/*var worldMediator:WorldMediator = facade.retrieveMediator(WorldMediator.NAME) as WorldMediator;
							if(worldMediator){
								sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ShowMessageMediator,[messages,null],SwitchScreenType.SHOW, worldMediator.view.stage)]);
							}*/
						messages.length>0?Global.unreadMessage = true:Global.unreadMessage = false;
						sendNotification(WorldConst.MESSAGE_DATA, messages);
//						}
					}
					break;
				case QUERYALLMESSAGE :
					if(!result.isEnd){
						messages.push(new MessageVO(PackData.app.CmdOStr[1],PackData.app.CmdOStr[2],
							PackData.app.CmdOStr[3],PackData.app.CmdOStr[4],PackData.app.CmdOStr[5],
							PackData.app.CmdOStr[6],PackData.app.CmdOStr[7],PackData.app.CmdOStr[8],
							PackData.app.CmdOStr[9],PackData.app.CmdOStr[10],PackData.app.CmdOStr[11],
							PackData.app.CmdOStr[12],PackData.app.CmdOStr[13]));
					}else{
						/*if(stage!=null){
							sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ShowMessageMediator,[messages,null],SwitchScreenType.SHOW, stage)]);
						}else{
							var englishIsland:HappyIslandMediator = facade.retrieveMediator(HappyIslandMediator.NAME) as HappyIslandMediator;
							if(englishIsland){
								sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ShowMessageMediator,[messages,null],SwitchScreenType.SHOW, englishIsland.view.stage)]);
							}
						}*/
						sendNotification(WorldConst.MESSAGE_DATA, messages,"all");
					}
					break;
				case WorldConst.HAVE_NEW_MESSAGE : 
					var msgType:String = notification.getBody() as String;
					branchByType(msgType);
					break;
				case GET_NEW_MESSAGE :
					if(!result.isErr){
						msg = new MessageVO(PackData.app.CmdOStr[1],PackData.app.CmdOStr[2],PackData.app.CmdOStr[3],
							PackData.app.CmdOStr[4],PackData.app.CmdOStr[5],PackData.app.CmdOStr[6],PackData.app.CmdOStr[7],
							PackData.app.CmdOStr[8],PackData.app.CmdOStr[9],PackData.app.CmdOStr[10],PackData.app.CmdOStr[11],
							PackData.app.CmdOStr[12],PackData.app.CmdOStr[13]);
						sendNotification(WorldConst.GET_GIFT, msg);
					}
					break;
				case CHANGE_READ_FLAG :
					message = notification.getBody() as MessageVO;
					readMessage(message.msgId);
					break;
				case READ_MESSAGE : 
					if(!result.isErr){
						message.readFlag = "R";
						Global.unreadMessage = messages.some(function(element:MessageVO, index:int, arr:Vector.<MessageVO>):Boolean{
							
							return element.readFlag=="U"?true:false;
							
						}
						);
						
						
					}
					break;
				case WorldConst.GET_UNREAD_MESSAGE :
					getUnreadMessage();
					break;
				case WorldConst.GET_ALL_MESSAGE : 
					stage = notification.getBody();
					getAllMessage();
					break;
				default : 
					break;
			}
		}
		
		override public function listNotificationInterests():Array{
			return [GET_UNREAD_MESSAGE, QUERYALLMESSAGE, WorldConst.HAVE_NEW_MESSAGE, 
				GET_NEW_MESSAGE, CHANGE_READ_FLAG, READ_MESSAGE, WorldConst.GET_UNREAD_MESSAGE, 
				WorldConst.GET_ALL_MESSAGE];
		}
		
		private function getUnreadMessage():void{
			messages = new Vector.<MessageVO>;
			PackData.app.CmdIStr[0] = CmdStr.QRY_UNREAD_MESSAGE;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 2;
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(GET_UNREAD_MESSAGE));
		}
		
		private function getAllMessage():void{
			messages = new Vector.<MessageVO>();
			PackData.app.CmdIStr[0] = CmdStr.QUERYALLMESSAGES;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 2;
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(QUERYALLMESSAGE));
		}
		
		private function getGift():void{
			PackData.app.CmdIStr[0] = CmdStr.GETNEWMESSAGE;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = "G";
			PackData.app.CmdInCnt = 3;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(GET_NEW_MESSAGE));
		}
		
		private function readMessage(msgid:String):void{
			PackData.app.CmdIStr[0] = CmdStr.UPDATEMESSAGE;
			PackData.app.CmdIStr[1] = msgid;
			PackData.app.CmdInCnt = 2;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(READ_MESSAGE,null,'cn-gb',null,SendCommandVO.QUEUE|SendCommandVO.UNIQUE));
		}
		
		private function branchByType(type:String):void{
			if(type == null) return;
			if(type == "M"){ //邮件
				sendNotification(WorldConst.CHANGE_BUTTON_TIPS, new ButtonTipsVO("MessageBtn", 1));
			}else if(type == "G"){  //礼包
				getGift();
			}
		}
		
	}
}