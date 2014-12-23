package com.mylib.game.fightGame
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.card.FightEffectFactoryProxy;
	import com.mylib.game.card.FightEffectVO;
	import com.mylib.game.charater.IHuman;
	import com.mylib.game.charater.JobTypes;
	import com.mylib.game.charater.logic.FighterControllerMediator;
	import com.mylib.game.charater.logic.IFightDecision;
	import com.mylib.game.charater.logic.ai.HeroGoAI;
	import com.mylib.game.charater.logic.ai.RollFightAI;
	import com.mylib.game.model.FightCharaterPoolProxy;
	import com.studyMate.global.Global;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.geom.Point;
	
	import de.polygonal.core.ObjectPool;
	
	import feathers.controls.Button;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.TextureAtlas;
	
	public class TestRollFightMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "FightingPlaybackMediator";
		private var pool:FightCharaterPoolProxy;
		private	var player1:FighterControllerMediator;
		private	var player2:FighterControllerMediator;
		private var effect:FightEffectVO;
		private var eff:MovieClip;
		
		public function TestRollFightMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		
		override public function onRegister():void
		{
			super.onRegister();
			
			Starling.current.stage.color = 0x70E1F5;
			if(!facade.hasProxy(ModuleConst.FIGHT_CHARATER_POOL)){
				pool = new FightCharaterPoolProxy(true);
				facade.registerProxy(pool);
				pool.init();
			}else{
				pool = facade.retrieveProxy(ModuleConst.FIGHT_CHARATER_POOL) as FightCharaterPoolProxy;
			}
			
			facade.registerProxy(new FightEffectFactoryProxy());
			
			
			effect = (Facade.getInstance(CoreConst.CORE).retrieveProxy(FightEffectFactoryProxy.NAME) as FightEffectFactoryProxy).getEffect(JobTypes.keep);
			
			eff = new MovieClip((Assets.petTexture.texture as TextureAtlas).getTextures("effect/jixu"));
			
			
			var button:Button = new Button();
			/*button.label = "play";
			button.x = 100;
			button.y = 460;
			button.addEventListener(Event.TRIGGERED,playHandle);
			view.addChild(button);
			
			button = new Button();
			button.label = "reset";
			button.x = 100;
			button.y = 500;
			button.addEventListener(Event.TRIGGERED,resetHandle);
			view.addChild(button);*/
			
			button = new Button();
			button.label = "积蓄能量";
			button.x = 100;
			button.y = 600;
			button.addEventListener(Event.TRIGGERED,keepHandle);
			view.addChild(button);
			
			button = new Button();
			button.label = "加血";
			button.x = 100;
			button.y = 650;
			button.addEventListener(Event.TRIGGERED,addBloodHandle);
			view.addChild(button);
			
			button = new Button();
			button.label = "小宇宙爆发";
			button.x = 100;
			button.y = 700;
			button.addEventListener(Event.TRIGGERED,yuzhouHandle);
			view.addChild(button);
			
			button = new Button();
			button.label = "受伤";
			button.x = 200;
			button.y = 600;
			button.addEventListener(Event.TRIGGERED,hurtHandle);
			view.addChild(button);
			
			pool.charaterPool =facade.retrieveProxy(ModuleConst.HUMAN_POOL) as ObjectPool;
			
			player1 = pool.object;
			player1.setTo(100,200);
			GlobalModule.charaterUtils.humanDressFun(player1.charater,Global.myDressList);
			
			view.addChild(player1.charater.view);
			player1.decision =  new RollFightAI(new Point(400,200),null);
			player1.start();
			
			
			player2 = pool.object;
			player2.setTo(1000,200);
			GlobalModule.charaterUtils.humanDressFun(player2.charater,Global.myDressList);
			
			view.addChild(player2.charater.view);
			player2.decision =  new HeroGoAI(new Point(1000,200),null);
			player2.start();
			
			
		}
		
		private function hurtHandle():void
		{
			(player1.decision as IFightDecision).makeHurtDecision(player1,player1);
		}
		
		private function yuzhouHandle():void
		{
			(Facade.getInstance(CoreConst.CORE).retrieveProxy(FightEffectFactoryProxy.NAME) as FightEffectFactoryProxy).getEffect(JobTypes.yuzhou).start(0,-120,-100,-120,-100,player1.charater.view);
		}
		
		private function addBloodHandle():void
		{
			(Facade.getInstance(CoreConst.CORE).retrieveProxy(FightEffectFactoryProxy.NAME) as FightEffectFactoryProxy).getEffect(JobTypes.addBlood).start(0,-150,-60,-150,-60,player1.charater.view);
		}
		private function keepHandle():void{
			
//			(player1.charater as IHuman).look("firm");
			player1.charater.action("xuli1",10,30,false);
			
//			player1.decision.makeDecision(player2);
//			effect.effect.loop = true;
//			effect.start(0,-180,-100,-180,-100,player1.charater.view,0);
			(player1.decision as IFightDecision).makeFightDecision(player1);
		}
		
		/*private function resetHandle(event:Event):void
		{
		player1.go(100,200);
		player2.go(1000,200);
		}
		
		private function playHandle(event:Event):void
		{
		player1.charater.velocity = 7;
		player2.charater.velocity = 7;
		player1.go(750,200);
		player2.go(350,200);
		
		<<<<<<< .mine
		effect.start(0,580,200,400,200,view);
		=======
		
		(player1.decision as HeroGoAI).addEventListener(EnterFightEvent.READY,arriveHandle);
		
		
		effect.start(1,580,200,400,200,view);
		>>>>>>> .r10501
		
		}*/
		
		
		
		private function arriveHandle(event:Event):void{
			
			if(player1.charater.view.x>500){
				player1.go(350,200);
			}else{
				player1.go(750,200);
			}
			
			if(player2.charater.view.x>500){
				player2.go(350,200);
			}else{
				player2.go(750,200);
			}
			
			
			effect.start(0.6,580,200,400,200,view);
			
			
		}
		
		
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
		}
	}
}