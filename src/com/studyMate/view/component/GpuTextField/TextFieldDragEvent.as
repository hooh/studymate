package com.studyMate.view.component.GpuTextField
{
	
	import com.greensock.TweenLite;
	import com.studyMate.world.component.MydragMethod.MyDragEvent;
	
	import flash.geom.Point;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	internal class TextFieldDragEvent extends EventDispatcher
	{
		public static const START_EFFECT:String= "StartEffect";
		public static const END_EFFECT:String = "EndEffect";
		
		private var _target:DisplayObject;
		private var _delay:Number;
		
		private var mouseDownX:Number;
		private var mouseDownY:Number;
		
		private var isShow:Boolean;
				
		public function TextFieldDragEvent(target:DisplayObject,delay:Number=0.6)
		{
			_target = target;
			_delay = delay;
			_target.addEventListener(TouchEvent.TOUCH,TOUCHHandler);
		}
		
		public function dispose():void
		{
			TweenLite.killTweensOf(onComp);
			_target.stage.removeEventListener(TouchEvent.TOUCH,stageMouseUpClick);
			_target.removeEventListener(TouchEvent.TOUCH,TOUCHHandler);
			_target = null;
		}
		
		private function TOUCHHandler(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_target);	
			var pos:Point;
			if(touch && touch.phase == TouchPhase.BEGAN){
				TweenLite.delayedCall(_delay,onComp,[event]);
				pos = touch.getLocation(_target);   
				mouseDownX = pos.x;
				mouseDownY = pos.y;
				_target.stage.addEventListener(TouchEvent.TOUCH,stageMouseUpClick);
			}else if(touch && touch.phase == TouchPhase.MOVED){
				pos = touch.getLocation(_target);  
				if(Math.abs(pos.x-mouseDownX)>10 || Math.abs(pos.y-mouseDownY)>10  ){
					TweenLite.killTweensOf(onComp);
					_target.removeEventListener(TouchEvent.TOUCH,TOUCHHandler);
				}
			}/*else if(touch && touch.phase == TouchPhase.ENDED){
				TweenLite.killTweensOf(onComp);
				_target.stage.removeEventListener(TouchEvent.TOUCH,stageMouseUpClick);
				//_target.addEventListener(TouchEvent.TOUCH,TOUCHHandler);
				if(isShow){
					isShow = false;
					dispatchEventWith(END_EFFECT,false);
				}
			}*/

		}
		
		private function stageMouseUpClick(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_target);	
			var pos:Point;
			if(touch && touch.phase == TouchPhase.ENDED){
				TweenLite.killTweensOf(onComp);
				_target.stage.removeEventListener(TouchEvent.TOUCH,stageMouseUpClick);
				_target.addEventListener(TouchEvent.TOUCH,TOUCHHandler);
				if(isShow){
					isShow = false;
					dispatchEventWith(END_EFFECT,false);
				}
			}						
		}

		/**
		 * 派发事件，开始特效
		 */		
		private function onComp(event:TouchEvent):void{
			isShow = true;
			var touch:Touch = event.getTouch(_target);	
			var pos:Point = touch.getLocation(_target.stage);;
			dispatchEventWith(START_EFFECT,false,{localX:mouseDownX,localY:mouseDownY,stageX:pos.x,stageY:pos.y});
		}
	}
}