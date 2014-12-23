package com.mylib.game.charater.logic.ai
{
	import com.byxb.utils.centerPivot;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.mylib.framework.CoreConst;
	import com.mylib.game.card.FightEffectFactoryProxy;
	import com.mylib.game.card.FightEffectVO;
	import com.mylib.game.card.GameCharater;
	import com.mylib.game.card.HeroFightManager;
	import com.mylib.game.charater.JobTypes;
	import com.mylib.game.charater.logic.AIState;
	import com.mylib.game.charater.logic.BaseCharaterControllerMediator;
	import com.mylib.game.charater.logic.FighterControllerMediator;
	import com.mylib.game.charater.logic.IFightDecision;
	import com.mylib.game.controller.vo.HeroFightVO;
	import com.mylib.game.ui.HPTextPool;
	
	import de.polygonal.core.ObjectPool;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.text.TextField;
	
	public class HeroFightAI implements IFightDecision
	{
		private var fightData:HeroFightVO;
		
		private var reduceHP:int;
		
		private var hero:GameCharater;
		
		private var hpField:TextField;
		private var hpPool:ObjectPool;
		
		private var hpPostion:int;
		
		private var effect:FightEffectVO;
		
		public function HeroFightAI(_fightData:HeroFightVO,myHero:GameCharater)
		{
			this.fightData = _fightData;
			this.hero = myHero;
			hpPool = Facade.getInstance(CoreConst.CORE).retrieveProxy(HPTextPool.NAME) as ObjectPool;
			
			var pos:int=0;
			for (var i:int = 0; i < _fightData.heros.length; i++) 
			{
				if(_fightData.heros[i]!=hero){
					
					if(hero.fighter.charater.view.x>_fightData.heros[i].fighter.charater.view.x){
						pos++;
					}
				}
			}
			
			hpPostion= pos*20;
			
			
			
			
			
			effect = (Facade.getInstance(CoreConst.CORE).retrieveProxy(FightEffectFactoryProxy.NAME) as FightEffectFactoryProxy).getEffect(hero.data.job);
			
			
		}
		
		
		public function makeFightDecision(ai:FighterControllerMediator):void
		{
			
			var att:int = hero.fighter.fighter.attack;
			
			if(hero.data.job!=JobTypes.warrior){
				att*=Math.random()+3;
			}
			
			reduceHP = att+att*(Math.random()*2-1)*0.1;
			
			
			var isCrit:Boolean;
			if(Math.random()>0.8){
				isCrit = true;
				reduceHP*=2;
			}
			
			
			
			
			if(fightData.cacheHP<reduceHP){
				reduceHP = fightData.cacheHP;
			}
			
			
			fightData.cacheHP-=reduceHP;
			
			if(hero.data.job==JobTypes.warrior){
				ai.charater.action("fight",8,ai.fighter.attackRate*20,false);
			}else{
				ai.charater.action("doctor",8,ai.fighter.attackRate*20,false);
			}
			
			TweenLite.to(ai,ai.fighter.attackRate*20,{onComplete:attackComplete,onCompleteParams:[ai,reduceHP,isCrit],useFrames:true});
			
			
			
			effect.start(ai.fighter.attackRate*15/60,ai.fighter.view.x,ai.fighter.view.y,
				fightData.monster.fighter.charater.view.x,fightData.monster.fighter.charater.view.y,ai.fighter.view.parent);
			
			
			
		}
		
		private function timeFly(ai:FighterControllerMediator,freezeTime:Number):void{
			
			ai.charater.idle();
			TweenLite.to(ai,freezeTime,{onComplete:ai.fsm.changeState,onCompleteParams:[AIState.IDLE]});
		}
		
		
		
		private function attackComplete(ai:FighterControllerMediator,reduceHP:int,isCrit:Boolean):void{
			
			fightData.remainHP-=reduceHP;
			
			if(fightData.remainHP<=0){
				fightData.remainHP=0;
			}
			
			Facade.getInstance(CoreConst.CORE).sendNotification(HeroFightManager.UPDATE_VALUE,fightData);
			
			hpField = hpPool.object;
			hpField.alpha = 0;
			
			if(hero.data.job==JobTypes.warrior){
				hpField.color = 0xf6f04e;
			}else if(hero.data.job==JobTypes.knight){
				hpField.color = 0x4ef8ba;
			}else{
				hpField.color = 0xfea82d;
			}
			
			
			hpField.x = fightData.monster.fighter.charater.view.x+hpPostion;
			
			hpField.y = ai.fighter.view.y-80;
			
			ai.fighter.view.parent.addChild(hpField);
			hpField.text = reduceHP.toString();
			
			
			centerPivot(hpField);
			
			
			TweenLite.from(hpField,1,{y:hpField.y+40});
//			TweenLite.to(hpField,0.5,{y:hpField.y-60,alpha:0,delay:0.8,onComplete:hpFieldAimationHandle,onCompleteParams:[hpField]});
			TweenMax.to(hpField,0.5,{alpha:1,yoyo:true,repeat:1,onComplete:hpFieldAimationHandle,onCompleteParams:[hpField]});
			TweenLite.killTweensOf(fightData.monster.fighter.charater.view,true);
			TweenMax.to(fightData.monster.fighter.charater.view,0.1,{x:fightData.monster.fighter.charater.view.x+ai.fighter.dirX*6,yoyo:true,repeat:1});
//			fightData.monster.fighter.charater.view.visible = false;
			
			
			if(isCrit){
				TweenMax.to(hpField,0.5,{scaleX:2,scaleY:2,yoyo:true,repeat:1});
			}
			
			
			ai.fighter.idle();
			if(hero.data.job==JobTypes.warrior){
				
				if(Math.random()>0.8){
					timeFly(ai,0.5);
				}else{
					ai.fsm.changeState(AIState.IDLE);
				}
				
			}else{
				
				
				timeFly(ai,2+Math.random()*2);
				
			}
			
			
			
			
		}
		
		private function hpFieldAimationHandle(field:TextField):void{
			hpPool.object = field;
		}
		
		public function makeEscapeDecision(ai:FighterControllerMediator):void
		{
		}
		
		public function makeHurtDecision(attacker:FighterControllerMediator, me:FighterControllerMediator):void
		{
		}
		
		public function makeDecision(ai:BaseCharaterControllerMediator):void
		{
			if(fightData.cacheHP>fightData.averageDamage*3||(fightData.remainHP<fightData.averageDamage*3&&fightData.cacheHP>0)){
				ai.fsm.changeState(AIState.FIGHTING);
			}
			
		}
		
		public function dispose():void
		{
			TweenLite.killTweensOf(hero.fighter);
			effect.dispose();
		}
		
		public function makeTargetingDecision(ai:BaseCharaterControllerMediator):void
		{
		}
		
		public function makeArriveDecision(ai:BaseCharaterControllerMediator):void
		{
		}
	}
}