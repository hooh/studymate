package com.mylib.game.fightGame
{
	import com.byxb.utils.centerPivot;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.logic.FighterControllerMediator;
	import com.mylib.game.model.FightCharaterPoolProxy;
	import com.studyMate.global.Global;
	import com.studyMate.module.GlobalModule;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class FightVideoView extends Sprite
	{
		private static const NAME:String = "FightVideoView";
		public static const PLAY_VIDEO_COMPLETE:String = NAME + "PlayVideoComplete";
		
		private var charaterSp:Sprite;
		
		private var pool:FightCharaterPoolProxy;
		private var me:FighterControllerMediator;
		private var enemy:FighterControllerMediator;
		
		public function FightVideoView(_pool:FightCharaterPoolProxy)
		{
			pool = _pool;
			
			var quad:Quad = new Quad(Global.stageWidth, Global.stageHeight, 0);
			quad.alpha = 0.3;
			addChild(quad);
			
			charaterSp = new Sprite;
			var _quad:Quad = new Quad(Global.stageWidth, Global.stageHeight, 0);
			_quad.alpha = 0.3;
			addChild(_quad);
			centerPivot(charaterSp);
			charaterSp.x = 640;
			charaterSp.y = 381;
			addChild(charaterSp);
			
			
			me = pool.object;
			GlobalModule.charaterUtils.humanDressFun(me.charater,Global.myDressList);
//			me.charater.view.x = 200;
//			me.charater.view.y = 350;
			me.charater.view.x = -600;
			me.charater.view.y = 0;
			me.charater.view.scaleX = 1.5;
			me.charater.view.scaleY = 1.5;
			
			
			enemy = pool.object;
			GlobalModule.charaterUtils.humanDressFun(enemy.charater,"face_face1");
//			enemy.charater.view.x = 1000;
//			enemy.charater.view.y = 350;
			enemy.charater.view.x = 600;
			enemy.charater.view.y = 0;
			enemy.charater.view.scaleX = -1.5;
			enemy.charater.view.scaleY = 1.5;
			
			
			
			
			addEventListener(Event.ADDED_TO_STAGE, initProBar);
			
		}
		public function updateData(_enemyDress:String):void{
			
			GlobalModule.charaterUtils.configHumanFromDressList(enemy.charater,_enemyDress,null);
		}
		
		private function initProBar(e:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, initProBar);
			
			charaterSp.addChild(me.charater.view);
			charaterSp.addChild(enemy.charater.view);
			
			
			
			
			TweenMax.to(me.charater.view,0.6,{x:0,yoyo:true,ease:Elastic.easeOut,repeat:int.MAX_VALUE});
			TweenMax.to(enemy.charater.view,0.6,{x:0,yoyo:true,ease:Elastic.easeOut,repeat:int.MAX_VALUE});
			TweenLite.delayedCall(5,destroy);
			
			playVideo();
		}
		private function playVideo():void{
			TweenLite.delayedCall(0.3,playVideo);
			
			charaterSp.rotation = Math.random()*2-1;
			
			me.charater.action("fight",8,me.fighter.attackRate*20,false);
			TweenLite.to(me,me.fighter.attackRate*20,{onComplete:attackComplete,onCompleteParams:[me],useFrames:true});
			enemy.charater.action("fight",8,enemy.fighter.attackRate*20,false);
			TweenLite.to(enemy,enemy.fighter.attackRate*20,{onComplete:attackComplete,onCompleteParams:[enemy],useFrames:true});
			
		}
		private function attackComplete(ai:FighterControllerMediator):void{
			
			ai.fighter.idle();
			
		}
		private function destroy():void{
			this.removeFromParent(true);
			
//			Facade.getInstance(CoreConst.CORE).sendNotification(FightVideoView.PLAY_VIDEO_COMPLETE);
		}
		
		
		
		
		override public function dispose():void
		{
			super.dispose();
			TweenLite.killTweensOf(dispose);
			TweenLite.killTweensOf(playVideo);
			TweenLite.killTweensOf(me);
			TweenLite.killTweensOf(enemy);
			TweenLite.killTweensOf(me.charater.view);
			TweenLite.killTweensOf(enemy.charater.view);
			
			if(me && pool){
				me.charater.view.scaleX = 1;
				me.charater.view.scaleY = 1;
				pool.object = me;
			}
			if(enemy && pool){
				enemy.charater.view.scaleX = 1;
				enemy.charater.view.scaleY = 1;
				pool.object = enemy;
			}
			
			
			removeChildren(0,-1,true);
			
			removeEventListener(Event.ADDED_TO_STAGE, initProBar);
		}
		
		
		
	}
}