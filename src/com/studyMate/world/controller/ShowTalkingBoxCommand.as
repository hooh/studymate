package com.studyMate.world.controller
{
	import com.greensock.TweenLite;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.world.screens.ui.ChatPanelMediator;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	
	public class ShowTalkingBoxCommand extends SimpleCommand implements ICommand
	{
		private var talkingBox:ChatPanelMediator;
		
		public function ShowTalkingBoxCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var isTalk2All:Boolean = notification.getBody() as Boolean;
			if(!facade.retrieveMediator(ChatPanelMediator.NAME)){
				talkingBox = new ChatPanelMediator();
				talkingBox.view.x = 190;
				talkingBox.view.y = -450;
//				talkingBox.view.alpha = 0.8;
				
				
				facade.registerMediator(talkingBox);
				
				AppLayoutUtils.uiLayer.addChild(talkingBox.view);
				
			}else{
				talkingBox = facade.retrieveMediator(ChatPanelMediator.NAME) as ChatPanelMediator;
			}
			
//			talkingBox.isTalk2All = isTalk2All;
			if(isTalk2All){
				
				if(talkingBox.isShow){
					TweenLite.to(talkingBox.view,0.3,{y:-450});
					TweenLite.to(talkingBox.input,0.3,{y:-240});
					talkingBox.input.text = "";
					talkingBox.groupChatTF.text = "";
					
					talkingBox.isShow = false;
					
					return;
				}
				talkingBox.talk2AllBtnHandle(null);
				//释放NPC
//				sendNotification(WorldConst.STOP_PLAYER_TALKING);
			}else{
				
				talkingBox.talk2NpcBtnHandle(null);
			}
			
			TweenLite.killTweensOf(delayFun);
			TweenLite.to(talkingBox.view,0.3,{y:0});
			TweenLite.to(talkingBox.input,0.3,{y:240});
			TweenLite.delayedCall(0.3,delayFun);
			
		}
		private function delayFun():void{
			if(talkingBox.gcRecordStr != "" && talkingBox.gcRecordStr != null){
				talkingBox.groupChatTF.text = talkingBox.gcRecordStr;
				talkingBox.groupChatTF.textFormat = talkingBox.tf;
			}
			talkingBox.isShow = true;
		}
	}
}