package com.studyMate.world.screens.chatroom
{
	import com.byxb.utils.centerPivot;
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.PopUpCommandVO;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class ChatAlertMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "ChatAlertMediator";
		
		private var vo:SwitchScreenVO;
		
		private var showStr:String;
		private var doFun:Function;
		
		public function ChatAlertMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void{
			this.vo = vo;
			
			this.doFun = vo.data[0] as Function;
			this.showStr = vo.data[1] as String;
			
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function onRegister():void{
			
			sendNotification(WorldConst.SET_ROLL_SCREEN,false);
			sendNotification(WorldConst.POPUP_SCREEN,(new PopUpCommandVO(this,true)));
			
			init();
			
			
		}
		
		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case WorldConst.HIDE_SETTING_SCREEN :
					vo.type = SwitchScreenType.HIDE;
					sendNotification(WorldConst.SWITCH_SCREEN,[vo]);
					break;
				
			}
		}
		override public function listNotificationInterests():Array{
			return [WorldConst.HIDE_SETTING_SCREEN];
		}
		
		private var showTF:TextField;
		private function init():void{
			var bg:Image = new Image(Assets.getChatViewTexture("charaterInfo/chatAlertBg"));
			view.addChild(bg);
			centerPivot(view);
			
			//y: 30  height:140
			showTF = new TextField(380,140,showStr,"HeiTi",25,0x6e421b);
			showTF.x = 30;
			showTF.y = 30;
			showTF.hAlign = HAlign.CENTER;
			showTF.vAlign = VAlign.CENTER;
			view.addChild(showTF);
			
			var closeBtn:Button = new Button(Assets.getChatViewTexture("charaterInfo/closeBtn"));
			closeBtn.x = 135;
			closeBtn.y = 175;
			closeBtn.addEventListener(Event.TRIGGERED,closeBtnHandle);
			view.addChild(closeBtn);
			
			var confirmBtn:Button = new Button(Assets.getChatViewTexture("charaterInfo/confirmBtn"));
			confirmBtn.x = 245;
			confirmBtn.y = 175;
			confirmBtn.addEventListener(Event.TRIGGERED,confirmBtnHandle);
			view.addChild(confirmBtn);
			
			view.alpha = 0;
			TweenLite.to(view,0.3,{alpha:1});
		}
		
		private function confirmBtnHandle():void{
			
			if(doFun){
				TweenLite.delayedCall(0.2,doFun);
			}
			
			closeBtnHandle();
		}
		
		
		private function closeBtnHandle():void{
			vo.type = SwitchScreenType.HIDE;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,[vo]);
		}
		
		
		
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class{
			return Sprite;
		}
		override public function onRemove():void{
			super.onRemove();
			
			/*TweenLite.killDelayedCallsTo(doFun);*/
			sendNotification(WorldConst.SET_ROLL_SCREEN,true);
			sendNotification(WorldConst.REMOVE_POPUP_SCREEN,this);
			
			view.removeChildren(0,-1,true);
		}
	}
}