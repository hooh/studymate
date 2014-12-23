package com.mylib.game.fightGame
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.mylib.framework.CoreConst;
	import com.mylib.game.card.FightEffectFactoryProxy;
	import com.mylib.game.card.FightEffectVO;
	import com.mylib.game.charater.HumanMediator;
	import com.mylib.game.charater.IHuman;
	import com.mylib.game.charater.JobTypes;
	import com.mylib.game.charater.logic.FighterControllerMediator;
	
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class FightCharger
	{
		private var fighter:FighterControllerMediator;
		private var chargeEffect:FightEffectVO;
		private var fighteEffect:FightEffectVO;
		
		private var bar:Image;
		private var barHolder:Sprite;
		private var mask:Rectangle;
		
		
		private var maxHeight:int;
		
		
		private var roller:CircleRoller;
		private var energyBar:Sprite;
		private var startTapX:int;
		
		private var guide:ChargeGuide;
		
		public function FightCharger(_fighter:FighterControllerMediator)
		{
			fighter = _fighter;
			
			
			fighter.charater.view.addEventListener(TouchEvent.TOUCH,startTouchHandle);
			
			chargeEffect = (Facade.getInstance(CoreConst.CORE).retrieveProxy(FightEffectFactoryProxy.NAME) as FightEffectFactoryProxy).getEffect(JobTypes.keep);
			fighteEffect = (Facade.getInstance(CoreConst.CORE).retrieveProxy(FightEffectFactoryProxy.NAME) as FightEffectFactoryProxy).getEffect(JobTypes.warrior);
			
			maxHeight = 60;
			bar = new Image(Assets.getFightGameTexture("bar"));
			bar.pivotY = maxHeight;
			
			barHolder = new Sprite();
			
			barHolder.addChild(bar);
			
			
			mask = new Rectangle(0,0,8,-maxHeight);
			
			barHolder.clipRect = mask;
			
			fighter.charater.view.addChild(barHolder);
			
			
			
			roller = new CircleRoller();
			roller.speed = 80;
			fighter.charater.view.addChild(roller);
			roller.x = 0;
			roller.y = 3;
			roller.scaleX = roller.scaleY = 0.75;
			
			roller.skewX = Math.PI/180*30;
			roller.rotation = Math.PI/180*25;
			roller.blendMode = BlendMode.MULTIPLY;
			
//			roller.skewY = Math.PI/180*30;
			
			
			energyBar = new Sprite();
			var barbg:Image = new Image(Assets.getFightGameTexture("bar_bg"));
			barbg.y = -maxHeight-1;
			barbg.x = -22;
			
			energyBar.addChild(barbg);
			energyBar.addChild(barHolder);
			energyBar.x = -60;
			energyBar.y = -10;
			fighter.charater.view.addChild(energyBar);
			
			
			
			RollerUtils.setRollerByProperty(roller,"30,80;500,30");
			roller.refresh();
			
			energyBar.visible = false;
			roller.visible = false;
			
			guide = new ChargeGuide;
			guide.y = -30;
			fighter.charater.view.addChild(guide);
			
			guide.play();
		}
		
		
		private function startTouchHandle(event:TouchEvent):void
		{
			var beginTouch:Touch = event.getTouch(event.target as DisplayObject,TouchPhase.BEGAN);
			var moveTouch:Touch = event.getTouch(event.target as DisplayObject,TouchPhase.MOVED);
			if(beginTouch){
				
				startTapX = beginTouch.globalX;
				
				
			}
			
			if(moveTouch){
				
				if(moveTouch.globalX-startTapX>200){
					guide.stop();
					fighter.charater.view.removeEventListener(TouchEvent.TOUCH,startTouchHandle);
					guide.visible = false;
					startCharge();
				}else{
					
					
					
					
					
				}
				
			}
			
		}
		
		private function startCharge():void{
			if(fighter.charater.view.stage){
				
				fighter.charater.view.stage.addEventListener(TouchEvent.TOUCH,stageTouchHandle);
				
			}
			
			
			(fighter.charater as IHuman).look("firm");
			fighter.charater.action("xuli1",10,30,false);
			
			
			chargeEffect.effect.loop = true;
			chargeEffect.start(0,-180,-100,-180,-100,fighter.charater.view,0);
			
			energyBar.visible = true;
			roller.visible = true;
			barHolder.clipRect.height = -1;
			TweenMax.to(barHolder.clipRect,0.8,{height:-maxHeight,yoyo:true,repeat:999,roundProps:["height"],ease:Linear.easeNone});
			TweenLite.killTweensOf(roundOver);
		}
		
		
		
		private function stageTouchHandle(event:TouchEvent):void
		{
			var endTouch:Touch = event.getTouch(event.target as DisplayObject,TouchPhase.ENDED);
			
			if(endTouch){
				fighter.charater.view.stage.removeEventListener(TouchEvent.TOUCH,stageTouchHandle);
//				(fighter.charater as IHuman).look(HumanMediator.FACE_NORMAL);
//				fighter.charater.idle();
				(fighter.charater as IHuman).action("fight",10,30,false);
				TweenLite.delayedCall(30,resetState,null,true);
				
				
				chargeEffect.dispose();
				TweenLite.delayedCall(0.4,fighteEffect.start,[0,20,0,20,0,fighter.charater.view,1]);
				TweenLite.killTweensOf(barHolder.clipRect);
				
				var roundPercent:Number = barHolder.clipRect.height/-maxHeight;
				var rTime:Number = 3*roundPercent;
				roller.roAngle(1080*roundPercent,rTime);
				TweenLite.delayedCall(rTime+1,roundOver);
			}
			
		}
		
		private function resetState():void{
			(fighter.charater as IHuman).look(HumanMediator.FACE_NORMAL);
			(fighter.charater as IHuman).idle();
		}
		
		private function roundOver():void{
			fighter.charater.idle();
			energyBar.visible = false;
			roller.visible = false;
			fighter.charater.view.addEventListener(TouchEvent.TOUCH,startTouchHandle);
			guide.play();
			guide.visible = true;
		}
		
		
	}
}