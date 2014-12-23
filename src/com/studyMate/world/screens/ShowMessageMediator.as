package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.controller.vo.EnableScreenCommandVO;
	import com.studyMate.world.model.MessageManagerMediator;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.model.vo.MessageVO;
	import com.studyMate.world.screens.component.SysRewardCartoonMediator;
	import com.studyMate.world.screens.ui.SVGMessageUI;
	
	import flash.text.TextFormat;
	
	import feathers.controls.ScrollText;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class ShowMessageMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "ShowMessageMediator";
//		public static const SHOW_ALL_MESSAGES:String = NAME + "ShowAllMessages";
//		public static const SHOW_NEW_MESSAGES:String = NAME + "ShowNewMessages";
		private const DEL_MESSAGE:String = NAME + "DeleteMessage";
		private const SET_MESSAGE_VISIBLE:String = NAME + "SetMessageVisible";
		public static const HIDE_VIEW:String = NAME + "HideView";
		private var vo:SwitchScreenVO;
		private var messages:Vector.<MessageVO>;
		
		private var _svgMessage:SVGMessageUI;
		public var msgTextField2:ScrollText;
		private var messageNumber:TextField;
		private var _messageIndex:int;
		private var sum:int;
		
		public function ShowMessageMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		public function get svgMessage():SVGMessageUI
		{
			if(_svgMessage==null){
				_svgMessage = new SVGMessageUI();
				_svgMessage.x = 165;_svgMessage.y = 90;
				_svgMessage.showWidth = 975;_svgMessage.showHeight = 500;
				view.addChild(_svgMessage);				
			}
			return _svgMessage;
		}

	

		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case REC_GIFT : 
					getGiftBtn.visible = false;
					messages[messageIndex].dealFlag = "Y";
					if(!result.isErr){
						if(PackData.app.CmdOStr[2] == "Gold"){
							sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SysRewardCartoonMediator,["奖励",PackData.app.CmdOStr[3]],SwitchScreenType.SHOW,view.stage,0,0)]);
						}
					}
					if(messages[messageIndex].msgText.indexOf('<@#Log>')==0){
						sendNotification(WorldConst.UPLOAD_SYSTEM_LOG);
					}
					break;
				case DEL_MESSAGE :
					if(!result.isErr){
						hasDeleted();
					}
					setViewVisible(true);
					break;
				case SET_MESSAGE_VISIBLE : 
					if(msgTextField2){
						msgTextField2.visible = notification.getBody() as Boolean;
					}
					break;
				case "deleMSG" :
					PackData.app.CmdIStr[0] = CmdStr.DELETE_MESSAGE;
					PackData.app.CmdIStr[1] = messages[messageIndex].msgId;
					PackData.app.CmdInCnt = 2;
					sendNotification(CoreConst.SEND_11,new SendCommandVO(DEL_MESSAGE,null,'cn-gb',null,SendCommandVO.QUEUE));
					break;
				case HIDE_VIEW : 
					vo.type = SwitchScreenType.HIDE;
					sendNotification(WorldConst.SWITCH_SCREEN,[vo]);
					break;
				case WorldConst.MESSAGE_DATA :
					messages = notification.getBody() as Vector.<MessageVO>;
					beginAt = 0;
					sum = messages.length;
					
					
					if(!sum&&notification.getType()!="all"){
						Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.CANCEL_SWITCH,vo);
						return;
					}
					
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
					break;
				case "noHandler":
					setViewVisible(true);
					break;
				default : 
					break;
			}
		}
		
		override public function listNotificationInterests():Array{
			return [REC_GIFT,DEL_MESSAGE,SET_MESSAGE_VISIBLE,"deleMSG",HIDE_VIEW,WorldConst.MESSAGE_DATA,"noHandler"];
		}
		
		private function hasDeleted():void{
			messages.splice(messageIndex, 1);
			sum--;
			if(messageIndex > 0){
				messageIndex = messageIndex - 1;
			}else{
				if(sum <= 0){
					vo.type = SwitchScreenType.HIDE;
					sendNotification(WorldConst.SWITCH_SCREEN,[vo]);
				}else{
					messageIndex = 0;
				}
			}
		}
		
		public function get messageIndex():int
		{
			return _messageIndex;
		}

		public function set messageIndex(value:int):void
		{
			getGiftBtn.visible = false;
			_messageIndex = value;
			
			if(!messages.length){
				return;
			}
			
			
			
			var parName:String = messages[_messageIndex].sopcode;
			var date:String = messages[_messageIndex].maketime;
			var dateStr:String = date.substr(0,4) + "-" + date.substr(4,2) + "-" + date.substr(6,2);
			
			if(messages[_messageIndex].msgText.indexOf('<svg')==0 || messages[_messageIndex].msgText.indexOf('<?xml')==0){
				msgTextField2.visible = false;
				svgMessage.visible = true;
				svgMessage.showSVGMessage(messages[_messageIndex].msgText);
			}else if(messages[_messageIndex].msgText.indexOf('<!DOCTYPE')==0){
				msgTextField2.visible = false;
				svgMessage.visible = true;
				svgMessage.showHtmlMessage(messages[_messageIndex].msgText);
			}else{
				msgTextField2.visible = true;
				if(_svgMessage)
					_svgMessage.visible = false;
				msgTextField2.verticalScrollPosition = 0;
				msgTextField2.text = "<p><font color='#6d4a2e' size='20'>" + Global.player.name + "</font></p><br/><p>" + messages[_messageIndex].msgText + "</p>";
				msgTextField2.text += "<br/><br/><font color='#6d4a2e' size='20'><p align = 'right'>" + parName + "</p><p align = 'right'>" + dateStr +"</p></font>";				
			}
			
			
			messageNumber.text = (messageIndex+1).toString() + "/" + sum.toString();
			if(messages[messageIndex].readFlag == "U" || messages[messageIndex].readFlag == null){
				sendNotification(MessageManagerMediator.CHANGE_READ_FLAG, messages[messageIndex]);
			}
			if(messages[messageIndex].msgType == "G" && messages[messageIndex].dealFlag == "N"){
				getGiftBtn.visible = true;
			}
		}
		
		public static const REC_GIFT:String = NAME + "RecGiftByMsgId";
		
		private function getGiftBtnHandler(event:Event):void{
			PackData.app.CmdIStr[0] = CmdStr.REC_GIFT_BY_MSG;
			PackData.app.CmdIStr[1] = messages[messageIndex].msgId;
			PackData.app.CmdInCnt = 2;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(REC_GIFT));
		}
		
		private var getGiftBtn:feathers.controls.Button;
		private var beginAt:int;

		override public function prepare(vo:SwitchScreenVO):void{
			/*this.vo = vo;
			messages = vo.data[0] as Vector.<MessageVO>;
			if(vo.data[1]) {
				beginAt = vo.data[1];
			}else{
				beginAt = 0;
			}
			sum = messages.length;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);*/
			
			
			
			messages = new Vector.<MessageVO>;
			
			
			
			
			this.vo = vo;
			var flag:String = vo.data[0] as String;
			if(flag == "U"){ //显示未读
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.GET_UNREAD_MESSAGE);
			}else if(flag == "A"){ //显示所有
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.GET_ALL_MESSAGE);
			}else if(flag == "B"){ //从写信界面返回的
				messages = vo.data[1] as Vector.<MessageVO>;
				if(vo.data[2]){
					beginAt = vo.data[2];
				}else{
					beginAt = 0;
				}
				sum = messages.length;
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
			}
		}
		
		
		override public function onRegister():void{
			sendNotification(WorldConst.HIDE_TALKINGBOX);
			var img:Image = new Image(Assets.getTexture("MessagePaper"));
			view.addChild(img);
			img.x = 28; img.y = 20;
			if(messages.length == 0){
				var txtField:TextField = new TextField(992, 57, "您的收件箱为空!", "HuaKanT", 40, 0x925200);
				txtField.autoScale = true; txtField.hAlign = HAlign.CENTER; txtField.vAlign = VAlign.CENTER;
				view.addChild(txtField);
				txtField.x = 157; txtField.y = 305;
			}else{
				var nextBtn:starling.display.Button = new starling.display.Button(Assets.getAtlasTexture("flip/zuo"));
				nextBtn.addEventListener(TouchEvent.TOUCH, nextBtnHandler);
				view.addChild(nextBtn);
				nextBtn.x = 592; nextBtn.y = 646;
				
				var preBtn:starling.display.Button = new starling.display.Button(Assets.getAtlasTexture("flip/you"));
				preBtn.addEventListener(TouchEvent.TOUCH, preBtnHandler);
				view.addChild(preBtn);
				preBtn.x = 724; preBtn.y = 646;
				
				messageNumber = new TextField(94, 35, "", "comic", 18, 0x88491b);
				messageNumber.autoScale = true; messageNumber.hAlign = HAlign.CENTER; messageNumber.vAlign = VAlign.CENTER;
				view.addChild(messageNumber);
				messageNumber.x = 630; messageNumber.y = 646;
				msgTextField2 = new ScrollText();
				msgTextField2.isHTML = true;
				view.addChild(msgTextField2);
				msgTextField2.x = 165; msgTextField2.y = 85;
				msgTextField2.width = 975; msgTextField2.height = 500;
								
				
				var mainFormat:TextFormat = new TextFormat();
				mainFormat.size = 24; mainFormat.color = 0x8e5841;
				mainFormat.font = "HeiTi";
				mainFormat.leading = 15;
				msgTextField2.textFormat = mainFormat;
				
				getGiftBtn = new feathers.controls.Button();
				getGiftBtn.label = "领取";
				getGiftBtn.scaleX = 2;
				getGiftBtn.scaleY = 2;
				getGiftBtn.visible = false;
				msgTextField2.addChild(getGiftBtn);
				getGiftBtn.x =  400;
				getGiftBtn.y = msgTextField2.height - 50;
				getGiftBtn.addEventListener(Event.TRIGGERED,getGiftBtnHandler);
				
				var replyBtn:Button = new Button(Assets.getAtlasTexture("message/reply"));
				replyBtn.x = 155; replyBtn.y = 47;
				view.addChild(replyBtn);
				replyBtn.addEventListener(TouchEvent.TOUCH, onReplyBtnhandler);
				
				var deleBtn:Button = new Button(Assets.getAtlasTexture("message/dele"));
				deleBtn.x = 262; deleBtn.y = 47;
				view.addChild(deleBtn);
				deleBtn.addEventListener(TouchEvent.TOUCH, onDeleBtnhandler);
				
				if(sum > 0){
					messageIndex = beginAt;
				}
			}
			
			var makeNew:Button = new Button(Assets.getAtlasTexture("message/new"));
			makeNew.x = 1097; makeNew.y = 600;
			view.addChild(makeNew);
			makeNew.addEventListener(TouchEvent.TOUCH, onMakeNewBtnhandler);
			
			var texture:Texture = Assets.getAtlasTexture("huInfo_closeBtn");
			var closeBtn:starling.display.Button = new starling.display.Button(texture);
			closeBtn.x = 1180; closeBtn.y = 10;
			closeBtn.addEventListener(TouchEvent.TOUCH, onCloseBtnHandler);
			view.addChild(closeBtn);
			sendNotification(MakeMessageMediator.HIDE_VIEW);
			sendNotification(WorldConst.HIDE_MAIN_MENU);
			sendNotification(WorldConst.SET_ROLL_SCREEN,false);
//			sendNotification(WorldConst.POPUP_SCREEN,new PopUpCommandVO(this,true));
			sendNotification(WorldConst.ENABLE_GPU_SCREENS, new EnableScreenCommandVO(false, NAME));
			
//			Global.stage.addEventListener(KeyboardEvent.KEY_DOWN,stageKeydownHandler,false,1);
		}
		
		/*protected function stageKeydownHandler(event:KeyboardEvent):void
		{
			// TODO Auto-generated method stub
			if(event.keyCode ==Keyboard.BACK || event.keyCode == Keyboard.ESCAPE){
				event.stopImmediatePropagation();
				event.preventDefault();
			}
		}*/
		
		private function onMakeNewBtnhandler(e:TouchEvent):void{
			var touch:Touch = e.getTouch(e.target as DisplayObject,TouchPhase.ENDED);
			if(touch){
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(MakeMessageMediator,[messages,messageIndex,null,null],SwitchScreenType.SHOW,AppLayoutUtils.uiLayer)]);
			}
		}
		
		private function onReplyBtnhandler(e:TouchEvent):void{
			var touch:Touch = e.getTouch(e.target as DisplayObject,TouchPhase.ENDED);
			if(touch){
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(MakeMessageMediator,[messages,messageIndex,messages[messageIndex].sid,messages[messageIndex].sopcode],SwitchScreenType.SHOW,AppLayoutUtils.uiLayer)]);
			}
		}
		
		private function onDeleBtnhandler(e:TouchEvent):void{
			var touch:Touch = e.getTouch(e.target as DisplayObject,TouchPhase.ENDED);
			if(touch){
				setViewVisible(false);
				var str:String = "确定删除本邮件吗？";
				sendNotification(WorldConst.ALERT_SHOW,new AlertVo(str,true,"deleMSG"));
				
			}
		}
		private function showDelBtn():void{
			
		}
		private var textParent:*;
		private function setViewVisible(_val:Boolean=false):void{
			if(view==null) return;
			view.visible = _val;
			svgMessage.visible = _val;

			if(_val){
				messageIndex = _messageIndex;
				if(textParent)	textParent.addChild(msgTextField2);
			}else{
				textParent = msgTextField2.parent;
				msgTextField2.removeFromParent();
			}
		}
		
		private function onCloseBtnHandler(e:TouchEvent):void{
			var touch:Touch = e.touches[0];
			if(touch.phase == TouchPhase.ENDED){
				vo.type = SwitchScreenType.HIDE;
				sendNotification(WorldConst.SWITCH_SCREEN,[vo]);
//				sendNotification(WorldConst.POP_SCREEN);
			}
		}
		
		private function nextBtnHandler(e:TouchEvent):void{
			var touch:Touch = e.touches[0];
			if(touch.phase == TouchPhase.ENDED){
				if(messageIndex > 0){
					messageIndex--;
				}
			}
		}
		
		private function preBtnHandler(e:TouchEvent):void{
			var touch:Touch = e.touches[0];
			if(touch.phase == TouchPhase.ENDED){
				if(messageIndex < sum-1){
					messageIndex++;
				}
			}
		}
		
		override public function onRemove():void{
//			Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN,stageKeydownHandler);
			sendNotification(WorldConst.SHOW_MAIN_MENU);
			sendNotification(WorldConst.SET_ROLL_SCREEN,true);
			sendNotification(WorldConst.ENABLE_GPU_SCREENS, new EnableScreenCommandVO(true));
//			sendNotification(WorldConst.REMOVE_POPUP_SCREEN,this);
			if(msgTextField2) msgTextField2.removeFromParent(true);
			super.onRemove();
		}
		
		override public function get viewClass():Class{
			return Sprite;
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
	}
}