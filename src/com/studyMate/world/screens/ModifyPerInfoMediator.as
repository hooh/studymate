package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import myLib.myTextBase.TextFieldHasKeyboard;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.model.vo.StudentInfoVO;
	
	import flash.events.TouchEvent;
	import flash.text.TextFormat;
	
	import feathers.controls.Button;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;

	public class ModifyPerInfoMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "ModifyPerInfoMediator";
		private static const MODIFY_PASSWORD_COMPLETE:String = "modifyPasswordComplete";
		private static const MODIFY_NICKNAME_COMPLETE:String = "modifyNickNameComplete";
		
		private var vo:SwitchScreenVO;
		private var modifyType:String;
		private var stuInfoVo:StudentInfoVO;
		
		
		private var modifySp:Sprite;
		private var oldPSWInput:TextFieldHasKeyboard;
		private var newPSWFirInput:TextFieldHasKeyboard;
		private var newPSWSecInput:TextFieldHasKeyboard;
		
		private var NNameInput:TextFieldHasKeyboard;
		
		private var newNNameInput:TextFieldHasKeyboard;
		
		public function ModifyPerInfoMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}
		override public function prepare(vo:SwitchScreenVO):void{
			this.vo = vo;
			this.modifyType = vo.data[0];
			this.stuInfoVo = vo.data[1];
			
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function onRegister():void{
			init();
		}
		private function init():void{
			modifySp = new Sprite();
			view.addChild(modifySp);
			
			var quad:Quad = new Quad(Global.stageWidth, Global.stageHeight, 0);
			quad.alpha = 0.7;
			modifySp.addChild(quad);
			
			if(modifyType == "password")
				modifyPswSp();
			else if(modifyType == "nickName")
				modifyNNameSp();

		}
		//显示修改密码面板
		private function modifyPswSp():void{
			var pswBg:Image = new Image(Assets.getAtlasTexture("targetWall/otherScroll"));
			view.addChild(pswBg);
			var x:int = pswBg.width>>1;
			var y:int = pswBg.height>>1;
			pswBg.x = 640-x; 
			pswBg.y = 281-y;
			
			pswBg = new Image(Assets.getAtlasTexture("targetWall/otherScroll"));
			view.addChild(pswBg);
			pswBg.x = 640-x;
			pswBg.y = 381-y;
			
			pswBg = new Image(Assets.getAtlasTexture("targetWall/otherScroll"));
			view.addChild(pswBg);
			pswBg.x = 640-x;
			pswBg.y = 481-y;
			
			oldPSWInput = new TextFieldHasKeyboard();
			oldPSWInput.name = "oldPSWInput";
			oldPSWInput.prompt = "旧密码";
			oldPSWInput.restrict = "A-Za-z0-9";
			oldPSWInput.defaultTextFormat = new TextFormat("HeiTi",28);
//			oldPSWInput.displayAsPassword = true;
			oldPSWInput.maxChars = 30;
			oldPSWInput.x = pswBg.x + 15; 
			oldPSWInput.y = pswBg.y-185;
			oldPSWInput.width = pswBg.width; 
			oldPSWInput.height = 47;
			Starling.current.nativeOverlay.addChild(oldPSWInput);
			oldPSWInput.addEventListener(flash.events.TouchEvent.TOUCH_BEGIN,PSWInputTouchHandle);
			
			newPSWFirInput = new TextFieldHasKeyboard();
			newPSWFirInput.name = "newPSWFirInput";
			newPSWFirInput.prompt = "新密码";
			newPSWFirInput.restrict = "A-Za-z0-9";
			newPSWFirInput.defaultTextFormat = new TextFormat("HeiTi",28);
//			newPSWFirInput.displayAsPassword = true;
			newPSWFirInput.maxChars = 10;
			newPSWFirInput.x = pswBg.x + 15; 
			newPSWFirInput.y = pswBg.y-85;
			newPSWFirInput.width = pswBg.width; 
			newPSWFirInput.height = 47;
			Starling.current.nativeOverlay.addChild(newPSWFirInput);
			newPSWFirInput.addEventListener(flash.events.TouchEvent.TOUCH_BEGIN,PSWInputTouchHandle);
			
			newPSWSecInput = new TextFieldHasKeyboard();
			newPSWSecInput.name = "newPSWSecInput";
			newPSWSecInput.prompt = "确认新密码";
			newPSWSecInput.restrict = "A-Za-z0-9";
			newPSWSecInput.defaultTextFormat = new TextFormat("HeiTi",28);
//			newPSWSecInput.displayAsPassword = true;
			newPSWSecInput.maxChars = 10;
			newPSWSecInput.x = pswBg.x + 15; 
			newPSWSecInput.y = pswBg.y+15;
			newPSWSecInput.width = pswBg.width; 
			newPSWSecInput.height = 47;
			Starling.current.nativeOverlay.addChild(newPSWSecInput);
			newPSWSecInput.addEventListener(flash.events.TouchEvent.TOUCH_BEGIN,PSWInputTouchHandle);
			
			var pswSureBtn:Button = new Button();
			pswSureBtn.label = "确认";
			pswSureBtn.x = 800;
			pswSureBtn.y = pswBg.y-135;
			pswSureBtn.addEventListener(Event.TRIGGERED,pswSureBtnHandle);
			view.addChild(pswSureBtn);
			
			var pswCancleBtn:Button = new Button();
			pswCancleBtn.label = "取消";
			pswCancleBtn.x = 800;
			pswCancleBtn.y = pswBg.y-35;
			pswCancleBtn.addEventListener(Event.TRIGGERED,pswCancleBtnHandle);
			view.addChild(pswCancleBtn);
			
			
			
		}
		//显示修改昵称面板
		private function modifyNNameSp():void{
			var nnameBg:Image = new Image(Assets.getAtlasTexture("targetWall/otherScroll"));
			view.addChild(nnameBg);
			nnameBg.x = 640-(nnameBg.width>>1); 
			nnameBg.y = 381-(nnameBg.height>>1);
			
			NNameInput = new TextFieldHasKeyboard();
			NNameInput.defaultTextFormat = new TextFormat("HeiTi",28);
			NNameInput.name = "NNameInput";
			NNameInput.prompt = "新昵称";
			NNameInput.maxChars = 16;
			NNameInput.x = nnameBg.x + 15; 
			NNameInput.y = nnameBg.y+15;
			NNameInput.width = nnameBg.width; 
			NNameInput.height = 47;
			Starling.current.nativeOverlay.addChild(NNameInput);
			NNameInput.addEventListener(flash.events.TouchEvent.TOUCH_BEGIN,NNameInputTouchHandle);
			
			var nnameSureBtn:Button = new Button();
			nnameSureBtn.label = "确认";
			nnameSureBtn.x = 800;
			nnameSureBtn.y = nnameBg.y-35;
			nnameSureBtn.addEventListener(Event.TRIGGERED,nnameSureBtnHandle);
			view.addChild(nnameSureBtn);
			
			var nnameCancleBtn:Button = new Button();
			nnameCancleBtn.label = "取消";
			nnameCancleBtn.x = 800;
			nnameCancleBtn.y = nnameBg.y+65;
			nnameCancleBtn.addEventListener(Event.TRIGGERED,pswCancleBtnHandle);
			view.addChild(nnameCancleBtn);
		}
		
		private function nnameSureBtnHandle(event:Event):void{
			if(NNameInput.text == ""){
				sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,
					640,381,null,"修改昵称，请先填写完整左边信息。"));
			}else if(NNameInput.text == stuInfoVo.nickName){
				sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,
					640,381,null,"新旧昵称一样了，请重新输入。"));
			}else{
				//修改密码
				PackData.app.CmdIStr[0] = CmdStr.MODIFY_STUDENT_INFO;
				PackData.app.CmdIStr[1] = stuInfoVo.operId;
				PackData.app.CmdIStr[2] = NNameInput.text;
				PackData.app.CmdIStr[3] = stuInfoVo.realName;
				PackData.app.CmdIStr[4] = stuInfoVo.smsTelNo;
				PackData.app.CmdIStr[5] = stuInfoVo.birth;
				PackData.app.CmdIStr[6] = stuInfoVo.sign;
				PackData.app.CmdInCnt = 7;
				sendNotification(CoreConst.SEND_11,new SendCommandVO(MODIFY_NICKNAME_COMPLETE));
			}
			NNameInput.text = "";
		}
		
		private function pswSureBtnHandle(event:Event):void{
			if(oldPSWInput.text == "" ||newPSWFirInput.text == "" ||newPSWSecInput.text == ""){
				sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,
					640,381,null,"修改密码，请先填写完整左边信息。"));
			}else if(newPSWFirInput.text != newPSWSecInput.text){
				sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,
					640,381,null,"两次输入的密码不一致。"));
			}else if(oldPSWInput.text == newPSWSecInput.text){
				sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,
					640,381,null,"新密码与旧密码相同，请重新输入!"));
			}else{
				//修改密码
				PackData.app.CmdIStr[0] = CmdStr.MODIFYPASSWORD;
				PackData.app.CmdIStr[1] = Global.player.userName;
				PackData.app.CmdIStr[2] = oldPSWInput.text;
				PackData.app.CmdIStr[3] = newPSWSecInput.text;
				PackData.app.CmdInCnt = 4;
				sendNotification(CoreConst.SEND_11,new SendCommandVO(MODIFY_PASSWORD_COMPLETE));
			}
			oldPSWInput.text = "";
			newPSWFirInput.text = "";
			newPSWSecInput.text = "";
		}
		private function pswCancleBtnHandle(event:Event):void{
			vo.type = SwitchScreenType.HIDE;
			sendNotification(WorldConst.SWITCH_SCREEN,[vo]);
		}
		

		
		private function PSWInputTouchHandle(event:flash.events.TouchEvent):void{
			trace((event.target as TextFieldHasKeyboard).name);
		}
		private function NNameInputTouchHandle(event:flash.events.TouchEvent):void{
			trace((event.target as TextFieldHasKeyboard).name);
		}


		
		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case MODIFY_PASSWORD_COMPLETE:
					if(PackData.app.CmdOStr[0].toString() == "M10"){
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,
							640,381,null,"原始密码输入错误!"));
					}else if(PackData.app.CmdOStr[0].toString() == "000"){
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,
							640,381,null,"密码修改成功!~O(∩_∩)O~"));
					}else{
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,
							640,381,null,"密码修改失败!"));
					}
					
					
					break;
				case MODIFY_NICKNAME_COMPLETE:
					if(!result.isErr)
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,
							640,381,null,"昵称修改成功!~O(∩_∩)O~"));
					
					
					break;
			}
		}
		override public function listNotificationInterests():Array{
			return [MODIFY_PASSWORD_COMPLETE,MODIFY_NICKNAME_COMPLETE];
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class{
			return Sprite;
		}
		
		override public function onRemove():void{
			super.onRemove();
			
			if(modifyType == "password"){
				oldPSWInput.removeEventListener(flash.events.TouchEvent.TOUCH_BEGIN,PSWInputTouchHandle);
				Starling.current.nativeOverlay.removeChild(oldPSWInput);	
				
				newPSWFirInput.removeEventListener(flash.events.TouchEvent.TOUCH_BEGIN,PSWInputTouchHandle);
				Starling.current.nativeOverlay.removeChild(newPSWFirInput);	
				
				newPSWSecInput.removeEventListener(flash.events.TouchEvent.TOUCH_BEGIN,PSWInputTouchHandle);
				Starling.current.nativeOverlay.removeChild(newPSWSecInput);	
			}else if(modifyType == "nickName"){
				NNameInput.removeEventListener(flash.events.TouchEvent.TOUCH_BEGIN,NNameInputTouchHandle);
				Starling.current.nativeOverlay.removeChild(NNameInput);	
			}
		}
	}
}