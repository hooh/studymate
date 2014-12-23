package com.mylib.game.card
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.game.controller.vo.HeroFightVO;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class RewardProcess
	{
		private var chest:MovieClip; 
		private var hfvo:HeroFightVO;
		
		public function RewardProcess(hfvo:HeroFightVO)
		{
			
			chest = new MovieClip(Assets.getUnderWorldAtlas().getTextures("chest/chest1"));
			chest.x = hfvo.monster.fighter.charater.view.x;
			chest.y = hfvo.monster.fighter.charater.view.y;
			chest.pivotX = chest.width>>1;
			chest.pivotY = chest.height>>1;
			chest.loop = false;
			chest.addEventListener(TouchEvent.TOUCH,touchHandle);
			Starling.juggler.add(chest);
			
			chest.stop();
			
			hfvo.monster.fighter.charater.view.parent.addChild(chest);
			hfvo.monster.fighter.charater.view.removeFromParent();
			
			this.hfvo = hfvo;
			
			
		}
		
		
		private function touchHandle(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.currentTarget as MovieClip,TouchPhase.ENDED);
			if(touch){
				Facade.getInstance(CoreConst.CORE).sendNotification(HeroFightManager.GET_REWARD,hfvo);
			}
		}
		
		public function open():void{
			chest.play();
			
			TweenLite.delayedCall(1,openHandle);
			
		}
		
		private function openHandle():void{
			chest.removeFromParent();
			dispose();
			
			Facade.getInstance(CoreConst.CORE).sendNotification(HeroFightManager.REOPEN_BASEMENT,hfvo);
			
		}
		
		
		
		public function dispose():void{
			
			chest.dispose();
			
			
		}
		
		
		
	}
}