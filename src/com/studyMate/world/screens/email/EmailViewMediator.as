package com.studyMate.world.screens.email
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.email.emailmediator.CollectEmailViewMediator;
	import com.studyMate.world.screens.email.emailmediator.ReadedEmailViewMediator;
	import com.studyMate.world.screens.email.emailmediator.SendedEmailViewMediator;
	import com.studyMate.world.screens.email.emailmediator.UnreadEmailViewMediator;
	import com.studyMate.world.screens.email.emailmediator.WriteEmailViewMediator;
	
	import flash.events.KeyboardEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.events.Event;

	public class EmailViewMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "EmailViewMediator";
		
		
		public function EmailViewMediator(mediatorName:String = null,viewComponent:Object = null)
		{
			super(NAME,viewComponent)
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class
		{
			return EmailView;
		}
		
		public function get view():EmailView{
			return getViewComponent() as EmailView;
		}
		
		
		override public function onRegister():void
		{
			Starling.current.stage.color = 0xffffff;
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(UnreadEmailViewMediator,null,SwitchScreenType.SHOW,view,90,0)]);
			view.unReadBtn.touchable = false;
			view.readedBtn.addEventListener(Event.TRIGGERED,readedEmailHandler);
			view.unReadBtn.addEventListener(Event.TRIGGERED,unReadEmailHandler);
			view.sendedBtn.addEventListener(Event.TRIGGERED,sendedEmailHandler);
			view.collectBtn.addEventListener(Event.TRIGGERED,collectEmailHandler);
			view.messageBtn.addEventListener(Event.TRIGGERED,writeEmailHandler);
			view.NumBtn.addEventListener(Event.TRIGGERED,unReadEmailHandler);
			
			trace("@VIEW:EmailViewMediator:");
		}
		
		override public function listNotificationInterests():Array
		{
			return[WorldConst.EMAIL_NUM];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var _emaildata:EmailData = new EmailData();
			switch(notification.getName())
			{
				case WorldConst.EMAIL_NUM:
				{
					if(Number(EmailView.numText.text)>0){
						view.NumBtn.visible = true;
					}else{
						view.NumBtn.visible = false;
						EmailView.numText.text = "";
					}
					break;
				}
			}
		}
		
		private function writeEmailHandler():void
		{
			view.ground.x = view.messageBtn.x - 10;
			view.ground.y = view.messageBtn.y;
			view.messageBtn.touchable = false;
			view.sendedBtn.touchable = true;
			view.unReadBtn.touchable = true;
			view.readedBtn.touchable = true;
			view.collectBtn.touchable = true;
			view.NumBtn.touchable = true;
			sendNotification(WorldConst.HIDE_SETTING_SCREEN);
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(WriteEmailViewMediator,null,SwitchScreenType.SHOW,view,90,0)]);
		}
		
		private function collectEmailHandler():void
		{
			view.ground.x = view.collectBtn.x - 10;
			view.ground.y = view.collectBtn.y;
			view.messageBtn.touchable = true;
			view.sendedBtn.touchable = true;
			view.unReadBtn.touchable = true;
			view.readedBtn.touchable = true;
			view.collectBtn.touchable = false;	
			view.NumBtn.touchable = true;
			sendNotification(WorldConst.HIDE_SETTING_SCREEN);
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(CollectEmailViewMediator,null,SwitchScreenType.SHOW,view,90,0)]);
		}
		
		private function sendedEmailHandler():void
		{
			view.ground.x = view.sendedBtn.x - 10;
			view.ground.y = view.sendedBtn.y ;
			view.messageBtn.touchable = true;
			view.sendedBtn.touchable = false;
			view.unReadBtn.touchable = true;
			view.readedBtn.touchable = true;
			view.collectBtn.touchable = true;
			view.NumBtn.touchable = true;
			sendNotification(WorldConst.HIDE_SETTING_SCREEN);
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SendedEmailViewMediator,null,SwitchScreenType.SHOW,view,90,0)]);
		}
		
		private function unReadEmailHandler(event:Event):void
		{
			view.ground.x = view.unReadBtn.x - 30;
			view.ground.y = view.unReadBtn.y - 20;
			view.messageBtn.touchable = true;
			view.sendedBtn.touchable = true;
			view.unReadBtn.touchable = false;
			view.readedBtn.touchable = true;
			view.collectBtn.touchable = true;
			view.NumBtn.touchable = false;
			sendNotification(WorldConst.HIDE_SETTING_SCREEN);
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(UnreadEmailViewMediator,null,SwitchScreenType.SHOW,view,90,0)]);
		}
		
		private function readedEmailHandler(event:Event):void
		{
			view.ground.x = view.readedBtn.x - 30;
			view.ground.y = view.readedBtn.y - 20;
			view.messageBtn.touchable = true;
			view.sendedBtn.touchable = true;
			view.unReadBtn.touchable = true;
			view.readedBtn.touchable = false;
			view.collectBtn.touchable = true;
			sendNotification(WorldConst.HIDE_SETTING_SCREEN);
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ReadedEmailViewMediator,null,SwitchScreenType.SHOW,view,90,0)]);
		}		
		
		
		override public function onRemove():void
		{
			sendNotification(WorldConst.HIDE_SETTING_SCREEN);
			view.removeChildren(0,-1,true);
			super.onRemove();
		}
	}
}