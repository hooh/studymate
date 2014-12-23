package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.controller.SubPackInfoMediator;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import myLib.myTextBase.TextFieldHasKeyboard;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	
	import flash.text.TextFormat;
	
	import mx.utils.StringUtil;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	public class SetPasswordMediator extends ScreenBaseMediator
	{
		
		public static const NAME:String = 'SetPasswordMediator';
		
		private const MODIFY_PASSWORD_COMPLETE:String = "modifyPasswordComplete";
		private var vo:SwitchScreenVO;
		
		private var oldPSWInput:TextFieldHasKeyboard;
		private var newPSWFirInput:TextFieldHasKeyboard;
		private var newPSWSecInput:TextFieldHasKeyboard;
		
		
		public function SetPasswordMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			this.vo = vo;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function onRegister():void
		{
			facade.registerMediator(new SubPackInfoMediator());

			var bg:Image = new Image(Assets.getTexture('passwordSetBg'));
			view.addChild(bg);
			
			var sureBtn:starling.display.Button = new starling.display.Button(Assets.getAtlasTexture("config2"));		
			sureBtn.x = 587;
			sureBtn.y = 615;
			view.addChild(sureBtn);
			sureBtn.addEventListener(Event.TRIGGERED,sureCilckHandler);
			
			var tf:TextFormat = new TextFormat('HeiTi,',28);
			
			oldPSWInput = new TextFieldHasKeyboard();
			oldPSWInput.defaultTextFormat = tf;
			oldPSWInput.prompt = "旧密码";
			oldPSWInput.restrict = "A-Za-z0-9";
			oldPSWInput.softKeyboardRestrict = /[a-zA-Z0-9]/;
			oldPSWInput.maxChars = 30;
			oldPSWInput.x = 702; 
			oldPSWInput.y = 102;
			oldPSWInput.width = 294; 
			oldPSWInput.height = 47;
			Starling.current.nativeOverlay.addChild(oldPSWInput);
			
			newPSWFirInput = new TextFieldHasKeyboard();
			newPSWFirInput.defaultTextFormat = tf;
			newPSWFirInput.prompt = "新密码";
			newPSWFirInput.restrict = "A-Za-z0-9";
			newPSWFirInput.softKeyboardRestrict = /[a-zA-Z0-9]/;
			newPSWFirInput.maxChars = 10;
			newPSWFirInput.x = 702; 
			newPSWFirInput.y = 304;
			newPSWFirInput.width = 294; 
			newPSWFirInput.height = 47;
			Starling.current.nativeOverlay.addChild(newPSWFirInput);
			
			newPSWSecInput = new TextFieldHasKeyboard();
			newPSWSecInput.defaultTextFormat = tf;
			newPSWSecInput.prompt = "确认新密码";
			newPSWSecInput.restrict = "A-Za-z0-9";
			newPSWSecInput.softKeyboardRestrict = /[a-zA-Z0-9]/;
			newPSWSecInput.maxChars = 10;
			newPSWSecInput.x = 702; 
			newPSWSecInput.y =460;
			newPSWSecInput.width = 294; 
			newPSWSecInput.height = 47;
			Starling.current.nativeOverlay.addChild(newPSWSecInput);
		}
		private var newPassword:String = '';
		private function sureCilckHandler():void
		{
			if(oldPSWInput.text == "" ||newPSWFirInput.text == "" ||newPSWSecInput.text == ""){
				sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,
					640,381,null,"请输入完整密码信息。"));
			}else if(newPSWFirInput.text != newPSWSecInput.text){
				sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,
					640,381,null,"两次输的新密码不一致。"));
			}else if(oldPSWInput.text == newPSWSecInput.text){
				sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,
					640,381,null,"新密码与旧密码相同，请重新输入!"));
			}else if(newPSWSecInput.text.length<3){
				sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,
					640,381,null,"新密码不能少于3位或超过10位，请重新输入!"));
			}else if(newPSWSecInput.text.length>10){
				sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,
					640,381,null,"新密码不能超过10位，请重新输入!"));
			}else{
				
				//修改密码
				PackData.app.CmdIStr[0] = CmdStr.MODIFYPASSWORD;
				PackData.app.CmdIStr[1] = Global.player.userName;
				PackData.app.CmdIStr[2] = StringUtil.trim(oldPSWInput.text);
				PackData.app.CmdIStr[3] = StringUtil.trim(newPSWSecInput.text);
				PackData.app.CmdInCnt = 4;
				sendNotification(CoreConst.SEND_11,new SendCommandVO(MODIFY_PASSWORD_COMPLETE));
				
				newPassword = PackData.app.CmdIStr[3];
			}
			oldPSWInput.text = "";
			newPSWFirInput.text = "";
			newPSWSecInput.text = "";
		}
		
		private function upPackHandler(e:Event):void{
			sendNotification(WorldConst.SUB_PACKLIST);
		}
		
		override public function onRemove():void
		{
			facade.removeMediator(SubPackInfoMediator.NAME);
			
			Starling.current.nativeOverlay.removeChild(oldPSWInput);				
			Starling.current.nativeOverlay.removeChild(newPSWFirInput);				
			Starling.current.nativeOverlay.removeChild(newPSWSecInput);	
			
			super.onRemove();
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case WorldConst.HIDE_SETTING_SCREEN :
					vo.type = SwitchScreenType.HIDE;
					sendNotification(WorldConst.SWITCH_SCREEN,[vo]);
					break;
				case MODIFY_PASSWORD_COMPLETE:
					if(PackData.app.CmdOStr[0].toString() == "M10"){
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,
							640,381,null,"原始密码输入错误!"));
					}else if(PackData.app.CmdOStr[0].toString() == "000"){
						if(newPassword!=''){
							Global.password = newPassword;							
						}
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,
							640,381,null,"密码修改成功!\n~O(∩_∩)O~"));
					}else{
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,
							640,381,null,"密码修改失败!"));
					}										
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.HIDE_SETTING_SCREEN,MODIFY_PASSWORD_COMPLETE];
		}
		
		public function get view():starling.display.Sprite{
			return getViewComponent() as starling.display.Sprite;
		}
		
		override public function get viewClass():Class{
			return starling.display.Sprite;
		}
	}
}