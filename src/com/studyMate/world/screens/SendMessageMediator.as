package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	
	import feathers.controls.Button;
	import feathers.controls.PickerList;
	import feathers.controls.Radio;
	import feathers.controls.TextInput;
	import feathers.core.ToggleGroup;
	import feathers.data.ListCollection;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;

	public class SendMessageMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "SendMessageMediator";
		public static const SEND_MESSAGE:String = NAME + "SendMessage";
		
		private var receiveId:TextInput;
		private var messageTxt:TextInput;
		private var sendBtn:Button;
		private var msgType:ToggleGroup;
		
		public function SendMessageMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function onRegister():void{
			var bg:Image = new Image(Assets.getTexture("task_bg"));
			bg.touchable = false;
			view.addChild(bg);
			
			var txtFld:TextField = new TextField(200,50,"接受者Id","HuaKanT",30,0x000000);
			txtFld.hAlign = HAlign.LEFT;
			txtFld.x = 200; txtFld.y = 200;
			view.addChild(txtFld);
			
			txtFld = new TextField(200,50,"消息文本内容","HuaKanT",30,0x000000);
			txtFld.hAlign = HAlign.LEFT;
			txtFld.x = 200; txtFld.y = 250;
			view.addChild(txtFld);
			
			receiveId = new TextInput();
			receiveId.x = 400; receiveId.y = 200;
			view.addChild(receiveId);
			
			msgType = new ToggleGroup();
			msgType.addEventListener(Event.CHANGE,msgTypeHandler);
			
			var radio:Radio = new Radio();
			radio.toggleGroup = msgType;
			radio.name = "M";
			radio.label = "消息";
			radio.x = 623; radio.y = 210;
			view.addChild(radio);
			
			radio = new Radio();
			radio.touchable = false;
			radio.toggleGroup = msgType;
			radio.name = "G";
			radio.label = "礼物";
			radio.x = 754; radio.y = 210;
//			view.addChild(radio);
			
			messageTxt = new TextInput();
			messageTxt.width = 820; messageTxt.height = 300;
			messageTxt.x = 200; messageTxt.y = 300;
			view.addChild(messageTxt);
			
			sendBtn = new Button();
			sendBtn.label = "发送";
			sendBtn.x = 990; sendBtn.y = 620;
			view.addChild(sendBtn);
			sendBtn.height = 39;
			sendBtn.addEventListener(Event.TRIGGERED,sendBtnHandler);
		}
		
		private function msgTypeHandler(e:Event):void{
			if((msgType.selectedItem as Radio).name == "G"){
				sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.stage,
					640,381,null,"礼品尚未领取功能，请慎用此选项. "));
			}
		}
		
		private function sendBtnHandler(e:Event):void{
			sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.stage,
				640,381,sendMsg,"确定要发送消息吗 "));
		}
		
		private function sendMsg():void{
			PackData.app.CmdIStr[0] = CmdStr.SEND_MESSAGE;
			PackData.app.CmdIStr[1] = receiveId.text;
			PackData.app.CmdIStr[2] = Global.player.operId;
			PackData.app.CmdIStr[3] = Global.player.userName;
			PackData.app.CmdIStr[4] = "H";
			PackData.app.CmdIStr[5] = (msgType.selectedItem as Radio).name;
			PackData.app.CmdIStr[6] = "0";
			PackData.app.CmdIStr[7] = "";
			PackData.app.CmdIStr[8] = messageTxt.text;
			PackData.app.CmdInCnt = 9;
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(SEND_MESSAGE));
		}
		
		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;		
			switch(notification.getName()){
				case SEND_MESSAGE :
					if(!result.isErr){
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.stage,
							640,381,null,"消息发送成功 "));
						receiveId.text = ""; messageTxt.text = "";
					}
					break;
			}
		}
		
		override public function listNotificationInterests():Array{
			return [SEND_MESSAGE];
		}
		
		override public function onRemove():void{
			super.onRemove();
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function get viewClass():Class{
			return Sprite;
		}
		
	}
}