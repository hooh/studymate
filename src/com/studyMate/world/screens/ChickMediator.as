package com.studyMate.world.screens
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.studyMate.world.screens.effects.SwimWater;
	import com.studyMate.world.screens.effects.WaterSpray;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.animation.Juggler;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	import starling.textures.Texture;
	
	
	public class ChickMediator extends Mediator implements IMediator
	{
		private const STATE_STAY:uint=1;
		
		
		public static var NAME:String = "ChickMediator";
		
		public var juggler:Juggler;
		private var chick:MovieClip;
		
		private var holder:Sprite;
		
		
		public function ChickMediator(chickName:String,viewComponent:Object,_juggler:Juggler)
		{
			juggler = _juggler;
			super(NAME+chickName, viewComponent);
		}
		
		override public function onRegister():void
		{
			
			chick = new MovieClip(Assets.getAtlas().getTextures("charater/chick"));
			holder = new Sprite();
			view.addChild(holder);
			
			
			holder.addChild(chick);
			
			view.pivotX = holder.width>>1;
			
			
			holder.addEventListener(TouchEvent.TOUCH,clickHandle);
			holder.touchable = true;
			
			randomAction();
		}
		
		private function randomAction():void{
			juggler.add(chick);
			var _x:int;
			var duration:Number = Math.round(Math.random()*3)+2;
			TweenMax.delayedCall(duration,stopRandomAction);
			
			if(duration>=4){
				_x = 100;
				chick.scaleX = -1;
			}else{
				_x = -100;
				chick.scaleX = 1;
			}
			TweenMax.to(chick,duration,{x:_x,ease:Linear.easeNone});
		}
		private function stopRandomAction():void{
			juggler.remove(chick);
			
			var duration:Number = Math.round(Math.random()*2)+1;
			TweenMax.delayedCall(duration,randomAction);
			TweenMax.killTweensOf(chick);
		}
		
		private function clickHandle(event:TouchEvent):void
		{
			// TODO Auto Generated method stub
			if(event.touches[0].phase=="ended"){
				
			}else if(event.touches[0].phase=="began"){

			}
		}		

		
		
		override public function onRemove():void
		{
			view.removeChildren(0,-1,true);
			view.dispose();
			TweenMax.killTweensOf(chick);
			TweenMax.killDelayedCallsTo(randomAction);
			TweenMax.killDelayedCallsTo(stopRandomAction);
		}
		
		

		
		public function centerPivot(obj:DisplayObject):void
		{
			obj.pivotX=obj.width / 2;
			obj.pivotY=obj.height / 2;
		}
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		
	}
}