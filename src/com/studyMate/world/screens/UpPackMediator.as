package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.controller.SubPackInfoMediator;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.model.vo.AlertVo;
	
	import flash.text.TextFormat;
	
	import mx.utils.StringUtil;
	
	import feathers.controls.Button;
	
	import myLib.myTextBase.TextFieldHasKeyboard;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;

	public class UpPackMediator extends ScreenBaseMediator
	{
		private var vo:SwitchScreenVO;
		private var logtxt:TextFieldHasKeyboard;
		private const NAME:String = 'UpPackMediator';
		public function UpPackMediator(mediatorName:String=null, viewComponent:Object=null)
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
//			var bg:Quad = new Quad(Global.stageWidth, Global.stageHeight, 0x82c0ff);
//			view.addChild(bg);
			
			var upBtn:Button = new Button();
			upBtn.label = "上传程序列表";
			upBtn.x = 200; upBtn.y = 200;
			upBtn.width = 200; upBtn.height = 100;
			upBtn.addEventListener(Event.TRIGGERED, upPackHandler);
			view.addChild(upBtn);
			
			var upBtn1:Button = new Button();
			upBtn1.label = "上传系统日志";
			upBtn1.x = 500; upBtn1.y = 200;
			upBtn1.width = 200; upBtn1.height = 100;
			upBtn1.addEventListener(Event.TRIGGERED, upPackHandler1);
			view.addChild(upBtn1);
			
			logtxt = new TextFieldHasKeyboard();
			var tf:TextFormat = new TextFormat('HeiTi',20,0);
			logtxt.defaultTextFormat = tf;
			logtxt.maxChars = 2;
			logtxt.restrict = "0-9";
			logtxt.softKeyboardRestrict = /[0-9]/;
			logtxt.width = 200;
			logtxt.height = 40;
			logtxt.prompt = '要上传的日志数';
			logtxt.x = 788;
			logtxt.y = 170;
			logtxt.border = true;
			Starling.current.nativeOverlay.addChild(logtxt);
		}
		
		private function upPackHandler1():void
		{
			var str:String = StringUtil.trim(logtxt.text);
			if(str.length>0){				
				sendNotification(WorldConst.UPLOAD_SYSTEM_LOG,int(str));//上传系统日志
			}else{
				sendNotification(WorldConst.UPLOAD_SYSTEM_LOG);//上传系统日志
			}
		}
		
		private function upPackHandler(e:Event):void{
			sendNotification(WorldConst.SUB_PACKLIST);
		}
		
		override public function onRemove():void
		{
			facade.removeMediator(SubPackInfoMediator.NAME);
			Starling.current.nativeOverlay.removeChild(logtxt);
			super.onRemove();
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case WorldConst.HIDE_SETTING_SCREEN :
					vo.type = SwitchScreenType.HIDE;
					sendNotification(WorldConst.SWITCH_SCREEN,[vo]);
					break;
				case WorldConst.REC_PACKLIST:
					if((PackData.app.CmdOStr[0] as String).charAt(1)=="0"){
						sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n程序列表已上传!",false));
					}
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.HIDE_SETTING_SCREEN, WorldConst.REC_PACKLIST];
		}
		
		public function get view():starling.display.Sprite{
			return getViewComponent() as starling.display.Sprite;
		}
		
		override public function get viewClass():Class{
			return starling.display.Sprite;
		}
	}
}