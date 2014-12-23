package com.studyMate.world.screens.ui
{
	import com.byxb.utils.centerPivot;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class Windmill extends Sprite
	{
		private var wmTexture:Texture;
		private var wmPoleTexture:Texture;
		private var windmill:Image;
		
		private var speed:Number;
		private var speedBck:Number;
		
		private const RP:Number = Math.PI*2;
		
		public function Windmill(_x:Number=0,_y:Number=0,_speed:Number=1,style:String="1")
		{
			super();
			x = _x;
			y = _y+40;
			speed = speedBck = _speed;
			
			wmTexture = Assets.getHappyIslandTexture("hapIsland_Windmill1_1");
			wmPoleTexture = Assets.getHappyIslandTexture("hapIsland_Windmill1_2");
			
			var windmillPole:Image =new Image(wmPoleTexture);
			windmillPole.x = -15;
			windmillPole.y -= 10;
			addChild(windmillPole);
			
			windmill = new Image(wmTexture);
			centerPivot(windmill);
			addChild(windmill);
			TweenMax.to(windmill,speed,{rotation:RP,repeat:int.MAX_VALUE,ease:Linear.easeNone});
			
			windmill.addEventListener(TouchEvent.TOUCH,clickHandle);
		}
		
		
		private var preTime:Number=0;
		private function clickHandle(event:TouchEvent):void{
			var touch:Touch = event.getTouch(windmill);
			if(touch){
				
				if(touch.phase ==TouchPhase.BEGAN){
					if(preTime == 0){
						preTime = new Date().getTime();
						
						speedNormal();
					}else{
						var nowTime:Number = new Date().getTime();
						//快速点击，加速飞车
						if( nowTime-preTime < 500)	speedUp();
						else	speedNormal();
						
						preTime = nowTime;
					}
				}
			}
		}
		
		private function speedUp():void{
			TweenLite.killTweensOf(windmill);
			
			speed -= 0.05;
			
			if(speed >= 0.3){
				
				setWindMill();
				
				TweenMax.to(windmill,speed,{rotation:RP,repeat:int.MAX_VALUE,ease:Linear.easeNone});
			}else{
				
				setWindMill(false,-300,-100);
				
				TweenMax.to(windmill,Math.random()+0.5,{rotation:RP,repeat:3,ease:Linear.easeNone,onComplete:speedNormal});
				
			}
		}
		private function speedNormal():void{
			TweenLite.killTweensOf(windmill);
			
			setWindMill();
			
			speed = speedBck;
			TweenMax.to(windmill,speed,{rotation:RP,repeat:int.MAX_VALUE,ease:Linear.easeNone});
		}
		
		private function setWindMill(isCenter:Boolean=true,_pivotX:Number=0,_pivotY:Number=0):void{
			windmill.rotation = 0;
			windmill.x = 0;
			windmill.y = 0;
			
			if(isCenter)
				centerPivot(windmill);
			else{
				windmill.pivotX = _pivotX;
				windmill.pivotY = _pivotY;
			}
			
		}
		
		
		
		override public function dispose():void
		{
			super.dispose();
			TweenLite.killTweensOf(windmill);
			windmill.removeEventListener(TouchEvent.TOUCH,clickHandle);
			
			wmTexture.dispose();
			wmPoleTexture.dispose();
			
			
			removeChildren(0,-1,true);
		}
	}
}