package com.studyMate.world.screens
{
	import com.byxb.extensions.starling.display.CameraSprite;
	import com.greensock.TweenLite;
	import com.mylib.api.ICharaterUtils;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.controller.SwitchScreenCommand;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.charater.CharaterUtils;
	import com.mylib.game.charater.IHuman;
	import com.mylib.game.charater.PetDogMediator;
	import com.mylib.game.charater.TalkingProxy;
	import com.mylib.game.charater.logic.AIState;
	import com.mylib.game.charater.logic.AbstractBoidMediator;
	import com.mylib.game.charater.logic.BaseCharaterControllerMediator;
	import com.mylib.game.charater.logic.HumanTalkShowProxy;
	import com.mylib.game.charater.logic.IslanderControllerMediator;
	import com.mylib.game.charater.logic.IslandersManagerMediator;
	import com.mylib.game.charater.logic.PetDogControllerMediator;
	import com.mylib.game.charater.logic.PetFactoryProxy;
	import com.mylib.game.charater.logic.ai.CharaterControlAI;
	import com.mylib.game.charater.logic.ai.ExitIslanderAI;
	import com.mylib.game.charater.logic.ai.IslanderAI;
	import com.mylib.game.charater.logic.ai.PetDogFreeAI;
	import com.mylib.game.charater.logic.vo.JoinIslandVO;
	import com.mylib.game.controller.MutiOnlineControllerMediator;
	import com.mylib.game.controller.MutiOnlineTransferMediator;
	import com.mylib.game.house.GetServerNpcMediator;
	import com.mylib.game.house.IslandSysHouseMediator;
	import com.mylib.game.model.CharaterSuitsInfoProxy;
	import com.mylib.game.model.IslanderPoolProxy;
	import com.studyMate.controller.IslandSwitchScreenCommand;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.model.vo.MessageVO;
	import com.studyMate.world.screens.component.ButterflyMediator;
	import com.studyMate.world.screens.ui.Windmill;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.PixelHitArea;

	public class SquareIslandMediator extends SceneMediator
	{
		public static const NAME:String = "SquareIslandMediator";
		
		private var vo:SwitchScreenVO;
		
		public var islanderPool:IslanderPoolProxy;
		private var range:Rectangle;
		private var manager:IslandersManagerMediator;
		private var maxIslander:int = 6;
		private var timeCount:Number=0;
		private var dog:PetDogMediator;
		private var dogController:PetDogControllerMediator;
		private var butterfly:AbstractBoidMediator;
		private var npcsuitProxy:CharaterSuitsInfoProxy;
		
		
		private var pathHolder:Sprite;
		private var charaterHolder:Sprite;
		private var sysHouseHolder:Sprite;
		
		private var hitArea:PixelHitArea;
		
		private var gift:GiftManagementMediator;
		
		private var talkBtn:Button;
		
		public function SquareIslandMediator(_hitArea:PixelHitArea, viewComponent:Object=null, camera:CameraSprite=null)
		{
			hitArea = _hitArea;
			super(NAME, viewComponent,camera);
		}
		override public function prepare(vo:SwitchScreenVO):void
		{
			this.vo = vo;
			
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);

		}
		
		override public function onRegister():void
		{
			
			sysHouseHolder = new Sprite();
			view.addChild(sysHouseHolder);
			
			pathHolder = new Sprite;
			view.addChild(pathHolder);
			
			charaterHolder = new Sprite();
			view.addChild(charaterHolder);
			
			
			
			range = new Rectangle(-640-640,130,1280+640,80);
			
			
			createWindmill();
			
			createAnimal();
			
			initIslandManager();
			
			
//			gift = new GiftManagementMediator(charaterHolder,range,camera);
//			facade.registerMediator(gift);
//			sendNotification(WorldConst.GET_READ_GIFT);
//			newMessage = new NewMessageMediator(charaterHolder);
//			facade.registerMediator(newMessage);
			
//			//面板-按钮
			createFrontPanel();
//			messageManager = facade.retrieveMediator(MessageManagerMediator.NAME) as MessageManagerMediator;
			
//			createTest();
			
			facade.registerMediator(new GetServerNpcMediator(range,charaterHolder,view));
		}
		override public function run():void
		{
			sendNotification(CoreConst.MANUAL_LOADING,true);
			facade.registerCommand(WorldConst.SWITCH_SCREEN,IslandSwitchScreenCommand);
			
			manager = new IslandersManagerMediator();
			facade.registerMediator(manager);
			
			butterfly.view.visible = true;
			butterfly.start();
			
			facade.registerMediator(new CharaterControllerMediator(pathHolder,range));
			
			//多人在线逻辑
			createMutiCharater();
			
			facade.registerMediator(new IslandSysHouseMediator(sysHouseHolder,hitArea));
			
			
			runEnterFrames = true;
			
			talkBtn.visible = true;
			
			/*npcList = new Vector.<IslanderControllerMediator>;
			createTest();*/
			
			
			
			
			(facade.retrieveMediator(GetServerNpcMediator.NAME) as GetServerNpcMediator).run();
			
		}
		
		override public function pause():void
		{
			(facade.retrieveProxy(HumanTalkShowProxy.NPC) as HumanTalkShowProxy).clean();
			
			for (var i:int = 0; i < manager.islanders.length; i++){
				(manager.islanders[i] as IslanderControllerMediator).pause();
				(manager.islanders[i] as IslanderControllerMediator).charater.actor.stop();
				
				(manager.islanders[i] as IslanderControllerMediator).fsm.changeState(AIState.IDLE);
				
				islanderPool.object = manager.islanders[i];
				
			}
			sendNotification(CoreConst.MANUAL_LOADING,false);
			facade.registerCommand(WorldConst.SWITCH_SCREEN,SwitchScreenCommand);
			
			facade.removeMediator(IslandersManagerMediator.NAME);
			
			facade.removeMediator(IslandSysHouseMediator.NAME);
			
			facade.removeMediator(MutiOnlineControllerMediator.NAME);
			facade.removeMediator(MutiOnlineTransferMediator.NAME);
			
			facade.removeMediator(CharaterControllerMediator.NAME);
			
			runEnterFrames = false;
			
			talkBtn.visible = false;
			
			butterfly.pause();
			butterfly.view.visible = false;
			
			sysHouseHolder.removeChildren(0,-1,true);
			
		
			
			(facade.retrieveMediator(GetServerNpcMediator.NAME) as GetServerNpcMediator).pause();
		}
		
		
/**初始化风车、水、多人在线、面板控制等*****************************************************************************************************/
		
		private function createWindmill():void{
			//加入风车
			var windmill:Windmill = new Windmill(30,10,Math.random()+0.5);
			pathHolder.addChild(windmill);
			
			windmill = new Windmill(420,20,Math.random()+0.5);
			pathHolder.addChild(windmill);
		}
		private function createAnimal():void{
			//小狗
			var petCreater:PetFactoryProxy = facade.retrieveProxy(PetFactoryProxy.NAME) as PetFactoryProxy;
			dog = petCreater.getPetDog("petDog1","dog1",range);
			GlobalModule.charaterUtils.humanDressFun(dog,"bmpNpc_bmp1");
//			dog.actor.switchCostume("head","face","normal");
			dog.velocity = 3;
			dogController = new PetDogControllerMediator("my dog",dog);
			dogController.decision = new PetDogFreeAI;
			dogController.fsm.changeState(AIState.IDLE);
			dogController.setTo(100,100);
			dogController.start();
			dogController.go(300,200);
			charaterHolder.addChild(dogController.charater.view);			
			
			//蝴蝶
			butterfly = new ButterflyMediator("butterfly",view);
		}
		
		
		private var captain:IslanderControllerMediator;
		private function createMutiCharater():void{
			captain = islanderPool.object;
			var charaterControlAI:CharaterControlAI = new CharaterControlAI();
			
			captain.charater.velocity = 3.5;
			captain.decision = charaterControlAI;
			
			
			
			GlobalModule.charaterUtils.configHumanFromDressList(captain.charater,Global.myDressList,range);
			charaterHolder.addChild(captain.charater.view);
			sendNotification(IslandersManagerMediator.JOIN_ISLAND,new JoinIslandVO(captain,new Point(Math.random()*1000-500,range.top+(Math.random()*range.height))));
			
			captain.fsm.changeState(AIState.IDLE);
			captain.setTo(manager.getIslanderHome(captain).x,manager.getIslanderHome(captain).y);
			captain.start();
			captain.charater.view.alpha = 1;

			captain.touchable = true;
			
			sendNotification(WorldConst.ADD_CHARATER_CONTROL,captain);
			sendNotification(WorldConst.UPDATE_PLAYER_MAP,"happy_island");
			sendNotification(WorldConst.UPDATE_PLAYER_CHARATER,captain.charater);
			
			//加入多人在线逻辑
			facade.registerMediator(new MutiOnlineTransferMediator());
			facade.registerMediator(new MutiOnlineControllerMediator(charaterHolder,range));
		}
		private function createFrontPanel():void{
			sendNotification(WorldConst.CREATE_TALKINGBOX);
			talkBtn = new Button(Assets.getAtlasTexture("mainMenu/menuTalkBtn"));
			talkBtn.x = 20;
			talkBtn.y = 110;
			talkBtn.addEventListener(Event.TRIGGERED,talkBtnHandle);
			camera.parent.addChild(talkBtn);
			
//			Test();

		}
		private function Test():void{
			var btn1:Button = new Button(Assets.getAtlasTexture("mainMenu/menuTalkBtn"));
			btn1.x = 100;
			btn1.y = 50;
			camera.parent.addChild(btn1);
			btn1.addEventListener(Event.TRIGGERED,btn1Handle);
			
			var btn2:Button = new Button(Assets.getAtlasTexture("mainMenu/menuTalkBtn"));
			btn2.x = 100;
			btn2.y = 80;
			camera.parent.addChild(btn2);
			btn2.addEventListener(Event.TRIGGERED,btn2Handle);
			
		}
		private function btn1Handle():void{
		}
		private function btn2Handle():void{
		}

		
/**事件监听*****************************************************************************************************/	


		//聊天按钮
		private function talkBtnHandle(e:Event):void{
			sendNotification(WorldConst.SHOW_TALKINGBOX,true);
		}
		
/**岛民、小狗、蝴蝶*****************************************************************************************************/		
		
		override public function advanceTime(time:Number):void
		{
			sendNotification(WorldConst.SORT_CONTAINER,charaterHolder);
			if(manager.islanders.length>maxIslander){
				timeCount+= time;
				
				if(timeCount>10){
					dismissIslander();
					timeCount = 0;
				}
				
			}else{
				/*callIslander(npcsuitProxy.npcSuitsMap.find("npc"+(int(Math.random()*8)+1).toString()));*/
				callIslander(npcsuitProxy.getDress("npc"+(int(Math.random()*8)+1).toString()));
			}
			
		}
		
		
		private function initIslandManager():void{
			
			islanderPool = new IslanderPoolProxy(true);
			facade.registerProxy(islanderPool);
			islanderPool.init();
			
			
			
			
			//获取NPC装备列表
			npcsuitProxy = new CharaterSuitsInfoProxy();
			facade.registerProxy(npcsuitProxy);
			
			/*var size:int = npcsuitProxy.npcSuitsMap.size;*/
			var size:int = npcsuitProxy.getSize();
			maxIslander = size-2;

		}
		
		protected function dismissIslander():void{
			var islander:IslanderControllerMediator = manager.findFreeIslander(null);
			if(islander){
				islander.decision = new ExitIslanderAI(500,100,islander.islanderDecision);
				islander.go(manager.getIslanderHome(islander).x,manager.getIslanderHome(islander).y);
			}
			
		}
		
		protected function callIslander(dress:String):void{
			
			var controller:IslanderControllerMediator = islanderPool.object;
			var islanderAI:IslanderAI = new IslanderAI();
			
			controller.charater.velocity = Math.random()*3+0.5;
			controller.decision = islanderAI;
			if(dress)
				GlobalModule.charaterUtils.configHumanFromDressList(controller.charater,dress,range);
			else
				GlobalModule.charaterUtils.configHumanFromDressList(controller.charater,"set2,face_face1,sword",range);
			charaterHolder.addChild(controller.charater.view);
			sendNotification(IslandersManagerMediator.JOIN_ISLAND,new JoinIslandVO(controller,new Point(Math.random()*1000-500,130)));
			/*sendNotification(IslandersManagerMediator.JOIN_ISLAND,new JoinIslandVO(controller,new Point(450,70)));*/
			controller.setTo(manager.getIslanderHome(controller).x,manager.getIslanderHome(controller).y);
			controller.start();
			controller.charater.view.alpha = 0;
			controller.touchable = true;
			TweenLite.to(controller.charater.view,1,{alpha:1,onComplete:controller.fsm.changeState,onCompleteParams:[AIState.DECISION]});
			/*controller.fsm.changeState(AIState.REST);
			controller.go(Math.random()*range.width+range.x,Math.random()*range.height+range.y);*/
			
		}
		
		
		
/**消息接收处理、移除回收等*****************************************************************************************************/		
		
		override public function handleNotification(notification:INotification):void
		{			
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName())
			{
				case WorldConst.GET_GIFT : 
					var msg:MessageVO  = notification.getBody() as MessageVO;
					gift.dropGift(msg);
					break;
				case BaseCharaterControllerMediator.CLICK_CHARATER:
					var talkProxy:TalkingProxy = facade.retrieveProxy(TalkingProxy.NAME) as TalkingProxy;
					var npc:IslanderControllerMediator = notification.getBody() as IslanderControllerMediator;
					//正在离开的NPC不参与对话
					if(npc.decision is IslanderAI){
						(facade.retrieveProxy(HumanTalkShowProxy.NPC) as HumanTalkShowProxy).endPlayerDialogue(npc.charater as IHuman);
						
						npc.fsm.changeState(AIState.IDLE);
						npc.fsm.changeState(AIState.TALK);
						
						talkProxy.talk(captain,npc);
						
						sendNotification(WorldConst.SHOW_TALKINGBOX,false);
					}else if(npc.decision is ExitIslanderAI){
						talkProxy.playerSay(npc.charater,"我妈妈喊我吃饭了！88");
					}
					
					break;
			}
		}
		override public function listNotificationInterests():Array
		{
			return [WorldConst.GET_GIFT,
				BaseCharaterControllerMediator.CLICK_CHARATER];
		}
		
		override public function onRemove():void
		{
			super.onRemove();

			sendNotification(CoreConst.MANUAL_LOADING,false);
			facade.registerCommand(WorldConst.SWITCH_SCREEN,SwitchScreenCommand);
			runEnterFrames = false;
			(facade.retrieveProxy(HumanTalkShowProxy.NPC) as HumanTalkShowProxy).clean();
			
			islanderPool.object = captain;
			for (var i:int = 0; i < manager.islanders.length; i++){
				islanderPool.object = manager.islanders[i];
			}
			facade.removeMediator(GetServerNpcMediator.NAME);
			
			facade.removeMediator(IslandSysHouseMediator.NAME);
			facade.removeMediator(CharaterControllerMediator.NAME);
			facade.removeMediator(MutiOnlineControllerMediator.NAME);
			facade.removeMediator(MutiOnlineTransferMediator.NAME);
			facade.removeMediator(GiftManagementMediator.NAME);
			facade.removeMediator(IslandersManagerMediator.NAME);
			facade.removeProxy(IslanderPoolProxy.NAME);
			facade.removeProxy(CharaterSuitsInfoProxy.NAME);
			
			
			
			sendNotification(WorldConst.UPDATE_PLAYER_CHARATER,null);
			sendNotification(WorldConst.HIDE_LEFT_MENU);
			sendNotification(WorldConst.DESTROY_TALKINGBOX);
			
			
			PixelHitArea.dispose();
			butterfly.dispose();
			dog.dispose();
			dogController.dispose();
			
			
			
		}
		/*public function get view():Sprite{
			return getViewComponent() as Sprite;
		}*/
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
	}
}