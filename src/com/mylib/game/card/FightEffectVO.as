package com.mylib.game.card
{
	import com.greensock.TweenLite;
	import com.mylib.game.charater.JobTypes;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;

	public class FightEffectVO
	{
		private var _effect:MovieClip;
		private var _startX:int;
		private var _startY:int;
		private var _targetX:int;
		private var _targetY:int;
		private var _duration:Number;
		private var _holder:DisplayObjectContainer;
		private var _index:int;
		public var type:uint;
		
		
		public static const FIX:uint = 1;
		public static const MOV:uint = 2;
		
		
		public function FightEffectVO()
		{
			
		}

		public function get effect():MovieClip
		{
			return _effect;
		}

		public function set effect(value:MovieClip):void
		{
			_effect = value;
			
			effect.addEventListener(Event.COMPLETE,effectComplete);
			effect.loop = false;
			effect.stop();
			
		}
		
		private function effectComplete(event:Event):void{
			
			if(!effect.loop){
				effect.removeFromParent();
			}
			
//			effect.visible = false;
		}
		
		
		public function start(duration:Number,startX:int,startY:int,targetX:int=0,targetY:int=0,holder:DisplayObjectContainer=null,index:int=-1):void{
			_duration = duration;
			_startX = startX;
			_startY = startY;
			_targetX = targetX;
			_targetY = targetY;
			_holder = holder;
			_index = index;
			
			if(!Starling.juggler.contains(effect)){
				Starling.juggler.add(effect);
			}
				
				
				if(type==MOV){
					var dir:int;
					effect.currentFrame = 0;
					if(startX>targetX){
						dir = -1;
					}else{
						dir = 1;
					}
					effect.play();
					if(index!=-1){
						holder.addChildAt(effect,index);
					}else{						
						holder.addChild(effect);
					}
					effect.scaleX = dir;
					
					effect.y = startY-40;
					effect.x = startX;
					
					TweenLite.to(effect,0.3,{x:targetX});
//					effect.visible = true;
				}else{
					effect.x = startX;
					effect.y = startY;
					if(duration){
						TweenLite.delayedCall(duration,effect.stop);
						TweenLite.delayedCall(duration,effect.removeFromParent);
					}
					fixEffectHandle();
				}
				
				
			
		}
		
		
		
		private function fixEffectHandle():void{
			effect.currentFrame = 0;
//			effect.visible = true;
			effect.play();
			if(_index!=-1){
				_holder.addChildAt(effect,_index);
			}else{						
				_holder.addChild(effect);
			}
			
			var dir:int;
			
			if(_startX>_targetX){
				dir = -1;
			}else{
				dir = 1;
			}
			
			effect.scaleX = dir;
			effect.y = _startY-60;
			effect.x = _startX+dir*30;
		}
		
		
		public function dispose():void{
			TweenLite.killTweensOf(fixEffectHandle);
			
			
			if(Starling.juggler.contains(effect)){
				Starling.juggler.remove(effect);
			}
			_effect.removeFromParent(true);
			
		}
		
		
		
		
		

	}
}