package com.mylib.game.house
{
	import com.greensock.TweenLite;
	import com.mylib.api.ICharaterUtils;
	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.CharaterUtils;
	import com.mylib.game.charater.IHuman;
	import com.mylib.game.charater.TalkingProxy;
	import com.mylib.game.charater.logic.AIState;
	import com.mylib.game.charater.logic.HumanTalkShowProxy;
	import com.mylib.game.charater.logic.IslanderControllerMediator;
	import com.mylib.game.charater.logic.ai.CharaterControlAI;
	import com.mylib.game.charater.logic.ai.ExitIslanderAI;
	import com.mylib.game.charater.logic.ai.IslanderAI;
	import com.mylib.game.model.IslanderPoolProxy;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.screens.IslandsMapMediator;
	
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class GetServerNpcMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "GetServerNpcMediator";
		private static const APPLY_NPC_COMPLETE:String = NAME + "ApplyNpcComplete";
		private static const IN_PLAYID_ROOMNPC_COMPLETE:String = NAME + "InPlayIdRoomnpcComplete";
		
		private var islanderPool:IslanderPoolProxy;
		private var npcRange:Rectangle;
		private var charaterHolder:Sprite;
		
		public function GetServerNpcMediator(range:Rectangle,charaterHolder:Sprite,viewComponent:Object=null)
		{
			this.npcRange = range;
			this.charaterHolder = charaterHolder;
			
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			initNpcBoat();
			
			
			islanderPool = facade.retrieveProxy(IslanderPoolProxy.NAME) as IslanderPoolProxy;
			
			
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName())
			{
				case APPLY_NPC_COMPLETE:
					if(!result.isErr){
						var isEnter:Boolean;
						if(PackData.app.CmdOStr[0] == "000"){
							//正常进入
							
							isEnter = true;
						}else if(PackData.app.CmdOStr[0] == "0M1"){
							//没有房间
							
							isEnter = false;
						}else if(PackData.app.CmdOStr[0] == "0M2")
							//没人分配了
							break;
						
						var npc:ServerNpc =  new ServerNpc(newNpc(PackData.app.CmdOStr[5]));
						npc.isEnter = isEnter;
						
						npc.serverNpcVo.npcHouseId = PackData.app.CmdOStr[2];
						npc.serverNpcVo.npcId = PackData.app.CmdOStr[3];
						npc.serverNpcVo.npcName = PackData.app.CmdOStr[4];
						npc.serverNpcVo.npcDressList = PackData.app.CmdOStr[5];
						npc.serverNpcVo.npcTr = PackData.app.CmdOStr[6];
						
						trace(npc.serverNpcVo.npcName);
						
						if(npcBoat){
							npcBoat.alpha = 1;
							npcBoat.y = 260;
							npcBoat.x = 800;
							
							npcBoat.addChild(npc.islander.charater.view);
							
							TweenLite.from(npcBoat,10,{x:1280,onComplete:npcArriveFun,onCompleteParams:[npc]});
							
						}
						
						
					}
					
					break;
				case IN_PLAYID_ROOMNPC_COMPLETE:
					if(result.isErr)
						currentNpc.isEnter = false;
					else
						(facade.retrieveMediator(IslandsMapMediator.NAME) as IslandsMapMediator).myCardPlayerList.push(currentNpc.serverNpcVo);
					
					
					
					letNpcLeave(currentNpc);
					
					
					
					
					
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			
			return [APPLY_NPC_COMPLETE,IN_PLAYID_ROOMNPC_COMPLETE];
		}
		
		
		
		private var npcBoat:Sprite;
		private var npcList:Vector.<IslanderControllerMediator> = new Vector.<IslanderControllerMediator>;
		
		private function initNpcBoat():void{
			npcBoat = new Sprite();
			
			
			view.addChild(npcBoat);
			npcBoat.y = 260;
			npcBoat.x = 800;
			
			
			var boat:Image = new Image(Assets.getHappyIslandTexture("hapIsland_NpcBoat1"));
			npcBoat.addChild(boat);
			
			
		}
		private function newNpc(dressList:String):IslanderControllerMediator{
			
			var npc:IslanderControllerMediator = islanderPool.object;
			npcList.push(npc);
			
			var npcAI:CharaterControlAI = new CharaterControlAI();
			
			npc.charater.velocity = Math.random()*3+0.5;
			npc.decision = npcAI;
			GlobalModule.charaterUtils.configHumanFromDressList(npc.charater,dressList,npcRange);
			
			npc.charater.view.alpha = 1;
			npc.charater.view.scaleX = -(Math.abs(npc.charater.view.scaleX));
			npc.charater.view.y = 40;
			npc.charater.view.x = 40;
			
			return npc;
		}
		
		//NPC上岸
		private function npcArriveFun(_npc:ServerNpc):void{
			var islanderAI:IslanderAI = new IslanderAI();
			
			charaterHolder.addChild(_npc.islander.charater.view);
			
			_npc.islander.charater.view.scaleX = 1;
			_npc.islander.decision = islanderAI;
			
			
			_npc.islander.fsm.changeState(AIState.RUN);
			
			
			_npc.islander.setTo(750,270);
			
			_npc.islander.start();
			
			
			
			currentNpc = _npc;
			
			letNpcGohome(_npc);
			
			
//			letNpcLeave(_npc);
			
			
			
//			TweenLite.to(_npc.islander.charater.view,1,{alpha:1,onComplete:_npc.islander.fsm.changeState,onCompleteParams:[AIState.DECISION]});
			
			TweenLite.to(npcBoat,1,{alpha:0});
			
			
		}
		private var currentNpc:ServerNpc;
		private function letNpcGohome(_npc:ServerNpc):void{
			PackData.app.CmdIStr[0] = CmdStr.IN_PLAYID_ROOMNPC;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = _npc.serverNpcVo.npcHouseId;
			PackData.app.CmdIStr[3] = _npc.serverNpcVo.npcId;
			PackData.app.CmdInCnt = 4;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(IN_PLAYID_ROOMNPC_COMPLETE));
			
			
		}
		private function letNpcLeave(_npc:ServerNpc):void{
			/*(facade.retrieveProxy(HumanTalkShowProxy.NPC) as HumanTalkShowProxy).endPlayerDialogue(npcList[0].charater as IHuman);
			
			npcList[0].decision = new ExitIslanderAI(500,100,npcList[0].islanderDecision);
			npcList[0].go(0,230);*/
			
			
			var talkProxy:TalkingProxy = facade.retrieveProxy(TalkingProxy.NAME) as TalkingProxy;
			
			if(_npc.isEnter)
				talkProxy.playerSay(_npc.islander.charater,"我要去第 "+_npc.serverNpcVo.npcHouseId+" 个房间哦！");
			else
				talkProxy.playerSay(_npc.islander.charater,"呜呜，没有房间哦，我要走咯...");
			
			_npc.islander.touchable = false;
			_npc.islander.decision = new ExitIslanderAI(500,100,_npc.islander.islanderDecision);
			_npc.islander.go(0,230);
		}
		
		
		//向后台取NPC
		private function getNpcFromServer():void{
			//发命令字
			PackData.app.CmdIStr[0] = CmdStr.APPLY_NPC_ROL_BYPLAYID;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 2;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(APPLY_NPC_COMPLETE));
			
			
			
			TweenLite.delayedCall(20,run);
		}
//		private function 
		
		
		public function run():void{
			npcBoat.visible = true;
			if(Global.isLoading){
				TweenLite.delayedCall(2,run);
				return;
			}
			
			getNpcFromServer();
			
			
			
		}
		public function pause():void{
			TweenLite.killTweensOf(run);
			TweenLite.killTweensOf(npcBoat);
			npcBoat.visible = false;
			
			for(var i:int = 0 ;i<npcList.length;i++){
				npcList[i].pause();
				if(npcList[i].charater)
					npcList[i].charater.actor.stop();
				
				npcList[i].fsm.changeState(AIState.IDLE);
				
				islanderPool.object = npcList[i];
				
			}
			npcList.splice(0,npcList.length);
			
		}
		
		
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function onRemove():void
		{
			super.onRemove();
			
			TweenLite.killTweensOf(run);
			TweenLite.killTweensOf(npcBoat);
			
			for(var i:int = 0 ;i<npcList.length;i++){
				npcList[i].pause();
				if(npcList[i].charater)
					npcList[i].charater.actor.stop();
				
				npcList[i].fsm.changeState(AIState.IDLE);
				
				islanderPool.object = npcList[i];
				
			}
			npcList = null;
			
			
		}
	}
}