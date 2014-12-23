package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.MP3PlayerProxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.framework.utils.CacheTool;
	import com.mylib.game.charater.CharaterUtils;
	import com.mylib.game.charater.HumanMediator;
	import com.mylib.game.charater.ICharater;
	import com.mylib.game.charater.logic.AIState;
	import com.mylib.game.charater.logic.IslanderControllerMediator;
	import com.mylib.game.charater.logic.ai.CharaterControlAI;
	import com.mylib.game.model.HumanPoolProxy;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.component.MusicLightSprite;
	import com.studyMate.world.component.MusicSignSprite;
	import com.studyMate.world.screens.ui.SendDelayMediator;
	
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class IndexMusicMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "IndexMusicMediator";
		
		private const hasNewGoods:String = NAME + "hasNewGoods";
		private var hasNew:Boolean;
		private var vo:SwitchScreenVO;
		
		private var goToChangeBtn:Image;
		private var goToMusicBtn:Image ;
		private var goToMarketBtn:Image ;
		
		private var doorSp:Sprite;
		private var counterSp:Sprite;
		private var lightSp:Sprite;
		
		private var charaterList:Vector.<ICharater> = new Vector.<ICharater>;
		private var guideCharter:IslanderControllerMediator;
		
		protected var sendDelayMediator:SendDelayMediator;
		
		public function IndexMusicMediator( viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function prepare(vo:SwitchScreenVO):void{
			this.vo = vo;
			
			PackData.app.CmdIStr[0] = CmdStr.USER_HAS_NEWFRAME;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = "MUSIC";
			PackData.app.CmdInCnt = 3;									 
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(hasNewGoods,null,'cn-gb',null,SendCommandVO.QUEUE|SendCommandVO.UNIQUE));			
		}
		override public function onRegister():void{
			//sendNotification(WorldConst.REMOVE_MAINMENU_BUTTON,"menuSoundBtn");
			sendNotification(WorldConst.HIDE_MAIN_MENU);
			
			var mp3Proxy:MP3PlayerProxy = facade.retrieveProxy(MP3PlayerProxy.NAME) as MP3PlayerProxy;
			mp3Proxy.onRemove();
			
			sendDelayMediator = new SendDelayMediator();
			facade.registerMediator(sendDelayMediator);	
			
			var bg:Image = new Image(Assets.getTexture("firstMusicBg"));
			bg.blendMode = BlendMode.NONE;
			bg.touchable = false;
			view.addChild(bg);
			
			doorSp = new Sprite;
			view.addChild(doorSp);
			
			counterSp = new Sprite;
			view.addChild(counterSp);
			
			lightSp = new Sprite;
			view.addChild(lightSp);
			
			creatDoor();
			
			
			if(hasNew){
				var texture:Texture = Assets.getMusicSeriesTexture("remindNewTip");
				if(texture){
					var remindNewTip:Image = new Image(texture);
					remindNewTip.x = 1046;
					remindNewTip.y = 315;
					remindNewTip.touchable = false;
					counterSp.addChild(remindNewTip); 																
				}
			}
			
			if(CacheTool.has(MusicMarketMediator.NAME,"hasNewBuy")){
				 if(CacheTool.getByKey(MusicMarketMediator.NAME,"hasNewBuy")){
					 var remindChangeTip:Image = new Image(Assets.getMusicSeriesTexture("remindChangeTip"));
					 remindChangeTip.x = 104;
					 remindChangeTip.y = 320;
					 remindChangeTip.touchable = false;
					 counterSp.addChild(remindChangeTip); 
				 }
				 CacheTool.clr(MusicMarketMediator.NAME,"hasNewBuy")
			 }
			 
			 this.backHandle = quitHandler;
//			 sendNotification(CoreConst.FLOW_RECORD,new RecordVO("ENTER_VIEW_MARK","IndexMusicMediator",0));
			 trace("@VIEW:IndexMusicMediator:");
		}
		private function quitHandler():void{//先停止消息后，再退出	
			sendDelayMediator.execute(sendNotification,[WorldConst.POP_SCREEN]);		
		}
		
		private function creatDoor():void{
			//添加各房门
			goToChangeBtn = new Image(Assets.getMusicSeriesTexture("goToExchange"));
			goToMusicBtn = new Image(Assets.getMusicSeriesTexture("goToMusicPlay"));
			goToMarketBtn = new Image(Assets.getMusicSeriesTexture("goToMarket"));
			
			goToChangeBtn.name = "Change";
			goToChangeBtn.x = 95;
			goToChangeBtn.y = 220;
			goToMusicBtn.name = "Music";
			goToMusicBtn.x = 450;
			goToMusicBtn. y = 126;
			goToMarketBtn.name = "Market";
			goToMarketBtn.x = 923;
			goToMarketBtn.y = 223;
			
			goToChangeBtn.addEventListener(TouchEvent.TOUCH,enterRoomHandler);
			goToMusicBtn.addEventListener(TouchEvent.TOUCH,enterRoomHandler);
			goToMarketBtn.addEventListener(TouchEvent.TOUCH,enterRoomHandler);
			
			doorSp.addChild(goToChangeBtn);
			doorSp.addChild(goToMusicBtn);
			doorSp.addChild(goToMarketBtn);
			
			//添加柜台
			var counter:Image;
			counter = new Image(Assets.getMusicSeriesTexture("counter1"));
			counter.x = 50;
			counter.y = 390;
			counterSp.addChild(counter);
			counter = new Image(Assets.getMusicSeriesTexture("counter1"));
			counter.x = 470;
			counter.y = 390;
			counterSp.addChild(counter);
			counter = new Image(Assets.getMusicSeriesTexture("counter2"));
			counter.x = 1128;
			counter.y = 295;
			counterSp.addChild(counter);

			//添加招牌
			var sign:MusicSignSprite;
			sign = new MusicSignSprite("分类");
			sign.x = 150;
			sign.y = 190;
			doorSp.addChild(sign);
			sign = new MusicSignSprite("音乐厅");
			sign.x = 570;
			sign.y = 190;
			doorSp.addChild(sign);
			sign = new MusicSignSprite("商城");
			sign.x = 980;
			sign.y = 190;
			doorSp.addChild(sign);
			
			
			//添加灯光
			var musicLight:MusicLightSprite;
			musicLight = new MusicLightSprite("light1",-10,640,-1,1.3,Math.random()+1.5);
			lightSp.addChild(musicLight);
			musicLight = new MusicLightSprite("light1",1290,665,1,-1.3,Math.random()+1.5,1);
			lightSp.addChild(musicLight);
			musicLight = new MusicLightSprite("light1",0,-100,-2,-4,Math.random()+1.5,1.3);
			lightSp.addChild(musicLight);
			musicLight = new MusicLightSprite("light1",1310,-200,2.5,5,Math.random()+1.5,1.3);
			lightSp.addChild(musicLight);
			
			musicLight = new MusicLightSprite("light2",700,-5,-1.3,1,1.7);
			lightSp.addChild(musicLight);
			musicLight = new MusicLightSprite("light2",640,0);
			lightSp.addChild(musicLight);
			musicLight = new MusicLightSprite("light2",580,-5,1.3,-1,1.7);
			lightSp.addChild(musicLight);
			

			creatHuman();
		}
		
		private function creatHuman():void{
			
			var charater:ICharater;
			for(var i:int=0;i<3;i++){
				charater = (facade.retrieveProxy(ModuleConst.HUMAN_POOL) as HumanPoolProxy).object;
				charater.view.alpha = 1;
				charater.view.scaleX = 1;
				charater.view.scaleY = 1;
				charater.view.y = 500;
				
				var dress:String;
				if(i == 0){
					//分类npc
					charater.view.x = 107;
					dress = "face_face1,set4";
				}else if(i == 1){
					//音乐厅npc
					charater.view.x = 527;
					dress = "face_face1,set6";
				}else{
					//商城npc
					charater.view.x = 1175;
					charater.dirX = -1;
					dress = "face_face1,set8";
				}
				GlobalModule.charaterUtils.configHumanFromDressList(charater as HumanMediator,dress,new Rectangle());
				
				doorSp.addChild(charater.view);
				charaterList.push(charater);
			}
			
			//引导-npc
			guideCharter = new IslanderControllerMediator("guideCharater",null,1);
			guideCharter.charater = (facade.retrieveProxy(ModuleConst.HUMAN_POOL) as HumanPoolProxy).object;
			guideCharter.charater.view.alpha = 1;
			guideCharter.charater.view.scaleX = 1.5;
			guideCharter.charater.view.scaleY = 1.5;
			
			guideCharter.charater.velocity = 3.5;
			guideCharter.decision = new CharaterControlAI();
			guideCharter.fsm.changeState(AIState.IDLE);
			guideCharter.setTo(640,620);
			guideCharter.start();
			
			GlobalModule.charaterUtils.configHumanFromDressList(guideCharter.charater,Global.myDressList,new Rectangle());
			counterSp.addChild(guideCharter.charater.view);
		}
		
		
		private var inRoomName:String="";
		private var beginX:Number;
		private var endX:Number;
		private function enterRoomHandler(event:TouchEvent):void
		{
			var img:DisplayObject = event.target as DisplayObject;
			var touchPoint:Touch = event.getTouch(img);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					beginX = touchPoint.globalX;
				}else if(touchPoint.phase==TouchPhase.ENDED){
					endX = touchPoint.globalX;
					if(Math.abs(endX-beginX) < 10){
						inRoomName = img.name;
						guideCharter.go(img.x+(img.width>>1),img.y+img.height);
					}
				}
			}
		}
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				case hasNewGoods:
					if((PackData.app.CmdOStr[0] as String)=="000"){	
						var flag:int = int(PackData.app.CmdOStr[1]);
						if(flag>0)
							hasNew = true;
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);	
					}
					break;
				case "AiArrived":
					switch(inRoomName){
						case "Change":
							sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ExchangeMusicMediator)]);
							break;
						case "Music":
							sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(MusicListPlayMediator)]);
							break;
						case "Market":
							sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(MusicMarketMediator)]);
							break;
					}
					break;
			}
		}
		override public function listNotificationInterests():Array{
			return [hasNewGoods,"AiArrived"];
		}
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class{
			return starling.display.Sprite;
		}
		override public function onRemove():void{
			for(var i:int=0;i<charaterList.length;i++)
				(facade.retrieveProxy(ModuleConst.HUMAN_POOL) as HumanPoolProxy).object = charaterList[i];
			if(guideCharter.charater){
				guideCharter.pause();
				(facade.retrieveProxy(ModuleConst.HUMAN_POOL) as HumanPoolProxy).object = guideCharter.charater;
				guideCharter.reset();
				guideCharter.charater = null;
				guideCharter.decision = null;
			}
			TweenLite.killTweensOf(guideCharter);
			
			charaterList = null;
			inRoomName="";
			
			goToChangeBtn.removeEventListener(TouchEvent.TOUCH,enterRoomHandler);
			goToMusicBtn.removeEventListener(TouchEvent.TOUCH,enterRoomHandler);
			goToMarketBtn.removeEventListener(TouchEvent.TOUCH,enterRoomHandler);
			facade.removeMediator(SendDelayMediator.NAME);
			
			
			doorSp.removeChildren(0,-1,true);
			counterSp.removeChildren(0,-1,true);
			lightSp.removeChildren(0,-1,true);
			view.removeChildren(0,-1,true);
			super.onRemove();
		}
	}
}