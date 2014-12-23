package com.studyMate.world.screens.component
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.christmasad.ChristmasAdViewMediator;
	import com.studyMate.world.screens.effects.BasePartical;
	import com.studyMate.world.screens.effects.SwimWater;
	import com.studyMate.world.screens.effects.WaterSpray;
	import com.studyMate.world.screens.view.AlertChrHopeMediator;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	
	public class MeteorSp extends Sprite
	{
		private var holder:Sprite;
		private var meteor:Quad;//流星
		private var _waterSpray:BasePartical;
		public function MeteorSp()
		{
			holder = new Sprite();
			this.addChild(holder);
			
			holder.x = 1280;
			holder.y = -80;
			
			meteor = new Quad(100,100);
			meteor.alpha = 0;
			holder.addChild(meteor);
			meteor.addEventListener(TouchEvent.TOUCH,meteorHandler);
			
			
			
			var delayTime:Number = 15+30*Math.random();
//			var delayTime:Number = 8;
			var speed:Number = 5 + 15*Math.random();
			TweenLite.to(holder,speed,{x:-250,y:200,delay:delayTime,onComplete:onComplete,onStart:onStart});
		}
		private function onStart():void{
			_waterSpray = new BasePartical(Assets.store["meteor"], Assets.getAtlas().getTexture("bg/swimwater"));
			_waterSpray.rotation = 1.4;
			_waterSpray.x = 75;
			_waterSpray.y = 55;
			holder.addChild(_waterSpray);
			_waterSpray.start();
		}
		
		private function onComplete():void{
			if(_waterSpray){
				_waterSpray.removeFromParent();
				_waterSpray.dispose();
				_waterSpray = null;
			}
			
			holder.x = 1280;
			holder.y = -80;
			var delayTime:Number = 15+60*Math.random();
			var speed:Number = 5 + 15*Math.random();
			TweenLite.to(holder,speed,{x:-250,y:200,delay:delayTime,onComplete:onComplete,onStart:onStart});
			meteor.touchable = true;
		}
		
		private function meteorHandler(e:TouchEvent):void
		{
			if(e.touches[0].phase=="ended"){
				meteor.touchable = false;
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(AlertChrHopeMediator,null,SwitchScreenType.SHOW)]);
			}
		}
		
		override public function dispose():void{
			TweenLite.killTweensOf(holder);
			if(_waterSpray){
				_waterSpray.removeFromParent();
				_waterSpray.dispose();
				_waterSpray = null;
			}
			super.dispose();
		}
	}
}