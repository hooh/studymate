package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Linear;
	
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class FlowerMediator extends Mediator
	{
		public function FlowerMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
		
		override public function onRegister():void
		{
			view.addEventListener(TouchEvent.TOUCH,flowerTouchHandle);
			view.pivotX = view.width>>1;
			view.pivotY = view.height;
			
			TweenLite.delayedCall(Math.random(),startShake);
			
			
			view.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
		}
		
		private function onRemoveFromStage(event:Event):void
		{
			facade.removeMediator(getMediatorName());
			
			
			
		}
		
		public function startShake():void{
			view.skewX = -0.05;
			view.skewY = -0.04;
			TweenMax.to(view,0.5,{skewX:0.05,skewY:0.04,yoyo:true,repeat:999});
		}
		
		override public function onRemove():void
		{
			TweenLite.killDelayedCallsTo(startShake);
			TweenLite.killTweensOf(view);
			view.removeFromParent(true);
		}
		
		private function flowerTouchHandle(event:TouchEvent):void
		{
			var target:Image = event.currentTarget as Image;
			var touch:Touch = event.getTouch(target,TouchPhase.ENDED);
			
			if(touch){
				TweenLite.killTweensOf(view);
				TweenLite.to(view,0.2,{skewX:-0.2,skewY:-0.1,onComplete:startTouchShake});
			}
		}
		
		private function startTouchShake():void{
			TweenMax.to(view,0.2,{skewX:0.2,skewY:0.1,yoyo:true,repeat:2,ease:Linear.easeOut,onComplete:touchCompleteHandle});
		}
		
		
		private function touchCompleteHandle():void{
			TweenLite.to(view,0.3,{skewX:-0.05,skewY:-0.04,onComplete:startShake});
		}
		
		public function get view():Image{
			
			return getViewComponent() as Image;
		}
		
		public function dispose():void{
			
			
			facade.removeMediator(getMediatorName());
			
			
		}
		
		
		
	}
}