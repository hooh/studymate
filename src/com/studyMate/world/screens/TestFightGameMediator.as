package com.studyMate.world.screens
{
	import com.greensock.TimelineLite;
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.card.FightEffectFactoryProxy;
	import com.mylib.game.card.FightEffectVO;
	import com.mylib.game.charater.HumanMediator;
	import com.mylib.game.charater.IHuman;
	import com.mylib.game.charater.JobTypes;
	import com.mylib.game.charater.logic.FighterControllerMediator;
	import com.mylib.game.charater.logic.ai.HeroGoAI;
	import com.mylib.game.fightGame.CircleChart;
	import com.mylib.game.fightGame.CircleRoller;
	import com.mylib.game.fightGame.FightCharger;
	import com.mylib.game.fightGame.FightingPlaybackMediator;
	import com.mylib.game.fightGame.RollerUtils;
	import com.mylib.game.model.FightCharaterPoolProxy;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.module.ModuleConst;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import de.polygonal.core.ObjectPool;
	
	import feathers.controls.Button;
	
	import luaAlchemy.LuaAlchemy;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.QuadtreeSprite;
	import starling.extensions.fluocode.Fluocam;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;

	public class TestFightGameMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "TestFightGameMediator";
		private var  property:String;
		private var maxBar:Quad;
		private var player:FighterControllerMediator;
		private var charger:FightCharger;
		private var eff:FightEffectVO;
		private var att:MovieClip;
		
		override public function onRemove():void
		{
			super.onRemove();
			
			view.stage.removeEventListener(TouchEvent.TOUCH,touchHandle);
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
			
			
			sendNotification(CoreConst.HIDE_STARUP_INFOR);
			
			
//			view.stage.addEventListener(TouchEvent.TOUCH,touchHandle);
			
			
//			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(FightingPlaybackMediator,null,SwitchScreenType.SHOW)]);
			
			var button:Button = new Button();
			button.label = "run lua";
			button.x = 100;
			button.y = 100;
			button.addEventListener(starling.events.Event.TRIGGERED,runHandle);
			view.addChild(button);
			
			maxBar = new Quad(10,50,0xffffff);
			view.addChild(maxBar);
			
			maxBar.x = 100;
			maxBar.y = 300;
			maxBar.pivotY = 50;
			
			
			
			if(!facade.hasProxy(ModuleConst.FIGHT_CHARATER_POOL)){
				pool = new FightCharaterPoolProxy(true);
				facade.registerProxy(pool);
				pool.init();
			}else{
				pool = facade.retrieveProxy(ModuleConst.FIGHT_CHARATER_POOL) as FightCharaterPoolProxy;
			}
			
			player = pool.object;
			
			facade.registerProxy(new FightEffectFactoryProxy());
			pool.charaterPool =facade.retrieveProxy(ModuleConst.HUMAN_POOL) as ObjectPool;
			
			player = pool.object;
			player.setTo(100,200);
			GlobalModule.charaterUtils.humanDressFun(player.charater,Global.myDressList);
			
			view.addChild(player.charater.view);
			player.decision =  new HeroGoAI(new Point(400,200),null);
			player.start();
			
			charger = new FightCharger(player);
			
			
			
			var img:Image = new Image(Assets.getFightGameTexture("underWorld_lvl1bg"));
			img.x = -250;
			img.y = -100;
			fighter1 = pool.object;
			fighter1.setTo(0,40);
			GlobalModule.charaterUtils.humanDressFun(fighter1.charater,Global.myDressList);
			fighter1.decision =  new HeroGoAI(new Point(0,40),null);
			fighter1.start();
			
			var holder:Sprite = new Sprite;
			var world:Sprite = new Sprite;
			view.addChild(holder);
			var  quard:Quad = new Quad(20,100,0xff0000);
			holder.addChild(world);
			holder.addChild(quard);
			var cam:Fluocam=new Fluocam(world, 500, 200, false,fighter1.charater.view,false);
			view.addChild(cam);
			world.addChild(img);
			
			holder.clipRect = new Rectangle(0,0,500,200);
			
			holder.x = 200;
			holder.y = 300;
			
			
			fighter2 = pool.object;
			fighter2.setTo(800,40);
			GlobalModule.charaterUtils.humanDressFun(fighter2.charater,Global.myDressList);
			fighter2.decision =  new HeroGoAI(new Point(800,40),null);
			fighter2.start();
			fighter2.charater.dirX = -1;
			
			world.addChild(fighter2.charater.view);
			world.addChild(fighter1.charater.view);
			
			
			var timeline:TimelineMax = new TimelineMax();
			
			timeline.append(TweenLite.delayedCall(4,cam.goToTarget,[fighter2.charater.view]));
			timeline.append(TweenLite.delayedCall(4,cam.goToTarget,[fighter1.charater.view]));
			timeline.append(TweenLite.delayedCall(0.1,function():void{
			(fighter1.charater as IHuman).look("firm");
			(fighter2.charater as IHuman).look("firm");
			
			}));
			timeline.append(TweenLite.delayedCall(2,fighter1.go,[420,40]));
			timeline.append(TweenLite.delayedCall(0.1,cam.zoomToTarget,[1.5,1]));
			timeline.add(TweenLite.delayedCall(0.1,fighter2.go,[470,40]));
			timeline.append(TweenLite.delayedCall(1,cam.zoomToTarget,[1,1]));
			
			TweenLite.delayedCall(13,attack);
//			timeline.addEventListener(flash.events.Event.COMPLETE,timelineCompleteHandle);
			timeline.play();
			
			
			eff = (Facade.getInstance(CoreConst.CORE).retrieveProxy(FightEffectFactoryProxy.NAME) as FightEffectFactoryProxy).getEffect(JobTypes.charge);
			eff.effect.loop = true;
			eff.effect.fps = 30;
			
			att = new MovieClip((Assets.petTexture.texture as TextureAtlas).getTextures("effect/atteff1"));
			Starling.juggler.add(att);
			att.setFrameDuration(0,0.3);
//			att.setFrameDuration(1,0.4);
			att.stop();
			att.loop = false;
			att.pivotX = att.width*0.5;
			att.pivotY = att.height*0.5;
			att.scaleX = att.scaleY = 0.5;
			att.x = 70;
			att.y = -50;
			att.fps = 30;
			att.addEventListener(starling.events.Event.COMPLETE,effectHandle);
		}
		
		private function effectHandle(event:starling.events.Event):void
		{
			// TODO Auto Generated method stub
			(event.target as MovieClip).removeFromParent();
		}
		
		protected function timelineCompleteHandle(event:flash.events.Event):void
		{
			attack();
			
			
		}
		
		private function attack():void{
			eff.start(1.1,100,-20,-30,-30,fighter1.charater.view);
			fighter1.charater.action("xuli1",10,30,false);
			
			TweenLite.delayedCall(1,function():void{
				(fighter1.charater as IHuman).action("fight",20,20,false);
				//			(fighter2.charater as IHuman).action("fight",14,20,false);
				TweenLite.delayedCall(30,resetState,[fighter1.charater],true);
				TweenLite.delayedCall(30,(fighter2.charater as IHuman).action,["hit",7,20,false],true);
				TweenLite.delayedCall(70,resetState,[fighter2.charater],true);
				TweenLite.delayedCall(30,playAttEff,null,true);
				//			TweenLite.delayedCall(30,resetState,[fighter2.charater],true);
				TweenLite.delayedCall(80,attack,null,true);
			}
			
			);
			
			
		}
		
		private function playAttEff():void{
			fighter1.charater.view.addChild(att);
			att.currentFrame = 0;
			att.play();
		}
		
		private function resetState(human:IHuman):void{
//			human.look(HumanMediator.FACE_NORMAL);
			human.idle();
			
			
		}
		
		private var fighter1:FighterControllerMediator;
		private var fighter2:FighterControllerMediator;
		
		private function worldHandle(event:TouchEvent):void{
			var touch:Touch = event.getTouch(event.currentTarget as DisplayObject,TouchPhase.ENDED);
			
			if(touch){
				
				trace(touch.getLocation(event.currentTarget as DisplayObject));
				
				
				
			}
			
		}
		
		
		private function runHandle(event:starling.events.Event):void{
			var file:File = Global.document.resolvePath(Global.localPath+"test.lua");
			var f:FileStream = new FileStream;
			f.open(file,FileMode.READ);
			var str:String = f.readMultiByte(f.bytesAvailable,PackData.BUFF_ENCODE);
//			lua.doString(str);
			
		}
		
		private function runBar():void{
			maxBar.height = 1;
			TweenMax.to(maxBar,0.6,{height:50,yoyo:true,repeat:999,ease:Linear.easeNone});
			
			
		}
		
		private function stopBar():void{
			
			TweenLite.killTweensOf(maxBar);
			
			
		}
		
		private var _start:Boolean;
		private var pool:FightCharaterPoolProxy;
		private function touchHandle(event:TouchEvent):void
		{
			
			var touchStart:Touch = event.getTouch((event.target as DisplayObject),TouchPhase.BEGAN);
			var touchEnd:Touch = event.getTouch((event.target as DisplayObject),TouchPhase.ENDED);
			
			
			if(touchStart){
				runBar();
			}else if(touchEnd){
				stopBar();
			}
			
			
			
			/*if(touch){
				_start = !_start;
				
				if(_start){
					runBar();
//					roller.start();
				}else{
//					roller.stop();
					stopBar();
					trace("roller value",roller.value);
					trace(RollerUtils.getRollerValueByProperty(roller.value,property));
				}
			}*/
			
			
			
		}
		
		public function TestFightGameMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
	}
}