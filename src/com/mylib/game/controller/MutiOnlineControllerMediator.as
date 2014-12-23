package com.mylib.game.controller
{
	import com.mylib.api.ICharaterUtils;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.charater.CharaterUtils;
	import com.mylib.game.charater.HumanMediator;
	import com.mylib.game.charater.ICharater;
	import com.mylib.game.charater.IHuman;
	import com.mylib.game.charater.TalkPair;
	import com.mylib.game.charater.logic.AIState;
	import com.mylib.game.charater.logic.HumanTalkShowProxy;
	import com.mylib.game.charater.logic.IslanderControllerMediator;
	import com.mylib.game.charater.logic.ai.CharaterControlAI;
	import com.mylib.game.charater.logic.ai.MutiOLExitAI;
	import com.mylib.game.model.IslanderPoolProxy;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.controller.vo.CharaterStateVO;
	import com.studyMate.world.model.MyCharaterInforMediator;
	import com.studyMate.world.screens.CharaterInfoMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.ui.ChatPanelMediator;
	
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class MutiOnlineControllerMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MutiOnlineControllerMediator";
		private var pool:IslanderPoolProxy;
		
		private var charaterMap:Dictionary;
		private var charaterViewMap:Dictionary;
		private var range:Rectangle;
		
		public function MutiOnlineControllerMediator(viewComponent:Object,range:Rectangle)
		{
			this.range = range;
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			pool = facade.retrieveProxy(IslanderPoolProxy.NAME) as IslanderPoolProxy;
			
			
			charaterMap = new Dictionary();
			charaterViewMap = new Dictionary();
		}
		
		
		public function recyle(id:String):void{
			
			
			(charaterMap[id] as IslanderControllerMediator).charater.view.removeEventListener(TouchEvent.TOUCH,touchHandle);
			delete charaterViewMap[(charaterMap[id] as IslanderControllerMediator).charater.view];
			
			(charaterMap[id] as IslanderControllerMediator).fsm.changeState(AIState.IDLE);
			pool.object = charaterMap[id] as IslanderControllerMediator;
			delete charaterMap[id];
		}
		
		
		override public function handleNotification(notification:INotification):void
		{
			var vo:CharaterStateVO = notification.getBody() as CharaterStateVO;
			var human:IslanderControllerMediator = charaterMap[vo.id];
			switch(notification.getName())
			{
				case WorldConst.CHARATER_LEAVE:
				{
					if(human){
						human.decision = new MutiOLExitAI(vo.id);
//						human.go(2500,150);
						human.go(range.width,150);
					}
					
					break;
				}
				case WorldConst.UPDATE_CHARATER_STATE:
				{
					var charaterControlAI:CharaterControlAI = new CharaterControlAI();
					if(!human){
						/*if(!(human = pool.object)){
							trace("撑爆了，不行了。");
							break;
						}*/
						human = pool.object;
						charaterMap[vo.id] = human;
						charaterViewMap[human.charater.view] = [vo.id,vo.dressList];
						
						
						
						human.charater.velocity = Math.random()*3+0.5;
						human.decision = charaterControlAI;
						
						
						view.addChild(human.charater.view);
					
						human.fsm.changeState(AIState.IDLE);
						human.setTo(range.left,range.top+(Math.random()*range.height));
						human.start();
						human.charater.view.alpha = 1;
						
					}
					
					if(vo.dressList){
						(Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CHARATER_UTILS) as ICharaterUtils).configHumanFromDressList(human.charater,vo.dressList,range);
						
						sendNotification(WorldConst.MARK_OTHER_PLAYER_CHARATER,human.charater);
						human.charater.actor.switchCostume("head","face","normal");
					}
					
					if(vo.location){
						human.charater.walk();
						
						human.go(vo.location.x,vo.location.y);
					}
					
					if(vo.say){
						var player:ICharater = (facade.retrieveMediator(MyCharaterInforMediator.NAME) as MyCharaterInforMediator).playerCharater;
						var talkingBox:ChatPanelMediator = facade.retrieveMediator(ChatPanelMediator.NAME) as ChatPanelMediator;
						
						var pair:TalkPair = new TalkPair("HuaKanT");
						pair.player1 = human.charater as IHuman;
						pair.player2 = player as IHuman;
						
						//写入对话框记录
						talkingBox.setAllTalkRecord(vo.name,vo.say.substring(vo.say.indexOf("<say>")+5,vo.say.lastIndexOf("</say>")));
						
						pair.dialogue = HumanTalkShowProxy.parseTopicXML(XML(vo.say));
						(facade.retrieveProxy(HumanTalkShowProxy.PLAYER) as HumanTalkShowProxy).processDialogue(pair);

					}
					human.decision = charaterControlAI;
					human.charater.view.alpha = 1;
					human.charater.view.addEventListener(TouchEvent.TOUCH,touchHandle);
					
					break;
				}
				
			}
		}
		
		
		private function touchHandle(event:TouchEvent):void{
			var target:DisplayObject = event.currentTarget as DisplayObject;
			var touch:Touch=event.getTouch(target);

			if(touch&&(touch.phase ==TouchPhase.ENDED)){
				sendNotification(WorldConst.SWITCH_SCREEN,
					[new SwitchScreenVO(CharaterInfoMediator,charaterViewMap[target],
						SwitchScreenType.SHOW,target.parent.parent.stage,640,381)]);
			}
			
		}
		
		private function getPlyerDressList(operId:String):void{
			sendNotification(WorldConst.GET_CHARATER_EQUIPMENT,[operId]);
		}
		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.CHARATER_LEAVE,WorldConst.UPDATE_CHARATER_STATE];
		}
		
		
		override public function onRemove():void
		{
			for(var id:String in charaterMap) 
			{
				pool.object = charaterMap[id];
			}
			
			(facade.retrieveProxy(HumanTalkShowProxy.PLAYER) as HumanTalkShowProxy).clean();
		}
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		
		
		
	}
}