package com.studyMate.module.engLearn.reward.centerManLayer
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.charater.logic.FighterControllerMediator;
	import com.mylib.game.model.FightCharaterPoolProxy;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.module.engLearn.api.LearnConst;
	import com.studyMate.world.animation.PlaneAni;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.extensions.fluocode.Fluocam;
	
	public class RAnimationMediator extends ScreenBaseMediator implements IRewardHuman
	{
		public static const NAME:String = "RAnimationMediator";
		
		private static const START_TIME:int = 3;
		
		private var vo:SwitchScreenVO;
		
		private var pool:FightCharaterPoolProxy;
		private var fighter1:FighterControllerMediator;
		private var fighter2:FighterControllerMediator;
		
		private var cam:Fluocam;
		
		private var holder:Sprite;
		private var screen:Sprite;
		private var world:Sprite;
		
		private var vsSp:Sprite;
		private var vsicon:Image;
		private var vsLight:Image;
		
		private var effSp:Sprite;
		private var flightsp:Sprite;
		private var fBom:Image
		
		private var goldSp:Sprite;
		private var star:Image;
		
		public function RAnimationMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function prepare(vo:SwitchScreenVO):void
		{
			this.vo = vo;
			
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
			
		}
		public function dispose():void{
			vo.type = SwitchScreenType.HIDE;
			sendNotification(WorldConst.SWITCH_SCREEN,[vo]);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			Starling.current.stage.color = 0xFFFFFF;
			view.addChild(new PlaneAni);
			/*return;
			
			if(!facade.hasProxy(ModuleConst.FIGHT_CHARATER_POOL)){
				pool = new FightCharaterPoolProxy(true);
				facade.registerProxy(pool);
				pool.init();
			}else{
				pool = facade.retrieveProxy(ModuleConst.FIGHT_CHARATER_POOL) as FightCharaterPoolProxy;
			}
			
			
			
			holder = new Sprite;
			holder.x = 400;
			holder.y = 200;
			view.addChild(holder);
			
			var backbg:Image = new Image(Assets.getRAnimationTexture("backBg"));
			holder.addChild(backbg);
			
			screen = new Sprite;
			screen.x = 7;
			screen.y = 7;
			screen.clipRect = new Rectangle(0,0,547,206);
			holder.addChild(screen);
			
			
			world = new Sprite;
			world.x = -150;
			screen.addChild(world);
			
			var img:Image = new Image(Assets.getRAnimationTexture("bg1"));
			world.addChild(img);
			
			
			var newEquip:String;
			//调整用户武器装备
			if(Global.myDressList.indexOf("weapon") != -1){
				var arr:Array = Global.myDressList.split(",");
				for (var i:int = 0; i < arr.length; i++) 
				{
					if(arr[i].indexOf("weapon") != -1){
						arr[i] = "weapon43";
						break;
					}
					
				}
				newEquip = arr.join(",");
				
			}else{
				newEquip = Global.myDressList+",weapon43";
				
			}
			
			fighter1 = pool.object;
			fighter1.setTo(250,150);
			GlobalModule.charaterUtils.humanDressFun(fighter1.charater,newEquip);
			fighter1.decision =  new HeroGoAI(new Point(250,150),null);
			fighter1.start();
			
			fighter2 = pool.object;
			fighter2.setTo(600,150);
			GlobalModule.charaterUtils.humanDressFun(fighter2.charater,"face_face1,defaultset");
			fighter2.decision =  new HeroGoAI(new Point(600,150),null);
			fighter2.start();
			fighter2.charater.dirX = -1;
			
			world.addChild(fighter1.charater.view);
			world.addChild(fighter2.charater.view);
			
			
			vsSp = new Sprite;
			vsSp.x = 280;
			vsSp.y = 60;
			screen.addChild(vsSp);
			
			vsicon = new Image(Assets.getRAnimationTexture("vsIcon"));
			centerPivot(vsicon);
			vsicon.x = -15;
			vsSp.addChild(vsicon);
			
			vsLight = new Image(Assets.getRAnimationTexture("LaserIcon"));
			centerPivot(vsLight);
			vsLight.y = 65;
			vsLight.scaleX = 1;
			vsSp.addChild(vsLight);
			
			TweenLite.from(vsLight, 0.3, {scaleX:0, delay:START_TIME, ease:Elastic.easeOut});
			TweenLite.from(vsicon, 0.2, {x: 50, y:-100, delay:START_TIME+0.2, ease:Elastic.easeOut});
			
			
			
			
			//创建镜头，对焦角色
			TweenLite.delayedCall(START_TIME+0.5,creatCam);
			
			//角色奔跑
			TweenLite.delayedCall(START_TIME+1.3,charaterRun);
			
			//战斗打架
			TweenLite.delayedCall(START_TIME+2.5,fight);*/
			
			
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case LearnConst.HIDE_REWARD:
				{
					dispose();
					break;
				}
					
				default:
				{
					break;
				}
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [LearnConst.HIDE_REWARD];
		}
		
		
		
		//创建镜头
//		private function creatCam():void{
//			vsSp.visible = false;
//			
//			cam = new Fluocam(world, 500, 300, false,fighter1.charater.view,false);
//			view.addChild(cam);
//			
//			cam.zoomToTarget(1.5,0.5);
//			
//		}
//		
//		//奔跑
//		private function charaterRun():void{
//			fighter1.go(400,150);
//			fighter2.go(500,150);
//			
//			cam.zoomToTarget(1,1);
//		}
//		
//		private function fight():void{
//			(fighter1.charater as IHuman).action("fight",20,20,false);
//			TweenLite.delayedCall(30,resetFighter1,null,true);
//			TweenLite.delayedCall(30,(fighter2.charater as IHuman).action,["hit",7,20,false],true);
//			TweenLite.delayedCall(70,resetFighter2,null,true);
//			TweenLite.delayedCall(80,showWinTips,null,true);
//			
//			playAttEff();
//		}
//		
//		
//		
//		
//		//战斗效果
//		private function playAttEff():void{
//			effSp = new Sprite;
//			effSp.x = 70;
//			screen.addChild(effSp);
//			
//			
//			flightsp = new Sprite;
//			var flight:Image = new Image(Assets.getRAnimationTexture("fightLight"));
//			flightsp.addChild(flight);
//			flightsp.clipRect = new Rectangle(0,0,0,flight.height);
//			effSp.addChild(flightsp);
//			
//			fBom = new Image(Assets.getRAnimationTexture("fightBom"));
//			centerPivot(fBom);
//			fBom.x = 216;
//			fBom.y = 120;
//			effSp.addChild(fBom);
//			
//			
//			TweenLite.to(flightsp.clipRect, 0.2, {delay:0.3, width:flight.width});
//			TweenLite.from(fBom, 0.2, {x: 50, y:-100, delay:0.5, ease:Elastic.easeOut, onComplete:effComplete});
//			
//		}
//		private function effComplete():void{
//			effSp.removeFromParent(true);
//		}
//		
//		private function resetFighter1():void{
//			(fighter1.charater as IHuman).look("fight");
//			(fighter1.charater as IHuman).action("GangnanStyle",20,60,true);
//			
//		}
//		
//		private function resetFighter2():void{
//			(fighter2.charater as IHuman).action("die",7,20,false);
//			
//		}
//		
//		
//		
//		//胜利字幕
//		private var winTips:Image;
//		private function showWinTips():void{
//			
//			winTips = new Image(Assets.getRAnimationTexture("failText"));
//			winTips.x = 400;
//			winTips.y = -50;
//			winTips.alpha = 1;
//			holder.addChild(winTips);
//			
//			TweenLite.from(winTips, 0.2, {alpha:0});
//			
//			TweenLite.delayedCall(0.8, swipToEnd);
//		}
//		
//		private function swipToEnd():void{
//			winTips.visible  = false;
//			cam.goToTarget(fighter2.charater.view);
//			
//			TweenLite.delayedCall(0.5,showGold);
//		}
//		
//		//空投金币
//		private function showGold():void{
//			
//			fighter2.charater.view.alpha = 0;
//			
//			
//			goldSp = new Sprite;
//			goldSp.x = 300;
//			goldSp.y = 130;
//			screen.addChild(goldSp);
//			
//			var gold:Image = new Image(Assets.getRAnimationTexture("goldTips"));
//			centerPivot(gold);
//			gold.x = 20;
//			goldSp.addChild(gold);
//			
//			star = new Image(Assets.getRAnimationTexture("goldStar"));
//			centerPivot(star);
//			star.y = -30;
//			star.alpha = 0;
//			goldSp.addChild(star);
//			
//			TweenLite.from(goldSp, 0.3, {x:500, y:-300, ease:Elastic.easeOut});
//			TweenMax.to(star, 0.3, {delay:0.3, alpha:1, yoyo:true, repeat:int.MAX_VALUE});
//			
//			
//		}
//		
//		
//		
//		
//		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function onRemove():void
		{
			super.onRemove();
//			
//			if(vsLight)	TweenLite.killTweensOf(vsLight);
//			if(vsicon)	TweenLite.killTweensOf(vsicon);
//			
//			TweenLite.killDelayedCallsTo(creatCam);
//			TweenLite.killDelayedCallsTo(charaterRun);
//			TweenLite.killDelayedCallsTo(fight);
//			
//			
//			
//			TweenLite.killDelayedCallsTo(resetFighter1);
//			TweenLite.killDelayedCallsTo((fighter2.charater as IHuman).action);
//			TweenLite.killDelayedCallsTo(resetFighter2);
//			TweenLite.killDelayedCallsTo(showWinTips);
//			
//			
//			if(flightsp)	TweenLite.killTweensOf(flightsp.clipRect);
//			if(fBom)	TweenLite.killTweensOf(fBom);
//			
//			if(winTips)	TweenLite.killTweensOf(winTips);
//			TweenLite.killDelayedCallsTo(swipToEnd);
//			
//			TweenLite.killDelayedCallsTo(showGold);
//			
//			
//			if(goldSp)	TweenLite.killTweensOf(goldSp);
//			if(star)	TweenMax.killTweensOf(star);
//			
//			
//			(facade.retrieveProxy(ModuleConst.FIGHT_CHARATER_POOL) as FightCharaterPoolProxy).object = fighter1;
//			(facade.retrieveProxy(ModuleConst.FIGHT_CHARATER_POOL) as FightCharaterPoolProxy).object = fighter2;
//			
//			facade.removeProxy(ModuleConst.FIGHT_CHARATER_POOL);
//			
//			
//			view.removeChildren(0,-1,true);
		}
		
		
		
		
	}
}