package com.mylib.game.controller
{
	import com.mylib.api.ICharaterUtils;
	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.CharaterMenuProxy;
	import com.mylib.game.charater.ICharater;
	import com.mylib.game.charater.TalkingProxy;
	import com.mylib.game.charater.logic.AIState;
	import com.mylib.game.charater.logic.HumanTalkShowProxy;
	import com.mylib.game.charater.logic.IslanderControllerMediator;
	import com.mylib.game.charater.logic.ai.CharaterControlAI;
	import com.mylib.game.charater.logic.ai.MutiOLExitAI;
	import com.mylib.game.controller.vo.CharaterMenuVO;
	import com.mylib.game.model.IslanderPoolProxy;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.controller.vo.CharaterStateVO;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.model.MyCharaterInforMediator;
	import com.studyMate.world.screens.WorldConst;
	
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
	
	public class MutiCharaterControllerMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MutiCharaterControllerMediator";
		private var pool:IslanderPoolProxy;
		
		private var charaterMap:Dictionary;
		private var charaterViewMap:Dictionary;
		private var range:Rectangle;
		
		private var cmenuProxy:CharaterMenuProxy;
		
		public function MutiCharaterControllerMediator(viewComponent:Object,range:Rectangle)
		{
			this.range = range;
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			pool = facade.retrieveProxy(IslanderPoolProxy.NAME) as IslanderPoolProxy;
			cmenuProxy = facade.retrieveProxy(CharaterMenuProxy.NAME) as CharaterMenuProxy;
			
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
			var human:IslanderControllerMediator;
			if(vo)	human = charaterMap[vo.id];
			switch(notification.getName())
			{
				case WorldConst.CHARATER_LEAVE:
				{
					if(human){
						human.decision = new MutiOLExitAI(vo.id);
						human.go(range.width,150);
					}
					
					break;
				}
				case WorldConst.UPDATE_CHARATER_STATE:
				{
					var charaterControlAI:CharaterControlAI = new CharaterControlAI();
					//只是更新说话
					if(vo.say){
						if(human){
							var player:ICharater = (facade.retrieveMediator(MyCharaterInforMediator.NAME) as MyCharaterInforMediator).playerCharater;
							var talkProxy:TalkingProxy = facade.retrieveProxy(TalkingProxy.NAME) as TalkingProxy;
							
							talkProxy.playerSay(human.charater,vo.say);
						}
						break;
					}
					
					//更新其他信息
					if(!human){
						/*if(!(human = pool.object)){
							trace("撑爆了，不行了。");
							break;
						}*/
						human = pool.object;
						charaterMap[vo.id] = human;
						charaterViewMap[human.charater.view] = [vo.id,vo.dressList,vo.level];
						
						
						
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
						
						//他人等级标示
						sendNotification(WorldConst.MARK_OTHER_PLAYER_CHARATER,[human.charater,vo.level]);
						
						human.charater.actor.switchCostume("head","face","normal");
					}
					
					if(vo.location){
						human.charater.walk();
						
						human.go(vo.location.x,vo.location.y);
					}
					
					
					human.decision = charaterControlAI;
					human.charater.view.alpha = 1;
					human.charater.view.addEventListener(TouchEvent.TOUCH,touchHandle);
					
					break;
				}
				case WorldConst.APPLY_FIGHT:{
					//挑战成功
					if(PackData.app.CmdOStr[0] == "000"){
						sendNotification(WorldConst.DIALOGBOX_SHOW,
							new DialogBoxShowCommandVO(view.stage,640,381,null,"您的战书已八百里加快派送，请耐心等待答复！"));
						
					}else if(PackData.app.CmdOStr[0] == "0M1"){
						//挑战失败,两人正在决斗中
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.stage,640,381,null,"请确认对手不在您的战斗名册内！"));
						
					}else if(PackData.app.CmdOStr[0] == "0M2"){
						//挑战失败,两人正在决斗中
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.stage,640,381,null,"英雄您已经在车轮战了，请量力而行！"));
						
					}else if(PackData.app.CmdOStr[0] == "MMM"){
						//其他错误
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.stage,640,381,null,"莫名错误，请与客服联系。"));
					}
					break;
				}
			}
		}
		
		
		private function touchHandle(event:TouchEvent):void{
			var target:DisplayObject = event.currentTarget as DisplayObject;
			var touch:Touch=event.getTouch(target);

			if(touch&&(touch.phase ==TouchPhase.ENDED)){
				
				var vo:CharaterMenuVO = new CharaterMenuVO((charaterMap[charaterViewMap[target][0]] as IslanderControllerMediator).charater,
					charaterViewMap[target][0],charaterViewMap[target][1],charaterViewMap[target][2]);
				
				cmenuProxy.showMenu(vo);
			}
			
		}

		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.CHARATER_LEAVE,WorldConst.UPDATE_CHARATER_STATE,WorldConst.APPLY_FIGHT];
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